import 'dart:async';
import 'package:flutter/material.dart';
import 'package:bible_app/services/daily_verse_service.dart';
import 'package:bible_app/widgets/home/verse_of_day_card.dart';

class DailyVerseCard extends StatefulWidget {
  const DailyVerseCard({super.key});

  @override
  State<DailyVerseCard> createState() => _DailyVerseCardState();
}

class _DailyVerseCardState extends State<DailyVerseCard>
    with WidgetsBindingObserver {
  final _service = DailyVerseService();
  DailyVerse? _verse;
  String _loadedDay = '';
  Timer? _midnightTimer;

  String _dayKey(DateTime d) => '${d.year}-${d.month}-${d.day}';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _load();
    _scheduleMidnightRefresh();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _midnightTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed &&
        _loadedDay != _dayKey(DateTime.now())) {
      _load();
      _scheduleMidnightRefresh();
    }
  }

  Future<void> _load() async {
    final now = DateTime.now();
    final verse = await _service.getVerseFor(now);
    if (!mounted) return;
    setState(() {
      _verse = verse;
      _loadedDay = _dayKey(now);
    });
  }

  void _scheduleMidnightRefresh() {
    _midnightTimer?.cancel();
    final now = DateTime.now();
    final nextMidnight = DateTime(now.year, now.month, now.day + 1);
    _midnightTimer =
        Timer(nextMidnight.difference(now) + Duration(seconds: 1), () {
      _load();
      _scheduleMidnightRefresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    final verse = _verse;
    if (verse == null) {
      return SizedBox(
        height: 140,
        child: Center(child: CircularProgressIndicator()),
      );
    }
    return VerseOfDayCard(reference: verse.reference, text: verse.text);
  }
}
