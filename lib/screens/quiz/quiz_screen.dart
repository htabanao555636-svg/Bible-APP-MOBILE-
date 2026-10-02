import 'package:flutter/material.dart';
import 'package:bible_app/app/theme.dart';
import 'package:bible_app/models/quiz_question_model.dart';
import 'package:bible_app/services/quiz_service.dart';
import 'package:bible_app/widgets/quiz/quiz_option_tile.dart';
import 'package:bible_app/screens/quiz/quiz_result_screen.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final _service = QuizService();
  late final List<QuizQuestion> _questions;

  int _index = 0;
  int _score = 0;
  int? _selected;
  bool _finishing = false;

  bool get _answered => _selected != null;
  QuizQuestion get _current => _questions[_index];
  bool get _isLast => _index == _questions.length - 1;

  @override
  void initState() {
    super.initState();
    _questions = _service.getRound(count: 10);
  }

  void _choose(int optionIndex) {
    if (_answered) return;
    setState(() {
      _selected = optionIndex;
      if (optionIndex == _current.correctIndex) _score++;
    });
  }

  Future<void> _next() async {
    if (!_isLast) {
      setState(() {
        _index++;
        _selected = null;
      });
      return;
    }

    setState(() => _finishing = true);
    try {
      await _service.saveResult(score: _score, total: _questions.length);
    } catch (_) {
      // The result screen still shows even if saving fails.
    }
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) =>
            QuizResultScreen(score: _score, total: _questions.length),
      ),
    );
  }

  OptionState _stateFor(int i) {
    if (!_answered) return OptionState.idle;
    if (i == _current.correctIndex) return OptionState.correct;
    if (i == _selected) return OptionState.wrong;
    return OptionState.dimmed;
  }

  @override
  Widget build(BuildContext context) {
    final q = _current;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Question ${_index + 1} of ${_questions.length}'),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: (_index + 1) / _questions.length,
                  minHeight: 8,
                  backgroundColor: AppColors.cardCream,
                  color: AppColors.primaryGreen,
                ),
              ),
              SizedBox(height: 24),
              Text(
                q.question,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  height: 1.4,
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: [
                    for (var i = 0; i < q.options.length; i++) ...[
                      QuizOptionTile(
                        label: q.options[i],
                        state: _stateFor(i),
                        onTap: _answered ? null : () => _choose(i),
                      ),
                      SizedBox(height: 10),
                    ],
                    if (_answered) ...[
                      SizedBox(height: 6),
                      Text(
                        _selected == q.correctIndex
                            ? 'Correct! Read: ${q.reference}'
                            : 'The answer is ${q.options[q.correctIndex]}. Read: ${q.reference}',
                        style: TextStyle(
                          color: AppColors.primaryGreen,
                          fontWeight: FontWeight.w600,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (_answered)
                ElevatedButton(
                  onPressed: _finishing ? null : _next,
                  child: _finishing
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(_isLast ? 'See Results' : 'Next Question'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
