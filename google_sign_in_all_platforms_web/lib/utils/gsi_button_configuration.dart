import 'package:google_sign_in_all_platforms_interface/google_sign_in_all_platforms_interface.dart';
import 'package:google_sign_in_web/google_sign_in_web.dart';

abstract class GSIAPButtonConfigUtils {
  static GSIButtonConfiguration fromJson(Map<String, dynamic> json) {
    return GSIButtonConfiguration(
      type: GSIButtonType.values.firstWhere(
        (e) => e.toString() == 'GSIButtonType.${json['type']}',
        orElse: () => GSIButtonType.standard,
      ),
      theme: GSIButtonTheme.values.firstWhere(
        (e) => e.toString() == 'GSIButtonTheme.${json['theme']}',
        orElse: () => GSIButtonTheme.filledBlue,
      ),
      size: GSIButtonSize.values.firstWhere(
        (e) => e.toString() == 'GSIButtonSize.${json['size']}',
        orElse: () => GSIButtonSize.medium,
      ),
      text: GSIButtonText.values.firstWhere(
        (e) => e.toString() == 'GSIButtonText.${json['text']}',
        orElse: () => GSIButtonText.signinWith,
      ),
      shape: GSIButtonShape.values.firstWhere(
        (e) => e.toString() == 'GSIButtonShape.${json['shape']}',
        orElse: () => GSIButtonShape.rectangular,
      ),
      logoAlignment: GSIButtonLogoAlignment.values.firstWhere(
        (e) =>
            e.toString() == 'GSIButtonLogoAlignment.${json['logoAlignment']}',
        orElse: () => GSIButtonLogoAlignment.left,
      ),
      minimumWidth: json['minimumWidth'] as double?,
      locale: json['locale'] as String?,
    );
  }

  static GSIButtonConfiguration fromGSIAP(GSIAPButtonUiConfig config) {
    return GSIButtonConfiguration(
      type: GSIButtonType.values.firstWhere(
        (e) => e.toString() == 'GSIButtonType.${config.type?.name}',
        orElse: () => GSIButtonType.standard,
      ),
      theme: GSIButtonTheme.values.firstWhere(
        (e) => e.toString() == 'GSIButtonTheme.${config.theme?.name}',
        orElse: () => GSIButtonTheme.filledBlue,
      ),
      size: GSIButtonSize.values.firstWhere(
        (e) => e.toString() == 'GSIButtonSize.${config.size?.name}',
        orElse: () => GSIButtonSize.medium,
      ),
      text: GSIButtonText.values.firstWhere(
        (e) => e.toString() == 'GSIButtonText.${config.text?.name}',
        orElse: () => GSIButtonText.signinWith,
      ),
      shape: GSIButtonShape.values.firstWhere(
        (e) => e.toString() == 'GSIButtonShape.${config.shape?.name}',
        orElse: () => GSIButtonShape.rectangular,
      ),
      logoAlignment: GSIButtonLogoAlignment.values.firstWhere(
        (e) =>
            e.toString() ==
            'GSIButtonLogoAlignment.${config.logoAlignment?.name}',
        orElse: () => GSIButtonLogoAlignment.left,
      ),
      minimumWidth: config.minimumWidth,
      locale: config.locale,
    );
  }
}
