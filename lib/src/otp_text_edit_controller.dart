import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '_src_exports.dart';

final _defaultOTPInteractor = OTPInteractor();

/// Custom controller for text views, IOS autofill is built in flutter.
class OTPTextEditController extends TextEditingController {
  /// OTP code length - trigger for callback.
  final int codeLength;

  /// [OTPTextEditController]'s receive OTP code callback.
  final StringCallback? onCodeReceive;

  /// Receiver gets TimeoutError after 5 minutes without sms.
  final VoidCallback? onTimeOutException;

  /// Error handler.
  final Function(Exception error)? errorHandler;

  /// Stop listening after receiving or error an OTP code.
  final bool autoStop;

  /// Interaction with OTP.
  @visibleForTesting
  final OTPInteractor otpInteractor;

  /// Wrapper for Platform io.
  @visibleForTesting
  final PlatformWrapper platform;

  OTPTextEditController({
    required this.codeLength,
    this.onCodeReceive,
    this.onTimeOutException,
    this.errorHandler,
    this.autoStop = true,
    OTPInteractor? otpInteractor,
    PlatformWrapper? platform,
  })  : otpInteractor = otpInteractor ?? _defaultOTPInteractor,
        platform = platform ?? PlatformWrapper() {
    addListener(checkForComplete);
  }

  /// Start listen for OTP code with User Consent API
  /// sms by default
  /// could be added another input as [SMSAutofillStrategy].
  Future<void> startListenUserConsent(
    ExtractStringCallback codeExtractor, {
    List<SMSAutofillStrategy>? strategies,
    String? senderNumber,
  }) {
    final smsListen = otpInteractor.startListenUserConsent(senderNumber);
    final strategiesListen = strategies?.map((e) => e.listenForCode());

    final list = [
      if (platform.isAndroid) smsListen,
      if (strategiesListen != null) ...strategiesListen,
    ];

    return Stream.fromFutures(list).first.then(
      (value) {
        if (autoStop) {
          stopListen();
        }
        text = codeExtractor(value);
      },
    ).catchError(
      // ignore: avoid_types_on_closure_parameters
      (Object error) {
        if (autoStop) {
          stopListen();
        }
        if (error is PlatformException && error.code == '408') {
          onTimeOutException?.call();
        } else if (error is Exception) {
          errorHandler?.call(error);
        } else {
          throw Exception('Unexpected error: $error');
        }
      },
    );
  }

  /// Start listen for OTP code with Retriever API
  /// sms by default
  /// could be added another input as [SMSAutofillStrategy].
  Future<void> startListenRetriever(
    ExtractStringCallback codeExtractor, {
    List<SMSAutofillStrategy>? additionalStrategies,
  }) {
    final smsListen = otpInteractor.startListenRetriever();
    final strategiesListen = additionalStrategies?.map(
      (e) => e.listenForCode(),
    );

    return Stream.fromFutures([
      if (platform.isAndroid) smsListen,
      if (strategiesListen != null) ...strategiesListen,
    ]).first.then(
      (value) {
        if (autoStop) {
          stopListen();
        }
        text = codeExtractor(value);
      },
    ).catchError(
      // ignore: avoid_types_on_closure_parameters
      (Object error) {
        if (autoStop) {
          stopListen();
        }
        if (error is PlatformException && error.code == '408') {
          onTimeOutException?.call();
        } else if (error is Exception) {
          errorHandler?.call(error);
        } else {
          throw Exception('Unexpected error: $error');
        }
      },
    );
  }

  /// Get OTP code from another input
  /// don't register any BroadcastReceivers.
  void startListenOnlyStrategies(
    List<SMSAutofillStrategy>? strategies,
    ExtractStringCallback codeExtractor,
  ) {
    final strategiesListen = strategies?.map((e) => e.listenForCode());
    Stream.fromFutures([
      if (strategiesListen != null) ...strategiesListen,
    ]).first.then((value) {
      text = codeExtractor(value);
    });
  }

  /// Broadcast receiver stop listen for OTP code, use in dispose.
  Future<Object?> stopListen() {
    return otpInteractor.stopListenForCode();
  }

  /// Call onComplete callback if code entered.
  void checkForComplete() {
    if (text.length == codeLength) onCodeReceive?.call(text);
  }
}
