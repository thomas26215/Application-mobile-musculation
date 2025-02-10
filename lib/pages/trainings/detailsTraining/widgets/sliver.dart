import 'package:flutter/material.dart';

class DetailSliverDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final double expandedHeight = 300; // Hauteur fixe
    final double roundedContainerHeight = 50; // Hauteur fixe
    final scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;

    return Stack(
      children: [
        Hero(
          tag: 'popular-game-placeholder',
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: expandedHeight,
            color: Theme.of(context).colorScheme.primary, // Couleur de fond pour simuler un espace réservé
            child: Icon(
              Icons.sports_esports, // Icône représentant un jeu
              size: 100,
              color: Colors.grey[600],
            ),
          ),
        ),
        Positioned(
          top: expandedHeight - roundedContainerHeight - shrinkOffset,
          left: 0,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: roundedContainerHeight,
            decoration: BoxDecoration(
              color: scaffoldBackgroundColor, // Utilisation de la couleur d'arrière-plan principale
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).padding.top,
          left: 16,
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back, color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }

  @override
  double get maxExtent => 300; // Hauteur maximale fixe

  @override
  double get minExtent => kToolbarHeight; // Hauteur minimale (barre d'outils)

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

