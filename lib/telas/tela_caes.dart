import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TelaCaes extends StatefulWidget {
  const TelaCaes({super.key});

  @override
  State<TelaCaes> createState() => _TelaCaesState();
}

class _TelaCaesState extends State<TelaCaes> {
  final racas = ['hound', 'pug', 'husky', 'beagle'];
  String raca = 'hound';
  String? imagem;
  String? erro;
  bool carregando = false;
  int sorteados = 0;

  Future<void> buscarCao() async {
    setState(() { carregando = true; erro = null; });
    try {
      final resposta = await http.get(
        Uri.parse('https://dog.ceo/api/breed/$raca/images/random'));
      if (resposta.statusCode != 200) throw Exception('Falha na consulta');
      final dados = jsonDecode(resposta.body);
      if (!mounted) return;
      setState(() {
        imagem = dados['message'];
        sorteados++;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() { erro = 'Não foi possível carregar a foto.'; });
    } finally {
      if (mounted) setState(() { carregando = false; });
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.amber.shade50,
    appBar: AppBar(title: const Text('Cães da Internet')),
    body: Center(child: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Text('Escolha a raça e sorteie um cachorro!'),
        const SizedBox(height: 8),
        Wrap(spacing: 8, children: racas.map((r) => ChoiceChip(
          label: Text(r),
          selected: raca == r,
          onSelected: (_) => setState(() { raca = r; }),
        )).toList()),
        const SizedBox(height: 16),
        if (carregando) const CircularProgressIndicator(),
        if (erro != null) Text(erro!),
        if (imagem != null) ...[
          const Text('Olha que fofura!', style: TextStyle(fontSize: 18)),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(imagem!, height: 260, fit: BoxFit.cover,
              errorBuilder: (_, _, _) => const Text('Imagem indisponível'))),
        ],
        const SizedBox(height: 16),
        Text('Fotos sorteadas: $sorteados'),
        const SizedBox(height: 8),
        ElevatedButton(onPressed: carregando ? null : buscarCao,
          child: const Text('Quero um cachorro!')),
      ]),
    )),
  );
}
