import 'dart:async';

import 'package:bitsync/services/shorturlservice.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:meta/meta.dart';

const DYNAMIC_LINK_URL_PREFIX = "https://bitsync.page.link";
const ANDROID_PACKAGE_NAME = "com.quintet.BitSync";
const IOS_BUNDLE_ID = "com.quintet.BitSync";
const IPAD_BUNDLE_ID = "com.quintet.BitSync";
const IOS_APPSTORE_ID = "";

class DynamicLinkService {
  static Future<Uri> createLink({
    @required String page,
  }) async {
    final parameters = DynamicLinkParameters(
      uriPrefix: DYNAMIC_LINK_URL_PREFIX,
      link: Uri.parse(DYNAMIC_LINK_URL_PREFIX + page),
      androidParameters: AndroidParameters(
        packageName: ANDROID_PACKAGE_NAME,
        minimumVersion: 1,
      ),
      iosParameters: IosParameters(
        appStoreId: IOS_APPSTORE_ID,
        bundleId: IOS_BUNDLE_ID,
        ipadBundleId: IPAD_BUNDLE_ID,
        minimumVersion: "1.0.0",
      ),
    );
    final url = await parameters.buildUrl();
    return Uri.parse(await ShortUrlService.makeShortUrl(url.toString()));

    // final shortLink = await parameters.buildShortLink();
    // return shortLink.shortUrl;
  }

  static Future<Uri> createRoomLink({@required String roomId}) async =>
      await createLink(page: "/rooms/" + roomId);

  static Stream<PendingDynamicLinkData> get stream => _streamController.stream;

  static void initialize() => _initialize();
}

final _streamController = StreamController<PendingDynamicLinkData>.broadcast();

void _initialize() {
  FirebaseDynamicLinks.instance.onLink(
    onSuccess: (data) async {
      _streamController.add(data);
    },
    onError: (e) async {
      print("================== DynamicLinkError ====================");
      print(e.message);
    },
  );
}

// test link page
// https://beatsync.page.link?amv=1&apn=com.quintet.BitSync&ibi=com.quintet.BitSync&imv=1.0.0&isi=&ipbi=com.quintet.BitSync&link=https%3A%2F%2Fbeatsync.page.link%2Frooms%2F142274323
