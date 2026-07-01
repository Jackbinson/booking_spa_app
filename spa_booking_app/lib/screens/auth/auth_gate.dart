import 'package:flutter/material.dart';

import '../../providers/auth_provider.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({
    required this.authProvider,
    required this.authenticatedBuilder,
    this.loadingWidget,
    super.key,
  });

  final AuthProvider authProvider;
  final WidgetBuilder authenticatedBuilder;
  final Widget? loadingWidget;

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  void initState() {
    super.initState();
    _initializeAfterBuild();
  }

  @override
  void didUpdateWidget(covariant AuthGate oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.authProvider != widget.authProvider) {
      _initializeAfterBuild();
    }
  }

  void _initializeAfterBuild() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      widget.authProvider.initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.authProvider,
      builder: (context, _) {
        final provider = widget.authProvider;

        if (provider.status == AuthStatus.initial || provider.isLoading) {
          return widget.loadingWidget ?? const _AuthLoadingScreen();
        }

        if (provider.isAuthenticated) {
          return widget.authenticatedBuilder(context);
        }

        return LoginScreen(
          authProvider: provider,
          onCreateAccount: () => _openRegistration(context),
        );
      },
    );
  }

  Future<void> _openRegistration(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => RegisterScreen(
          authProvider: widget.authProvider,
          onRegisterSuccess: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }
}

class _AuthLoadingScreen extends StatelessWidget {
  const _AuthLoadingScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFFCF9FF),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.spa_rounded, size: 72, color: Color(0xFF7C4D9E)),
              SizedBox(height: 24),
              CircularProgressIndicator(
                key: Key('auth_gate_progress_indicator'),
                color: Color(0xFF7C4D9E),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
