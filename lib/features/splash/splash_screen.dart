import 'package:flutter/material.dart';

import '../../shared/widgets/app_logo.dart';
import '../../shared/widgets/home_shell.dart';

const _logoSize = 120.0;

/// Hauteur de chute avant impact, en pixels logiques (~1,5x le logo).
const _dropHeight = 180.0;

/// Décalages (début, fin) des 3 anneaux d'onde, sur la timeline du
/// contrôleur commun : chaque anneau démarre un peu après le précédent.
const _ringIntervals = [
  Interval(0.0, 0.6, curve: Curves.easeOut),
  Interval(0.15, 0.75, curve: Curves.easeOut),
  Interval(0.3, 0.9, curve: Curves.easeOut),
];

/// Écran de démarrage : le logo tombe et rebondit au sol comme un ballon
/// (`Curves.bounceOut`), pendant que des anneaux d'onde pulsent depuis le
/// point d'impact, avant un fondu vers l'écran principal.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<Animation<double>> _ringScales;
  late final List<Animation<double>> _ringOpacities;
  late final Animation<double> _logoBounce;
  late final Animation<double> _logoOpacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));

    _ringScales = _ringIntervals
        .map(
          (interval) => Tween(
            begin: 0.3,
            end: 3.0,
          ).animate(CurvedAnimation(parent: _controller, curve: interval)),
        )
        .toList();
    _ringOpacities = _ringIntervals
        .map(
          (interval) => Tween(
            begin: 0.35,
            end: 0.0,
          ).animate(CurvedAnimation(parent: _controller, curve: interval)),
        )
        .toList();

    // Chute + rebond façon ballon : part au-dessus du point de repos
    // (`-_dropHeight`) et retombe à 0 avec la courbe `bounceOut`, qui simule
    // naturellement plusieurs rebonds d'amplitude décroissante.
    _logoBounce = Tween(
      begin: -_dropHeight,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.bounceOut));
    _logoOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.15, curve: Curves.easeOut),
    );

    _controller.forward().whenComplete(() {
      Future.delayed(const Duration(milliseconds: 400), _goToHome);
    });
  }

  void _goToHome() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) => const HomeShell(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return SizedBox(
              width: _logoSize * 3,
              height: _logoSize * 3,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  for (var i = 0; i < _ringIntervals.length; i++)
                    Container(
                      width: _logoSize * _ringScales[i].value,
                      height: _logoSize * _ringScales[i].value,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colorScheme.primary.withValues(alpha: _ringOpacities[i].value),
                      ),
                    ),
                  Transform.translate(
                    offset: Offset(0, _logoBounce.value),
                    child: FadeTransition(
                      opacity: _logoOpacity,
                      child: const AppLogo(size: _logoSize),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
