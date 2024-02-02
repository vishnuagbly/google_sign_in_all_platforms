# google_sign_in_all_platforms_interface

A common platform interface for the `google_sign_in_all_platforms` plugin.

This interface allows platform-specific implementations of the `google_sign_in_all_platforms`
plugin, as well as the plugin itself, to ensure they are supporting the same interface.

# Usage

To implement a new platform-specific implementation of `google_sign_in_all_platforms`,
extend `GoogleSignInAllPlatformsInterface` with an implementation that performs the
platform-specific behavior.