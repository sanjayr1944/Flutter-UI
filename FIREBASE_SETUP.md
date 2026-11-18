# Connect a Flutter app to Firebase

1. Create a Firebase project in the [Firebase Console](https://console.firebase.google.com/).
2. Register an app for each platform you plan to support. For Android, use the application ID from `android/app/build.gradle.kts`.
3. Install the [Firebase CLI](https://firebase.google.com/docs/cli), then sign in:

   ```bash
   firebase login
   ```

4. Open a terminal in the Flutter project folder, the one containing `pubspec.yaml`, and add Firebase Core:

   ```bash
   flutter pub add firebase_core
   ```

5. Install the FlutterFire CLI:

   ```bash
   dart pub global activate flutterfire_cli
   ```

   On Windows, if `flutterfire` is not recognized, add `%LOCALAPPDATA%\Pub\Cache\bin` to `PATH` and reopen the terminal.

6. Configure the project and select the Firebase project and Flutter platforms:

   ```bash
   flutterfire configure
   ```

   This generates `lib/firebase_options.dart` and the platform configuration files.

7. Initialize Firebase in `lib/main.dart` before calling `runApp`:

   ```dart
   WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp(
     options: DefaultFirebaseOptions.currentPlatform,
   );
   runApp(const MyApp());
   ```

   Import `package:firebase_core/firebase_core.dart` and `firebase_options.dart`.

8. Add the Flutter plugin for each Firebase product you use, for example:

   ```bash
   flutter pub add firebase_auth cloud_firestore
   ```

9. Run `flutterfire configure` again after adding a Firebase product or platform, then enable the needed Firebase services in the Firebase Console. For this app, enable the sign-in providers used by Firebase Authentication and create a Cloud Firestore database.
10. Set secure Firebase Authentication and Firestore rules for your app before using real user data.
11. Fetch packages and run the app:

    ```bash
    flutter pub get
    flutter run
    ```

12. Follow the [official FlutterFire setup guide](https://firebase.google.com/docs/flutter/setup) if setup options or platform requirements change.
