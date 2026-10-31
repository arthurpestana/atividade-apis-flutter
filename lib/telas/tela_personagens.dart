import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../modelos/personagem.dart';
import 'tela_detalhe_personagem.dart';

class TelaPersonagens extends StatefulWidget {
  const TelaPersonagens({super.key});

  @override
  State<TelaPersonagens> createState() => _TelaPersonagensState();
}

class _TelaPersonagensState extends State<TelaPersonagens> {
  final filtros = {'': 'Todos', 'alive': 'Vivos', 'dead': 'Mortos'};
  String status = '';
  int pagina = 1;
  int totalPaginas = 1;
  int? favorito;
  late Future<List<Personagem>> _futuro;

  @override
  void initState() {
    super.initState();
    _futuro = buscarPersonagens(); // pede os dados UMA vez, ao abrir a tela
    carregarFavorito();
  }

  Future<List<Personagem>> buscarPersonagens() async {
    final filtro = status.isEmpty ? '' : '&status=$status';
    final resposta = await http.get(Uri.parse(
      'https://rickandmortyapi.com/api/character?page=$pagina$filtro'));
    if (resposta.statusCode != 200) {
      throw Exception('Falha na consulta: ${resposta.statusCode}');
    }
    final dados = jsonDecode(resposta.body) as Map<String, dynamic>;
    // Dispensa setState: o FutureBuilder redesenha logo depois, quando o Future completa.
    totalPaginas = dados['info']['pages'];
    final lista = dados['results'] as List<dynamic>;
    return lista
        .map((item) => Personagem.fromMap(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> carregarFavorito() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() { favorito = prefs.getInt('favorito'); });
  }

  void _recarregar() {
    setState(() { _futuro = buscarPersonagens(); });
  }

  void mudarFiltro(String novo) {
    setState(() {
      status = novo;
      pagina = 1;
      _futuro = buscarPersonagens();
    });
  }

  void mudarPagina(int nova) {
    setState(() {
      pagina = nova;
      _futuro = buscarPersonagens();
    });
  }

  Future<void> abrirDetalhe(Personagem p) async {
    await Navigator.push(context,
      MaterialPageRoute(builder: (_) => TelaDetalhePersonagem(personagem: p)));
    carregarFavorito();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Personagens')),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Wrap(spacing: 8, children: filtros.entries.map((f) =>
            ChoiceChip(
              label: Text(f.value),
              selected: status == f.key,
              onSelected: (selecionado) {
                if (selecionado) mudarFiltro(f.key);
              },
            )).toList()),
        ),
        Expanded(child: FutureBuilder<List<Personagem>>(
          future: _futuro,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const Text('Não foi possível carregar os personagens.'),
                  const SizedBox(height: 12),
                  ElevatedButton(onPressed: _recarregar,
                    child: const Text('Tentar de novo')),
                ]),
              );
            }
            final personagens = snapshot.data!;
            return Column(children: [
              Expanded(child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: personagens.length,
                itemBuilder: (context, i) {
                  final p = personagens[i];
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(p.imagem)),
                      title: Text(p.nome),
                      subtitle: Text('${p.especie} · ${p.status}'),
                      trailing: p.id == favorito
                        ? const Icon(Icons.star, color: Colors.amber)
                        : const Icon(Icons.chevron_right),
                      onTap: () => abrirDetalhe(p),
                    ),
                  );
                },
              )),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: pagina > 1
                        ? () => mudarPagina(pagina - 1) : null,
                      child: const Text('Anterior')),
                    Text('Página $pagina de $totalPaginas'),
                    ElevatedButton(
                      onPressed: pagina < totalPaginas
                        ? () => mudarPagina(pagina + 1) : null,
                      child: const Text('Próxima')),
                  ],
                ),
              ),
            ]);
          },
        )),
      ]),
    );
  }
}
