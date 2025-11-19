import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import './constants.dart';

class RccCore extends StatelessWidget {
  const RccCore({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = context.watch<ChangeNotifier>();
    final dynamic rccProvider = provider;
    final statusColor = rccProvider.statusColor as Color;

    return Semantics(
      container: true,
      label: 'Network connection control panel',
      child: Center(
      child: Padding(
        padding: const .all(20.0),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          decoration: BoxDecoration(
            color: theme.cardColor.withValues(alpha: 0.9),
            borderRadius: .circular(24),
            boxShadow: [
              BoxShadow(
                color: statusColor.withValues(alpha: 0.2),
                blurRadius: 15,
                spreadRadius: 1,
                offset: const Offset(0, 4),
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                spreadRadius: 0,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(color: statusColor.withValues(alpha: 0.3), width: 1.5),
          ),
          child: ClipRRect(
            borderRadius: .circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const .all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      statusColor.withValues(alpha: 0.05),
                      statusColor.withValues(alpha: 0.02),
                    ],
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RccStatusBadge(),
                    const SizedBox(height: 20),
                    RccStatusIndicator(),
                    const SizedBox(height: 20),
                    RccStatusText(),
                    const SizedBox(height: 6),
                    RccStatusMessage(),
                    const SizedBox(height: 24),
                    RccButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ),
    );
  }
}

class RccStatusBadge extends StatelessWidget {
  const RccStatusBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ChangeNotifier>();
    final dynamic rccProvider = provider;
    final statusColor = rccProvider.statusColor as Color;

    return Container(
      padding: const .symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: .circular(20),
        border: Border.all(
          color: statusColor.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            rccProvider.status as String,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
              color: statusColor,
            ),
          ),
        ],
      ),
    );
  }
}

class RccStatusIndicator extends StatelessWidget {
  const RccStatusIndicator({super.key});

  IconData _getStatusIcon(dynamic provider) {
    if (provider.isLoading as bool) {
      return Constants.iconRccSync;
    }
    switch (provider.status as String) {
      case 'STARTED':
        return Constants.iconRccConnected;
      case 'STARTING':
      case 'STOPPING':
        return Constants.iconRccSync;
      default:
        return Constants.iconRccDisconnected;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = context.watch<ChangeNotifier>();
    final dynamic rccProvider = provider;
    final statusColor = rccProvider.statusColor as Color;

    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            theme.brightness == Brightness.dark
                ? Colors.grey.shade900
                : Colors.white,
            theme.brightness == Brightness.dark
                ? Colors.grey.shade900.withValues(alpha: 0.9)
                : Colors.white.withValues(alpha: 0.9),
          ],
          stops: const [0.5, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: statusColor.withValues(alpha: 0.3),
            blurRadius: 20,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            spreadRadius: 0,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(
          color: statusColor,
          width: rccProvider.isLoading as bool ? 3 : 2,
        ),
      ),
      child: Center(
        child: ShaderMask(
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                statusColor,
                statusColor.withValues(alpha: 0.7),
              ],
            ).createShader(bounds);
          },
          child: Icon(
            _getStatusIcon(rccProvider),
            size: 60,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class RccStatusText extends StatelessWidget {
  const RccStatusText({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = context.watch<ChangeNotifier>();
    final dynamic rccProvider = provider;
    final statusColor = rccProvider.statusColor as Color;

    return Text(
      rccProvider.statusText as String,
      style: theme.textTheme.headlineMedium?.copyWith(
        color: statusColor,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class RccStatusMessage extends StatelessWidget {
  const RccStatusMessage({super.key});

  String _getStatusMessage(String status) {
    switch (status) {
      case 'STARTED':
        return 'Your connection is secure and protected';
      case 'STARTING':
        return 'Establishing secure connection...';
      case 'STOPPING':
        return 'Disconnecting...';
      default:
        return 'Ready to connect';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = context.watch<ChangeNotifier>();
    final dynamic rccProvider = provider;

    return Text(
      _getStatusMessage(rccProvider.status as String),
      style: theme.textTheme.bodyMedium?.copyWith(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
        height: 1.4,
      ),
      textAlign: TextAlign.center,
    );
  }
}

class RccButton extends StatefulWidget {
  const RccButton({super.key});

  @override
  State<RccButton> createState() => _RccButtonState();
}

class _RccButtonState extends State<RccButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  IconData _getButtonIcon(String status) {
    switch (status) {
      case 'STARTED':
        return Constants.iconRccStop;
      case 'STARTING':
      case 'STOPPING':
        return Constants.iconRccSync;
      default:
        return Constants.iconRccPower;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = context.watch<ChangeNotifier>();
    final dynamic rccProvider = provider;
    final isConnected = rccProvider.status == 'STARTED';

    return Semantics(
      button: true,
      enabled: rccProvider.isButtonEnabled as bool,
      label: isConnected ? 'Disconnect from network' : 'Connect to network',
      hint: rccProvider.isLoading as bool ? 'Processing...' : null,
      child: GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: double.infinity,
              height: 52,
              decoration: BoxDecoration(
                borderRadius: .circular(16),
                boxShadow: [
                  BoxShadow(
                    color: (isConnected ? Colors.red : theme.colorScheme.primary).withValues(alpha: 0.25),
                    blurRadius: 20,
                    spreadRadius: -2,
                    offset: const Offset(0, 8),
                  ),
                  BoxShadow(
                    color: (isConnected ? Colors.red : theme.colorScheme.primary).withValues(alpha: 0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: .circular(16),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: isConnected
                            ? [
                                Colors.red.shade500.withValues(alpha: 0.9),
                                Colors.red.shade600.withValues(alpha: 0.95),
                              ]
                            : [
                                theme.colorScheme.primary.withValues(alpha: 0.9),
                                theme.colorScheme.primary.withValues(alpha: 0.95),
                              ],
                      ),
                      borderRadius: .circular(16),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: rccProvider.isButtonEnabled as bool
                            ? () => rccProvider.toggle(context)
                            : null,
                        borderRadius: .circular(16),
                        splashColor: Colors.white.withValues(alpha: 0.2),
                        highlightColor: Colors.white.withValues(alpha: 0.1),
                        child: Container(
                          padding: const .symmetric(horizontal: 24),
                          child: Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (rccProvider.isLoading as bool)
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white.withValues(alpha: 0.9),
                                    ),
                                  )
                                else
                                  Icon(
                                    _getButtonIcon(rccProvider.status as String),
                                    color: Colors.white,
                                    size: 22,
                                  ),
                                const SizedBox(width: 10),
                                Text(
                                  rccProvider.buttonText as String,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    ),
    );
  }
}