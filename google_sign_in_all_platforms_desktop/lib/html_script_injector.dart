import 'package:flutter/services.dart' show rootBundle;

/// A utility class for injecting Google Authentication JavaScript into HTML pages
class HtmlScriptInjector {
  static const String _scriptAssetPath = 'packages/google_sign_in_all_platforms_desktop/assets/google_auth_script.js';
  
  /// Cached script content to avoid repeated file reads
  static String? _cachedScriptContent;

  /// Injects Google Authentication script into the provided HTML page
  /// 
  /// This function validates that [authPage] is valid HTML and injects
  /// the necessary JavaScript for handling OAuth2 authentication responses.
  /// 
  /// The script handles both implicit flow (fragments) and authorization code flow (query parameters),
  /// automatically processing authentication data and sending it to the appropriate server endpoint.
  /// 
  /// [authPage] - The HTML content to inject the script into
  /// 
  /// Returns the modified HTML with the authentication script injected
  /// 
  /// Throws [ArgumentError] if [authPage] is not valid HTML
  /// Throws [Exception] if the authentication script cannot be loaded
  /// 
  /// Example:
  /// ```dart
  /// String customHtml = '''
  /// <!DOCTYPE html>
  /// <html>
  /// <head><title>My Custom Auth Page</title></head>
  /// <body>
  ///   <h1>Processing Authentication...</h1>
  /// </body>
  /// </html>
  /// ''';
  /// 
  /// String enhancedHtml = await HtmlScriptInjector.injectAuthScript(customHtml);
  /// ```
  /// 
  /// The injected script will dispatch custom events that your HTML page can listen to:
  /// - `google-auth-token-processing`: When token processing starts
  /// - `google-auth-success`: When authentication succeeds
  /// - `google-auth-error`: When authentication fails
  static Future<String> injectAuthScript(String authPage) async {
    // Validate HTML input
    _validateHtml(authPage);
    
    // Load the authentication script if not already cached
    if (_cachedScriptContent == null) {
      _cachedScriptContent = await _loadAuthScript();
    }
    
    // Inject the script into the HTML
    return _injectScript(authPage, _cachedScriptContent!);
  }

  /// Validates that the provided string is valid HTML
  static void _validateHtml(String authPage) {
    if (authPage.trim().isEmpty) {
      throw ArgumentError('authPage cannot be empty');
    }
    
    // Basic HTML validation - check for common HTML patterns
    final htmlPattern = RegExp(r'<!DOCTYPE\s+html|<html[^>]*>|<HTML[^>]*>', caseSensitive: false);
    final hasHtmlDeclaration = htmlPattern.hasMatch(authPage);
    
    // Also check for basic HTML tags
    final hasHtmlTags = RegExp(r'<(html|head|body|div|p|h[1-6]|span)[^>]*>', caseSensitive: false).hasMatch(authPage);
    
    if (!hasHtmlDeclaration && !hasHtmlTags) {
      throw ArgumentError(
        'authPage does not appear to be valid HTML. '
        'Expected HTML document with DOCTYPE declaration or HTML tags.'
      );
    }
    
    // Check for mismatched or malformed tags (basic validation)
    final openTags = RegExp(r'<([a-zA-Z][a-zA-Z0-9]*)[^>]*(?<!/)>').allMatches(authPage);
    final closeTags = RegExp(r'</([a-zA-Z][a-zA-Z0-9]*)>').allMatches(authPage);
    
    // Count self-closing tags
    final selfClosingTags = RegExp(r'<([a-zA-Z][a-zA-Z0-9]*)[^>]*/\s*>').allMatches(authPage);
    final voidElements = {'area', 'base', 'br', 'col', 'embed', 'hr', 'img', 'input', 'link', 'meta', 'source', 'track', 'wbr'};
    
    final openTagCounts = <String, int>{};
    final closeTagCounts = <String, int>{};
    
    // Count opening tags (excluding self-closing and void elements)
    for (final match in openTags) {
      final tagName = match.group(1)!.toLowerCase();
      if (!voidElements.contains(tagName)) {
        openTagCounts[tagName] = (openTagCounts[tagName] ?? 0) + 1;
      }
    }
    
    // Subtract self-closing tags from open tag counts
    for (final match in selfClosingTags) {
      final tagName = match.group(1)!.toLowerCase();
      if (openTagCounts.containsKey(tagName)) {
        openTagCounts[tagName] = openTagCounts[tagName]! - 1;
        if (openTagCounts[tagName]! <= 0) {
          openTagCounts.remove(tagName);
        }
      }
    }
    
    // Count closing tags
    for (final match in closeTags) {
      final tagName = match.group(1)!.toLowerCase();
      closeTagCounts[tagName] = (closeTagCounts[tagName] ?? 0) + 1;
    }
    
    // Basic validation - check if major tags are balanced
    final importantTags = ['html', 'head', 'body'];
    for (final tag in importantTags) {
      final openCount = openTagCounts[tag] ?? 0;
      final closeCount = closeTagCounts[tag] ?? 0;
      if (openCount != closeCount && openCount > 0) {
        // Only warn for now, don't throw error as some HTML might be intentionally incomplete
        print('Warning: Potentially unmatched $tag tags (open: $openCount, close: $closeCount)');
      }
    }
  }

  /// Loads the authentication script from assets
  static Future<String> _loadAuthScript() async {
    try {
      return await rootBundle.loadString(_scriptAssetPath);
    } catch (e) {
      throw Exception('Failed to load Google Authentication script: $e');
    }
  }

  /// Injects the script into the HTML at the appropriate location
  static String _injectScript(String html, String scriptContent) {
    final scriptTag = '<script type="text/javascript">\n$scriptContent\n</script>';
    
    // Try to inject before the closing </body> tag
    final bodyClosePattern = RegExp(r'</body\s*>', caseSensitive: false);
    final bodyMatch = bodyClosePattern.firstMatch(html);
    
    if (bodyMatch != null) {
      // Insert before </body>
      final insertPosition = bodyMatch.start;
      return html.substring(0, insertPosition) +
             '\n$scriptTag\n' +
             html.substring(insertPosition);
    }
    
    // If no </body> tag, try to inject before </html>
    final htmlClosePattern = RegExp(r'</html\s*>', caseSensitive: false);
    final htmlMatch = htmlClosePattern.firstMatch(html);
    
    if (htmlMatch != null) {
      // Insert before </html>
      final insertPosition = htmlMatch.start;
      return html.substring(0, insertPosition) +
             '\n$scriptTag\n' +
             html.substring(insertPosition);
    }
    
    // If neither tag is found, append at the end
    return html + '\n$scriptTag';
  }

  /// Clears the cached script content (useful for testing or if script is updated)
  static void clearCache() {
    _cachedScriptContent = null;
  }
}
