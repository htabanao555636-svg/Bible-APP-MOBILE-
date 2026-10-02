import 'package:bible_app/app/app.dart';
import 'package:bible_app/firebase_options.dart';
import 'package:bible_app/providers/font_size_provider.dart';
import 'package:bible_app/providers/theme_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await ThemeController.instance.load();
  await FontSizeController.instance.load();
  runApp(const MyApp());
}
