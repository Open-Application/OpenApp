import 'package:flutter/material.dart';
import '../ui.dart';

class AnimationDurations {
  static const Duration instant = Duration(milliseconds: 100);
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration medium = Duration(milliseconds: 500);
  static const Duration short = Duration(milliseconds: 600);
  static const Duration slow = Duration(milliseconds: 600);
  static const Duration slower = Duration(milliseconds: 800);
  static const Duration long = Duration(milliseconds: 1200);
  static const Duration verySlow = Duration(milliseconds: 1200);
  static const Duration extraSlow = Duration(milliseconds: 2000);
}

class AnimationCurves {
  static const Curve easeIn = Curves.easeIn;
  static const Curve easeOut = Curves.easeOut;
  static const Curve easeInOut = Curves.easeInOut;
  static const Curve easeInOutCubic = Curves.easeInOutCubic;
  static const Curve easeOutCubic = Curves.easeOutCubic;
  static const Curve bounceOut = Curves.bounceOut;
  static const Curve elasticOut = Curves.elasticOut;
}

mixin RccAnimationMixin<T extends StatefulWidget> on TickerProviderStateMixin<T> {
  late AnimationController _animationController;
  AnimationController get animationController => _animationController;
  AnimationController get primaryController => _animationController;
  AnimationController? _secondaryController;
  AnimationController? get secondaryController => _secondaryController;

  late Animation<double> _fadeAnimation;
  Animation<double> get fadeAnimation => _fadeAnimation;

  late Animation<Offset> _slideAnimation;
  Animation<Offset> get slideAnimation => _slideAnimation;

  late Animation<double> _scaleAnimation;
  Animation<double> get scaleAnimation => _scaleAnimation;

  List<Animation<double>> _itemAnimations = [];
  List<Animation<double>> get itemAnimations => _itemAnimations;

  void initializeAnimation({
    Duration duration = const Duration(milliseconds: 800),
    bool autoStart = true,
  }) {
    _animationController = AnimationController(duration: duration, vsync: this);

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    if (autoStart) {
      _animationController.forward();
    }
  }

  void initializeSecondaryAnimation({
    Duration duration = const Duration(milliseconds: 1200),
    bool autoStart = false,
  }) {
    _secondaryController = AnimationController(duration: duration, vsync: this);
    if (autoStart) {
      _secondaryController!.forward();
    }
  }

  void initializeItemAnimations(int count) {
    _itemAnimations = List.generate(count, (index) {
      final double start = (index * 0.08).clamp(0.0, 0.9);
      final double end = (start + 0.3).clamp(start, 1.0);

      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(
            start,
            end,
            curve: Curves.easeOutCubic,
          ),
        ),
      );
    });
  }

  Animation<double> createFadeAnimation({
    required AnimationController controller,
    double begin = 0.0,
    double end = 1.0,
    Curve curve = Curves.easeOut,
  }) {
    return Tween<double>(begin: begin, end: end).animate(
      CurvedAnimation(parent: controller, curve: curve),
    );
  }

  Animation<Offset> createSlideAnimation({
    required AnimationController controller,
    Offset begin = const Offset(0, 0.2),
    Offset end = Offset.zero,
    Curve curve = Curves.easeOut,
  }) {
    return Tween<Offset>(begin: begin, end: end).animate(
      CurvedAnimation(parent: controller, curve: curve),
    );
  }

  Animation<double> createScaleAnimation({
    required AnimationController controller,
    double begin = 0.8,
    double end = 1.0,
    Curve curve = Curves.easeOut,
  }) {
    return Tween<double>(begin: begin, end: end).animate(
      CurvedAnimation(parent: controller, curve: curve),
    );
  }

  void disposeAnimations() {
    _animationController.dispose();
    _secondaryController?.dispose();
  }
}

class RccLoadingIndicator extends StatelessWidget {
  final double? size;
  final Color? color;
  final double strokeWidth;

  const RccLoadingIndicator({
    super.key,
    this.size,
    this.color,
    this.strokeWidth = 2.0,
  });

  factory RccLoadingIndicator.small({Color? color}) {
    return RccLoadingIndicator(
      size: 16,
      color: color,
      strokeWidth: 2.0,
    );
  }

  factory RccLoadingIndicator.medium({Color? color}) {
    return RccLoadingIndicator(
      size: 24,
      color: color,
      strokeWidth: 2.5,
    );
  }

  factory RccLoadingIndicator.large({Color? color}) {
    return RccLoadingIndicator(
      size: 36,
      color: color,
      strokeWidth: 3.0,
    );
  }

  factory RccLoadingIndicator.page({Color? color}) {
    return RccLoadingIndicator(
      size: 48,
      color: color,
      strokeWidth: 3.5,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final actualSize = size ?? UI.scaledDimension(24);

    return Center(
      child: SizedBox(
        width: actualSize,
        height: actualSize,
        child: CircularProgressIndicator(
          strokeWidth: strokeWidth,
          valueColor: AlwaysStoppedAnimation<Color>(
            color ?? theme.colorScheme.primary,
          ),
        ),
      ),
    );
  }
}

class RccEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? description;
  final Widget? action;
  final double? iconSize;
  final Color? iconColor;

  const RccEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.description,
    this.action,
    this.iconSize,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: UI.paddingAll(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: iconSize ?? UI.adaptiveIconSize(64),
              color: iconColor ?? theme.colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            SizedBox(height: UI.responsiveSpacing(24)),
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            if (description != null) ...[
              SizedBox(height: UI.responsiveSpacing(8)),
              Text(
                description!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (action != null) ...[
              SizedBox(height: UI.responsiveSpacing(24)),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}