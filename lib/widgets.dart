import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'theme.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: child,
    );
  }
}

class Tag extends StatelessWidget {
  final String text;
  const Tag(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.orange,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: const TextStyle(
            fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 0.5),
      ),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool expand;
  const PrimaryButton(this.text,
      {super.key, required this.onPressed, this.expand = false});

  @override
  Widget build(BuildContext context) {
    final btn = ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.orange,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        textStyle: const TextStyle(
            fontWeight: FontWeight.w800, fontSize: 12, letterSpacing: 0.8),
      ),
      child: Text(text),
    );
    return expand ? SizedBox(width: double.infinity, child: btn) : btn;
  }
}

class PageHeader extends StatelessWidget {
  final String overline, title;
  final Widget? trailing;
  const PageHeader(
      {super.key, required this.overline, required this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(overline,
                  style: const TextStyle(
                      fontSize: 10,
                      letterSpacing: 1.2,
                      color: AppColors.muted,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(title,
                  style: const TextStyle(
                      fontSize: 26, fontWeight: FontWeight.w800)),
            ],
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}

class CardTitle extends StatelessWidget {
  final String title, subtitle;
  final Widget? trailing;
  const CardTitle(this.title, this.subtitle, {super.key, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w700)),
              const SizedBox(height: 2),
              Text(subtitle,
                  style:
                      const TextStyle(fontSize: 11, color: AppColors.muted)),
            ],
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}

class ProgressRow extends StatelessWidget {
  final String label;
  final double value; // 0..1
  const ProgressRow(this.label, this.value, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        children: [
          Row(
            children: [
              Text(label,
                  style: const TextStyle(fontSize: 12, color: AppColors.muted)),
              const Spacer(),
              Text('${(value * 100).round()}%',
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.orange)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: value,
              minHeight: 6,
              backgroundColor: AppColors.border,
              color: AppColors.orange,
            ),
          ),
        ],
      ),
    );
  }
}

class StatTile extends StatelessWidget {
  final IconData icon;
  final String label, value, unit, delta;
  const StatTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.unit = '',
    this.delta = '',
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.orange.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: AppColors.orange),
          ),
          const SizedBox(height: 14),
          Text(label,
              style: const TextStyle(
                  fontSize: 10, letterSpacing: 1, color: AppColors.muted)),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(value,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.w800)),
              const SizedBox(width: 4),
              Flexible(
                child: Text(unit,
                    overflow: TextOverflow.ellipsis,
                    style:
                        const TextStyle(fontSize: 11, color: AppColors.muted)),
              ),
            ],
          ),
          if (delta.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(delta,
                style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.green)),
          ],
        ],
      ),
    );
  }
}

class BarChart extends StatelessWidget {
  final List<double> values;
  final List<String> labels;
  final int highlight;
  final double height;
  const BarChart({
    super.key,
    required this.values,
    required this.labels,
    required this.highlight,
    this.height = 190,
  });

  @override
  Widget build(BuildContext context) {
    final maxV = values.reduce(math.max);
    return SizedBox(
      height: height,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (int i = 0; i < values.length; i++)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Column(
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: FractionallySizedBox(
                          heightFactor: values[i] / maxV,
                          widthFactor: 1,
                          child: Container(
                            decoration: BoxDecoration(
                              color: i == highlight
                                  ? AppColors.orange
                                  : const Color(0xFF3A3A3A),
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(labels[i],
                        style: const TextStyle(
                            fontSize: 9, color: AppColors.muted)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Distribui os filhos em colunas de acordo com a largura disponível.
class ResponsiveWrap extends StatelessWidget {
  final List<Widget> children;
  final int maxCols;
  final double minItemWidth;
  final double gap;
  const ResponsiveWrap({
    super.key,
    required this.children,
    this.maxCols = 4,
    this.minItemWidth = 150,
    this.gap = 16,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      final fit = ((c.maxWidth + gap) / (minItemWidth + gap)).floor();
      final cols = math.max(1, math.min(maxCols, fit));
      final w = (c.maxWidth - gap * (cols - 1)) / cols;
      return Wrap(
        spacing: gap,
        runSpacing: gap,
        children: [for (final ch in children) SizedBox(width: w, child: ch)],
      );
    });
  }
}
