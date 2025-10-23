import 'dart:math' as math;
import 'package:flutter/material.dart';

enum DeviceType { mobile, tablet, desktop }

enum ScreenSize { compact, small, medium, large, xlarge, xxlarge }

enum LayoutMode { single, master, extended }

class UI {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double _safeAreaHorizontal;
  static late double _safeAreaVertical;
  static late double safeScreenWidth;
  static late double safeScreenHeight;
  static late TextScaler textScaler;
  static late double devicePixelRatio;
  static late Orientation orientation;

  static late DeviceType deviceType;
  static late ScreenSize screenSize;
  static late LayoutMode layoutMode;
  static late bool isPhone;
  static late bool isTablet;
  static late bool isDesktop;
  static late bool isFoldable;

  static late double _baseUnit;
  static late double _scaleFactorWidth;
  static late double _scaleFactorHeight;
  static late double _scaleFactor;

  static const double _designWidth = 390.0;
  static const double _designHeight = 844.0;

  static const double _compactBreakpoint = 360.0;
  static const double _smallBreakpoint = 412.0;
  static const double _mediumBreakpoint = 600.0;
  static const double _largeBreakpoint = 840.0;
  static const double _xlargeBreakpoint = 1200.0;

  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    orientation = _mediaQueryData.orientation;
    devicePixelRatio = _mediaQueryData.devicePixelRatio;
    textScaler = _mediaQueryData.textScaler;

    _safeAreaHorizontal =
        _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    _safeAreaVertical =
        _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
    safeScreenWidth = screenWidth - _safeAreaHorizontal;
    safeScreenHeight = screenHeight - _safeAreaVertical;

    _classifyDevice();

    _calculateScaleFactors();

