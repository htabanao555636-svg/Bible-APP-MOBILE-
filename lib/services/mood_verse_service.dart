import 'package:flutter/material.dart';
import 'package:bible_app/app/theme.dart';

class MoodVerse {
  final String reference;
  final String text;
  final String reflection;

  const MoodVerse({
    required this.reference,
    required this.text,
    required this.reflection,
  });
}

class Mood {
  final String id;
  final String label;
  final IconData icon;
  final Color color;
  final List<MoodVerse> verses;

  const Mood({
    required this.id,
    required this.label,
    required this.icon,
    required this.color,
    required this.verses,
  });
}

class MoodVerseService {
  static List<Mood> get moods => [
    Mood(
      id: 'worried',
      label: 'Worried',
      icon: Icons.cloud_outlined,
      color: AppColors.moodBlue,
      verses: const [
        MoodVerse(
          reference: '1 Peter 5:7',
          text: "Casting all your care upon him; for he careth for you.",
          reflection:
              "You do not have to carry every worry alone. Hand it over in prayer, because God cares about the details of your life.",
        ),
        MoodVerse(
          reference: 'Proverbs 3:5',
          text: "Trust in the LORD with all thine heart; and lean not unto thine own understanding.",
          reflection:
              "When you cannot see the way forward, trust God instead of your own understanding.",
        ),
        MoodVerse(
          reference: 'Proverbs 3:6',
          text: "In all thy ways acknowledge him, and he shall direct thy paths.",
          reflection:
              "Invite God into every decision, big or small. He promises to guide you.",
        ),
        MoodVerse(
          reference: 'Philippians 4:6',
          text:
              "Be careful for nothing; but in every thing by prayer and supplication with thanksgiving let your requests be made known unto God.",
          reflection:
              "Turn each worry into a prayer. Say it out loud to God, and thank Him in advance for listening.",
        ),
        MoodVerse(
          reference: 'Matthew 6:34',
          text:
              "Take therefore no thought for the morrow: for the morrow shall take thought for the things of itself. Sufficient unto the day is the evil thereof.",
          reflection:
              "You only need enough strength for today. Tomorrow's worries can wait for tomorrow.",
        ),
      ],
    ),
    Mood(
      id: 'sad',
      label: 'Sad',
      icon: Icons.water_drop_outlined,
      color: AppColors.moodPurple,
      verses: const [
        MoodVerse(
          reference: 'Psalm 34:18',
          text:
              "The LORD is nigh unto them that are of a broken heart; and saveth such as be of a contrite spirit.",
          reflection:
              "God is closest when you are hurting most. You are not forgotten in your sadness.",
        ),
        MoodVerse(
          reference: 'Psalm 30:5',
          text:
              "For his anger endureth but a moment; in his favour is life: weeping may endure for a night, but joy cometh in the morning.",
          reflection:
              "This hard season will not last forever. Morning is coming.",
        ),
        MoodVerse(
          reference: 'Psalm 147:3',
          text: "He healeth the broken in heart, and bindeth up their wounds.",
          reflection:
              "God does not just see your pain, He tends to it, gently and personally.",
        ),
        MoodVerse(
          reference: 'Matthew 5:4',
          text: "Blessed are they that mourn: for they shall be comforted.",
          reflection:
              "Grief is not a sign of weak faith. Comfort is promised to those who mourn.",
        ),
        MoodVerse(
          reference: 'Revelation 21:4',
          text:
              "And God shall wipe away all tears from their eyes; and there shall be no more death, neither sorrow, nor crying, neither shall there be any more pain: for the former things are passed away.",
          reflection:
              "A day is coming when every tear is wiped away for good. Hold on to that hope.",
        ),
      ],
    ),
    Mood(
      id: 'stressed',
      label: 'Stressed',
      icon: Icons.bolt_outlined,
      color: AppColors.moodOrange,
      verses: const [
        MoodVerse(
          reference: 'Matthew 11:28',
          text:
              "Come unto me, all ye that labour and are heavy laden, and I will give you rest.",
          reflection:
              "Jesus invites you to stop and rest in Him. Take a slow breath and let go of what you cannot control.",
        ),
        MoodVerse(
          reference: 'John 14:27',
          text:
              "Peace I leave with you, my peace I give unto you: not as the world giveth, give I unto you. Let not your heart be troubled, neither let it be afraid.",
          reflection:
              "The peace God gives does not depend on your circumstances. Ask Him for it today.",
        ),
        MoodVerse(
          reference: 'Psalm 46:1',
          text: "God is our refuge and strength, a very present help in trouble.",
          reflection:
              "Whatever is overwhelming you right now, God is near, not distant, in the middle of it.",
        ),
        MoodVerse(
          reference: 'Philippians 4:13',
          text: "I can do all things through Christ which strengtheneth me.",
          reflection:
              "You do not have to face today's pressure in your own strength alone.",
        ),
        MoodVerse(
          reference: 'Isaiah 41:10',
          text:
              "Fear thou not; for I am with thee: be not dismayed; for I am thy God: I will strengthen thee; yea, I will help thee.",
          reflection:
              "God promises His presence, strength, and help. Lean on that promise today.",
        ),
      ],
    ),
    Mood(
      id: 'lonely',
      label: 'Lonely',
      icon: Icons.person_outline,
      color: AppColors.moodTeal,
      verses: const [
        MoodVerse(
          reference: 'Deuteronomy 31:6',
          text:
              "Be strong and of a good courage, fear not, nor be afraid of them: for the LORD thy God, he it is that doth go with thee; he will not fail thee, nor forsake thee.",
          reflection:
              "Even when no one is around, God is walking with you. You are never truly alone.",
        ),
        MoodVerse(
          reference: 'Psalm 25:16',
          text: "Turn thee unto me, and have mercy upon me; for I am desolate and afflicted.",
          reflection:
              "It is honest to tell God when you feel alone. He welcomes that kind of prayer.",
        ),
        MoodVerse(
          reference: 'Hebrews 13:5',
          text: "...for he hath said, I will never leave thee, nor forsake thee.",
          reflection:
              "This is a direct promise from God, not a hope, a promise. He stays.",
        ),
        MoodVerse(
          reference: 'Psalm 68:6',
          text: "God setteth the solitary in families...",
          reflection:
              "God cares about your need for connection and community, not just your need for comfort.",
        ),
        MoodVerse(
          reference: 'Matthew 28:20',
          text: "...and, lo, I am with you alway, even unto the end of the world.",
          reflection:
              "Jesus' promise of presence has no expiration date and no exceptions.",
        ),
      ],
    ),
    Mood(
      id: 'angry',
      label: 'Angry',
      icon: Icons.local_fire_department_outlined,
      color: AppColors.moodPink,
      verses: const [
        MoodVerse(
          reference: 'Proverbs 15:1',
          text:
              "A soft answer turneth away wrath: but grievous words stir up anger.",
          reflection:
              "Before you respond, pause. A calm word can change the whole situation.",
        ),
        MoodVerse(
          reference: 'Ephesians 4:26',
          text:
              "Be ye angry, and sin not: let not the sun go down upon your wrath.",
          reflection:
              "Anger is a feeling, not a sin by itself. Bring it to God before it grows into something harmful.",
        ),
        MoodVerse(
          reference: 'James 1:19',
          text:
              "...let every man be swift to hear, slow to speak, slow to wrath.",
          reflection:
              "Listening first, speaking second, is a simple habit that defuses most conflict.",
        ),
        MoodVerse(
          reference: 'Proverbs 29:11',
          text: "A fool uttereth all his mind: but a wise man keepeth it in till afterwards.",
          reflection:
              "It is wise to wait before saying everything you feel in the heat of the moment.",
        ),
        MoodVerse(
          reference: 'Colossians 3:8',
          text:
              "But now ye also put off all these; anger, wrath, malice, blasphemy, filthy communication out of your mouth.",
          reflection:
              "You are not stuck with your anger. It is something you can, with God's help, set down.",
        ),
      ],
    ),
    Mood(
      id: 'happy',
      label: 'Happy',
      icon: Icons.wb_sunny_outlined,
      color: AppColors.moodYellow,
      verses: const [
        MoodVerse(
          reference: 'Psalm 118:24',
          text:
              "This is the day which the LORD hath made; we will rejoice and be glad in it.",
          reflection:
              "Enjoy this good moment and give God the credit for it.",
        ),
        MoodVerse(
          reference: 'Nehemiah 8:10',
          text:
              "...for the joy of the LORD is your strength.",
          reflection:
              "Joy is more than a mood. It gives you strength for whatever comes next.",
        ),
        MoodVerse(
          reference: 'Psalm 16:11',
          text:
              "Thou wilt shew me the path of life: in thy presence is fulness of joy; at thy right hand there are pleasures for evermore.",
          reflection:
              "True, lasting joy is found close to God, not just in circumstances.",
        ),
        MoodVerse(
          reference: 'James 1:17',
          text:
              "Every good gift and every perfect gift is from above, and cometh down from the Father of lights...",
          reflection:
              "Whatever is making you happy today traces back to God's generosity.",
        ),
        MoodVerse(
          reference: 'Psalm 100:2',
          text: "Serve the LORD with gladness: come before his presence with singing.",
          reflection:
              "Let this happiness become worship. Bring it, and your thanks, straight to God.",
        ),
      ],
    ),
    Mood(
      id: 'thankful',
      label: 'Thankful',
      icon: Icons.favorite_outline,
      color: AppColors.moodTeal,
      verses: const [
        MoodVerse(
          reference: '1 Thessalonians 5:18',
          text:
              "In every thing give thanks: for this is the will of God in Christ Jesus concerning you.",
          reflection:
              "Gratitude changes how we see our day. Name three things you are thankful for right now.",
        ),
        MoodVerse(
          reference: 'Psalm 107:1',
          text: "O give thanks unto the LORD, for he is good: for his mercy endureth for ever.",
          reflection:
              "God's goodness does not run out. Thank Him for His mercy today.",
        ),
        MoodVerse(
          reference: 'Psalm 136:1',
          text: "O give thanks unto the LORD; for he is good: for his mercy endureth for ever.",
          reflection:
              "Gratitude is even better shared out loud. Tell someone what you're thankful for today.",
        ),
        MoodVerse(
          reference: 'Colossians 3:15',
          text:
              "...and be ye thankful.",
          reflection:
              "Sometimes the instruction is simply this short and simply this clear.",
        ),
        MoodVerse(
          reference: 'Psalm 95:2',
          text: "Let us come before his presence with thanksgiving, and make a joyful noise unto him with psalms.",
          reflection:
              "Thanksgiving is not just a feeling, it's something you can actively bring to God in prayer.",
        ),
      ],
    ),
  ];
}
