class Config {
  /// Prevents from object instantiation.
  Config._();

  /// Holds the 'Site Key' for the `Google reCAPTCHA v3` API .
  static const String siteKey = '6LeUofckAAAAABZWNok6hqgglqFA_vonGlYaBDvi ';

  /// Holds the 'Secret Key' for the `Google reCAPTCHA v3` API .
  static const String secretKey = '6LeUofckAAAAAMnPjQJ-8h8DmPX35AK4Ne_BD8_I';

  /// Holds the 'Verfication URL' for the `Google reCAPTCHA v3` API .
  static final verificationURL =
      Uri.parse('https://www.google.com/recaptcha/api/siteverify');
}
