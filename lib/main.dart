import 'package:flutter/material.dart';
import 'app_shell.dart';
import 'theme.dart';

void main() => runApp(const TrainXApp());

class TrainXApp extends StatelessWidget {
  const TrainXApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TrainX',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      home: const AppShell(),
    );
  }
}
