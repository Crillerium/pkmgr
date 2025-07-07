import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const StudyReminderApp());
}

class StudyReminderApp extends StatelessWidget {
  const StudyReminderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '学习提醒',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
      ),
      home: const HomePage(),
      routes: {
        '/progress': (context) => const ProgressPage(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('开卷！'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () {
              Navigator.pushNamed(context, '/progress');
            },
            tooltip: '学习进度',
          ),
        ],
      ),
      body: const Center(
        child: MaterialCardContent(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('学习信心+1'),
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 1),
            ),
          );
        },
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
      ),
    );
  }
}

class MaterialCardContent extends StatelessWidget {
  const MaterialCardContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.school,
                size: 64,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              '我要去学科目一！',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(height: 16),
            Text(
              '坚持学习，成就更好的自己',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  double _knowledgeProgress = 0.3;
  double _notesProgress = 0.5;
  double _practiceProgress = 0.7;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  // 从SharedPreferences加载进度
  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _knowledgeProgress = prefs.getDouble('knowledgeProgress') ?? 0.3;
      _notesProgress = prefs.getDouble('notesProgress') ?? 0.5;
      _practiceProgress = prefs.getDouble('practiceProgress') ?? 0.7;
    });
  }

  // 保存进度到SharedPreferences
  Future<void> _saveProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('knowledgeProgress', _knowledgeProgress);
    await prefs.setDouble('notesProgress', _notesProgress);
    await prefs.setDouble('practiceProgress', _practiceProgress);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('进度已保存！'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('学习进度'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveProgress,
            tooltip: '保存进度',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            ProgressSection(
              title: '科目一知识点观看进度',
              progress: _knowledgeProgress,
              icon: Icons.video_library,
              onChanged: (value) {
                setState(() {
                  _knowledgeProgress = value;
                });
              },
            ),
            const SizedBox(height: 32),
            ProgressSection(
              title: '笔记背诵进度',
              progress: _notesProgress,
              icon: Icons.notes,
              onChanged: (value) {
                setState(() {
                  _notesProgress = value;
                });
              },
            ),
            const SizedBox(height: 32),
            ProgressSection(
              title: '驾考宝典刷题进度',
              progress: _practiceProgress,
              icon: Icons.quiz,
              onChanged: (value) {
                setState(() {
                  _practiceProgress = value;
                });
              },
            ),
            const Spacer(),
            Center(
              child: FilledButton.tonal(
                onPressed: _saveProgress,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text('保存进度', style: TextStyle(fontSize: 18)),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class ProgressSection extends StatelessWidget {
  final String title;
  final double progress;
  final IconData icon;
  final ValueChanged<double> onChanged;

  const ProgressSection({
    super.key,
    required this.title,
    required this.progress,
    required this.icon,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 12),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        LinearProgressIndicator(
          value: progress,
          minHeight: 16,
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).colorScheme.primary,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Text(
              '${(progress * 100).toStringAsFixed(0)}%',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const Spacer(),
            IconButton.filledTonal(
              icon: const Icon(Icons.remove),
              onPressed: () {
                if (progress > 0) {
                  onChanged(progress - 0.1);
                }
              },
            ),
            const SizedBox(width: 12),
            IconButton.filled(
              icon: const Icon(Icons.add),
              onPressed: () {
                if (progress < 1) {
                  onChanged(progress + 0.1);
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}