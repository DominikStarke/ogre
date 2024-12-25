import 'package:flutter/material.dart';

ColorScheme get darkScheme => ColorScheme.fromSeed(seedColor: Colors.teal, brightness: Brightness.dark);
ColorScheme get lightScheme => ColorScheme.fromSeed(seedColor: Colors.teal, brightness: Brightness.light);

TextTheme get textTheme => const TextTheme(
  bodyLarge: TextStyle(fontSize: 13, fontWeight: FontWeight.w300),
  bodyMedium: TextStyle(fontSize: 13, fontWeight: FontWeight.w300),
  bodySmall: TextStyle(fontSize: 10, fontWeight: FontWeight.w300),

  labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
  labelMedium: TextStyle(fontSize: 13, fontWeight: FontWeight.w300),
  labelSmall: TextStyle(fontSize: 10, fontWeight: FontWeight.w300),

  titleLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  titleMedium: TextStyle(fontSize: 13, fontWeight: FontWeight.w300),
  titleSmall: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
);

InputDecorationTheme get inputDecorationTheme => const InputDecorationTheme(
  border: OutlineInputBorder(),
);

ThemeData getTheme(Brightness brightness) {
  return ThemeData(
    useMaterial3: true,
    colorScheme: brightness == Brightness.light ? lightScheme : darkScheme,
    textTheme: textTheme,
    inputDecorationTheme: inputDecorationTheme,
  );
}
