# score_app

A score app that can mark the reason for score changes, manage the default reasons, and record score history.

It should be able to run on Android, iOS, and desktop. Notice that it does not support web since it uses ObjectBox for data storage, which does not have web support. Also, the development process is focused on android and desktop (windows and linux(ubuntu)), so the UI may not be optimized for iOS and mac.

## install step
1. ensure you have Flutter installed. If not, follow the instructions on the official Flutter website: https://flutter.dev/docs/get-started/install
2. install dependencies (objectbox, cupertino_icons)
```bash
flutter pub get
```
3. run app
```bash
flutter run
```

## build apk
```bash
flutter build apk --release
```

## build desktop app
```bash
flutter build windows --release # for windows
flutter build linux --release # for linux
```