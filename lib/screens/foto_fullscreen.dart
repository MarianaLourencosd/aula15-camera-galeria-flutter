import 'dart:io';
import 'package:flutter/material.dart';

class FotoFullScreen extends StatelessWidget {
  final File imagem;

  const FotoFullScreen({super.key, required this.imagem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.black),
      body: Center(
        child: Hero(
          tag: 'fotoPerfil',
          child: InteractiveViewer(
            minScale: 0.5,
            maxScale: 4.0,
            child: Image.file(imagem),
          ),
        ),
      ),
    );
  }
}
