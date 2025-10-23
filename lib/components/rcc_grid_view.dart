import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import '../providers/preferences_provider.dart';

class RccGridView extends StatelessWidget {
  final List<Widget> children;
  final SliverGridDelegate gridDelegate;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final ScrollController? controller;
  final bool shrinkWrap;
  final bool reverse;
  final Axis scrollDirection;
  final bool? primary;
  final double? cacheExtent;
  final DragStartBehavior dragStartBehavior;
  final Clip clipBehavior;
  final String? restorationId;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;

  const RccGridView({
    super.key,
    required this.children,
    required this.gridDelegate,
    this.padding,
    this.physics,
    this.controller,
    this.shrinkWrap = false,
    this.reverse = false,
    this.scrollDirection = Axis.vertical,
    this.primary,
    this.cacheExtent,
    this.dragStartBehavior = DragStartBehavior.start,
    this.clipBehavior = Clip.hardEdge,
    this.restorationId,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
  });

  @override
  Widget build(BuildContext context) {
    final prefsProvider = context.watch<PreferencesProvider?>();
    final isHarmonyOS = prefsProvider?.isHuaweiDevice ?? false;

    if (!isHarmonyOS) {
      return GridView(
        gridDelegate: gridDelegate,
        padding: padding,
        physics: physics ?? const ClampingScrollPhysics(),
        controller: controller,
        shrinkWrap: shrinkWrap,
        reverse: reverse,
        scrollDirection: scrollDirection,
        primary: primary,
        cacheExtent: cacheExtent,
        dragStartBehavior: dragStartBehavior,
        clipBehavior: clipBehavior,
        restorationId: restorationId,
        keyboardDismissBehavior: keyboardDismissBehavior,
        children: children,
      );
    }

    return RepaintBoundary(
      child: ScrollConfiguration(
        behavior: const _NoGlowScrollBehavior(),
        child: CustomScrollView(
          controller: controller,
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          shrinkWrap: shrinkWrap,
          reverse: reverse,
          scrollDirection: scrollDirection,
          primary: primary,
          cacheExtent: cacheExtent,
          dragStartBehavior: dragStartBehavior,
          clipBehavior: clipBehavior,
          restorationId: restorationId,
          keyboardDismissBehavior: keyboardDismissBehavior,
          slivers: [
            SliverPadding(
              padding: padding ?? EdgeInsets.zero,
              sliver: SliverGrid(
                gridDelegate: gridDelegate,
                delegate: SliverChildBuilderDelegate(
                  (context, index) => RepaintBoundary(child: children[index]),
                  childCount: children.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RccGridViewBuilder extends StatelessWidget {
  final IndexedWidgetBuilder itemBuilder;
  final int? itemCount;
  final SliverGridDelegate gridDelegate;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final ScrollController? controller;
  final bool shrinkWrap;
  final bool reverse;
  final Axis scrollDirection;
  final bool? primary;
  final double? cacheExtent;
  final DragStartBehavior dragStartBehavior;
  final Clip clipBehavior;
  final String? restorationId;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;
  final int? semanticChildCount;

  const RccGridViewBuilder({
    super.key,
    required this.itemBuilder,
    required this.gridDelegate,
    this.itemCount,
    this.padding,
    this.physics,
    this.controller,
    this.shrinkWrap = false,
    this.reverse = false,
    this.scrollDirection = Axis.vertical,
    this.primary,
    this.cacheExtent,
    this.dragStartBehavior = DragStartBehavior.start,
    this.clipBehavior = Clip.hardEdge,
    this.restorationId,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.semanticChildCount,
  });

  @override
  Widget build(BuildContext context) {
    final prefsProvider = context.watch<PreferencesProvider?>();
    final isHarmonyOS = prefsProvider?.isHuaweiDevice ?? false;

    if (!isHarmonyOS) {
      return GridView.builder(
        gridDelegate: gridDelegate,
        padding: padding,
        physics: physics ?? const ClampingScrollPhysics(),
        controller: controller,
        shrinkWrap: shrinkWrap,
        reverse: reverse,
        scrollDirection: scrollDirection,
        primary: primary,
        cacheExtent: cacheExtent,
        dragStartBehavior: dragStartBehavior,
        clipBehavior: clipBehavior,
        restorationId: restorationId,
        keyboardDismissBehavior: keyboardDismissBehavior,
        addAutomaticKeepAlives: addAutomaticKeepAlives,
        addRepaintBoundaries: addRepaintBoundaries,
        addSemanticIndexes: addSemanticIndexes,
        semanticChildCount: semanticChildCount,
        itemCount: itemCount,
        itemBuilder: itemBuilder,
      );
    }

    return RepaintBoundary(
      child: ScrollConfiguration(
        behavior: const _NoGlowScrollBehavior(),
        child: CustomScrollView(
          controller: controller,
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          shrinkWrap: shrinkWrap,
          reverse: reverse,
          scrollDirection: scrollDirection,
          primary: primary,
          cacheExtent: cacheExtent,
          dragStartBehavior: dragStartBehavior,
          clipBehavior: clipBehavior,
          restorationId: restorationId,
          keyboardDismissBehavior: keyboardDismissBehavior,
          slivers: [
            SliverPadding(
              padding: padding ?? EdgeInsets.zero,
              sliver: SliverGrid(
                gridDelegate: gridDelegate,
                delegate: SliverChildBuilderDelegate(
                  (context, index) =>
                      RepaintBoundary(child: itemBuilder(context, index)),
                  childCount: itemCount,
                  addAutomaticKeepAlives: addAutomaticKeepAlives,
                  addRepaintBoundaries: false,
                  addSemanticIndexes: addSemanticIndexes,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RccGridViewCount extends StatelessWidget {
  final List<Widget> children;
  final int crossAxisCount;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final double childAspectRatio;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final ScrollController? controller;
  final bool shrinkWrap;
  final bool reverse;
  final bool? primary;
  final double? cacheExtent;
  final DragStartBehavior dragStartBehavior;
  final Clip clipBehavior;
  final String? restorationId;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;

  const RccGridViewCount({
    super.key,
    required this.children,
    required this.crossAxisCount,
    this.mainAxisSpacing = 0.0,
    this.crossAxisSpacing = 0.0,
    this.childAspectRatio = 1.0,
    this.padding,
    this.physics,
    this.controller,
    this.shrinkWrap = false,
    this.reverse = false,
    this.primary,
    this.cacheExtent,
    this.dragStartBehavior = DragStartBehavior.start,
    this.clipBehavior = Clip.hardEdge,
    this.restorationId,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
  });

  @override
  Widget build(BuildContext context) {
    return RccGridView(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: mainAxisSpacing,
        crossAxisSpacing: crossAxisSpacing,
        childAspectRatio: childAspectRatio,
      ),
      padding: padding,
      physics: physics,
      controller: controller,
      shrinkWrap: shrinkWrap,
      reverse: reverse,
      scrollDirection: Axis.vertical,
      primary: primary,
      cacheExtent: cacheExtent,
      dragStartBehavior: dragStartBehavior,
      clipBehavior: clipBehavior,
      restorationId: restorationId,
      keyboardDismissBehavior: keyboardDismissBehavior,
      children: children,
    );
  }
}

class RccGridViewExtent extends StatelessWidget {
  final List<Widget> children;
  final double maxCrossAxisExtent;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final double childAspectRatio;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final ScrollController? controller;
  final bool shrinkWrap;
  final bool reverse;
  final bool? primary;
  final double? cacheExtent;
  final DragStartBehavior dragStartBehavior;
  final Clip clipBehavior;
  final String? restorationId;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;

  const RccGridViewExtent({
    super.key,
    required this.children,
    required this.maxCrossAxisExtent,
    this.mainAxisSpacing = 0.0,
    this.crossAxisSpacing = 0.0,
    this.childAspectRatio = 1.0,
    this.padding,
    this.physics,
    this.controller,
    this.shrinkWrap = false,
    this.reverse = false,
    this.primary,
    this.cacheExtent,
    this.dragStartBehavior = DragStartBehavior.start,
    this.clipBehavior = Clip.hardEdge,
    this.restorationId,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
  });

  @override
  Widget build(BuildContext context) {
    return RccGridView(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: maxCrossAxisExtent,
        mainAxisSpacing: mainAxisSpacing,
        crossAxisSpacing: crossAxisSpacing,
        childAspectRatio: childAspectRatio,
      ),
      padding: padding,
      physics: physics,
      controller: controller,
      shrinkWrap: shrinkWrap,
      reverse: reverse,
      scrollDirection: Axis.vertical,
      primary: primary,
      cacheExtent: cacheExtent,
      dragStartBehavior: dragStartBehavior,
      clipBehavior: clipBehavior,
      restorationId: restorationId,
      keyboardDismissBehavior: keyboardDismissBehavior,
      children: children,
    );
  }
}

class _NoGlowScrollBehavior extends ScrollBehavior {
  const _NoGlowScrollBehavior();

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const BouncingScrollPhysics();
  }
}
