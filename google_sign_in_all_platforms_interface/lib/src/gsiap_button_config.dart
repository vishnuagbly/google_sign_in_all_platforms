import 'package:google_sign_in_all_platforms_interface/src/credentials.dart';

/// Google Sign In Button Configurations
class GSIAPButtonConfig {
  /// Google Sign In Button Configurations
  ///
  /// Note:- Currently we don't have "onFail" method, since with
  /// google_sign_in_web, there is no way to check, if the sign-in process was
  /// a failure.
  const GSIAPButtonConfig({
    this.uiConfig,
    this.onSignIn,
    this.onSignOut,
  });

  /// UI Config
  final GSIAPButtonUiConfig? uiConfig;

  /// On Successful Sign-In Callback
  final void Function(GoogleSignInCredentials creds)? onSignIn;

  /// On Successful Sign-Out Callback
  final void Function()? onSignOut;
}

/// A class to configure the Google Sign-In Button for web.
///
/// See:
/// * https://developers.google.com/identity/gsi/web/reference/js-reference#GsiButtonConfiguration
class GSIAPButtonUiConfig {
  /// Constructs a button configuration object.
  const GSIAPButtonUiConfig({
    this.type,
    this.theme,
    this.size,
    this.text,
    this.shape,
    this.logoAlignment,
    this.minimumWidth,
    this.locale,
  }) : assert(
          minimumWidth == null || minimumWidth > 0,
          'Minimum width cannot be negative',
        );

  /// The button type: icon, or standard button.
  final GSIAPButtonType? type;

  /// The button theme.
  ///
  /// For example, filledBlue or filledBlack.
  final GSIAPButtonTheme? theme;

  /// The button size.
  ///
  /// For example, small or large.
  final GSIAPButtonSize? size;

  /// The button text.
  ///
  /// For example "Sign in with Google" or "Sign up with Google".
  final GSIAPButtonText? text;

  /// The button shape.
  ///
  /// For example, rectangular or circular.
  final GSIAPButtonShape? shape;

  /// The Google logo alignment: left or center.
  final GSIAPButtonLogoAlignment? logoAlignment;

  /// The minimum button width, in pixels.
  ///
  /// The maximum width is 400 pixels.
  final double? minimumWidth;

  /// The pre-set locale of the button text.
  ///
  /// If not set, the browser's default locale or the Google session user's
  /// preference is used.
  ///
  /// Different users might see different versions of localized buttons, possibly
  /// with different sizes.
  final String? locale;
}

/// The type of button to be rendered.
///
/// See:
/// * https://developers.google.com/identity/gsi/web/reference/js-reference#type
enum GSIAPButtonType {
  /// A button with text or personalized information.
  standard,

  /// An icon button without text.
  icon;
}

/// The theme of the button to be rendered.
///
/// See:
/// * https://developers.google.com/identity/gsi/web/reference/js-reference#theme
enum GSIAPButtonTheme {
  /// A standard button theme.
  outline,

  /// A blue-filled button theme.
  filledBlue,

  /// A black-filled button theme.
  filledBlack;
}

/// The size of the button to be rendered.
///
/// See:
/// * https://developers.google.com/identity/gsi/web/reference/js-reference#size
enum GSIAPButtonSize {
  /// A large button (about 40px tall).
  large,

  /// A medium-sized button (about 32px tall).
  medium,

  /// A small button (about 20px tall).
  small;
}

/// The button text.
///
/// See:
/// * https://developers.google.com/identity/gsi/web/reference/js-reference#text
enum GSIAPButtonText {
  /// The button text is "Sign in with Google".
  signinWith,

  /// The button text is "Sign up with Google".
  signupWith,

  /// The button text is "Continue with Google".
  continueWith,

  /// The button text is "Sign in".
  signin;
}

/// The button shape.
///
/// See:
/// * https://developers.google.com/identity/gsi/web/reference/js-reference#shape
enum GSIAPButtonShape {
  /// The rectangular-shaped button.
  rectangular,

  /// The circle-shaped button.
  pill;
  // Does this need circle and square?
}

/// The alignment of the Google logo. The default value is left. This attribute only applies to the standard button type.
///
/// See:
/// * https://developers.google.com/identity/gsi/web/reference/js-reference#logo_alignment
enum GSIAPButtonLogoAlignment {
  /// Left-aligns the Google logo.
  left,

  /// Center-aligns the Google logo.
  center;
}
