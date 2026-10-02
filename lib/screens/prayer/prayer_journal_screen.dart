import 'package:flutter/material.dart';
import 'package:bible_app/app/theme.dart';
import 'package:bible_app/models/prayer_model.dart';
import 'package:bible_app/services/prayer_service.dart';
import 'package:bible_app/screens/prayer/new_prayer_screen.dart';
import 'package:bible_app/widgets/prayer/prayer_card.dart';

class PrayerJournalScreen extends StatefulWidget {
  const PrayerJournalScreen({super.key});

  @override
  State<PrayerJournalScreen> createState() => _PrayerJournalScreenState();
}

class _PrayerJournalScreenState extends State<PrayerJournalScreen> {
  final _service = PrayerService();
  int _filter = 0; // 0 = All, 1 = Active, 2 = Answered

  void _openEditor([PrayerModel? prayer]) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => NewPrayerScreen(prayer: prayer)),
    );
  }

  Future<void> _confirmDelete(PrayerModel prayer) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Delete prayer?'),
        content: Text('"${prayer.title}" will be permanently deleted.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _service.remove(prayer.id);
      } catch (_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not delete prayer.')),
          );
        }
      }
    }
  }

  Future<void> _toggleAnswered(PrayerModel prayer) async {
    try {
      await _service.setAnswered(prayer.id, !prayer.isAnswered);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not update prayer.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text('Prayer Journal')),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        onPressed: () => _openEditor(),
        icon: Icon(Icons.add),
        label: Text('New Prayer'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Row(
              children: [
                _filterChip('All', 0),
                SizedBox(width: 8),
                _filterChip('Active', 1),
                SizedBox(width: 8),
                _filterChip('Answered', 2),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<PrayerModel>>(
              stream: _service.watchPrayers(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Could not load prayers.',
                        style: TextStyle(color: AppColors.textMuted)),
                  );
                }
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final all = snapshot.data!;
                final prayers = all.where((p) {
                  if (_filter == 1) return !p.isAnswered;
                  if (_filter == 2) return p.isAnswered;
                  return true;
                }).toList();

                if (prayers.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Text(
                        all.isEmpty
                            ? 'Your prayer journal is empty.\nTap "New Prayer" to write your first one.'
                            : 'No prayers in this filter.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: AppColors.textMuted, height: 1.5),
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  padding: EdgeInsets.fromLTRB(16, 12, 16, 96),
                  itemCount: prayers.length,
                  separatorBuilder: (_, _) => SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final prayer = prayers[index];
                    return PrayerCard(
                      prayer: prayer,
                      onTap: () => _openEditor(prayer),
                      onToggleAnswered: () => _toggleAnswered(prayer),
                      onDelete: () => _confirmDelete(prayer),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String label, int value) {
    final selected = _filter == value;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      selectedColor: AppColors.primaryGreen,
      labelStyle: TextStyle(
        color: selected ? Colors.white : AppColors.textDark,
        fontWeight: FontWeight.w600,
      ),
      onSelected: (_) => setState(() => _filter = value),
    );
  }
}
