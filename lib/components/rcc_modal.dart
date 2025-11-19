import 'package:flutter/material.dart';
import '../constants.dart';
import '../l10n/app_localizations.dart';
import '../ui.dart';

class RccModal extends StatelessWidget {
  final String titleText;
  final IconData? titleIcon;
  final Color? accentColor;
  final Widget child;
  final Widget footerButton;

  const RccModal._({
    required this.titleText,
    this.titleIcon,
    this.accentColor,
    required this.child,
    required this.footerButton,
  });

  static Future<T?> show<T>({
    required BuildContext context,
    required String titleText,
    IconData? titleIcon,
    Color? accentColor,
    required Widget child,
    required Widget footerButton,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useRootNavigator: false,
      builder: (BuildContext context) {
        return RccModal._(
          titleText: titleText,
          titleIcon: titleIcon,
          accentColor: accentColor,
          footerButton: footerButton,
          child: child,
        );
      },
    );
  }

  static Future<T?> showInfo<T>({
    required BuildContext context,
    required String title,
    required String message,
    Widget? footerButton,
  }) {
    final localizations = AppLocalizations.of(context)!;
    return show<T>(
      context: context,
      titleText: title,
      titleIcon: Constants.iconInfoOutline,
      child: RccModalContent(
        child: Text(
          message,
          style: TextStyle(
            fontSize: UI.bodyTextSize,
            height: 1.5,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
      footerButton: footerButton ?? RccModalButton(
        text: localizations.close,
        isPrimary: true,
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  static Future<T?> showDetails<T>({
    required BuildContext context,
    required String title,
    IconData? icon,
    Color? accentColor,
    required List<RccModalSection> sections,
    Widget? footerButton,
  }) {
    final localizations = AppLocalizations.of(context)!;
    return show<T>(
      context: context,
      titleText: title,
      titleIcon: icon,
      accentColor: accentColor,
      child: RepaintBoundary(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: UI.paddingOnly(
            left: Constants.modalContentPadding,
            right: Constants.modalContentPadding,
            bottom: Constants.modalContentPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int i = 0; i < sections.length; i++) ...[
                RepaintBoundary(child: sections[i]),
                if (i < sections.length - 1) SizedBox(height: UI.scaledDimension(Constants.modalSectionSpacing)),
              ],
            ],
          ),
        ),
      ),
      footerButton: footerButton ?? RccModalButton(
        text: localizations.close,
        isPrimary: true,
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor = accentColor ?? theme.colorScheme.primary;

    return RepaintBoundary(
      child: Container(
        height: MediaQuery.of(context).size.height * Constants.modalPopupHeightFactor,
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: .only(
            topLeft: .circular(UI.scaledDimension(Constants.modalBorderRadius)),
            topRight: .circular(UI.scaledDimension(Constants.modalBorderRadius)),
          ),
        ),
        child: Column(
          children: [
            RepaintBoundary(
              child: Column(
                children: [
                  Container(
                    width: UI.scaledDimension(Constants.modalHandleWidth),
                    height: UI.scaledDimension(Constants.modalHandleHeight),
                    margin: .only(
                      top: UI.scaledDimension(Constants.modalHandleTopMargin),
                      bottom: UI.scaledDimension(Constants.modalHandleBottomMargin),
                    ),
                    decoration: BoxDecoration(
                      color: effectiveColor.withValues(alpha: 0.3),
                      borderRadius: .circular(UI.scaledDimension(Constants.modalHandleHeight) / 2),
                    ),
                  ),

                  Container(
                    padding: .symmetric(horizontal: UI.scaledDimension(Constants.modalHeaderPadding)),
                    child: Row(
                      children: [
                        if (titleIcon != null) ...[
                          Icon(
                            titleIcon,
                            color: effectiveColor,
                            size: UI.adaptiveIconSize(Constants.modalIconSize),
                          ),
                          SizedBox(width: UI.scaledDimension(Constants.modalIconSpacing)),
                        ],
                        Expanded(
                          child: Text(
                            titleText,
                            style: TextStyle(
                              fontSize: UI.titleLarge,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: UI.scaledDimension(Constants.modalHeaderBottomSpacing)),

                  Container(
                    height: 1,
                    color: effectiveColor.withValues(alpha: 0.15),
                  ),
                ],
              ),
            ),

            Expanded(
              child: RepaintBoundary(
                child: child,
              ),
            ),

            RepaintBoundary(
              child: Container(
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  border: Border(
                    top: BorderSide(
                      color: theme.colorScheme.outline.withValues(alpha: 0.1),
                      width: 1,
                    ),
                  ),
                ),
                child: SafeArea(
                  top: false,
                  child: Padding(
                    padding: UI.paddingAll(16),
                    child: footerButton,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RccModalSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final IconData? icon;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;

  const RccModalSection({
    super.key,
    required this.title,
    required this.children,
    this.icon,
    this.backgroundColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveBackgroundColor = backgroundColor ?? theme.colorScheme.surface;

    return Container(
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: .circular(UI.scaledDimension(16)),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: UI.paddingOnly(left: 16, right: 16, top: 16, bottom: 12),
            child: Row(
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    size: UI.adaptiveIconSize(18),
                    color: theme.colorScheme.primary,
                  ),
                  SizedBox(width: UI.scaledDimension(8)),
                ],
                Text(
                  title,
                  style: TextStyle(
                    fontSize: UI.sectionTitleSize,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 1,
            color: theme.colorScheme.outline.withValues(alpha: 0.1),
          ),
          Padding(
            padding: UI.paddingAll(16),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }
}

class RccModalRow extends StatelessWidget {
  final String label;
  final String value;
  final Widget? valueWidget;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;
  final CrossAxisAlignment crossAxisAlignment;

  const RccModalRow({
    super.key,
    required this.label,
    this.value = '',
    this.valueWidget,
    this.labelStyle,
    this.valueStyle,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveLabelStyle = labelStyle ??
        theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        );
    final effectiveValueStyle = valueStyle ??
        theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
        );

    return Padding(
      padding: UI.paddingOnly(bottom: 8),
      child: Row(
        crossAxisAlignment: crossAxisAlignment,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: effectiveLabelStyle,
            ),
          ),
          SizedBox(width: UI.scaledDimension(16)),
          Expanded(
            flex: 3,
            child: valueWidget ??
                Text(
                  value,
                  style: effectiveValueStyle,
                  textAlign: TextAlign.right,
                ),
          ),
        ],
      ),
    );
  }
}

class RccModalContent extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const RccModalContent({
    super.key,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      padding: padding ?? UI.paddingOnly(left: 24, right: 24, top: 16, bottom: 16),
      child: child,
    );
  }
}

class RccModalButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool isPrimary;
  final bool isDanger;

  const RccModalButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.isPrimary = false,
    this.isDanger = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Color? effectiveBackgroundColor = backgroundColor;
    Color? effectiveForegroundColor = foregroundColor;

    if (isDanger) {
      effectiveBackgroundColor ??= theme.colorScheme.error.withValues(alpha: 0.1);
      effectiveForegroundColor ??= theme.colorScheme.error;
    } else if (isPrimary) {
      effectiveBackgroundColor ??= theme.colorScheme.primary;
      effectiveForegroundColor ??= theme.colorScheme.onPrimary;
    }

    return SizedBox(
      width: double.infinity,
      height: UI.scaledDimension(Constants.modalButtonHeight),
      child: isPrimary
          ? FilledButton(
              onPressed: onPressed,
              style: FilledButton.styleFrom(
                backgroundColor: effectiveBackgroundColor,
                foregroundColor: effectiveForegroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: .circular(UI.scaledDimension(Constants.modalButtonBorderRadius)),
                ),
              ),
              child: Text(
                text,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            )
          : FilledButton.tonal(
              onPressed: onPressed,
              style: FilledButton.styleFrom(
                backgroundColor: effectiveBackgroundColor,
                foregroundColor: effectiveForegroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: .circular(UI.scaledDimension(Constants.modalButtonBorderRadius)),
                ),
              ),
              child: Text(
                text,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
    );
  }
}