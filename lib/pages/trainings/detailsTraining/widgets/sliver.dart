import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class DetailSliverDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final double expandedHeight = 300;
    final double roundedContainerHeight = 50;
    final scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;

    return Stack(
      children: [
        Hero(
          tag: 'popular-game-placeholder',
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: expandedHeight,
            color: Theme.of(context).colorScheme.primary,
            child: ModelViewer(
              src: 'assets/test.glb',
              alt: 'A 3D model',
              ar: false, // Désactivé pour éviter l'accès à la caméra
              autoRotate: true,
              cameraControls: true,
              disableZoom: false,
              backgroundColor: Theme.of(context).colorScheme.primary,
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
              color: scaffoldBackgroundColor,
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
  double get maxExtent => 300;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

