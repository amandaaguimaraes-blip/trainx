import 'package:flutter/material.dart';
import '../data.dart';
import '../theme.dart';
import '../widgets.dart';
import 'camera_checkin.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      final wide = c.maxWidth >= 860;
      final pad = c.maxWidth >= 600 ? 32.0 : 16.0;
      const gap = SizedBox(height: 20);

      final main = Column(children: const [
        _Hero(),
        gap,
        _Stats(),
        gap,
        _VolumeCard(),
      ]);
      final side = Column(children: const [
        _WeeklyGoal(),
        gap,
        _MuscleEvolution(),
        gap,
        _NextExercises(),
      ]);

      return SingleChildScrollView(
        padding: EdgeInsets.all(pad),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PageHeader(overline: dataHoje(), title: 'Olá, Lucas 👋'),
            const SizedBox(height: 24),
            if (wide)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 3, child: main),
                  const SizedBox(width: 20),
                  SizedBox(width: 340, child: side),
                ],
              )
            else ...[
              main,
              gap,
              side,
            ],
          ],
        ),
      );
    });
  }
}

class _Hero extends StatelessWidget {
  const _Hero();

  @override
  Widget build(BuildContext context) {
    final w = workouts.first;
    Widget info(IconData i, String t) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(i, size: 13, color: AppColors.muted),
            const SizedBox(width: 4),
            Text(t, style: const TextStyle(fontSize: 11, color: AppColors.muted)),
          ],
        );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xFF4A2A1C), Color(0xFF181818)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Tag('TREINO DE HOJE'),
          const SizedBox(height: 40),
          Text(w.name,
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          const Text('Peito, ombros e tríceps. Um treino focado em força e hipertrofia.',
              style: TextStyle(fontSize: 12, color: AppColors.muted)),
          const SizedBox(height: 14),
          Wrap(spacing: 16, runSpacing: 6, children: [
            info(Icons.timer_outlined, w.duration),
            info(Icons.local_fire_department_outlined, '${w.kcal} kcal'),
            info(Icons.fitness_center, '${w.exercises.length} exercícios'),
          ]),
          const SizedBox(height: 20),
          PrimaryButton('INICIAR TREINO →',
              onPressed: () => iniciarTreino(context, w)),
        ],
      ),
    );
  }
}

class _Stats extends StatelessWidget {
  const _Stats();

  @override
  Widget build(BuildContext context) {
    return const ResponsiveWrap(
      minItemWidth: 140,
      children: [
        StatTile(
            icon: Icons.local_fire_department,
            label: 'CALORIAS',
            value: '2.840',
            unit: 'kcal',
            delta: '+8,2%'),
        StatTile(
            icon: Icons.bolt,
            label: 'VOLUME',
            value: '42,5',
            unit: 'ton',
            delta: '+12,8%'),
        StatTile(
            icon: Icons.timer,
            label: 'TREINOS',
            value: '4',
            unit: 'na semana'),
        StatTile(
            icon: Icons.trending_up,
            label: 'EVOLUÇÃO',
            value: '+12%',
            unit: 'no mês'),
      ],
    );
  }
}

class _VolumeCard extends StatelessWidget {
  const _VolumeCard();

  @override
  Widget build(BuildContext context) {
    return const AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CardTitle('Volume de treino', 'Quilos levantados por dia'),
          SizedBox(height: 20),
          BarChart(values: volumeSemanal, labels: diasSemana, highlight: 4),
        ],
      ),
    );
  }
}

class _WeeklyGoal extends StatelessWidget {
  const _WeeklyGoal();

  @override
  Widget build(BuildContext context) {
    return const AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CardTitle('Meta semanal', 'Mantenha sua consistência',
              trailing: Text('4/5',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.orange))),
          SizedBox(height: 16),
          ProgressRow('Treinos realizados', 0.8),
        ],
      ),
    );
  }
}

class _MuscleEvolution extends StatelessWidget {
  const _MuscleEvolution();

  @override
  Widget build(BuildContext context) {
    return const AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CardTitle('Evolução muscular', 'Últimos 30 dias'),
          SizedBox(height: 16),
          ProgressRow('Peito', 0.82),
          ProgressRow('Costas', 0.74),
          ProgressRow('Pernas', 0.68),
          ProgressRow('Ombros', 0.61),
        ],
      ),
    );
  }
}

class _NextExercises extends StatelessWidget {
  const _NextExercises();

  @override
  Widget build(BuildContext context) {
    final list = workouts.first.exercises.take(3).toList();
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CardTitle('Próximos exercícios', 'Treino de hoje'),
          const SizedBox(height: 12),
          for (final e in list)
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.bg,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  const Icon(Icons.fitness_center,
                      size: 16, color: AppColors.orange),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(e.name,
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w700)),
                        Text('${e.sets} séries x ${e.reps}',
                            style: const TextStyle(
                                fontSize: 10, color: AppColors.muted)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
