import 'dart:async';
import 'dart:io';

import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;

const _userAgent =
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:76.0) Gecko/20100101 Firefox/76.0";

const _HOST_STRING = "https://www.shorturl.at/";
const _REFERER_START =
    "https://www.google.com/search?ei=FFa_Xpf5M4nv-gS6iLmgAg&q=short+url&oq=short+url&gs_lcp=CgZwc3ktYWIQAzICCAAyAggAMgIIADICCAAyAggAMgIIADICCAAyAggAMgIIADICCAA6BAgAEEc6BAgAEENQ_C9Y-DdgiDloAHACeACAAdYBiAGADZIBBTAuMS43mAEAoAEBqgEHZ3dzLXdpeg&sclient=psy-ab&ved=0ahUKEwiX0_75sLfpAhWJt54KHTpEDiQQ4dUDCAs&uact=5";

final _host1 = Uri.parse(_HOST_STRING);
final _host2 = Uri.parse("https://www.shorturl.at/shortener.php");

final cookiePattern = RegExp(r"([A-Za-z0-9_]+)=([A-Za-z0-9-/+=]+)");

class ShortUrlService {
  static http.Client _client = http.Client();
  static Map<String, String> _cookies = {};

  static Map<String, String> _buildHeader(
      {String referer = _REFERER_START, bool forPost = false}) {
    var headers = {
      "User-Agent": _userAgent,
      "Accept":
          "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8",
      "Accept-Language": "en-US,en;q=0.5",
      "Accept-Encoding": "gzip, deflate",
      "Connection": "keep-alive",
      "Referer": referer ?? _REFERER_START,
      "TE": "Trailers",
      "Upgrade-Insecure-Requests": "1",
    };
    if (forPost) {
      headers["Content-Type"] = "application/x-www-form-urlencoded";
    }
    if (_cookies.isNotEmpty)
      headers["Cookie"] =
          _cookies.entries.map((e) => "${e.key}=${e.value}").join("; ");
    return headers;
  }

  static void _parseCookies(http.Response response) {
    if (response.headers.containsKey("set-cookie")) {
      var setCookie = response.headers["set-cookie"];
      var cookie = Cookie.fromSetCookieValue(setCookie);
      var sets = cookiePattern.allMatches(cookie.value);
      sets.forEach((cookie) {
        _cookies[cookie.group(1)] = cookie.group(2);
      });
    }
  }

  static Future<String> makeShortUrl(final String origin) async {
    var response = await _client.get(
      _host1,
      headers: _buildHeader(referer: _REFERER_START),
    );

    if (response.statusCode != 200) {
      print(
          "============================ SHORTURL_ERROR 1: ${response.statusCode}");
      return origin;
    }
    _parseCookies(response);

    // final String body = "u=${Uri.encodeComponent(origin)}";
    response = await _client.post(
      _host2,
      headers: _buildHeader(referer: _HOST_STRING, forPost: true),
      body: {"u": origin},
    );

    if (response.statusCode != 200) {
      print(
          "============================ SHORTURL_ERROR 2: ${response.statusCode}");
      return origin;
    }
    _parseCookies(response);

    print("============= DECODING COMPLETE:");

    final body = response.body;
    print(body);

    var document = parser.parse(body);
    var element = document.getElementById("shortenurl");
    return element.attributes["value"];
  }
}
