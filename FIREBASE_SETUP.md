# Configure this Flutter app with Firebase

1. Clone the repository and switch to the `firebase` branch:

   ```bash
   git clone --branch firebase https://github.com/sanjayr1944/Flutter-UI.git
   cd Flutter-UI
   ```

2. In the [Firebase Console](https://console.firebase.google.com/), select the Firebase project provided by your team, or create a development project if your team asks you to. Do not use a production project for experiments.
3. Check the app identifiers before registering platforms. For Android, check `applicationId` in `android/app/build.gradle.kts`. For iOS, check the Bundle Identifier in the Runner target in Xcode. Keep the identifiers unchanged unless you intend to register new Firebase apps.
4. Install the Firebase CLI. On Windows with Node.js 18 or later installed, run:

   ```bash
   npm install -g firebase-tools
   ```

   On other systems, follow the [Firebase CLI installation instructions](https://firebase.google.com/docs/cli#install_the_firebase_cli).

5. Sign in with the Google account that has access to the team Firebase project and verify that the project is visible:

   ```bash
   firebase login
   firebase projects:list
   ```

6. Install the FlutterFire CLI:

   ```bash
   dart pub global activate flutterfire_cli
   ```

   On Windows, if `flutterfire` is not recognized, add `%LOCALAPPDATA%\Pub\Cache\bin` to `PATH`, then reopen the terminal.

7. Open a terminal in the Flutter project root, the folder containing `pubspec.yaml`, and fetch the packages:

   ```bash
   flutter pub get
   ```

8. Configure the Flutter platforms with the selected Firebase project:

   ```bash
   flutterfire configure
   ```

   Select the team Firebase project, then select each platform you plan to run (Android, iOS, or web). The CLI registers or matches the platform apps and generates `lib/firebase_options.dart` plus required platform configuration.

9. Confirm that `firebase_core` is in `pubspec.yaml`. If it is missing, add it:

   ```bash
   flutter pub add firebase_core
   ```

10. Initialize Firebase in `lib/main.dart` before creating widgets or calling `runApp`:

    ```dart
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(const MyApp());
    ```

    Import `package:firebase_core/firebase_core.dart` and `firebase_options.dart`. This repository already initializes Firebase this way in `lib/main.dart`.

11. Add the Flutter plugin for each Firebase product the app uses. This app already includes Firebase Authentication and Cloud Firestore in `pubspec.yaml`; for another product, add its Flutter plugin with `flutter pub add PLUGIN_NAME`.
12. Run `flutterfire configure` again after adding a Firebase product or platform so the Firebase configuration stays current.
13. In the Firebase Console, enable the sign-in providers used by Firebase Authentication, create the Cloud Firestore database, and set rules that limit access to authorized users. Do not use open test rules with real data.
14. Run the app on a selected platform:

    ```bash
    flutter run
    ```

15. When switching to a different Firebase project, run `flutterfire configure` again and select that project. Review the generated configuration changes before committing them.
16. Use the [official FlutterFire setup guide](https://firebase.google.com/docs/flutter/setup) and [Firebase CLI guide](https://firebase.google.com/docs/cli) for current platform requirements and command details.
