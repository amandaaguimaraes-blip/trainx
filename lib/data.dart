import 'package:flutter/material.dart';

class Exercise {
  final String name;
  final int sets;
  final String reps;
  const Exercise(this.name, this.sets, this.reps);
}

class Workout {
  final String name, muscles, tag, duration, category;
  final int kcal;
  final List<Exercise> exercises;
  final List<Color> gradient;
  const Workout({
    required this.name,
    required this.muscles,
    required this.tag,
    required this.duration,
    required this.category,
    required this.kcal,
    required this.exercises,
    required this.gradient,
  });
}

const workouts = <Workout>[
  Workout(
    name: 'Superior & Força',
    muscles: 'Peito, Ombros, Tríceps',
    tag: 'HIPERTROFIA',
    duration: '52 min',
    category: 'Hipertrofia',
    kcal: 420,
    gradient: [Color(0xFF3A2A22), Color(0xFF151515)],
    exercises: [
      Exercise('Supino Reto', 4, '8-10'),
      Exercise('Crucifixo Inclinado', 3, '12'),
      Exercise('Desenvolvimento', 4, '10'),
      Exercise('Elevação Lateral', 3, '15'),
      Exercise('Tríceps Corda', 3, '12'),
    ],
  ),
  Workout(
    name: 'Leg Day',
    muscles: 'Quadríceps, Posterior, Glúteos',
    tag: 'FORÇA',
    duration: '47 min',
    category: 'Pernas',
    kcal: 380,
    gradient: [Color(0xFF262626), Color(0xFF141414)],
    exercises: [
      Exercise('Agachamento Livre', 4, '8'),
      Exercise('Leg Press', 4, '12'),
      Exercise('Cadeira Extensora', 3, '15'),
      Exercise('Mesa Flexora', 3, '12'),
      Exercise('Panturrilha em Pé', 4, '15'),
    ],
  ),
  Workout(
    name: 'Costas & Bíceps',
    muscles: 'Costas, Braços, Trapézio',
    tag: 'HIPERTROFIA',
    duration: '48 min',
    category: 'Costas',
    kcal: 400,
    gradient: [Color(0xFF2B2B2B), Color(0xFF161616)],
    exercises: [
      Exercise('Puxada Frontal', 4, '10'),
      Exercise('Remada Curvada', 4, '8-10'),
      Exercise('Remada Baixa', 3, '12'),
      Exercise('Rosca Direta', 3, '10'),
      Exercise('Rosca Martelo', 3, '12'),
    ],
  ),
  Workout(
    name: 'Ombros & Core',
    muscles: 'Ombros, Abdômen, Core',
    tag: 'DEFINIÇÃO',
    duration: '45 min',
    category: 'Força',
    kcal: 300,
    gradient: [Color(0xFF33261F), Color(0xFF141414)],
    exercises: [
      Exercise('Desenvolvimento Militar', 4, '8'),
      Exercise('Elevação Frontal', 3, '12'),
      Exercise('Face Pull', 3, '15'),
      Exercise('Prancha', 3, '45s'),
      Exercise('Abdominal Infra', 3, '15'),
    ],
  ),
];

const filtros = ['Todos', 'Hipertrofia', 'Força', 'Pernas', 'Peito', 'Costas'];

const diasSemana = ['SEG', 'TER', 'QUA', 'QUI', 'SEX', 'SÁB', 'DOM'];
const volumeSemanal = <double>[42, 68, 48, 78, 92, 50, 30];
const volumeMensal = <double>[40, 62, 48, 74, 66, 92, 68];

String dataHoje() {
  const dias = [
    'SEGUNDA-FEIRA', 'TERÇA-FEIRA', 'QUARTA-FEIRA', 'QUINTA-FEIRA',
    'SEXTA-FEIRA', 'SÁBADO', 'DOMINGO'
  ];
  const meses = [
    'JANEIRO', 'FEVEREIRO', 'MARÇO', 'ABRIL', 'MAIO', 'JUNHO', 'JULHO',
    'AGOSTO', 'SETEMBRO', 'OUTUBRO', 'NOVEMBRO', 'DEZEMBRO'
  ];
  final n = DateTime.now();
  return '${dias[n.weekday - 1]}, ${n.day} DE ${meses[n.month - 1]}';
}
