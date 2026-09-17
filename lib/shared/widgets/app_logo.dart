import 'package:flutter/material.dart';

/// Logo de l'application : cercle au dégradé de marque (primary → tertiary,
/// identique à la bannière d'économie de l'historique) avec une tirelire
/// blanche centrée. Réutilisé pour l'icône de l'app et l'écran de démarrage
/// animé afin que les deux partagent exactement le même dessin.
class AppLogo extends StatelessWidget {
  final double size;

  const AppLogo({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colorScheme.primary, colorScheme.tertiary],
        ),
      ),
      child: Center(
        child: Icon(Icons.savings_rounded, color: Colors.white, size: size * 0.52),
      ),
    );
  }
}
