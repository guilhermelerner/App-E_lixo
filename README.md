# E-Lixo

Aplicativo educativo em Flutter sobre resíduos eletrônicos. A experiência reúne
orientações de descarte, protocolos básicos de conserto e um museu virtual para
explicar a evolução e o impacto de diferentes equipamentos.

## Destaques

- Navegação principal entre E-Lixo e E-Museu
- Vídeo educativo incorporado na página do E-Lixo
- Protocolos de conserto com retorno direto ao vídeo
- Museu virtual com carrossel de peças e ficha técnica
- Interface responsiva para totem vertical 2160 × 3840
- Solicitação de tela cheia ao entrar em um módulo
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

### Executar no totem em modo quiosque

Em um PowerShell, inicie o servidor local:

```powershell
flutter run -d web-server --web-port 8080
```

Em outro PowerShell, abra o Edge em modo imersivo:

```powershell
Start-Process msedge.exe -ArgumentList "--kiosk http://localhost:8080 --edge-kiosk-type=fullscreen"
```

## Motivação

O descarte incorreto de eletrônicos traz riscos ambientais e à saúde. O E-Lixo
foi criado para tornar informações sobre identificação, cuidados e destinação
desses materiais mais acessíveis.

## Status

Projeto educacional em desenvolvimento, preparado para execução em um totem
interativo de alta resolução. As imagens e fichas do acervo ficam no projeto;
o vídeo incorporado ainda depende de conexão com a internet.
