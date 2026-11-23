import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/media_service.dart';
import 'foto_fullscreen.dart';

class PerfilScreen extends StatefulWidget {
const PerfilScreen({super.key});

@override
State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
final _mediaService = MediaService();
File? _imagemPerfil;
final _nomeController = TextEditingController(text: 'Diego Menegassi');
static const _keyFoto = 'caminho_foto_perfil';

@override
void initState() {
super.initState();
_carregarCaminhoFoto();
}

Future<void> _salvarCaminhoFoto(String caminho) async {
final prefs = await SharedPreferences.getInstance();
await prefs.setString(_keyFoto, caminho);
}

Future<void> _carregarCaminhoFoto() async {
final prefs = await SharedPreferences.getInstance();
final caminho = prefs.getString(_keyFoto);
if (caminho != null && File(caminho).existsSync()) {
  setState(() {
    _imagemPerfil = File(caminho);
  });
}
}

Future<void> _removerCaminhoFoto() async {
final prefs = await SharedPreferences.getInstance();
await prefs.remove(_keyFoto);
}

Future<void> _capturarImagem(bool daCamera) async {
Navigator.pop(context);
final File? imagem = daCamera
    ? await _mediaService.tirarFoto()
    : await _mediaService.selecionarDaGaleria();
if (imagem != null) {
  setState(() {
    _imagemPerfil = imagem;
  });
  await _salvarCaminhoFoto(imagem.path);
}
}

void _removerFoto() async {
Navigator.pop(context);
setState(() {
  _imagemPerfil = null;
});
await _removerCaminhoFoto();
}

void _exibirOpcoesMidia() {
showModalBottomSheet(
  context: context,
  builder: (context) => Container(
    padding: const EdgeInsets.all(16),
    height: 220,
    child: Column(
      children: [
        ListTile(
          leading: const Icon(Icons.camera_alt, color: Colors.pink),
          title: const Text('Tirar Foto com a Camera'),
          onTap: () => _capturarImagem(true),
        ),
        ListTile(
          leading: const Icon(Icons.photo_library, color: Colors.pink),
          title: const Text('Escolher da Galeria'),
          onTap: () => _capturarImagem(false),
        ),
        ListTile(
          leading: const Icon(Icons.delete, color: Colors.pink),
          title: const Text('Remover Foto'),
          onTap: _removerFoto,
        ),
      ],
    ),
  ),
);
}

@override
Widget build(BuildContext context) {
return Scaffold(
  appBar: AppBar(title: const Text('Perfil do Usuario'), centerTitle: true),
  body: SingleChildScrollView(
    padding: const EdgeInsets.all(24.0),
    child: Column(
      children: [
        Center(
          child: Stack(
            children: [
              GestureDetector(
                onTap: () {
                  if (_imagemPerfil != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FotoFullScreen(imagem: _imagemPerfil!),
                      ),
                    );
                  }
                },
                child: Hero(
                  tag: 'fotoPerfil',
                  child: CircleAvatar(
                    radius: 70,
                    backgroundColor: Colors.pink.shade100,
                    backgroundImage: _imagemPerfil != null
                        ? FileImage(_imagemPerfil!)
                        : null,
                    child: _imagemPerfil == null
                        ? const Icon(Icons.person, size: 70, color: Colors.pink)
                        : null,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: FloatingActionButton.small(
                  onPressed: _exibirOpcoesMidia,
                  child: const Icon(Icons.camera_alt),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        TextField(
          controller: _nomeController,
          decoration: const InputDecoration(
            labelText: 'Nome Completo',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.badge),
          ),
        ),
      ],
    ),
  ),
);
}
}
