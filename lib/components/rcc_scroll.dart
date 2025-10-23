import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/preferences_provider.dart';

class RccScrollBehavior extends ScrollBehavior {
  final bool disableGlow;

  const RccScrollBehavior({this.disableGlow = false});

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    final prefsProvider = context.read<PreferencesProvider?>();
    final needsOptimization = prefsProvider?.needsRenderingOptimization ?? false;

    if (disableGlow || needsOptimization) {
      return child;
    }

    return super.buildOverscrollIndicator(context, child, details);
  }

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    final prefsProvider = context.read<PreferencesProvider?>();
    final needsOptimization = prefsProvider?.needsRenderingOptimization ?? false;

    if (needsOptimization) {
      return const ClampingScrollPhysics(
        parent: RangeMaintainingScrollPhysics(),
      );
    }

    return const ClampingScrollPhysics();
  }
}

class NoOverscrollPhysics extends ScrollPhysics {
  const NoOverscrollPhysics({super.parent});

  @override
  NoOverscrollPhysics applyTo(ScrollPhysics? ancestor) {
    return NoOverscrollPhysics(parent: buildParent(ancestor));
  }

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    if (value < position.pixels && position.pixels <= position.minScrollExtent) {
      return value - position.pixels;
    }
    if (position.maxScrollExtent <= position.pixels && position.pixels < value) {
      return value - position.pixels;
    }
    if (value < position.minScrollExtent && position.minScrollExtent < position.pixels) {
      return value - position.minScrollExtent;
    }
    if (position.pixels < position.maxScrollExtent && position.maxScrollExtent < value) {
      return value - position.maxScrollExtent;
    }
    return 0.0;
  }

  @override
  Simulation? createBallisticSimulation(ScrollMetrics position, double velocity) {
    final ScrollPhysics? parent = this.parent;
    if (parent != null) {
      return parent.createBallisticSimulation(position, velocity);
    }

    final tolerance = toleranceFor(position);
    if (velocity.abs() < tolerance.velocity ||
        (velocity < 0.0 && position.pixels <= position.minScrollExtent) ||
        (velocity > 0.0 && position.pixels >= position.maxScrollExtent)) {
      return null;
    }

    return ClampingScrollSimulation(
      position: position.pixels,
      velocity: velocity,
      tolerance: tolerance,
    );
  }

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    if ((offset < 0.0 && position.pixels <= position.minScrollExtent) ||
        (offset > 0.0 && position.pixels >= position.maxScrollExtent)) {
      return offset * 0.5;
    }
    return offset;
  }

  @override
  SpringDescription get spring => const SpringDescription(
        mass: 0.5,
        stiffness: 100.0,
        damping: 1.0,
      );
}