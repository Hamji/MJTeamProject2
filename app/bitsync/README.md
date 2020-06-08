# BitSync

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


## Google Auth가 안 될 경우
Firebase Settings의 Android App에 debug.keystore의 SHA 지문 추가
대개 user directory의 .android directory 내에 debug.keystore에 있음

- [How to get SHA thumbnail from Keystore](https://stackoverflow.com/questions/51845559/generate-sha-1-for-flutter-app)


## DCDG로 Class UML 추출

- [DCDG](https://pub.dev/packages/dcdg)
- [How to use DCDG](https://github.com/glesica/dcdg.dart/blob/master/USAGE.txt)
- Simple Usage: Proejct directory에서 flutter pub global run dcdg --output=<FILE>


## Build 안 될 경우
> flutter channel master
> flutter upgrade