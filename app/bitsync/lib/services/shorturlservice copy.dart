import 'dart:async';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:html/dom.dart';
import 'package:html/parser.dart' as parser;

const _userAgent =
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:76.0) Gecko/20100101 Firefox/76.0";

final _HOST_STRING = "https://www.shorturl.at/";
final _REFERER_START =
    "https://www.google.com/search?ei=FFa_Xpf5M4nv-gS6iLmgAg&q=short+url&oq=short+url&gs_lcp=CgZwc3ktYWIQAzICCAAyAggAMgIIADICCAAyAggAMgIIADICCAAyAggAMgIIADICCAA6BAgAEEc6BAgAEENQ_C9Y-DdgiDloAHACeACAAdYBiAGADZIBBTAuMS43mAEAoAEBqgEHZ3dzLXdpeg&sclient=psy-ab&ved=0ahUKEwiX0_75sLfpAhWJt54KHTpEDiQQ4dUDCAs&uact=5";

final _host1 = Uri.parse(_HOST_STRING);
final _host2 = Uri.parse("https://www.shorturl.at/shortener.php");

enum _Method {
  Get,
  Post,
}

class ShortUrlService {
  static HttpClient _client;
  static List<Cookie> _cookies;

  static Future<HttpClientResponse> _makeRequest(final Uri uri,
      {_Method method = _Method.Get, String data, String referer}) async {
    var request = await (method == _Method.Get
        ? _client.getUrl
        : _client.postUrl)(_host1);
    request.headers.add("User-Agent", _userAgent);
    request.headers.add("Accept",
        "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8");
    request.headers.add("Accept-Language", "en-US,en;q=0.5");
    request.headers.add("Accept-Encoding", "gzip, deflate");

    if (referer?.isNotEmpty ?? false) request.headers.add("Referer", referer);
    if (data?.isNotEmpty ?? false) {
      request.bufferOutput = true;
      request.write(Uri.encodeComponent(data));
    }

    return request.close();
  }

  static Future<String> makeShortUrl(final String origin) async {
    if (_client == null) {
      _client = HttpClient();
    }

    var response = await _makeRequest(_host1,
        method: _Method.Get, referer: _REFERER_START);
    _cookies = response.cookies;
    if (response.statusCode != 200) {
      print("======================= SHORTURL_ERROR 1: ${response.statusCode}");
      return origin;
    }

    response = await _makeRequest(
      _host2,
      method: _Method.Post,
      referer: _HOST_STRING,
      data: "u=${Uri.encodeComponent(origin)}",
    );
    _cookies = response.cookies;

    if (response.statusCode != 200) {
      print("======================= SHORTURL_ERROR 2: ${response.statusCode}");
      return origin;
    }

    final completer = Completer<String>();
    final buffer = StringBuffer();

    // (response.headers[HttpHeaders.contentEncodingHeader]?.contains("gzip") ??
    //             false
    //         ? response.transform(gzip.decoder).transform(utf8.decoder)
    //         : response.transform(utf8.decoder))

    response.transform(utf8.decoder).listen(
      (b) => buffer.write(b),
      onDone: () {
        print("============= DECODING COMPLETE:");

        final body = buffer.toString();
        print(body);

        var document = parser.parse(body);
        var element = document.getElementById("shortenurl");
        var result = element.attributes["value"];

        completer.complete(result);
      },
      onError: completer.completeError,
    );

    return completer.future;
  }
}
