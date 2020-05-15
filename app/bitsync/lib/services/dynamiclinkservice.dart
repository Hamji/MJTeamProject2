import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:meta/meta.dart';

const DYNAMIC_LINK_URL_PREFIX = "https://beatsync.page.link";
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
    return await parameters.buildUrl();
    // final shortLink = await parameters.buildShortLink();
    // return shortLink.shortUrl;
  }

  static Future<Uri> createRoomLink({@required String roomId}) async =>
      await createLink(page: "/rooms/" + roomId);
}
// test link page
// https://beatsync.page.link?amv=1&apn=com.quintet.BitSync&ibi=com.quintet.BitSync&imv=1.0.0&isi=&ipbi=com.quintet.BitSync&link=https%3A%2F%2Fbeatsync.page.link%2Frooms%2F142274323