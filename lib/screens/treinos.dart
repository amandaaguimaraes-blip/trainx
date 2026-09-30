import 'package:flutter/material.dart';
import '../data.dart';
import '../theme.dart';
import '../widgets.dart';
import 'camera_checkin.dart';

class TreinosPage extends StatefulWidget {
  const TreinosPage({super.key});

  @override
  State<TreinosPage> createState() => _TreinosPageState();
}

class _TreinosPageState extends State<TreinosPage> {
  String _filtro = 'Todos';

  @override
  Widget build(BuildContext context) {
    final lista = _filtro == 'Todos'
        ? workouts
        : workouts.where((w) => w.category == _filtro).toList();

    return LayoutBuilder(builder: (context, c) {
      final pad = c.maxWidth >= 600 ? 32.0 : 16.0;
      return SingleChildScrollView(
        padding: EdgeInsets.all(pad),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PageHeader(
              overline: 'BIBLIOTECA',
              title: 'Meus treinos',
              trailing: c.maxWidth >= 500
                  ? PrimaryButton('+ NOVO TREINO', onPressed: _novo)
                  : IconButton.filled(
                      style: IconButton.styleFrom(
                          backgroundColor: AppColors.orange),
                      onPressed: _novo,
                      icon: const Icon(Icons.add)),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final f in filtros)
                  ChoiceChip(
                    label: Text(f, style: const TextStyle(fontSize: 12)),
                    selected: _filtro == f,
                    selectedColor: AppColors.orange,
                    backgroundColor: AppColors.card,
                    side: const BorderSide(color: AppColors.border),
                    showCheckmark: false,
                    onSelected: (_) => setState(() => _filtro = f),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            if (lista.isEmpty)
              const Padding(
                padding: EdgeInsets.all(40),
                child: Center(
                  child: Text('Nenhum treino nesta categoria',
                      style: TextStyle(color: AppColors.muted)),
                ),
              )
            else
              ResponsiveWrap(
                maxCols: 2,
                minItemWidth: 320,
                gap: 20,
                children: [for (final w in lista) _WorkoutCard(w)],
              ),
          ],
        ),
      );
    });
  }

  void _novo() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Criar treino: em breve')),
    );
  }
}

class _WorkoutCard extends StatelessWidget {
  final Workout w;
  const _WorkoutCard(this.w);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: w.gradient,
              ),
            ),
            child: Stack(
              children: [
                const Center(
                  child: Icon(Icons.fitness_center,
                      size: 56, color: Color(0x22FFFFFF)),
                ),
                Positioned(top: 12, right: 12, child: Tag(w.tag)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(w.name,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text(w.muscles,
                    style:
                        const TextStyle(fontSize: 11, color: AppColors.muted)),
                const SizedBox(height: 10),
                Text('${w.duration}  •  ${w.exercises.length} exercícios',
                    style:
                        const TextStyle(fontSize: 11, color: AppColors.muted)),
                const SizedBox(height: 14),
                PrimaryButton('INICIAR TREINO →',
                    expand: true,
                    onPressed: () => iniciarTreino(context, w)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