    final double smallerDimension = math.min(screenWidth, screenHeight);
    _baseUnit = smallerDimension / 100;
  }

  static void _classifyDevice() {
    if (screenWidth < _mediumBreakpoint) {
      deviceType = DeviceType.mobile;
      isPhone = true;
      isTablet = false;
      isDesktop = false;
    } else if (screenWidth < _xlargeBreakpoint) {
      deviceType = DeviceType.tablet;
      isPhone = false;
      isTablet = true;
      isDesktop = false;
    } else {
      deviceType = DeviceType.desktop;
      isPhone = false;
      isTablet = false;
      isDesktop = true;
    }

    if (screenWidth < _compactBreakpoint) {
      screenSize = ScreenSize.compact;
    } else if (screenWidth < _smallBreakpoint) {
      screenSize = ScreenSize.small;
    } else if (screenWidth < _mediumBreakpoint) {
      screenSize = ScreenSize.medium;
    } else if (screenWidth < _largeBreakpoint) {
      screenSize = ScreenSize.large;
    } else if (screenWidth < _xlargeBreakpoint) {
      screenSize = ScreenSize.xlarge;
    } else {
      screenSize = ScreenSize.xxlarge;
    }

    if (screenWidth < _mediumBreakpoint) {
      layoutMode = LayoutMode.single;
    } else if (screenWidth < _largeBreakpoint) {
      layoutMode = LayoutMode.master;
    } else {
      layoutMode = LayoutMode.extended;
    }

    final aspectRatio = screenWidth / screenHeight;
    isFoldable = (aspectRatio < 0.6 || aspectRatio > 2.0) && isPhone;
  }

  static void _calculateScaleFactors() {
    double referenceWidth = _designWidth;
    double referenceHeight = _designHeight;

    if (isTablet) {
      referenceWidth = orientation == Orientation.portrait ? 834.0 : 1194.0;
      referenceHeight = orientation == Orientation.portrait ? 1194.0 : 834.0;
    } else if (isDesktop) {
      referenceWidth = 1440.0;
      referenceHeight = 900.0;
    } else if (orientation == Orientation.landscape) {
      referenceWidth = _designHeight;
      referenceHeight = _designWidth;
    }

    _scaleFactorWidth = screenWidth / referenceWidth;
    _scaleFactorHeight = screenHeight / referenceHeight;

    if (isDesktop) {
      _scaleFactor = _scaleFactorWidth;
    } else if (orientation == Orientation.landscape) {
      _scaleFactor = math.min(_scaleFactorWidth, _scaleFactorHeight);
    } else {
      _scaleFactor = math.min(_scaleFactorWidth, _scaleFactorHeight);
    }

    if (isPhone) {
      _scaleFactor = _scaleFactor.clamp(0.85, 1.3);
    } else if (isTablet) {
      _scaleFactor = _scaleFactor.clamp(0.9, 1.5);
    } else {
      _scaleFactor = _scaleFactor.clamp(0.8, 2.0);
    }
  }

  static double getResponsiveValue(double designValue) {
    return designValue * _scaleFactor;
  }

  static double unit(double multiplier) {
    return _baseUnit * multiplier;
  }

  static double width(double percentage) {
    return screenWidth * (percentage / 100);
  }

  static double height(double percentage) {
    return screenHeight * (percentage / 100);
  }

  static double safeWidth(double percentage) {
    return safeScreenWidth * (percentage / 100);
  }

  static double safeHeight(double percentage) {
    return safeScreenHeight * (percentage / 100);
  }

  static double fontSize(double designSize) {
    double baseScale = _scaleFactor;

    if (isDesktop) {
      baseScale = baseScale * 1.1;
    } else if (isTablet) {
      baseScale = baseScale * 1.0;
    } else {
      double widthFactor = screenWidth / _designWidth;
      baseScale = widthFactor.clamp(0.85, 1.0);
    }

    double scaledSize = designSize * baseScale;

    double minSize = designSize * 0.8;
    double maxSize = designSize * 1.2;
    scaledSize = scaledSize.clamp(minSize, maxSize);

    final double systemScale = textScaler.scale(1.0);
    if (systemScale > 1.2) {
      scaledSize = scaledSize * (1.2 / systemScale);
    }

    return scaledSize;
  }

  static const double _displayLarge = 57;
  static const double _displayMedium = 45;
  static const double _displaySmall = 36;
  static const double _headlineLarge = 32;
  static const double _headlineMedium = 28;
  static const double _headlineSmall = 24;
  static const double _titleLarge = 22;
  static const double _titleMedium = 16;
  static const double _titleSmall = 14;
  static const double _bodyLarge = 16;
  static const double _bodyMedium = 14;
  static const double _bodySmall = 12;
  static const double _labelLarge = 14;
  static const double _labelMedium = 12;
  static const double _labelSmall = 11;

  static double textSize(String style) {
    switch (style) {
      case 'displayLarge':
        return fontSize(_displayLarge);
      case 'displayMedium':
        return fontSize(_displayMedium);
      case 'displaySmall':
        return fontSize(_displaySmall);
      case 'headlineLarge':
        return fontSize(_headlineLarge);
      case 'headlineMedium':
        return fontSize(_headlineMedium);
      case 'headlineSmall':
        return fontSize(_headlineSmall);
      case 'titleLarge':
        return fontSize(_titleLarge);
      case 'titleMedium':
        return fontSize(_titleMedium);
      case 'titleSmall':
        return fontSize(_titleSmall);
      case 'bodyLarge':
        return fontSize(_bodyLarge);
      case 'bodyMedium':
        return fontSize(_bodyMedium);
      case 'bodySmall':
        return fontSize(_bodySmall);
      case 'labelLarge':
        return fontSize(_labelLarge);
      case 'labelMedium':
        return fontSize(_labelMedium);
      case 'labelSmall':
        return fontSize(_labelSmall);
      default:
        return fontSize(_bodyMedium);
    }
  }

  static double adaptiveFontSize(double designSize) {
    return fontSize(designSize);
  }

  static double sp(
    double designSize, {
    bool respectSystemScaling = true,
    double? maxScale,
  }) {
    double size = fontSize(designSize);

    if (respectSystemScaling && !isDesktop) {
      final double systemScale = textScaler.scale(1.0);
      final double effectiveScale = maxScale != null
          ? systemScale.clamp(1.0, maxScale)
          : systemScale;
      size *= effectiveScale;
    }

    return size;
  }

  static double safeTextSize(double designSize, {double maxScale = 1.3}) {
    return sp(designSize, respectSystemScaling: true, maxScale: maxScale);
  }

  static double scaledDimension(double designDimension) {
    if (isDesktop) {
      return designDimension * (screenWidth / 1440.0);
    } else if (orientation == Orientation.landscape && isPhone) {
      return designDimension * _scaleFactor * 0.9;
    }
    return designDimension * _scaleFactor;
  }

  static EdgeInsets paddingAll(double designPadding) {
    double scaled = scaledDimension(designPadding);

    if (isDesktop) {
      scaled = math.max(scaled, designPadding);
    } else if (orientation == Orientation.landscape && isPhone) {
      scaled *= 0.8;
    }

    return EdgeInsets.all(scaled);
  }

  static EdgeInsets paddingSymmetric({
    double horizontal = 0,
    double vertical = 0,
  }) {
    double hScaled = scaledDimension(horizontal);
    double vScaled = scaledDimension(vertical);

    if (orientation == Orientation.landscape && isPhone) {
      vScaled *= 0.7;
      hScaled *= 0.9;
    } else if (isDesktop) {
      hScaled = math.max(hScaled, horizontal);
      vScaled = math.max(vScaled, vertical);
    }

    return EdgeInsets.symmetric(horizontal: hScaled, vertical: vScaled);
  }

  static EdgeInsets paddingOnly({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) {
    return EdgeInsets.only(
      left: scaledDimension(left),
      top: scaledDimension(top),
      right: scaledDimension(right),
      bottom: scaledDimension(bottom),
    );
  }

  static double get pageTitleSize => textSize('headlineMedium');

  static double get pageSubtitleSize => textSize('bodyMedium');

  static double get sectionTitleSize => textSize('titleMedium');

  static double get titleLarge => textSize('titleLarge');

  static double get cardTitleSize => textSize('titleMedium');

  static double get cardSubtitleSize => textSize('bodySmall');

  static double get bodyTextSize => textSize('bodyMedium');

  static double get labelTextSize => textSize('labelMedium');

  static double get buttonTextSize => textSize('labelMedium');

  static double get tabTextSize => textSize('labelMedium');

  static double get navTextSize => textSize('labelSmall');

  static double get helperTextSize => textSize('bodySmall');

  static EdgeInsets adaptivePadding({
    double horizontal = 5.0,
    double vertical = 2.5,
  }) {
    return EdgeInsets.symmetric(
      horizontal: width(horizontal),
      vertical: height(vertical),
    );
  }

  static double adaptiveIconSize(double designSize) {
    double baseScale = _scaleFactor;

    if (screenSize == ScreenSize.compact) {
      baseScale *= 0.85;
    } else if (screenSize == ScreenSize.small) {
      baseScale *= 0.9;
    }

    if (orientation == Orientation.landscape && isPhone) {
      baseScale *= 0.85;
    }

    double size = designSize * baseScale;

    double minSize, maxSize;
    if (isDesktop) {
      minSize = designSize * 0.8;
      maxSize = designSize * 1.5;
    } else {
      minSize = designSize * 0.7;
      maxSize = designSize * 1.2;
    }

    return size.clamp(minSize, maxSize);
  }

  static double adaptiveRadius(double designRadius) {
    return scaledDimension(designRadius);
  }

  static double adaptiveElevation(double designElevation) {
    if (isDesktop) {
      return designElevation * 1.2;
    }
    return designElevation * (_scaleFactor * 0.8 + 0.2);
  }

  static double minSize(double percentage) {
    return math.min(width(percentage), height(percentage));
  }

  static double maxSize(double percentage) {
    return math.max(width(percentage), height(percentage));
  }

  static SliverGridDelegate adaptiveGrid({
    int baseColumns = 2,
    double childAspectRatio = 1.0,
    double crossAxisSpacing = 10,
    double mainAxisSpacing = 10,
  }) {
    int columns;

    if (orientation == Orientation.landscape) {
      columns = (screenWidth / 200).floor();
    } else {
      columns = (screenWidth / 150).floor();
    }

    columns = columns.clamp(1, isDesktop ? 8 : 4);

    return SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: columns,
      childAspectRatio: childAspectRatio,
      crossAxisSpacing: scaledDimension(crossAxisSpacing),
      mainAxisSpacing: scaledDimension(mainAxisSpacing),
    );
  }

  static BoxConstraints adaptiveConstraints({
    double? minWidth,
    double? maxWidth,
    double? minHeight,
    double? maxHeight,
  }) {
    return BoxConstraints(
      minWidth: minWidth != null ? scaledDimension(minWidth) : 0.0,
      maxWidth: maxWidth != null ? scaledDimension(maxWidth) : double.infinity,
      minHeight: minHeight != null ? scaledDimension(minHeight) : 0.0,
      maxHeight: maxHeight != null
          ? scaledDimension(maxHeight)
          : double.infinity,
    );
  }

  static TextStyle adaptiveTextStyle({
    double fontSize = 14,
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacing,
    double? height,
  }) {
    return TextStyle(
      fontSize: adaptiveFontSize(fontSize),
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing != null
          ? scaledDimension(letterSpacing)
          : null,
      height: height,
    );
  }

  static int responsiveColumns() {
    switch (screenSize) {
      case ScreenSize.compact:
        return 1;
      case ScreenSize.small:
        return 2;
      case ScreenSize.medium:
        return 2;
      case ScreenSize.large:
        return 3;
      case ScreenSize.xlarge:
        return 4;
      case ScreenSize.xxlarge:
        return 5;
    }
  }

  static double responsiveSpacing([double? designSpacing]) {
    if (designSpacing != null) {
      return scaledDimension(designSpacing);
    }

    switch (deviceType) {
      case DeviceType.mobile:
        return unit(4);
      case DeviceType.tablet:
        return unit(5);
      case DeviceType.desktop:
        return 24.0;
    }
  }

  static bool useSingleColumn() {
    return layoutMode == LayoutMode.single ||
        (orientation == Orientation.portrait && isPhone);
  }

  static bool useMasterDetail() {
    return layoutMode == LayoutMode.master ||
        (orientation == Orientation.landscape && isPhone) ||
        (orientation == Orientation.portrait && isTablet);
  }

  static bool useExtendedLayout() {
    return layoutMode == LayoutMode.extended ||
        (orientation == Orientation.landscape && isTablet) ||
        isDesktop;
  }

  static double getButtonHeight() {
    const double designHeight = 48.0;
    double height = scaledDimension(designHeight);

    if (isDesktop) {
      return math.max(height, 40.0);
    }
    return math.max(height, 44.0);
  }

  static double getAppBarHeight() {
    if (orientation == Orientation.landscape && isPhone) {
      return 48.0;
    }
    const double designHeight = 56.0;
    return scaledDimension(designHeight);
  }

  static double getBottomNavHeight() {
    if (orientation == Orientation.landscape && isPhone) {
      return 48.0;
    }
    const double designHeight = 60.0;
    return math.max(scaledDimension(designHeight), 56.0);
  }

  static bool get isLandscape => orientation == Orientation.landscape;

  static bool get isPortrait => orientation == Orientation.portrait;

  static bool get shouldShowSidebar => screenWidth >= _largeBreakpoint;

  static bool get shouldCollapseMenu => screenWidth < _mediumBreakpoint;

  static double get scaleFactor => _scaleFactor;

  static double get baseUnit => _baseUnit;

  static double get u1 => unit(1);
  static double get u2 => unit(2);
  static double get u4 => unit(4);
  static double get u8 => unit(8);
  static double get u12 => unit(12);
  static double get u16 => unit(16);
  static double get u20 => unit(20);
  static double get u24 => unit(24);
  static double get u32 => unit(32);
}

