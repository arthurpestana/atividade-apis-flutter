# APIs Divertidas em Flutter

Atividade prática da disciplina **Dispositivos Móveis I** (Unitins, 6º período), orientada pela Profª. Madianita Bogo Marioti.

App Flutter que consome três APIs públicas e gratuitas. A tela inicial tem um botão para cada uma das três telas:

| Tela | API | O que faz |
|---|---|---|
| Galeria de cães | [Dog CEO](https://dog.ceo/dog-api/) | Sorteia uma foto de cachorro da raça escolhida |
| Pokédex | [PokéAPI](https://pokeapi.co/) | Busca um Pokémon por nome ou número e mostra imagem, ID, tipos, altura e peso |
| Personagens | [Rick and Morty API](https://rickandmortyapi.com/) | Lista paginada com filtro por status, tela de detalhe e personagem favorito |

## Como executar

Requer Flutter 3.29 ou superior (Dart 3.7+).

```bash
flutter pub get
flutter run
```

Para rodar os testes:

```bash
flutter test
```

## Exercícios resolvidos

| # | Tela | Exercício |
|---|---|---|
| 1 | Galeria de cães | Título, cor de fundo e texto do botão personalizados; frase acima da imagem |
| 2 | Galeria de cães | Contador de fotos sorteadas |
| 3 | Galeria de cães | Escolha da raça com `ChoiceChip` dentro de um `Wrap` |
| 4 | Pokédex | ID do Pokémon e resultado dentro de um `Card` |
| 5 | Pokédex | Botão para buscar um Pokémon aleatório entre 1 e 151 |
| 6 | Pokédex | Tipos do Pokémon exibidos como `Chip` |
| 7 | Personagens | Gênero e localização atual na tela de detalhe |
| 8 | Personagens | Filtro por status: todos, vivos ou mortos |
| 9 | Personagens | Navegação entre páginas (anterior e próxima) |
| 10 | Personagens | Favorito salvo com `SharedPreferences`, marcado com estrela na lista |

## Estrutura

```
lib/
├── main.dart                         tela inicial com os três botões
├── modelos/
│   └── personagem.dart               classe modelo com fromMap
└── telas/
    ├── tela_caes.dart
    ├── tela_pokemon.dart
    ├── tela_personagens.dart
    └── tela_detalhe_personagem.dart
```

## Conceitos praticados

- Requisições GET com o pacote `http` e leitura do JSON com `jsonDecode`
- JSON simples, aninhado e em lista, convertido em classe modelo com `fromMap`
- Estado com `setState`, indicador de carregamento e tratamento de erro com `try/catch/finally`
- `FutureBuilder` com o `Future` criado no `initState`
- Imagens da internet com `Image.network`, `NetworkImage`, `ClipRRect` e `errorBuilder`
- Navegação com `Navigator.push`, passando um objeto pelo construtor
- Persistência local com `shared_preferences`
