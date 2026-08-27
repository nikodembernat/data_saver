# data_saver

[![Package](https://img.shields.io/pub/v/data_saver.svg)](https://pub.dev/packages/data_saver) [![Publisher](https://img.shields.io/pub/publisher/data_saver.svg)](https://pub.dev/packages/data_saver/publisher) [![MIT License](https://img.shields.io/badge/license-MIT-purple.svg)](https://opensource.org/licenses/MIT) [![LeanCode Style](https://img.shields.io/badge/style-leancode__lint-black)](https://pub.dartlang.org/packages/leancode_lint)

`data_saver` provides a simple way of checking the current [Data Saver](https://source.android.com/docs/core/data/data-saver) (Android) / [Low Data Mode](https://developer.apple.com/documentation/foundation/nsurlsessionconfiguration/3235751-allowsconstrainednetworkaccess) (iOS).

|                                                                                              Status                                                                                              |               Comments               |
| :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------: | :----------------------------------: |
| [![data_saver - Tests (stable)](https://github.com/nikodembernat/data_saver/actions/workflows/test_stable.yaml/badge.svg)](https://github.com/nikodembernat/data_saver/actions/workflows/test_stable.yaml) |    Current stable Flutter version    |
|    [![data_saver - Tests (beta)](https://github.com/nikodembernat/data_saver/actions/workflows/test_beta.yaml/badge.svg)](https://github.com/nikodembernat/data_saver/actions/workflows/test_beta.yaml)    |     Current beta Flutter version     |
|    [![data_saver - Tests (3.44.0)](https://github.com/nikodembernat/data_saver/actions/workflows/test_min.yaml/badge.svg)](https://github.com/nikodembernat/data_saver/actions/workflows/test_min.yaml)    | The oldest supported Flutter version |

## Getting started

1. Add this package to your dependencies.

```yaml
dependencies:
  data_saver: latest_version
```

2. Get the dependencies.

```sh
flutter pub get
```

## Usage

```dart
const dataSaver = DataSaver();

// Mode is one of the following values:
// - enabled
// - whitelisted (Android-only)
// - disabled
final mode = await dataSaver.checkMode();
```

## Behavior on unsupported platforms

If a particular platform is not supported by this plugin it will return `DataSaverMode.disabled` instead of throwing a `MissingPluginException`. Support for more platforms is coming soon.

## Additional information

- This package requires at least Flutter 3.44 and Dart 3.12.
- This package requires at least iOS 15.0 and macOS 12.0.
- Apple platform integration requires Swift Package Manager, which Flutter enables by default since 3.44. CocoaPods is not supported.
- If there are any issues feel free to go to [GitHub Issues](https://github.com/nikodembernat/data_saver/issues) and report a bug.

## Maintainers

- [Nikodem Bernat](https://nikodembernat.com)