class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? mobileLandscape;
  final Widget? tablet;
  final Widget? tabletLandscape;
  final Widget? desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.mobileLandscape,
    this.tablet,
    this.tabletLandscape,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    UI.init(context);

    if (UI.isDesktop && desktop != null) {
      return desktop!;
    }

    if (UI.isTablet) {
      if (UI.isLandscape && tabletLandscape != null) {
        return tabletLandscape!;
      }
      if (tablet != null) {
        return tablet!;
      }
    }

    if (UI.isPhone) {
      if (UI.isLandscape && mobileLandscape != null) {
        return mobileLandscape!;
      }
      return mobile;
    }

    return mobile;
  }
}

class AdaptiveScaffold extends StatelessWidget {
  final Widget? body;
  final Widget? navigationRail;
  final Widget? drawer;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  const AdaptiveScaffold({
    super.key,
    this.body,
    this.navigationRail,
    this.drawer,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
  });

  @override
  Widget build(BuildContext context) {
    UI.init(context);

    if (UI.shouldShowSidebar && navigationRail != null) {
      return Scaffold(
        appBar: appBar,
        body: Row(
          children: [
            navigationRail!,
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(child: body ?? const SizedBox()),
          ],
        ),
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: floatingActionButtonLocation,
      );
    }

    return Scaffold(
      appBar: appBar,
      drawer: drawer,
      body: body,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
    );
  }
}

