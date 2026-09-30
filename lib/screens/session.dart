import 'dart:async';
import 'package:flutter/material.dart';
import '../data.dart';
import '../theme.dart';
import '../widgets.dart';

class WorkoutSessionPage extends StatefulWidget {
  final Workout workout;
  const WorkoutSessionPage({super.key, required this.workout});

  @override
  State<WorkoutSessionPage> createState() => _WorkoutSessionPageState();
}

class _WorkoutSessionPageState extends State<WorkoutSessionPage> {
  late final List<List<bool>> _done;
  late final Timer _timer;
  int _seconds = 0;

  @override
  void initState() {
    super.initState();
    _done = [
      for (final e in widget.workout.exercises) List<bool>.filled(e.sets, false)
    ];
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _seconds++);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String get _clock {
    final m = (_seconds ~/ 60).toString().padLeft(2, '0');
    final s = (_seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  double get _progress {
    final total = _done.fold<int>(0, (a, l) => a + l.length);
    final ok = _done.fold<int>(0, (a, l) => a + l.where((x) => x).length);
    return total == 0 ? 0 : ok / total;
  }

  @override
  Widget build(BuildContext context) {
    final w = widget.workout;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.sidebar,
        title: Text(w.name,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Text(_clock,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.orange)),
            ),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              ProgressRow('Progresso do treino', _progress),
              const SizedBox(height: 4),
              for (int i = 0; i < w.exercises.length; i++) ...[
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(w.exercises[i].name,
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 2),
                      Text(
                          '${w.exercises[i].sets} séries x ${w.exercises[i].reps}',
                          style: const TextStyle(
                              fontSize: 12, color: AppColors.muted)),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          for (int s = 0; s < _done[i].length; s++)
                            GestureDetector(
                              onTap: () =>
                                  setState(() => _done[i][s] = !_done[i][s]),
                              child: Container(
                                width: 44,
                                height: 44,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: _done[i][s]
                                      ? AppColors.orange
                                      : AppColors.bg,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: _done[i][s]
                                          ? AppColors.orange
                                          : AppColors.border),
                                ),
                                child: _done[i][s]
                                    ? const Icon(Icons.check, size: 20)
                                    : Text('${s + 1}',
                                        style: const TextStyle(
                                            color: AppColors.muted)),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
              ],
              const SizedBox(height: 8),
              PrimaryButton('FINALIZAR TREINO', expand: true, onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Treino concluído em $_clock 💪')),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
