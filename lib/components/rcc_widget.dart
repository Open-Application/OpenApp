import 'package:flutter/material.dart';
import '../ui.dart';
import '../utils/haptic_helper.dart';
import '../constants.dart';

class RccBackButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final double? iconSize;
  final Color? backgroundColor;
  final Color? iconColor;
  final bool showShadow;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;

  const RccBackButton({
    super.key,
    required this.onTap,
    this.icon = Constants.iconArrowLeft,
    this.iconSize,
    this.backgroundColor,
    this.iconColor,
    this.showShadow = true,
    this.borderRadius = Constants.defaultBorderRadius,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveIconSize = iconSize ?? UI.adaptiveIconSize(20);
    final effectivePadding = padding ?? UI.paddingAll(12);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticUtils.lightImpact();
          onTap();
        },
        borderRadius: .circular(UI.scaledDimension(borderRadius)),
        child: Container(
          padding: effectivePadding,
          decoration: BoxDecoration(
            color: backgroundColor ?? theme.colorScheme.surface.withValues(alpha: Constants.defaultBackgroundOpacity),
            borderRadius: .circular(UI.scaledDimension(borderRadius)),
            boxShadow: showShadow
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: Constants.defaultShadowOpacity),
                      blurRadius: UI.scaledDimension(8),
                      offset: Offset(0, UI.scaledDimension(2)),
                    ),
                  ]
                : null,
          ),
          child: Icon(
            icon,
            size: effectiveIconSize,
            color: iconColor ?? theme.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}

class RccExpandableItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isExpanded;
  final VoidCallback onTap;
  final Widget expandedContent;
  final Widget? expandedAction;
  final Widget? trailingAction;

  const RccExpandableItem({
    super.key,
    required this.icon,
    required this.title,
    required this.isExpanded,
    required this.onTap,
    required this.expandedContent,
    this.expandedAction,
    this.trailingAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: .circular(UI.scaledDimension(12)),
        border: Border.all(
          color: isExpanded
              ? theme.colorScheme.primary.withValues(alpha: Constants.defaultOnSurfaceOpacity)
              : theme.colorScheme.outline.withValues(alpha: Constants.defaultOutlineOpacity),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: .circular(UI.scaledDimension(12)),
          child: Padding(
            padding: UI.paddingAll(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          icon,
                          size: UI.adaptiveIconSize(15),
                          color: isExpanded
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                        SizedBox(width: UI.scaledDimension(12)),
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: UI.buttonTextSize,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                    if (isExpanded && expandedAction != null)
                      expandedAction!
                    else if (trailingAction != null)
                      trailingAction!
                    else
                      AnimatedRotation(
                        turns: isExpanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          Constants.iconChevronDown,
                          size: UI.adaptiveIconSize(15),
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                  ],
                ),
                if (isExpanded)
                  AnimatedSize(
                    duration: const Duration(milliseconds: 200),
                    child: expandedContent,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RccSectionTitle extends StatelessWidget {
  final String title;

  const RccSectionTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      title,
      style: TextStyle(
        fontSize: UI.labelTextSize,
        color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    );
  }
}

class RccPageHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const RccPageHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: UI.pageTitleSize,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: UI.scaledDimension(4)),
        Text(
          subtitle,
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: UI.pageSubtitleSize,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }
}



class RccListItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final Widget? trailing;
  final Color? iconColor;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final bool showChevron;
  final Color? backgroundColor;
  final Widget? leading;

  const RccListItem({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
    this.trailing,
    this.iconColor,
    this.titleStyle,
    this.subtitleStyle,
    this.padding,
    this.borderRadius = Constants.defaultBorderRadius,
    this.showChevron = true,
    this.backgroundColor,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveTrailing = trailing ??
        (showChevron
            ? Icon(
                Constants.iconChevronRight,
                size: UI.adaptiveIconSize(16),
                color: theme.colorScheme.onSurface.withValues(alpha: Constants.defaultOnSurfaceOpacity),
              )
            : null);

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.colorScheme.surface,
        borderRadius: .circular(UI.scaledDimension(borderRadius)),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: Constants.defaultOutlineOpacity),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticUtils.selectionClick();
            onTap();
          },
          borderRadius: .circular(UI.scaledDimension(borderRadius)),
          child: Container(
            padding: padding ?? UI.paddingAll(16),
            child: Row(
              children: [
                leading ?? Icon(
                  icon,
                  size: UI.adaptiveIconSize(20),
                  color: iconColor ?? theme.colorScheme.onSurfaceVariant,
                ),
                SizedBox(width: UI.scaledDimension(12)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: titleStyle ?? theme.textTheme.bodyMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (subtitle != null) ...[
                        SizedBox(height: UI.scaledDimension(2)),
                        Text(
                          subtitle!,
                          style: subtitleStyle ?? theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(alpha: Constants.defaultOnSurfaceSecondaryOpacity),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                if (effectiveTrailing != null) effectiveTrailing,
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class RccCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final Color? backgroundColor;
  final Border? border;
  final List<BoxShadow>? boxShadow;

  const RccCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.margin,
    this.borderRadius = Constants.defaultBorderRadius,
    this.backgroundColor,
    this.border,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveBorder = border ??
        Border.all(
          color: theme.colorScheme.outline.withValues(alpha: Constants.defaultOutlineOpacity),
        );

    Widget content = Container(
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.colorScheme.surface,
        borderRadius: .circular(UI.scaledDimension(borderRadius)),
        border: effectiveBorder,
        boxShadow: boxShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: onTap != null
            ? InkWell(
                onTap: () {
                  HapticUtils.lightImpact();
                  onTap!();
                },
                borderRadius: .circular(UI.scaledDimension(borderRadius)),
                child: Padding(
                  padding: padding ?? UI.paddingAll(16),
                  child: child,
                ),
              )
            : Padding(
                padding: padding ?? UI.paddingAll(16),
                child: child,
              ),
      ),
    );

    return content;
  }
}


class RccActionButton extends StatelessWidget {
  final IconData? icon;
  final String label;
  final VoidCallback onTap;
  final bool isPrimary;
  final Color? primaryColor;
  final Color? secondaryColor;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final bool showShadow;
  final bool useGradient;

  const RccActionButton({
    super.key,
    this.icon,
    required this.label,
    required this.onTap,
    this.isPrimary = false,
    this.primaryColor,
    this.secondaryColor,
    this.borderRadius = 12,
    this.padding,
    this.showShadow = true,
    this.useGradient = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectivePrimaryColor = primaryColor ?? theme.colorScheme.primary;
    final effectiveSecondaryColor = secondaryColor ?? effectivePrimaryColor.withValues(alpha: 0.8);

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(UI.scaledDimension(borderRadius)),
      child: InkWell(
        onTap: () {
          HapticUtils.selectionClick();
          onTap();
        },
        borderRadius: .circular(UI.scaledDimension(borderRadius)),
        child: Container(
          padding: padding ?? UI.paddingSymmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            gradient: isPrimary && useGradient
                ? LinearGradient(colors: [effectivePrimaryColor, effectiveSecondaryColor])
                : null,
            color: isPrimary && !useGradient
                ? effectivePrimaryColor
                : !isPrimary
                    ? theme.colorScheme.surface
                    : null,
            borderRadius: .circular(UI.scaledDimension(borderRadius)),
            border: Border.all(
              color: isPrimary
                  ? Colors.transparent
                  : effectivePrimaryColor.withValues(alpha: Constants.defaultOnSurfaceOpacity),
            ),
            boxShadow: isPrimary && showShadow
                ? [
                    BoxShadow(
                      color: effectivePrimaryColor.withValues(alpha: Constants.defaultOnSurfaceOpacity),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: UI.adaptiveIconSize(18),
                  color: isPrimary ? Colors.white : effectivePrimaryColor,
                ),
                SizedBox(width: UI.scaledDimension(6)),
              ],
              Text(
                label,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: isPrimary ? Colors.white : effectivePrimaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RccTransactionItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool showIconBackground;
  final EdgeInsetsGeometry? margin;

  const RccTransactionItem({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.showIconBackground = true,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return RccCard(
      margin: margin ?? UI.paddingOnly(bottom: 12),
      onTap: onTap,
      child: Row(
        children: [
          if (showIconBackground)
            Container(
              width: UI.scaledDimension(40),
              height: UI.scaledDimension(40),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: iconColor.withValues(alpha: Constants.defaultOutlineOpacity),
              ),
              child: Icon(
                icon,
                size: UI.adaptiveIconSize(24),
                color: iconColor,
              ),
            )
          else
            Icon(
              icon,
              size: UI.adaptiveIconSize(24),
              color: iconColor,
            ),
          SizedBox(width: UI.responsiveSpacing(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (subtitle != null) ...[
                  SizedBox(height: UI.scaledDimension(2)),
                  Text(
                    subtitle!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}


class RccSimpleButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isPrimary;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double height;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final bool enabled;

  const RccSimpleButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isPrimary = true,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.height = 52.0,
    this.borderRadius = Constants.defaultBorderRadius,
    this.padding,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveEnabled = enabled && !isLoading;

    final effectiveBackgroundColor = backgroundColor ??
      (isPrimary ? theme.colorScheme.primary : theme.colorScheme.surface);
    final effectiveForegroundColor = foregroundColor ??
      (isPrimary ? theme.colorScheme.onPrimary : theme.colorScheme.primary);

    return SizedBox(
      height: UI.scaledDimension(height),
      width: double.infinity,
      child: Material(
        color: effectiveEnabled
          ? effectiveBackgroundColor
          : effectiveBackgroundColor.withValues(alpha: 0.5),
        borderRadius: .circular(UI.scaledDimension(borderRadius)),
        child: InkWell(
          onTap: effectiveEnabled ? () {
            HapticUtils.selectionClick();
            onPressed();
          } : null,
          borderRadius: .circular(UI.scaledDimension(borderRadius)),
          child: Container(
            padding: padding ?? UI.paddingSymmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isLoading)
                  SizedBox(
                    width: UI.scaledDimension(20),
                    height: UI.scaledDimension(20),
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(effectiveForegroundColor),
                    ),
                  )
                else if (icon != null) ...[
                  Icon(
                    icon,
                    size: UI.adaptiveIconSize(20),
                    color: effectiveForegroundColor,
                  ),
                  SizedBox(width: UI.scaledDimension(8)),
                ],
                if (!isLoading)
                  Text(
                    text,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: effectiveForegroundColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class RccPageScaffold extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final bool useSafeArea;
  final EdgeInsetsGeometry? padding;
  final bool useListView;
  final ScrollPhysics? physics;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final bool resizeToAvoidBottomInset;
  final bool extendBody;
  final bool extendBodyBehindAppBar;

  const RccPageScaffold({
    super.key,
    required this.child,
    this.backgroundColor,
    this.useSafeArea = true,
    this.padding,
    this.useListView = false,
    this.physics = const ClampingScrollPhysics(),
    this.appBar,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.floatingActionButtonLocation,
    this.resizeToAvoidBottomInset = true,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
  });

  @override
  Widget build(BuildContext context) {
    UI.init(context);
    final theme = Theme.of(context);

    Widget content = child;

    if (padding != null) {
      content = Padding(padding: padding!, child: content);
    }

    if (useListView) {
      content = ListView(
        physics: physics,
        padding: padding ?? EdgeInsets.zero,
        children: [child],
      );
    }

    if (useSafeArea) {
      content = SafeArea(child: content);
    }

    return Scaffold(
      backgroundColor: backgroundColor ?? theme.scaffoldBackgroundColor,
      appBar: appBar,
      body: content,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButtonLocation: floatingActionButtonLocation,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      extendBody: extendBody,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
    );
  }
}


class RccStatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;
  final Color? iconColor;
  final Color? valueColor;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;
  final MainAxisAlignment alignment;

  const RccStatItem({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.iconColor,
    this.valueColor,
    this.labelStyle,
    this.valueStyle,
    this.alignment = MainAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: alignment,
      children: [
        if (icon != null) ...[
          Icon(
            icon,
            size: UI.adaptiveIconSize(16),
            color: iconColor ?? theme.colorScheme.primary,
          ),
          SizedBox(width: UI.scaledDimension(8)),
        ],
        Column(
          crossAxisAlignment: alignment == MainAxisAlignment.center
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: labelStyle ??
                  theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
            ),
            SizedBox(height: UI.scaledDimension(2)),
            Text(
              value,
              style: valueStyle ??
                  theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: valueColor ?? theme.colorScheme.onSurface,
                  ),
            ),
          ],
        ),
      ],
    );
  }
}

class RccSection extends StatelessWidget {
  final String? title;
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final bool showBorder;

  const RccSection({
    super.key,
    this.title,
    required this.child,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.showBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: margin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            RccSectionTitle(title: title!),
            SizedBox(height: UI.scaledDimension(12)),
          ],
          Container(
            padding: padding ?? UI.paddingAll(16),
            decoration: BoxDecoration(
              color: backgroundColor ?? theme.colorScheme.surface,
              borderRadius: .circular(UI.scaledDimension(12)),
              border: showBorder
                  ? Border.all(
                      color: theme.colorScheme.outline.withValues(alpha: Constants.defaultOutlineOpacity),
                    )
                  : null,
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}

class RccFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final int? count;
  final Color? selectedColor;
  final Color? selectedBackgroundColor;

  const RccFilterChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.count,
    this.selectedColor,
    this.selectedBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveSelectedColor = selectedColor ?? theme.colorScheme.primary;
    final effectiveBackgroundColor = selectedBackgroundColor ??
        effectiveSelectedColor.withValues(alpha: 0.2);

    return GestureDetector(
      onTap: () {
        HapticUtils.selectionClick();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: UI.paddingSymmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? effectiveBackgroundColor
              : theme.colorScheme.surface,
          borderRadius: .circular(UI.scaledDimension(20)),
          border: Border.all(
            color: isSelected
                ? effectiveSelectedColor
                : theme.colorScheme.outline.withValues(alpha: 0.2),
            width: isSelected ? UI.scaledDimension(1.5) : UI.scaledDimension(1),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: UI.labelTextSize,
                color: isSelected
                    ? effectiveSelectedColor
                    : theme.colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            if (count != null) ...[
              SizedBox(width: UI.scaledDimension(6)),
              Container(
                padding: UI.paddingSymmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isSelected
                      ? effectiveSelectedColor.withValues(alpha: 0.2)
                      : theme.colorScheme.onSurface.withValues(alpha: Constants.defaultOutlineOpacity),
                  borderRadius: .circular(UI.scaledDimension(10)),
                ),
                child: Text(
                  count.toString(),
                  style: TextStyle(
                    fontSize: UI.safeTextSize(10),
                    color: isSelected
                        ? effectiveSelectedColor
                        : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}