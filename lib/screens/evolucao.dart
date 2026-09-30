import 'package:flutter/material.dart';
import '../data.dart';
import '../theme.dart';
import '../widgets.dart';

class EvolucaoPage extends StatefulWidget {
  const EvolucaoPage({super.key});

  @override
  State<EvolucaoPage> createState() => _EvolucaoPageState();
}

class _EvolucaoPageState extends State<EvolucaoPage> {
  String _periodo = 'Últimos 30 dias';

  @override
  Widget build(BuildContext context) {
    final semanal = _periodo == 'Últimos 7 dias';
    return LayoutBuilder(builder: (context, c) {
      final wide = c.maxWidth >= 860;
      final pad = c.maxWidth >= 600 ? 32.0 : 16.0;

      final chart = AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CardTitle('Volume de treino', 'Quilos levantados',
                trailing: Text(semanal ? '+8,4%' : '+12,8%',
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.orange))),
            const SizedBox(height: 20),
            BarChart(
              values: semanal ? volumeSemanal : volumeMensal,
              labels: semanal
                  ? diasSemana
                  : const ['S1', 'S2', 'S3', 'S4', 'S5', 'S6', 'S7'],
              highlight: semanal ? 4 : 5,
              height: 220,
            ),
          ],
        ),
      );

      const prs = AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CardTitle('PRs recentes', 'Recordes pessoais'),
            SizedBox(height: 12),
            _PrRow('Supino Reto', '+2 kg'),
            _PrRow('Agachamento', '+10 kg'),
            _PrRow('Remada', '+2 kg'),
          ],
        ),
      );

      return SingleChildScrollView(
        padding: EdgeInsets.all(pad),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PageHeader(
              overline: 'PERFORMANCE',
              title: 'Sua evolução',
              trailing: DropdownButton<String>(
                value: _periodo,
                underline: const SizedBox(),
                dropdownColor: AppColors.card,
                style: const TextStyle(fontSize: 12, color: AppColors.text),
                items: const [
                  DropdownMenuItem(
                      value: 'Últimos 7 dias', child: Text('Últimos 7 dias')),
                  DropdownMenuItem(
                      value: 'Últimos 30 dias', child: Text('Últimos 30 dias')),
                ],
                onChanged: (v) => setState(() => _periodo = v ?? _periodo),
              ),
            ),
            const SizedBox(height: 24),
            if (wide)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: chart),
                  const SizedBox(width: 20),
                  const SizedBox(width: 340, child: prs),
                ],
              )
            else ...[
              chart,
              const SizedBox(height: 20),
              prs,
            ],
            const SizedBox(height: 20),
            const ResponsiveWrap(
              minItemWidth: 140,
              children: [
                StatTile(
                    icon: Icons.monitor_weight_outlined,
                    label: 'PESO',
                    value: '78,4',
                    unit: 'kg'),
                StatTile(
                    icon: Icons.event_available,
                    label: 'SESSÕES',
                    value: '126',
                    unit: 'treinos'),
                StatTile(
                    icon: Icons.bolt,
                    label: 'VOLUME',
                    value: '42,5',
                    unit: 'ton'),
                StatTile(
                    icon: Icons.local_fire_department,
                    label: 'CONSISTÊNCIA',
                    value: '86%',
                    unit: 'no mês'),
              ],
            ),
          ],
        ),
      );
    });
  }
}

class _PrRow extends StatelessWidget {
  final String nome, ganho;
  const _PrRow(this.nome, this.ganho);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          const Icon(Icons.emoji_events, size: 18, color: AppColors.orange),
          const SizedBox(width: 12),
          Expanded(
            child: Text(nome,
                style:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
          ),
          Text(ganho,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: AppColors.green)),
        ],
      ),
    );
  }
}