class MasterDetailView extends StatelessWidget {
  final Widget master;
  final Widget? detail;
  final double masterWidth;
  final bool showDivider;

  const MasterDetailView({
    super.key,
    required this.master,
    this.detail,
    this.masterWidth = 320,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    UI.init(context);

    if (UI.useSingleColumn()) {
      return master;
    }

    if (UI.useMasterDetail() || UI.useExtendedLayout()) {
      return Row(
        children: [
          SizedBox(
            width: UI.isDesktop ? masterWidth : UI.width(40),
            child: master,
          ),
          if (showDivider) const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: detail ?? const Center(child: Text('Select an item')),
          ),
        ],
      );
    }

    return master;
  }
}

class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final double minItemWidth;
  final double childAspectRatio;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final EdgeInsetsGeometry? padding;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.minItemWidth = 200,
    this.childAspectRatio = 1.0,
    this.crossAxisSpacing = 10,
    this.mainAxisSpacing = 10,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    UI.init(context);

    final int crossAxisCount = math.max(
      1,
      (UI.screenWidth / minItemWidth).floor(),
    );

    return GridView.builder(
      padding: padding,
      physics: const ClampingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: UI.scaledDimension(crossAxisSpacing),
        mainAxisSpacing: UI.scaledDimension(mainAxisSpacing),
      ),
      itemCount: children.length,
      itemBuilder: (context, index) => children[index],
    );
  }
}

