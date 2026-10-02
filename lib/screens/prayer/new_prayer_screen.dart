import 'package:flutter/material.dart';
import 'package:bible_app/app/theme.dart';
import 'package:bible_app/models/prayer_model.dart';
import 'package:bible_app/services/prayer_service.dart';

class NewPrayerScreen extends StatefulWidget {
  final PrayerModel? prayer; // null = new prayer, otherwise edit

  const NewPrayerScreen({super.key, this.prayer});

  @override
  State<NewPrayerScreen> createState() => _NewPrayerScreenState();
}

class _NewPrayerScreenState extends State<NewPrayerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _service = PrayerService();
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  bool _saving = false;

  bool get _isEditing => widget.prayer != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.prayer?.title ?? '');
    _contentController =
        TextEditingController(text: widget.prayer?.content ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);
    try {
      final title = _titleController.text.trim();
      final content = _contentController.text.trim();

      if (_isEditing) {
        await _service.update(
            id: widget.prayer!.id, title: title, content: content);
      } else {
        await _service.add(title: title, content: content);
      }

      if (mounted) Navigator.of(context).pop();
    } catch (_) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not save prayer. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(_isEditing ? 'Edit Prayer' : 'New Prayer')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _titleController,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    hintText: 'e.g. Guidance for my studies',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Give your prayer a title';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _contentController,
                  textCapitalization: TextCapitalization.sentences,
                  minLines: 8,
                  maxLines: 14,
                  decoration: InputDecoration(
                    labelText: 'Your prayer',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Write your prayer';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _saving ? null : _save,
                  child: _saving
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(_isEditing ? 'Save Changes' : 'Save Prayer'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
