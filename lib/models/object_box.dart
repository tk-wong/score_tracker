import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import '../objectbox.g.dart'; // created by `flutter pub run build_runner build`

class ObjectBox {
  /// The Store of this app.
  late final Store _store;

  ObjectBox._create(this._store) {
    // Add any additional setup code, e.g. build queries.
  }

  /// Create an instance of ObjectBox to use throughout the app.
  static Future<ObjectBox> create() async {
    // Future<Store> openStore() {...} is defined in the generated objectbox.g.dart
    late final Store store;
    if (kDebugMode) {
      store = await openStore(directory: "memory:objectbox-score-app");
    } else {
      final docsDir = await getApplicationDocumentsDirectory();
      store = await openStore(
        directory: p.join(docsDir.path, "objectbox-score-app"),
      );
    }
    return ObjectBox._create(store);
  }

  /// A getter to get the Store of this app.
  Store get store => _store;
}

// https://docs.objectbox.io/getting-started
