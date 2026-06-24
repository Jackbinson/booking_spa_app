import 'package:flutter/material.dart';

import '../../providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({
    required this.authProvider,
    this.onLogin,
    this.onRegisterSuccess,
    this.onTermsPressed,
    super.key,
  });

  final AuthProvider authProvider;
  final VoidCallback? onLogin;
  final VoidCallback? onRegisterSuccess;
  final VoidCallback? onTermsPressed;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptedTerms = false;
  bool _showTermsError = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF9FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFF241735),
        elevation: 0,
        title: const Text('Tạo tài khoản'),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.spa_rounded,
                    size: 72,
                    color: Color(0xFF7C4D9E),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Bắt đầu hành trình thư giãn',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: const Color(0xFF241735),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Tạo tài khoản để đặt lịch nhanh hơn và theo dõi các liệu trình của bạn.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF766C80),
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          key: const Key('register_full_name_field'),
                          controller: _fullNameController,
                          textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.next,
                          autofillHints: const [AutofillHints.name],
                          decoration: _inputDecoration(
                            label: 'Họ và tên',
                            icon: Icons.person_outline_rounded,
                          ),
                          validator: _validateFullName,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          key: const Key('register_email_field'),
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          autocorrect: false,
                          autofillHints: const [AutofillHints.email],
                          decoration: _inputDecoration(
                            label: 'Email',
                            icon: Icons.mail_outline_rounded,
                          ),
                          validator: _validateEmail,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          key: const Key('register_password_field'),
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          textInputAction: TextInputAction.next,
                          autofillHints: const [AutofillHints.newPassword],
                          decoration: _passwordDecoration(
                            label: 'Mật khẩu',
                            obscure: _obscurePassword,
                            toggleKey: const Key(
                              'toggle_register_password_visibility',
                            ),
                            onToggle: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          validator: _validatePassword,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          key: const Key('register_confirm_password_field'),
                          controller: _confirmPasswordController,
                          obscureText: _obscureConfirmPassword,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => _submit(),
                          decoration: _passwordDecoration(
                            label: 'Xác nhận mật khẩu',
                            obscure: _obscureConfirmPassword,
                            toggleKey: const Key(
                              'toggle_confirm_password_visibility',
                            ),
                            onToggle: () {
                              setState(() {
                                _obscureConfirmPassword =
                                    !_obscureConfirmPassword;
                              });
                            },
                          ),
                          validator: _validateConfirmPassword,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  CheckboxListTile(
                    key: const Key('register_terms_checkbox'),
                    value: _acceptedTerms,
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: const Color(0xFF7C4D9E),
                    onChanged: (value) {
                      setState(() {
                        _acceptedTerms = value ?? false;
                        _showTermsError = false;
                      });
                    },
                    title: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        const Text(
                          'Tôi đồng ý với ',
                          style: TextStyle(color: Color(0xFF766C80)),
                        ),
                        GestureDetector(
                          onTap: widget.onTermsPressed,
                          child: const Text(
                            'Điều khoản và Chính sách bảo mật',
                            style: TextStyle(
                              color: Color(0xFF7C4D9E),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_showTermsError)
                    const Padding(
                      padding: EdgeInsets.only(left: 12, bottom: 12),
                      child: Text(
                        'Vui lòng đồng ý với điều khoản sử dụng.',
                        key: Key('register_terms_error'),
                        style: TextStyle(
                          color: Color(0xFFB3261E),
                          fontSize: 12,
                        ),
                      ),
                    ),
                  AnimatedBuilder(
                    animation: widget.authProvider,
                    builder: (context, _) {
                      final provider = widget.authProvider;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (provider.errorMessage case final message?)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Text(
                                message,
                                key: const Key('register_error_message'),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Color(0xFFB3261E),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          FilledButton(
                            key: const Key('register_submit_button'),
                            onPressed: provider.isLoading ? null : _submit,
                            style: FilledButton.styleFrom(
                              minimumSize: const Size.fromHeight(54),
                              backgroundColor: const Color(0xFF7C4D9E),
                              foregroundColor: Colors.white,
                              disabledBackgroundColor: const Color(0xFFBDA7CC),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: provider.isLoading
                                ? const SizedBox.square(
                                    dimension: 22,
                                    child: CircularProgressIndicator(
                                      key: Key('register_progress_indicator'),
                                      strokeWidth: 2.4,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
                                    'Đăng ký',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Đã có tài khoản?',
                        style: TextStyle(color: Color(0xFF766C80)),
                      ),
                      TextButton(
                        key: const Key('register_login_button'),
                        onPressed:
                            widget.onLogin ??
                            () {
                              if (Navigator.of(context).canPop()) {
                                Navigator.of(context).pop();
                              }
                            },
                        child: const Text('Đăng nhập'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFE4DCE9)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFE4DCE9)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFF7C4D9E), width: 1.5),
      ),
    );
  }

  InputDecoration _passwordDecoration({
    required String label,
    required bool obscure,
    required Key toggleKey,
    required VoidCallback onToggle,
  }) {
    return _inputDecoration(
      label: label,
      icon: Icons.lock_outline_rounded,
    ).copyWith(
      suffixIcon: IconButton(
        key: toggleKey,
        tooltip: obscure ? 'Hiện mật khẩu' : 'Ẩn mật khẩu',
        onPressed: onToggle,
        icon: Icon(
          obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
        ),
      ),
    );
  }

  String? _validateFullName(String? value) {
    if ((value?.trim().length ?? 0) < 2) {
      return 'Họ và tên phải có ít nhất 2 ký tự.';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    final emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

    if (email.isEmpty) return 'Vui lòng nhập email.';
    if (!emailPattern.hasMatch(email)) return 'Email không hợp lệ.';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Vui lòng nhập mật khẩu.';
    if (value.length < 6) return 'Mật khẩu phải có ít nhất 6 ký tự.';
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng xác nhận mật khẩu.';
    }
    if (value != _passwordController.text) {
      return 'Mật khẩu xác nhận không khớp.';
    }
    return null;
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    widget.authProvider.clearError();

    final formIsValid = _formKey.currentState?.validate() ?? false;
    if (!_acceptedTerms) {
      setState(() => _showTermsError = true);
    }
    if (!formIsValid || !_acceptedTerms) return;

    final success = await widget.authProvider.register(
      fullName: _fullNameController.text,
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (success && mounted) {
      widget.onRegisterSuccess?.call();
    }
  }
}
