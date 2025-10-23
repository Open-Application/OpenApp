import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import '../providers/preferences_provider.dart';

class RccListView extends StatelessWidget {
  final List<Widget> children;
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

  const RccListView({
    super.key,
    required this.children,
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
      return ListView(
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

    if (children.length < 20) {
      return _buildSingleChildScrollView();
    }

    return _buildCustomScrollView();
  }

  Widget _buildSingleChildScrollView() {
    final processedChildren = children.map((child) => RepaintBoundary(child: child)).toList();

    return RepaintBoundary(
      child: ScrollConfiguration(
        behavior: const _NoGlowScrollBehavior(),
        child: SingleChildScrollView(
          padding: padding,
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          controller: controller,
          reverse: reverse,
          scrollDirection: scrollDirection,
          primary: primary,
          dragStartBehavior: dragStartBehavior,
          clipBehavior: clipBehavior,
          restorationId: restorationId,
          keyboardDismissBehavior: keyboardDismissBehavior,
          child: scrollDirection == Axis.vertical
              ? Column(
                  mainAxisSize: shrinkWrap ? MainAxisSize.min : MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: processedChildren,
                )
              : Row(
                  mainAxisSize: shrinkWrap ? MainAxisSize.min : MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: processedChildren,
                ),
        ),
      ),
    );
  }

  Widget _buildCustomScrollView() {
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
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => RepaintBoundary(
                    child: children[index],
                  ),
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

class RccListViewBuilder extends StatelessWidget {
  final IndexedWidgetBuilder itemBuilder;
  final int? itemCount;
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
  final double? itemExtent;
  final Widget? prototypeItem;
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;
  final int? semanticChildCount;

  const RccListViewBuilder({
    super.key,
    required this.itemBuilder,
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
    this.itemExtent,
    this.prototypeItem,
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
      return ListView.builder(
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
        itemExtent: itemExtent,
        prototypeItem: prototypeItem,
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
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => RepaintBoundary(
                    child: itemBuilder(context, index),
                  ),
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

class RccListViewSeparated extends StatelessWidget {
  final IndexedWidgetBuilder itemBuilder;
  final IndexedWidgetBuilder separatorBuilder;
  final int itemCount;
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

  const RccListViewSeparated({
    super.key,
    required this.itemBuilder,
    required this.separatorBuilder,
    required this.itemCount,
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
  });

  @override
  Widget build(BuildContext context) {
    final prefsProvider = context.watch<PreferencesProvider?>();
    final isHarmonyOS = prefsProvider?.isHuaweiDevice ?? false;

    if (!isHarmonyOS) {
      return ListView.separated(
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
        itemCount: itemCount,
        itemBuilder: itemBuilder,
        separatorBuilder: separatorBuilder,
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
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final int itemIndex = index ~/ 2;
                    if (index.isEven) {
                      return RepaintBoundary(
                        child: itemBuilder(context, itemIndex),
                      );
                    }
                    return separatorBuilder(context, itemIndex);
                  },
                  childCount: itemCount * 2 - 1,
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