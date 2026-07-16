import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../models/user_profile.dart';
import '../../providers/auth_provider.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _imagePicker = ImagePicker();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _birthdayController;
  late final TextEditingController _addressController;
  late String _gender;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().currentUser;
    _nameController = TextEditingController(text: user.fullName);
    _phoneController = TextEditingController(text: user.phone);
    _birthdayController = TextEditingController(
      text: profileBirthDateInputValue(user.birthday),
    );
    _addressController = TextEditingController(text: user.address);
    _gender = _genderValue(user.gender);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _birthdayController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _pickAvatar() async {
    final image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1080,
      imageQuality: 85,
    );
    if (image == null || !mounted) {
      return;
    }

    final success = await context.read<AuthProvider>().uploadAvatar(
      bytes: await image.readAsBytes(),
      contentType: _contentTypeFor(image),
    );
    if (!mounted) {
      return;
    }
    _showResult(
      success
          ? 'Đã cập nhật ảnh đại diện.'
          : context.read<AuthProvider>().errorMessage!,
      success: success,
    );
  }

  Future<void> _pickBirthday() async {
    final parsed = DateTime.tryParse(_birthdayController.text);
    final selected = await showDatePicker(
      context: context,
      initialDate: parsed ?? DateTime(2000, 1, 1),
      firstDate: DateTime(1900, 1, 1),
      lastDate: DateTime.now(),
    );
    if (selected == null) {
      return;
    }
    setState(() {
      _birthdayController.text =
          '${selected.year.toString().padLeft(4, '0')}-${selected.month.toString().padLeft(2, '0')}-${selected.day.toString().padLeft(2, '0')}';
    });
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    final success = await context.read<AuthProvider>().updateProfile(
      fullName: _nameController.text,
      phone: _phoneController.text,
      birthDate: _birthdayController.text,
      gender: _gender,
      address: _addressController.text,
    );
    if (!mounted) {
      return;
    }
    if (success) {
      Navigator.of(context).pop();
      return;
    }
    _showResult(context.read<AuthProvider>().errorMessage!, success: false);
  }

  void _showResult(String message, {required bool success}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: success ? Colors.green.shade700 : AppColors.danger,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Chỉnh sửa hồ sơ')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Center(
                child: Stack(
                  children: [
                    _ProfileAvatar(user: user, size: 108),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Material(
                        color: AppColors.primary,
                        shape: const CircleBorder(),
                        child: IconButton(
                          onPressed: auth.isLoading ? null : _pickAvatar,
                          icon: const Icon(Icons.photo_camera_outlined),
                          color: Colors.white,
                          tooltip: 'Chọn ảnh từ thư viện',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Chạm biểu tượng máy ảnh để thay ảnh đại diện',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textLight),
              ),
              const SizedBox(height: 26),
              TextFormField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Họ và tên',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (value) {
                  if ((value ?? '').trim().length < 2) {
                    return 'Vui lòng nhập họ tên hợp lệ.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: user.email,
                enabled: false,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Số điện thoại',
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _birthdayController,
                readOnly: true,
                onTap: _pickBirthday,
                decoration: const InputDecoration(
                  labelText: 'Ngày sinh',
                  prefixIcon: Icon(Icons.cake_outlined),
                  suffixIcon: Icon(Icons.calendar_month_outlined),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _gender,
                decoration: const InputDecoration(
                  labelText: 'Giới tính',
                  prefixIcon: Icon(Icons.wc_outlined),
                ),
                items: const [
                  DropdownMenuItem(value: '', child: Text('Chưa cập nhật')),
                  DropdownMenuItem(value: 'male', child: Text('Nam')),
                  DropdownMenuItem(value: 'female', child: Text('Nữ')),
                  DropdownMenuItem(value: 'other', child: Text('Khác')),
                ],
                onChanged: auth.isLoading
                    ? null
                    : (value) => setState(() => _gender = value ?? ''),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                minLines: 2,
                maxLines: 3,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Địa chỉ',
                  alignLabelWithHint: true,
                  prefixIcon: Icon(Icons.location_on_outlined),
                ),
              ),
              const SizedBox(height: 28),
              FilledButton.icon(
                onPressed: auth.isLoading ? null : _save,
                icon: auth.isLoading
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save_outlined),
                label: Text(auth.isLoading ? 'Đang lưu...' : 'Lưu thay đổi'),
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                  backgroundColor: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _genderValue(String label) {
    switch (label) {
      case 'Nam':
        return 'male';
      case 'Nữ':
        return 'female';
      case 'Khác':
        return 'other';
      default:
        return '';
    }
  }

  String _contentTypeFor(XFile image) {
    final mimeType = image.mimeType;
    if (mimeType == 'image/jpeg' ||
        mimeType == 'image/png' ||
        mimeType == 'image/webp') {
      return mimeType!;
    }
    final path = image.path.toLowerCase();
    if (path.endsWith('.png')) {
      return 'image/png';
    }
    if (path.endsWith('.webp')) {
      return 'image/webp';
    }
    return 'image/jpeg';
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({required this.user, required this.size});

  final UserProfile user;
  final double size;

  @override
  Widget build(BuildContext context) {
    final imageUrl = user.avatar.trim();
    return Container(
      width: size,
      height: size,
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        color: AppColors.secondary,
        shape: BoxShape.circle,
      ),
      child: imageUrl.isEmpty
          ? Icon(
              Icons.person_outline,
              color: AppColors.primary,
              size: size * .5,
            )
          : Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Icon(
                Icons.person_outline,
                color: AppColors.primary,
                size: size * .5,
              ),
            ),
    );
  }
}
