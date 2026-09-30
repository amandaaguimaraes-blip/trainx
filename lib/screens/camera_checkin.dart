import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import '../data.dart';
import '../state.dart';
import '../theme.dart';
import '../widgets.dart';
import 'session.dart';

/// Abre a câmera para confirmar a identidade e, se confirmado, inicia o treino.
Future<void> iniciarTreino(BuildContext context, Workout w) {
  return Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => CameraCheckInPage(workout: w)),
  );
}

/// [workout] == null significa modo "cadastrar foto de referência" (Perfil).
class CameraCheckInPage extends StatefulWidget {
  final Workout? workout;
  const CameraCheckInPage({super.key, this.workout});

  @override
  State<CameraCheckInPage> createState() => _CameraCheckInPageState();
}

class _CameraCheckInPageState extends State<CameraCheckInPage> {
  CameraController? _ctrl;
  String? _erro;
  Uint8List? _foto;
  bool _busy = false;

  bool get _cadastro => widget.workout == null;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      final cams = await availableCameras();
      if (cams.isEmpty) {
        setState(() => _erro = 'Nenhuma câmera encontrada neste dispositivo.');
        return;
      }
      final cam = cams.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
        orElse: () => cams.first,
      );
      final ctrl =
          CameraController(cam, ResolutionPreset.medium, enableAudio: false);
      await ctrl.initialize();
      if (!mounted) {
        ctrl.dispose();
        return;
      }
      setState(() => _ctrl = ctrl);
    } catch (_) {
      if (mounted) {
        setState(() => _erro =
            'Não foi possível acessar a câmera. Verifique se a permissão foi concedida.');
      }
    }
  }

  @override
  void dispose() {
    _ctrl?.dispose();
    super.dispose();
  }

  Future<void> _tirarFoto() async {
    if (_ctrl == null || _busy) return;
    setState(() => _busy = true);
    try {
      final file = await _ctrl!.takePicture();
      final bytes = await file.readAsBytes();
      if (mounted) setState(() => _foto = bytes);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao tirar a foto. Tente de novo.')),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _salvarReferencia() {
    AppState.fotoReferencia = _foto;
    Navigator.pop(context, true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Foto de referência salva!')),
    );
  }

  void _confirmarEIniciar() {
    if (AppState.fotoReferencia == null) AppState.fotoReferencia = _foto;
    _iniciar();
  }

  void _iniciar() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (_) => WorkoutSessionPage(workout: widget.workout!)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.sidebar,
        title: Text(_cadastro ? 'Foto de referência' : 'Confirme que é você',
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: _body(),
          ),
        ),
      ),
    );
  }

  Widget _body() {
    if (_erro != null) return _erroView();
    if (_foto != null) return _resultado();
    if (_ctrl == null) {
      return const Center(
          child: CircularProgressIndicator(color: AppColors.orange));
    }
    return _preview();
  }

  Widget _preview() {
    final ar = _ctrl!.value.aspectRatio;
    final portrait = MediaQuery.of(context).orientation == Orientation.portrait;
    final ratio = (!kIsWeb && portrait && ar > 1) ? 1 / ar : ar;
    return Column(
      children: [
        Expanded(
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: AspectRatio(
                aspectRatio: ratio,
                child: CameraPreview(_ctrl!),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Text('Posicione seu rosto no centro e tire a foto.',
            style: TextStyle(fontSize: 12, color: AppColors.muted)),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: _tirarFoto,
          child: Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.orange, width: 4),
            ),
            padding: const EdgeInsets.all(6),
            child: Container(
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: AppColors.orange),
              child: _busy
                  ? const Padding(
                      padding: EdgeInsets.all(18),
                      child: CircularProgressIndicator(
                          strokeWidth: 3, color: Colors.white),
                    )
                  : const Icon(Icons.camera_alt, size: 26),
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _img(Uint8List b, String label) {
    return Expanded(
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AspectRatio(
              aspectRatio: 3 / 4,
              child: Image.memory(b, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 6),
          Text(label,
              style: const TextStyle(fontSize: 11, color: AppColors.muted)),
        ],
      ),
    );
  }

  Widget _resultado() {
    final ref = AppState.fotoReferencia;
    final comparar = !_cadastro && ref != null;

    String texto;
    if (_cadastro) {
      texto = 'Essa será a foto usada para confirmar sua identidade.';
    } else if (ref == null) {
      texto = 'Ainda não há foto cadastrada. Vamos usar esta como referência.';
    } else {
      texto = 'Compare as fotos e confirme que é você.';
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          if (comparar)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _img(ref, 'Foto cadastrada'),
                const SizedBox(width: 12),
                _img(_foto!, 'Foto agora'),
              ],
            )
          else
            Row(children: [
              const Spacer(),
              SizedBox(
                  width: 240,
                  child: Row(children: [_img(_foto!, 'Sua foto')])),
              const Spacer(),
            ]),
          const SizedBox(height: 16),
          Text(texto,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: AppColors.muted)),
          const SizedBox(height: 16),
          if (_cadastro)
            PrimaryButton('SALVAR COMO MINHA FOTO',
                expand: true, onPressed: _salvarReferencia)
          else
            PrimaryButton('SOU EU, INICIAR TREINO →',
                expand: true, onPressed: _confirmarEIniciar),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => setState(() => _foto = null),
            child: const Text('Tirar outra foto',
                style: TextStyle(color: AppColors.muted)),
          ),
        ],
      ),
    );
  }

  Widget _erroView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.videocam_off, size: 48, color: AppColors.muted),
        const SizedBox(height: 16),
        Text(_erro!,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.muted)),
        const SizedBox(height: 20),
        if (!_cadastro)
          PrimaryButton('CONTINUAR SEM CÂMERA (DEMO)', onPressed: _iniciar),
      ],
    );
  }
}
