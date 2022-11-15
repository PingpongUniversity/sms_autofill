import 'dart:io';

class UnsupportedPlatform implements Exception {
  @override
  String toString() {
    if (Platform.isIOS) {
      return 'On iOS OTP autofill is built in TextField. Code from sms stores for 3 minutes.(see Readme)';
    }
    return super.toString();
  }
}
