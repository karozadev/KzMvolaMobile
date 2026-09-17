import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

const _portfolioUrl = 'https://stephanot.karoza.dev';

/// Signature de l'auteur affichée en bas de l'écran principal, avec un lien
/// vers son portfolio.
class AppCreditFooter extends StatelessWidget {
  const AppCreditFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => launchUrl(Uri.parse(_portfolioUrl)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Text(
            'Créé avec ❤️ par Stephanot Zafindratafa',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
          ),
        ),
      ),
    );
  }
}
