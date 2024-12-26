import 'package:flutter/material.dart';

ColorScheme getDarkScheme ([Color color = Colors.teal]) => ColorScheme.fromSeed(
  seedColor: color,
  contrastLevel: .2,
  dynamicSchemeVariant: DynamicSchemeVariant.fruitSalad,
  brightness: Brightness.dark
);

ColorScheme getLightScheme ([Color color = Colors.teal]) => ColorScheme.fromSeed(
  seedColor: color,
  contrastLevel: .2,
  dynamicSchemeVariant: DynamicSchemeVariant.fruitSalad,
  brightness: Brightness.light
);

TextTheme get textTheme => const TextTheme(
  bodyLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
  bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
  bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),

  labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
  labelMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
  labelSmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),

  titleLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  titleMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
  titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
);

InputDecorationTheme get inputDecorationTheme => const InputDecorationTheme(
  border: OutlineInputBorder(),
);

ThemeData getTheme({
  required Brightness brightness,
  required Color color
}) {
  return ThemeData(
    useMaterial3: true,
    colorScheme: brightness == Brightness.light
      ? getLightScheme(color)
      : getDarkScheme(color),
    textTheme: textTheme,
    inputDecorationTheme: inputDecorationTheme,
  );
}
