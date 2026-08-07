# E-Lixo

Aplicativo educativo em Flutter sobre resíduos eletrônicos. A experiência reúne
orientações de descarte, conteúdos de conscientização e um museu virtual para
explicar a evolução e o impacto de diferentes equipamentos.

## Destaques

- Navegação principal por módulos
- Categorias de resíduos eletrônicos
- Conteúdo educativo sobre segurança, coleta e impacto ambiental
- Museu virtual com cards, detalhes e seções expansíveis
- Interface responsiva baseada em Material Design
- Suporte às plataformas mantidas pelo Flutter

## Tecnologias

- Flutter
- Dart
- Material Design

## Organização do projeto

```text
lib/
├── main.dart
└── modules/
    ├── educa/       # Conteúdos educativos
    ├── e_lixo/      # Categorias e informações sobre resíduos
    └── e_museu/     # Museu virtual e detalhes dos itens
assets/images/       # Imagens utilizadas pela aplicação
```

## Como executar

### Pré-requisitos

- Flutter SDK compatível com Dart 3.9 ou superior
- Emulador ou dispositivo configurado

```bash
git clone https://github.com/guilhermelerner/App-E_lixo.git
cd App-E_lixo
flutter pub get
flutter run
```

Para verificar a qualidade do código:

```bash
flutter analyze
flutter test
```

## Motivação

O descarte incorreto de eletrônicos traz riscos ambientais e à saúde. O E-Lixo
foi criado para tornar informações sobre identificação, cuidados e destinação
desses materiais mais acessíveis.

## Status

Projeto educacional em desenvolvimento. Os módulos principais já estão
estruturados e podem ser ampliados com mapas de pontos de coleta e fontes de
dados externas.
