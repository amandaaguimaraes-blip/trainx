import 'package:flutter/material.dart';
import 'screens/dashboard.dart';
import 'screens/evolucao.dart';
import 'screens/perfil.dart';
import 'screens/treinos.dart';
import 'theme.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  static const _items = [
    (Icons.home_outlined, 'Dashboard'),
    (Icons.bolt, 'Treinos'),
    (Icons.bar_chart, 'Evolução'),
    (Icons.person_outline, 'Perfil'),
  ];

  Widget get _page {
    switch (_index) {
      case 1:
        return const TreinosPage();
      case 2:
        return const EvolucaoPage();
      case 3:
        return const PerfilPage();
      default:
        return const DashboardPage();
    }
  }

  void _soon(String nome) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$nome: em breve')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.of(context).size.width >= 800;

    if (!wide) {
      return Scaffold(
        body: SafeArea(child: _page),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: (i) => setState(() => _index = i),
          destinations: [
            for (final it in _items)
              NavigationDestination(icon: Icon(it.$1), label: it.$2),
          ],
        ),
      );
    }

    return Scaffold(
      body: Row(
        children: [
          _Sidebar(
            index: _index,
            items: _items,
            onSelect: (i) => setState(() => _index = i),
            onSoon: _soon,
          ),
          Expanded(child: _page),
        ],
      ),
    );
  }
}

class _Sidebar extends StatelessWidget {
  final int index;
  final List<(IconData, String)> items;
  final ValueChanged<int> onSelect;
  final ValueChanged<String> onSoon;
  const _Sidebar({
    required this.index,
    required this.items,
    required this.onSelect,
    required this.onSoon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      decoration: const BoxDecoration(
        color: AppColors.sidebar,
        border: Border(right: BorderSide(color: AppColors.border)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _Logo(),
          const SizedBox(height: 28),
          const _Overline('MENU PRINCIPAL'),
          for (int i = 0; i < items.length; i++)
            _NavItem(
              icon: items[i].$1,
              label: items[i].$2,
              selected: i == index,
              onTap: () => onSelect(i),
            ),
          const SizedBox(height: 20),
          const _Overline('CONTA'),
          _NavItem(
              icon: Icons.settings_outlined,
              label: 'Configurações',
              selected: false,
              onTap: () => onSoon('Configurações')),
          _NavItem(
              icon: Icons.help_outline,
              label: 'Ajuda',
              selected: false,
              onTap: () => onSoon('Ajuda')),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: const Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.orange,
                  child: Text('LS',
                      style:
                          TextStyle(fontSize: 11, fontWeight: FontWeight.w800)),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Lucas Silva',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w700)),
                      Text('Membro Premium',
                          style: TextStyle(
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

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 30,
          height: 30,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.orange,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text('T',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
        ),
        const SizedBox(width: 10),
        const Text('TRAIN',
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
        const Text('X',
            style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 18,
                color: AppColors.orange)),
      ],
    );
  }
}

class _Overline extends StatelessWidget {
  final String text;
  const _Overline(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(text,
          style: const TextStyle(
              fontSize: 9, letterSpacing: 1.2, color: AppColors.muted)),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.orange : AppColors.muted;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
          decoration: BoxDecoration(
            color: selected ? AppColors.orange.withOpacity(0.15) : null,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 12),
              Text(label,
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: selected ? Colors.white : AppColors.muted)),
            ],
          ),
        ),
      ),
    );
  }
}