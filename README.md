# Lenra Client Store

The Lenra Client Store in Flutter.

### Requirements
- [flutter](https://flutter.dev/docs/get-started/install) + [web setup](https://flutter.dev/docs/get-started/web)

## Getting Started

Run flutter app with chrome
```sh
flutter run -d chrome --web-port 10000 --dart-define=LENRA_SERVER_URL=http://localhost:4000
```

Run flutter test
```sh
flutter test
```

Run flutter test with coverage report (need to install lcov)
```sh
flutter test --coverage && lcov --list coverage/lcov.info
```
