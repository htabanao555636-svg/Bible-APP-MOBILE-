import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bible_app/models/quiz_question_model.dart';

class QuizService {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  // The FIRST option is always the correct answer. It is shuffled per round.
  static QuizQuestion _q(
      String question, String correct, List<String> wrong, String reference) {
    return QuizQuestion(
      question: question,
      options: [correct, ...wrong],
      correctIndex: 0,
      reference: reference,
    );
  }

  static final List<QuizQuestion> _bank = [
    _q('Which book is the first book of the Bible?', 'Genesis',
        ['Exodus', 'Psalms', 'Matthew'], 'Genesis 1'),
    _q('Which book is the last book of the Bible?', 'Revelation',
        ['Jude', 'Acts', 'Malachi'], 'Revelation 22'),
    _q('Who was the first man?', 'Adam', ['Noah', 'Abel', 'Enoch'],
        'Genesis 2:7'),
    _q('Who was the first woman?', 'Eve', ['Sarah', 'Ruth', 'Miriam'],
        'Genesis 3:20'),
    _q('Who built the ark?', 'Noah', ['Moses', 'Abraham', 'David'],
        'Genesis 6:14'),
    _q('Who was Jacob\'s twin brother?', 'Esau', ['Isaac', 'Laban', 'Reuben'],
        'Genesis 25'),
    _q('Who was sold into slavery by his brothers?', 'Joseph',
        ['Benjamin', 'Judah', 'Levi'], 'Genesis 37:28'),
    _q('Who was the brother of Moses?', 'Aaron', ['Joshua', 'Caleb', 'Eli'],
        'Exodus 4:14'),
    _q('How many plagues did God send on Egypt?', 'Ten',
        ['Seven', 'Twelve', 'Forty'], 'Exodus 12'),
    _q('On which mountain did Moses receive the Ten Commandments?', 'Sinai',
        ['Zion', 'Carmel', 'Olivet'], 'Exodus 19:20'),
    _q('What food did God provide to Israel in the wilderness?', 'Manna',
        ['Honey cakes', 'Olives', 'Barley soup'], 'Exodus 16:31'),
    _q('Who was the first king of Israel?', 'Saul',
        ['David', 'Solomon', 'Samuel'], '1 Samuel 10'),
    _q('Who was the mother of Samuel?', 'Hannah',
        ['Naomi', 'Esther', 'Rebekah'], '1 Samuel 1:20'),
    _q('Who defeated Goliath?', 'David', ['Saul', 'Jonathan', 'Joshua'],
        '1 Samuel 17:50'),
    _q('Which king asked God for an understanding heart?', 'Solomon',
        ['David', 'Hezekiah', 'Josiah'], '1 Kings 3:9'),
    _q('Which prophet was taken up to heaven in a whirlwind?', 'Elijah',
        ['Elisha', 'Isaiah', 'Jeremiah'], '2 Kings 2:11'),
    _q('Which queen risked her life to save the Jewish people in Persia?',
        'Esther', ['Ruth', 'Deborah', 'Jezebel'], 'Esther 4:14'),
    _q('Which book of the Bible comes right after Psalms?', 'Proverbs',
        ['Ecclesiastes', 'Job', 'Isaiah'], 'Proverbs 1'),
    _q('Who was thrown into the lions\' den?', 'Daniel',
        ['Jonah', 'Elijah', 'Ezekiel'], 'Daniel 6:16'),
    _q('Who was swallowed by a great fish?', 'Jonah',
        ['Job', 'Micah', 'Amos'], 'Jonah 1:17'),
    _q('In which town was Jesus born?', 'Bethlehem',
        ['Nazareth', 'Jerusalem', 'Capernaum'], 'Matthew 2:1'),
    _q('Who was the mother of Jesus?', 'Mary',
        ['Martha', 'Elizabeth', 'Anna'], 'Luke 1:27'),
    _q('In which river was Jesus baptized?', 'Jordan',
        ['Nile', 'Euphrates', 'Jabbok'], 'Matthew 3:13'),
    _q('How many disciples did Jesus choose?', 'Twelve',
        ['Seven', 'Ten', 'Seventy'], 'Luke 6:13'),
    _q('What did Jesus turn water into at the wedding in Cana?', 'Wine',
        ['Milk', 'Oil', 'Honey'], 'John 2:9'),
    _q('Which disciple walked on water toward Jesus?', 'Peter',
        ['John', 'Andrew', 'Thomas'], 'Matthew 14:29'),
    _q('Which tax collector climbed a sycamore tree to see Jesus?',
        'Zacchaeus', ['Matthew', 'Levi', 'Nicodemus'], 'Luke 19:4'),
    _q('Which two words make up the shortest verse in the KJV Bible?',
        'Jesus wept', ['God is', 'Pray always', 'Rejoice ever'], 'John 11:35'),
    _q('In which garden did Jesus pray before He was arrested?', 'Gethsemane',
        ['Eden', 'Bethany', 'Olivet Grove'], 'Matthew 26:36'),
    _q('Which disciple denied Jesus three times?', 'Peter',
        ['Judas', 'Thomas', 'Philip'], 'Matthew 26:75'),
    _q('Who was the first Christian martyr?', 'Stephen',
        ['James', 'Barnabas', 'Timothy'], 'Acts 7:59'),
    _q('Saul of Tarsus was also known by what name?', 'Paul',
        ['Silas', 'Barnabas', 'Apollos'], 'Acts 13:9'),
    _q('In which book do we find the "fruit of the Spirit"?', 'Galatians',
        ['Romans', 'Ephesians', 'James'], 'Galatians 5:22'),
  ];

  /// A random set of questions with the answer options shuffled.
  List<QuizQuestion> getRound({int count = 10}) {
    final pool = List<QuizQuestion>.from(_bank)..shuffle();

    return pool.take(count).map((q) {
      final correct = q.options[q.correctIndex];
      final options = List<String>.from(q.options)..shuffle();
      return QuizQuestion(
        question: q.question,
        options: options,
        correctIndex: options.indexOf(correct),
        reference: q.reference,
      );
    }).toList();
  }

  CollectionReference<Map<String, dynamic>>? get _col {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return null;
    return _db.collection('users').doc(uid).collection('quizResults');
  }

  Future<void> saveResult({required int score, required int total}) async {
    await _col?.add({
      'score': score,
      'total': total,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  /// Live list of the user's past results, newest first.
  Stream<List<QuizResultModel>> watchResults() {
    final col = _col;
    if (col == null) return Stream.value([]);

    return col.snapshots().map((snap) {
      final now = DateTime.now();
      final list = snap.docs.map(QuizResultModel.fromDoc).toList();
      list.sort((a, b) =>
          (b.createdAt ?? now).compareTo(a.createdAt ?? now));
      return list;
    });
  }
}
