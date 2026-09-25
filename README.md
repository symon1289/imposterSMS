# 🎭 Imposter SMS

<p align="center">
  <img src="assets/images/app_logo.png" alt="Imposter SMS Logo" width="140"/>
</p>

<p align="center">
  A social party game where players receive secret questions directly through SMS.
</p>

<p align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter\&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart\&logoColor=white)
![Platform](https://img.shields.io/badge/Platform-Android-3DDC84?logo=android\&logoColor=white)
![Version](https://img.shields.io/badge/Version-1.3.1%2B10-blue)
![License](https://img.shields.io/badge/License-MIT-green)

</p>

---

## 📖 Description

**Imposter SMS** is a social party game built with Flutter for Android.

The game is designed for groups of friends playing together in the same physical location. One player secretly receives a different question from everyone else, making them the **Imposter**.

The host creates a game, adds the players' phone numbers, selects a question category, and sends each player their secret question via SMS.

### 🎮 How It Works

1. Create a new game.
2. Add the players and their phone numbers.
3. Select a question category.
4. The game randomly selects an Imposter.
5. Most players receive the same question.
6. The Imposter receives a different but related question.
7. Players answer their questions without revealing them.
8. The group discusses the answers and tries to identify the Imposter.
9. Reveal the Imposter and start another round.

### 💡 Example

**Crewmate question:**

> How many relationships have you had?

**Imposter question:**

> How many dates have you been on this year?

The questions are similar enough to allow the Imposter to participate, but different enough to create suspicion and discussion.

---

## 📚 Table of Contents

* [Features](#-features)
* [Tech Stack](#-tech-stack)
* [Requirements](#-requirements)
* [Installation](#-installation)
* [Usage](#-usage)
* [Project Structure](#-project-structure)
* [Question System](#-question-system)
* [SMS Permissions](#-sms-permissions)
* [Version Management](#-version-management)
* [Contributing](#-contributing)
* [License](#-license)
* [Important Links](#-important-links)
* [Footer](#-footer)

---

## ✨ Features

### 🎭 Imposter Game

* Randomly assigns an Imposter to each round.
* Gives the majority of players the same question.
* Gives the Imposter a different question.
* Designed for social group gameplay.

### 📱 SMS-Based Questions

* Sends secret questions directly to players' phones.
* Players do not need to see each other's questions.
* Uses the phone's SMS capabilities.
* Designed for Android devices.

### 👥 Multiplayer Party Experience

* Add multiple players to a game.
* Use real phone numbers for SMS delivery.
* Designed for groups playing together in person.

### 🗂️ Question Categories

The game can support different types of questions, including:

* Dating
* Relationships
* Friendship
* Childhood
* Work
* Funny
* Flirty
* Slightly Dirty
* Embarrassing
* Deep
* Random

Question categories can be expanded as the game grows.

### 💾 Local Data Storage

The application uses Hive for local persistence, allowing game-related data to be stored locally on the device.

### 🔊 Sound Effects

The application includes audio assets for creating a more engaging game experience.

### 🔐 Permission Handling

The app handles Android runtime permissions required for functionality such as SMS.

### 🎨 Custom Android Experience

The project includes:

* Custom application icon
* Adaptive Android icon
* Native splash screen
* Custom image assets
* Custom sound assets

---

## 🛠️ Tech Stack

| Technology                                                        | Purpose                                       |
| ----------------------------------------------------------------- | --------------------------------------------- |
| [Flutter](https://flutter.dev/)                                   | Cross-platform UI framework                   |
| [Dart](https://dart.dev/)                                         | Programming language                          |
| [Provider](https://pub.dev/packages/provider)                     | State management                              |
| [Hive](https://pub.dev/packages/hive)                             | Local data storage                            |
| [Hive Flutter](https://pub.dev/packages/hive_flutter)             | Flutter integration for Hive                  |
| [Another Telephony](https://pub.dev/packages/another_telephony)   | SMS functionality                             |
| [AudioPlayers](https://pub.dev/packages/audioplayers)             | Audio playback                                |
| [Permission Handler](https://pub.dev/packages/permission_handler) | Runtime permission management                 |
| [Intl](https://pub.dev/packages/intl)                             | Internationalization and date/time formatting |
| [Build Runner](https://pub.dev/packages/build_runner)             | Code generation                               |
| [Hive Generator](https://pub.dev/packages/hive_generator)         | Hive adapter generation                       |

The current application uses Dart SDK `^3.10.1` and version `1.3.1+10`.

---

## 📋 Requirements

Before installing the project, make sure you have:

* Flutter SDK
* Dart SDK compatible with the project
* Android Studio or another Android development environment
* Android SDK
* An Android device or emulator

> **Note:** Imposter SMS currently targets Android functionality, particularly because SMS functionality is central to the application. The project configuration enables Android launcher icons and splash screens while disabling the corresponding iOS configurations.

---

## 🚀 Installation

### 1. Clone the Repository

```bash
git clone https://github.com/symon1289/imposterSMS.git
```

Navigate into the project:

```bash
cd imposterSMS
```

### 2. Install Dependencies

Run:

```bash
flutter pub get
```

### 3. Generate Hive Files

If the project contains generated Hive adapters that need to be regenerated, run:

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 4. Check Connected Devices

```bash
flutter devices
```

Make sure an Android device is connected.

### 5. Run the Application

```bash
flutter run
```

---

## ▶️ Usage

### Create a Game

Launch the application and create a new game.

Add the players who will participate in the round.

For each player, provide the phone number that should receive their secret question.

### Start the Round

Once all players have been added:

1. Select the desired question category.
2. Start the game.
3. The game randomly selects the Imposter.
4. Questions are assigned.
5. The appropriate question is sent to each player.

### Play

Each player checks their SMS privately.

Players should **not show their question to anyone else**.

Everyone then answers their question and participates in the discussion.

### Find the Imposter

After everyone has answered, the group discusses the responses and votes on who they believe is the Imposter.

Finally, reveal the Imposter and see whether the group was correct.

---

## 📁 Project Structure

The project follows a Flutter application structure:

```text
imposterSMS/
│
├── android/                 # Android-specific configuration
│
├── assets/
│   ├── images/              # Application images and logo
│   └── sounds/              # Sound effects
│
├── bin/
│   └── version_manager.dart # Automated version management
│
├── lib/                     # Main Flutter application
│
├── test/                    # Flutter tests
│
├── .vscode/                 # VS Code configuration
│
├── analysis_options.yaml    # Dart analyzer configuration
├── devtools_options.yaml    # Flutter DevTools configuration
├── pubspec.yaml             # Project dependencies and configuration
├── pubspec.lock             # Locked dependency versions
└── README.md                # Project documentation
```

The repository currently contains dedicated `android`, `assets`, `bin`, `lib`, and `test` directories.

---

## 🧠 Question System

The core concept of Imposter SMS is based on **paired questions**.

Each game round uses two related questions:

```text
                 Question Pair
                      │
            ┌─────────┴─────────┐
            │                   │
       Crew Question       Imposter Question
            │                   │
       Most Players          One Player
```

### Example

```text
Category: Dating

Crewmates:
"What is your longest relationship?"

Imposter:
"What is the longest date you've been on?"
```

The questions should:

* Have a similar subject.
* Be answerable with a short response.
* Allow the Imposter to blend into the group.
* Create enough ambiguity for discussion.
* Avoid making the Imposter immediately obvious.

---

## 📱 SMS Permissions

Because SMS functionality is a core part of the application, Android permissions may be required.

The application uses the `permission_handler` package for runtime permission management and `another_telephony` for SMS functionality.

When running the application on a physical Android device, make sure the required permissions are granted.

> **Important:** SMS functionality may behave differently on emulators and physical devices. For real-world testing, a physical Android device is recommended.

---

## 🔢 Version Management

The project includes an automated version-management script:

```text
bin/version_manager.dart
```

The script can update the application version, commit the change, and create a Git tag.

### Build Version

Increment the build number:

```bash
dart bin/version_manager.dart build
```

Example:

```text
1.3.1+10 → 1.3.1+11
```

### Patch Version

```bash
dart bin/version_manager.dart patch
```

Example:

```text
1.3.1+10 → 1.3.2+11
```

### Minor Version

```bash
dart bin/version_manager.dart minor
```

Example:

```text
1.3.1+10 → 1.4.0+11
```

### Major Version

```bash
dart bin/version_manager.dart major
```

Example:

```text
1.3.1+10 → 2.0.0+11
```

The script automatically:

1. Updates the version in `pubspec.yaml`.
2. Commits the version change.
3. Creates a Git tag for the new version.

---

## 🤝 Contributing

Contributions are welcome.

### 1. Fork the Repository

Fork the project on GitHub.

### 2. Clone Your Fork

```bash
git clone https://github.com/YOUR_USERNAME/imposterSMS.git
cd imposterSMS
```

### 3. Create a Feature Branch

```bash
git checkout -b feature/my-new-feature
```

### 4. Make Your Changes

Implement your feature or fix.

Before submitting your changes, run:

```bash
flutter analyze
```

and:

```bash
flutter test
```

### 5. Commit Your Changes

Use a clear commit message:

```bash
git add .
git commit -m "feat: add new question category"
```

### 6. Push Your Branch

```bash
git push origin feature/my-new-feature
```

### 7. Open a Pull Request

Open a Pull Request against the `main` branch.

### Contribution Guidelines

When contributing:

* Keep the code readable and maintainable.
* Follow Dart and Flutter conventions.
* Add tests for important game logic.
* Avoid committing generated secrets or private information.
* Keep question content appropriate for the intended category.
* Test SMS-related functionality on a real Android device when possible.

---

## 📄 License

This project is currently published as a public GitHub repository.

If this project is intended to be distributed as open source, add a license file such as:

```text
LICENSE
```

and update this section with the exact license terms.

**Until a license is explicitly added to the repository, the source code should not be assumed to be freely reusable, modified, or redistributed.**

---

## 🔗 Important Links

### Repository

[GitHub Repository](https://github.com/symon1289/imposterSMS)

### Flutter

[Flutter Documentation](https://docs.flutter.dev/)

### Dart

[Dart Documentation](https://dart.dev/)

### Flutter Packages

[pub.dev](https://pub.dev/)

### Provider

[Provider on pub.dev](https://pub.dev/packages/provider)

### Hive

[Hive on pub.dev](https://pub.dev/packages/hive)

### Another Telephony

[Another Telephony on pub.dev](https://pub.dev/packages/another_telephony)

### AudioPlayers

[AudioPlayers on pub.dev](https://pub.dev/packages/audioplayers)

### Permission Handler

[Permission Handler on pub.dev](https://pub.dev/packages/permission_handler)

---

## 📌 Project Status

**Current Version:** `1.3.1+10`

**Platform:** Android

**Framework:** Flutter

The repository is under active development and may change as new game modes, question categories, UI improvements, and gameplay features are introduced.

---

## 🎭 Footer

<p align="center">
  <strong>Imposter SMS</strong>
</p>

<p align="center">
  Ask the question. Hide the answer. Find the Imposter.
</p>

<p align="center">
  Made with ❤️ using Flutter & Dart
</p>

<p align="center">
  <a href="https://github.com/symon1289/imposterSMS">GitHub</a>
  ·
  <a href="https://github.com/symon1289/imposterSMS/issues">Issues</a>
</p>


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
