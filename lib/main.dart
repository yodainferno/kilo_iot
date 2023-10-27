import 'package:flutter/material.dart' show runApp;
import 'package:flutter_riverpod/flutter_riverpod.dart' show ProviderScope;
import 'app.dart' show App;

void main() {
  runApp(
    const ProviderScope( // только 1 оболочка на верхнем уровне
      child: App()
    )
  );
}
