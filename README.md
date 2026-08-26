# E-Lixo

Aplicativo educativo em Flutter sobre resíduos eletrônicos. A experiência reúne
orientações de descarte, protocolos básicos de conserto e um museu virtual para
explicar a evolução e o impacto de diferentes equipamentos.

## Destaques

- Navegação principal entre E-Lixo e E-Museu
- Categorias de resíduos eletrônicos
- Protocolos de conserto organizados por componente
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

Projeto educacional em desenvolvimento, preparado para execução local em um
totem interativo de alta resolução. O conteúdo é mantido localmente para que a
experiência continue funcionando mesmo sem conexão com a internet.
