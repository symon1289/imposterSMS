# impostersms

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Automated Versioning

This project includes a script to automate version bumping and git tagging.

### Usage

Run the script from the root of the project:

```bash
# Bump build number (default) -> 1.0.0+2
dart bin/version_manager.dart build

# Bump patch version -> 1.0.1+3
dart bin/version_manager.dart patch

# Bump minor version -> 1.1.0+4
dart bin/version_manager.dart minor

# Bump major version -> 2.0.0+5
dart bin/version_manager.dart major
```

The script will:
1. Update `version` in `pubspec.yaml`.
2. Commit the change to Git.
3. Create a Git tag (e.g., `v1.0.0+2`).
