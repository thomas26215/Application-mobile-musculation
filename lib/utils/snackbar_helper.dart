import 'package:flutter/material.dart';

enum SnackBarType { info, success, error }

void showCustomNotification(BuildContext context, String message, {SnackBarType type = SnackBarType.info}) {
  Color backgroundColor;
  IconData icon;

  switch (type) {
    case SnackBarType.success:
      backgroundColor = Colors.green.shade700;
      icon = Icons.check_box;
      break;
    case SnackBarType.error:
      backgroundColor = Colors.red.shade700;
      icon = Icons.stop;
      break;
    case SnackBarType.info:
    default:
      backgroundColor = Colors.blue.shade700;
      icon = Icons.info_outline;
  }

  final overlay = Overlay.of(context);
  final notificationKey = GlobalKey<_AnimatedNotificationState>();
  late OverlayEntry overlayEntry;

  overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: MediaQuery.of(context).padding.top + 20,
      left: 20,
      right: 20,
      child: AnimatedNotification(
        key: notificationKey,
        icon: icon,
        message: message,
        backgroundColor: backgroundColor,
        onDismiss: () {
          if (overlayEntry.mounted) overlayEntry.remove();
        },
      ),
    ),
  );

  overlay.insert(overlayEntry);

  Future.delayed(const Duration(seconds: 3), () {
    if (overlayEntry.mounted) {
      notificationKey.currentState?.dismiss();
    }
  });
}

class AnimatedNotification extends StatefulWidget {
  final IconData icon;
  final String message;
  final Color backgroundColor;
  final VoidCallback onDismiss;

  const AnimatedNotification({
    Key? key,
    required this.icon,
    required this.message,
    required this.backgroundColor,
    required this.onDismiss,
  }) : super(key: key);

  @override
  _AnimatedNotificationState createState() => _AnimatedNotificationState();
}

class _AnimatedNotificationState extends State<AnimatedNotification> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _expand;
  bool _isDismissing = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _expand = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    _controller.forward();
  }

  Future<void> dismiss() async {
    if (_isDismissing) return;
    _isDismissing = true;
    await _controller.reverse();
    widget.onDismiss();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        if (details.primaryDelta != null && details.primaryDelta! < -10) {
          dismiss();
        }
      },
      child: Align(
        alignment: Alignment.topCenter,
        child: ClipRect(
          child: AnimatedBuilder(
            animation: _expand,
            builder: (context, child) {
              return Align(
                alignment: Alignment.centerLeft,
                widthFactor: _expand.value,
                child: child,
              );
            },
            child: LayoutBuilder(
              builder: (context, constraints) {
                // On limite la largeur maximale à la largeur de l'écran moins les marges
                double maxWidth = constraints.maxWidth;
                return ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: maxWidth,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: widget.backgroundColor,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(widget.icon, color: Colors.white, size: 24),
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 14),
                            child: Text(
                              widget.message,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                decoration: TextDecoration.none,
                              ),
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3, // Limite à 3 lignes, ajuste selon besoin
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

