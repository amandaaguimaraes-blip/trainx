import 'package:flutter/material.dart';
import '../state.dart';
import '../theme.dart';
import '../widgets.dart';
import 'camera_checkin.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  Future<void> _cadastrarFoto() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CameraCheckInPage()),
    );
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final foto = AppState.fotoReferencia;
    return LayoutBuilder(builder: (context, c) {
      final pad = c.maxWidth >= 600 ? 32.0 : 16.0;
      return SingleChildScrollView(
        padding: EdgeInsets.all(pad),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PageHeader(overline: 'CONTA', title: 'Perfil'),
            const SizedBox(height: 24),
            AppCard(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColors.orange,
                    backgroundImage: foto != null ? MemoryImage(foto) : null,
                    child: foto == null
                        ? const Text('LS',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w800))
                        : null,
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Lucas Silva',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w800)),
                        SizedBox(height: 2),
                        Text('Membro Premium',
                            style: TextStyle(
                                fontSize: 12, color: AppColors.muted)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CardTitle(
                    'Confirmação de identidade',
                    foto == null
                        ? 'Cadastre uma foto para confirmar que é você ao iniciar o treino'
                        : 'Foto cadastrada. Ela será usada no check-in do treino',
                  ),
                  const SizedBox(height: 16),
                  PrimaryButton(
                    foto == null ? 'CADASTRAR FOTO' : 'ATUALIZAR FOTO',
                    onPressed: _cadastrarFoto,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const ResponsiveWrap(
              minItemWidth: 200,
              children: [
                StatTile(
                    icon: Icons.flag, label: 'OBJETIVO', value: 'Hipertrofia'),
                StatTile(
                    icon: Icons.calendar_month,
                    label: 'FREQUÊNCIA',
                    value: '5x',
                    unit: 'por semana'),
                StatTile(
                    icon: Icons.monitor_weight_outlined,
                    label: 'PESO ATUAL',
                    value: '78,4',
                    unit: 'kg'),
              ],
            ),
          ],
        ),
      );
    });
  }
}
