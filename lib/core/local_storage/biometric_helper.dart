import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class BiometricHelper {
  final LocalAuthentication _auth = LocalAuthentication();

  // 1. Check if the phone actually has a fingerprint/face scanner
  Future<bool> hasBiometrics() async {
    try {
      final bool canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
      final bool canAuthenticate = canAuthenticateWithBiometrics || await _auth.isDeviceSupported();
      return canAuthenticate;
    } catch (e) {
      return false;
    }
  }

  // 2. Trigger the scanner! (Legacy Syntax)
  Future<bool> authenticate() async {
    try {
      // Stripped down to the absolute core requirements so it works on ANY version
      return await _auth.authenticate(
        localizedReason: 'Please authenticate to log in securely',
      );
    } catch (e) {
      debugPrint('Biometric Error: $e');
      return false;
    }
  }
}