class ResponsiveVisibility extends StatelessWidget {
  final Widget child;
  final bool hiddenOnMobile;
  final bool hiddenOnTablet;
  final bool hiddenOnDesktop;
  final bool hiddenInPortrait;
  final bool hiddenInLandscape;
  final Widget replacement;

  const ResponsiveVisibility({
    super.key,
    required this.child,
    this.hiddenOnMobile = false,
    this.hiddenOnTablet = false,
    this.hiddenOnDesktop = false,
    this.hiddenInPortrait = false,
    this.hiddenInLandscape = false,
    this.replacement = const SizedBox.shrink(),
  });

  @override
  Widget build(BuildContext context) {
    UI.init(context);

    bool shouldHide = false;

    if (UI.isPhone && hiddenOnMobile) shouldHide = true;
    if (UI.isTablet && hiddenOnTablet) shouldHide = true;
    if (UI.isDesktop && hiddenOnDesktop) shouldHide = true;
    if (UI.isPortrait && hiddenInPortrait) shouldHide = true;
    if (UI.isLandscape && hiddenInLandscape) shouldHide = true;

    return shouldHide ? replacement : child;
  }
}

class AdaptiveText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool autoScale;

  const AdaptiveText(
    this.text, {
    super.key,
    this.fontSize = 14,
    this.fontWeight,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.autoScale = true,
  });

  @override
  Widget build(BuildContext context) {
    UI.init(context);

    final effectiveFontSize = autoScale ? UI.fontSize(fontSize) : fontSize;

    return Text(
      text,
      style: TextStyle(
        fontSize: effectiveFontSize,
        fontWeight: fontWeight,
        color: color,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow ?? (maxLines != null ? TextOverflow.ellipsis : null),
    );
  }
}

class AdaptiveContainer extends StatelessWidget {
  final Widget? child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Decoration? decoration;
  final AlignmentGeometry? alignment;
  final BoxConstraints? constraints;

  const AdaptiveContainer({
    super.key,
    this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.decoration,
    this.alignment,
    this.constraints,
  });

  @override
  Widget build(BuildContext context) {
    UI.init(context);
    return Container(
      width: width != null ? UI.scaledDimension(width!) : null,
      height: height != null ? UI.scaledDimension(height!) : null,
      padding: padding,
      margin: margin,
      decoration: decoration,
      alignment: alignment,
      constraints: constraints,
      child: child,
    );
  }
}

class AdaptiveSizedBox extends StatelessWidget {
  final double? width;
  final double? height;
  final Widget? child;

  const AdaptiveSizedBox({super.key, this.width, this.height, this.child});

  @override
  Widget build(BuildContext context) {
    UI.init(context);
    return SizedBox(
      width: width != null ? UI.scaledDimension(width!) : null,
      height: height != null ? UI.scaledDimension(height!) : null,
      child: child,
    );
  }
}

class ScreenSizeBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, BoxConstraints constraints)
  builder;

  const ScreenSizeBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        UI.init(context);
        return builder(context, constraints);
      },
    );
  }
}

class OrientationAwareWidget extends StatelessWidget {
  final Widget portrait;
  final Widget landscape;

  const OrientationAwareWidget({
    super.key,
    required this.portrait,
    required this.landscape,
  });

  @override
  Widget build(BuildContext context) {
    UI.init(context);
    return UI.isPortrait ? portrait : landscape;
  }
}
