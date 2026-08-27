## Unreleased

- **Breaking**: Bumped min. Flutter version to 3.44.0 and Dart version to 3.12.0
- **Breaking**: Bumped Android `minSdk` from 19 to 24 and `compileSdk` from 33 to 36
- **Breaking**: Bumped the iOS deployment target from 11.0 to 15.0
- **Breaking**: Bumped the macOS deployment target from 10.11 to 12.0
- **Breaking**: Removed CocoaPods support - iOS and macOS are now integrated exclusively via Swift Package Manager
- Added Swift Package Manager support for iOS and macOS
- Added a privacy manifest (`PrivacyInfo.xcprivacy`) to the iOS and macOS plugin bundles
- Migrated the Android build to the Kotlin Gradle DSL, AGP 9.0.1 and Java 17
- Regenerated the platform folders and the example app with the Flutter 3.44 templates
- Fixed the Apple implementation replying more than once and leaking an `NWPathMonitor` per call
- Fixed the Android implementation never replying on an unrecognised `restrictBackgroundStatus`
- Updated the repository URL after a GitHub username change

## 0.4.0

- **Breaking**: Bumped min. Flutter version to 3.27.0
- Updated CI/CD pipeline

## 0.3.0

- **Breaking**: `data_saver` now requires `web: ^1.0.0`
- **Breaking**: Bumped min. Flutter version to 3.22.0
- Added `leancode_lint` package instead of a custom set of rules

## 0.2.0

- Added support for macOS

## 0.1.0

- **Breaking**: Bumped min. Flutter version to 3.16.0
- Added support for Web
- Fixed version constraints
- Automated build releases
- Updated `README.md`

## 0.0.1

- Initial release
