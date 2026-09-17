import 'package:flutter/material.dart';

/// Vert/teal calme plutôt que le rouge de marque MVola : le rôle `error` de
/// Material 3 est déjà rouge, semer tout le thème depuis le rouge d'un
/// produit tiers créerait une collision visuelle avec les états d'erreur.
/// Le vert renforce en plus l'idée d'économie réalisée à chaque interaction.
const _seedColor = Color(0xFF00695C);

const _cardShape = RoundedRectangleBorder(
  borderRadius: BorderRadius.all(Radius.circular(16)),
);

ThemeData _themeFrom(Brightness brightness) {
  final colorScheme = ColorScheme.fromSeed(seedColor: _seedColor, brightness: brightness);
  return ThemeData(
    useMaterial3: true,
    fontFamily: 'Montserrat',
    colorScheme: colorScheme,
    scaffoldBackgroundColor: colorScheme.surface,
    cardTheme: CardThemeData(
      elevation: 0,
      shape: _cardShape,
      color: colorScheme.surfaceContainerLow,
      margin: EdgeInsets.zero,
    ),
    chipTheme: ChipThemeData(
      shape: const StadiumBorder(),
      selectedColor: colorScheme.primaryContainer,
      labelStyle: TextStyle(color: colorScheme.onSurface),
      side: BorderSide(color: colorScheme.outlineVariant),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: colorScheme.primary, width: 2),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      indicatorColor: colorScheme.secondaryContainer,
      backgroundColor: colorScheme.surface,
      elevation: 0,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}

final lightTheme = _themeFrom(Brightness.light);
final darkTheme = _themeFrom(Brightness.dark);
