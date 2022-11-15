typedef ExtractStringCallback = String Function(String?);

abstract class SMSAutofillStrategy {
  Future<String> listenForCode();
}
