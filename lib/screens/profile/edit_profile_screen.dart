import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bible_app/app/theme.dart';
import 'package:bible_app/services/auth_service.dart';
import 'package:bible_app/widgets/common/user_avatar.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final String _originalName;
  late final String _originalEmail;
  bool _saving = false;
  bool _uploadingPhoto = false;

  @override
  void initState() {
    super.initState();
    final user = _authService.currentUser;
    _originalName = user?.displayName?.trim() ?? '';
    _originalEmail = user?.email?.trim() ?? '';
    _nameController = TextEditingController(text: _originalName);
    _emailController = TextEditingController(text: _originalEmail);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _message(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _pickAndUploadPhoto() async {
    XFile? picked;
    try {
      picked = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 300,
        maxHeight: 300,
        imageQuality: 70,
      );
    } catch (_) {
      _message('Could not open your files. Please try again.');
      return;
    }

    if (picked == null) return; // user cancelled

    setState(() => _uploadingPhoto = true);
    try {
      final Uint8List bytes = await picked.readAsBytes();
      await _authService.uploadProfilePhoto(bytes);
      _message('Profile photo updated.');
    } catch (_) {
      _message('Could not upload photo. Please try again.');
    } finally {
      if (mounted) setState(() => _uploadingPhoto = false);
    }
  }

  Future<String?> _askForPassword() {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Confirm your password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'For your security, please re-enter your password to change your email.',
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              obscureText: true,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, null),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, controller.text),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final newName = _nameController.text.trim();
    final newEmail = _emailController.text.trim();
    final nameChanged = newName != _originalName;
    final emailChanged = newEmail != _originalEmail;

    if (!nameChanged && !emailChanged) {
      Navigator.of(context).pop();
      return;
    }

    setState(() => _saving = true);

    try {
      if (nameChanged) {
        await _authService.updateDisplayName(newName);
      }

      if (emailChanged) {
        try {
          await _authService.updateEmail(newEmail);
        } on FirebaseAuthException catch (e) {
          if (e.code == 'requires-recent-login') {
            final password = await _askForPassword();
            if (password == null || password.isEmpty) {
              setState(() => _saving = false);
              return;
            }
            await _authService.reauthenticateWithPassword(password);
            await _authService.updateEmail(newEmail);
          } else {
            rethrow;
          }
        }
      }

      if (!mounted) return;

      if (emailChanged) {
        _message('Check $newEmail for a link to confirm your new email.');
      } else {
        _message('Profile updated.');
      }

      await Future.delayed(const Duration(milliseconds: 600));
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        setState(() => _saving = false);
        _message(_authService.friendlyError(e));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final name = _authService.currentUser?.displayName?.trim() ?? '';
    final initial = name.isEmpty ? '?' : name[0].toUpperCase();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Edit Profile')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: GestureDetector(
                  onTap: _uploadingPhoto ? null : _pickAndUploadPhoto,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      UserAvatar(initial: initial, radius: 50),
                      if (_uploadingPhoto)
                        Positioned.fill(
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.black.withOpacity(0.4),
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      Positioned(
                        bottom: -2,
                        right: -2,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.primaryGreen,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.background, width: 2),
                          ),
                          child: const Icon(Icons.camera_alt,
                              size: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'Tap to change photo',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                ),
              ),
              const SizedBox(height: 24),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Enter your name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || !value.contains('@')) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Changing your email will send a confirmation link to the new address. It only takes effect once you click that link.',
                      style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _saving ? null : _save,
                      child: _saving
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text('Save Changes'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
