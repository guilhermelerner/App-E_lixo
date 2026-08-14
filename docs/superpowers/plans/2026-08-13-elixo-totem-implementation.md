# E-Lixo Totem Android 4K Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Transformar o aplicativo Flutter atual em um totem Android vertical, offline e seguro, com os módulos E-Museu e E-Lixo, sincronização manual do acervo e conteúdo adequado a visitantes.

**Architecture:** A implementação será feita em quatro fases independentes: base responsiva e tela inicial, conteúdo E-Lixo orientado a dados, acervo E-Museu com sincronizador transacional e integração Android para quiosque. As telas consumirão repositórios locais baseados em JSON; rede será usada somente pela ferramenta de atualização executada por um responsável fora do totem.

**Tech Stack:** Flutter, Dart 3.9+, Material 3, `video_player`, `http`, `html`, `image`, `crypto`, `args`, testes `flutter_test` e Android/Kotlin para recursos de quiosque.

## Global Constraints

- Plataforma-alvo: Android em orientação retrato.
- Resolução principal: 2160 × 3840; resolução secundária de teste: 1080 × 1920.
- O layout deve usar restrições responsivas, nunca coordenadas fixas baseadas em 4K.
- O aplicativo deve operar sem internet durante a visita.
- A tela inicial contém somente E-Museu e E-Lixo; Educa não é um módulo independente.
- Vídeo de fundo local, de 15–30 segundos, sem áudio automático; usar fundo estático enquanto não houver mídia licenciada.
- Vídeos educativos somente começam por ação explícita e não podem depender de transmissão do YouTube.
- Inatividade padrão: 120 segundos, configurável.
- Nenhuma instrução pública pode orientar ligação direta de fonte, medição energizada, improviso em processador ou exclusão destrutiva de dados.
- O sincronizador não executa commit, push ou publicação.
- Cada tarefa termina com testes verdes e um commit isolado.

---

## Mapa de arquivos

### Arquivos existentes a substituir ou ajustar

- `lib/main.dart`: ponto de entrada mínimo, orientação e inicialização.
- `lib/modules/e_lixo/e_lixo_page.dart`: removido depois da migração para `lib/features/elixo/`.
- `lib/modules/e_museu/e_museu_page.dart`: removido depois da migração para `lib/features/emuseu/`.
- `lib/modules/educa/educa_page.dart`: removido depois que o conteúdo útil migrar para E-Lixo.
- `pubspec.yaml`: dependências e diretórios de assets.
- `test/widget_test.dart`: substituição do teste de contador inválido.
- `android/app/src/main/AndroidManifest.xml`: orientação, nome e configuração de quiosque.
- `android/app/src/main/kotlin/com/example/e_lixo_app/MainActivity.kt`: modo imersivo e ponte opcional para lock task.
- `README.md`: comandos, arquitetura e operação do totem.

### Novas unidades

- `lib/app/e_lixo_app.dart`: `MaterialApp`, tema e rotas.
- `lib/app/app_routes.dart`: nomes de rotas e criação das páginas.
- `lib/app/app_theme.dart`: cores, tipografia, cartões e botões.
- `lib/app/totem_config.dart`: `inactivityTimeout` e caminho opcional do vídeo.
- `lib/shared/widgets/totem_scaffold.dart`: cabeçalho consistente com Voltar e Início.
- `lib/shared/widgets/responsive_content.dart`: largura máxima, margens e colunas.
- `lib/shared/widgets/asset_image_with_fallback.dart`: imagem local resiliente.
- `lib/shared/session/inactivity_gate.dart`: retorno ao início após inatividade.
- `lib/features/home/home_page.dart`: dois módulos e fundo ambiente.
- `lib/features/home/home_background.dart`: vídeo local e fallback estático.
- `lib/features/elixo/domain/elixo_topic.dart`: modelo do conteúdo seguro.
- `lib/features/elixo/data/elixo_repository.dart`: leitura e validação do JSON.
- `lib/features/elixo/presentation/elixo_page.dart`: cinco categorias.
- `lib/features/elixo/presentation/elixo_topic_page.dart`: cartões por tema.
- `lib/features/elixo/presentation/elixo_detail_page.dart`: detalhe padronizado.
- `lib/features/elixo/presentation/local_video_page.dart`: reprodução iniciada pelo visitante.
- `lib/features/emuseu/domain/museum_item.dart`: modelo do item do acervo.
- `lib/features/emuseu/data/museum_repository.dart`: leitura do acervo empacotado.
- `lib/features/emuseu/presentation/emuseu_page.dart`: categorias e grade responsiva.
- `lib/features/emuseu/presentation/museum_detail_page.dart`: detalhes do item.
- `lib/sync/emuseu_page_config.dart`: lista permitida de páginas e categorias.
- `lib/sync/emuseu_parser.dart`: HTML para itens normalizados.
- `lib/sync/emuseu_sync_service.dart`: download, imagem, diff e publicação transacional.
- `tool/sync_emuseu.dart`: CLI pública da sincronização.
- `assets/data/elixo.json`: conteúdo editorial seguro.
- `assets/data/acervo.json`: snapshot offline do e-Museu.
- `assets/images/emuseu/`: imagens geradas pelo sincronizador.
- `assets/videos/`: vídeos locais licenciados quando disponíveis.
- `test/fixtures/emuseu/*.html`: fragmentos versionados das quatro páginas oficiais.

---

## Fase A — Base responsiva e tela inicial

### Task 1: Corrigir a base do aplicativo e substituir a navegação de três abas

**Files:**
- Create: `lib/app/e_lixo_app.dart`
- Create: `lib/app/app_routes.dart`
- Create: `lib/app/app_theme.dart`
- Create: `lib/features/home/home_page.dart`
- Modify: `lib/main.dart`
- Modify: `test/widget_test.dart`

**Interfaces:**
- Produces: `ELixoApp({Key? key})`, `AppRoutes.home`, `HomePage({Key? key})`.
- Consumes: temporariamente `ELixoPage` e `EMuseuPage` dos módulos atuais.

- [ ] **Step 1: Substituir o teste de contador por um teste da navegação aprovada**

```dart
testWidgets('home apresenta somente os dois módulos principais', (tester) async {
  await tester.pumpWidget(const ELixoApp());

  expect(find.text('E-Museu'), findsOneWidget);
  expect(find.text('E-Lixo'), findsOneWidget);
  expect(find.text('Educa'), findsNothing);
});
```

- [ ] **Step 2: Executar o teste e confirmar a falha atual**

Run: `flutter test test/widget_test.dart`

Expected: FAIL porque o teste atual ainda instancia `MyApp` ou porque a nova tela inicial não existe.

- [ ] **Step 3: Criar tema, rotas e tela inicial mínima**

`lib/app/app_routes.dart` deve expor:

```dart
abstract final class AppRoutes {
  static const home = '/';
  static const elixo = '/elixo';
  static const emuseu = '/emuseu';
}
```

`ELixoApp` deve criar um `MaterialApp` sem banner, usar `AppTheme.light`, registrar as três rotas e abrir `HomePage`. `HomePage` deve usar dois `FilledButton` ou cartões semânticos grandes e navegar por nome. Não importar `EducaPage`.

- [ ] **Step 4: Reduzir `main.dart` ao ponto de entrada**

```dart
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ELixoApp());
}
```

- [ ] **Step 5: Formatar, analisar e executar o teste**

Run: `dart format lib test && flutter analyze && flutter test test/widget_test.dart`

Expected: análise sem erros e teste PASS.

- [ ] **Step 6: Commit**

```bash
git add lib/main.dart lib/app lib/features/home test/widget_test.dart
git commit -m "feat: cria navegação principal do totem"
```

### Task 2: Adicionar responsividade, fundo ambiente e retorno por inatividade

**Files:**
- Create: `lib/app/totem_config.dart`
- Create: `lib/shared/widgets/responsive_content.dart`
- Create: `lib/shared/session/inactivity_gate.dart`
- Create: `lib/features/home/home_background.dart`
- Create: `test/shared/session/inactivity_gate_test.dart`
- Create: `test/features/home/home_page_test.dart`
- Modify: `lib/features/home/home_page.dart`
- Modify: `lib/app/e_lixo_app.dart`
- Modify: `pubspec.yaml`

**Interfaces:**
- Produces: `TotemConfig.inactivityTimeout`, `InactivityGate({required Widget child, required Duration timeout, required VoidCallback onTimeout})`, `ResponsiveContent.columnCountFor(double width)`, `HomeBackground({String? videoAssetPath})`, `HomePage({Widget? background})`.
- Consumes: `AppRoutes.home`, `HomePage`.

- [ ] **Step 1: Adicionar a dependência de vídeo e declarar diretórios de assets existentes**

Run: `flutter pub add video_player`

Manter `assets/images/museu/` declarado. Os novos diretórios de dados e imagens somente serão declarados nas tarefas que criarem arquivos reais dentro deles; declarar diretório vazio faz o build do Flutter falhar. Declarar `assets/videos/` somente quando ele contiver mídia licenciada.

- [ ] **Step 2: Escrever testes de coluna e inatividade**

```dart
test('totem vertical usa duas colunas', () {
  expect(ResponsiveContent.columnCountFor(1080), 2);
  expect(ResponsiveContent.columnCountFor(2160), 2);
});

testWidgets('retorna ao início após 120 segundos', (tester) async {
  var timedOut = false;
  await tester.pumpWidget(MaterialApp(
    home: InactivityGate(
      timeout: const Duration(seconds: 120),
      onTimeout: () => timedOut = true,
      child: const Placeholder(),
    ),
  ));
  await tester.pump(const Duration(seconds: 121));
  expect(timedOut, isTrue);
});
```

- [ ] **Step 3: Executar os testes e confirmar que falham por símbolos ausentes**

Run: `flutter test test/shared/session/inactivity_gate_test.dart test/features/home/home_page_test.dart`

Expected: FAIL por `ResponsiveContent` e `InactivityGate` inexistentes.

- [ ] **Step 4: Implementar layout responsivo e temporizador reiniciável**

`InactivityGate` deve reiniciar um `Timer` em `PointerDownEvent`, `PointerMoveEvent` e `PointerSignalEvent`, cancelá-lo em `dispose()` e chamar `onTimeout` uma vez. `ELixoApp` deve envolver o `Navigator` no gate e, no timeout, executar `pushNamedAndRemoveUntil(AppRoutes.home, (_) => false)`.

- [ ] **Step 5: Implementar fundo com fallback**

`HomeBackground` deve mostrar a imagem existente `assets/images/museu/monitorbak.jpg` com gradiente escuro quando `videoAssetPath == null`, quando houver erro de inicialização ou quando a duração não estiver entre 15 e 30 segundos. Quando houver caminho válido, usar `VideoPlayerController.asset`, `setLooping(true)`, `setVolume(0)` e cobrir com `ColoredBox(color: Color(0x99000000))`. O teste de `HomePage` deve injetar um `background` simples para não inicializar plugin.

- [ ] **Step 6: Verificar as duas resoluções no teste de widget**

```dart
for (final size in const [Size(1080, 1920), Size(2160, 3840)]) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  await tester.pumpWidget(const ELixoApp());
  expect(tester.takeException(), isNull);
}
```

- [ ] **Step 7: Executar validação e commit**

Run: `dart format lib test && flutter analyze && flutter test`

```bash
git add pubspec.yaml pubspec.lock lib/app lib/shared lib/features/home test
git commit -m "feat: adapta inicio para totem vertical"
```

---

## Fase B — Conteúdo E-Lixo seguro e orientado a dados

### Task 3: Criar o modelo, repositório e snapshot editorial do E-Lixo

**Files:**
- Create: `lib/features/elixo/domain/elixo_topic.dart`
- Create: `lib/features/elixo/data/elixo_repository.dart`
- Create: `assets/data/elixo.json`
- Create: `test/features/elixo/elixo_repository_test.dart`
- Create: `test/fixtures/elixo_valid.json`
- Modify: `pubspec.yaml`

**Interfaces:**
- Produces: `enum ELixoSection`, `ELixoTopic.fromJson(Map<String, Object?>)`, `ELixoDataSource.load() -> Future<List<ELixoTopic>>`, `ELixoRepository implements ELixoDataSource`.
- Consumes: `AssetBundle` injetado no construtor do repositório.

- [ ] **Step 1: Escrever testes de parse, ordem e validação de segurança**

```dart
test('carrega tópicos por seção e rejeita campos obrigatórios vazios', () async {
  final topics = await repository.load();
  expect(topics.map((item) => item.id), contains('fonte-alimentacao'));
  expect(topics.first.title, isNotEmpty);
  expect(
    topics.expand((item) => item.doNot).join(' ').toLowerCase(),
    isNot(contains('use um clipe')),
  );
});
```

Adicionar testes separados para JSON inválido, ID duplicado e seção desconhecida; todos devem lançar `FormatException` com o ID ou índice problemático.

- [ ] **Step 2: Executar os testes e confirmar a falha**

Run: `flutter test test/features/elixo/elixo_repository_test.dart`

Expected: FAIL porque os modelos não existem.

- [ ] **Step 3: Implementar o modelo imutável**

Campos exatos:

```dart
final String id;
final ELixoSection section;
final String title;
final String summary;
final String? imageAsset;
final List<String> commonProblems;
final List<String> safeChecks;
final List<String> doNot;
final String whenToSeekHelp;
final String destination;
final String? videoAsset;
final String? captionAsset;
```

- [ ] **Step 4: Criar o conteúdo editorial inicial**

O JSON deve conter os IDs `computador-sem-imagem`, `fonte-alimentacao`, `hd-armazenamento`, `conexoes-sata`, `processador`, `placa-video`, `multimetro`, `backup`, `restauracao-redefinicao-formatacao`, `impactos-e-lixo`, `reutilizacao-reciclagem` e `descarte-correto`.

Para `fonte-alimentacao`, o campo `doNot` deve conter: “Não abra a fonte, não interligue pinos e não faça testes com ela ligada à tomada.” O item `multimetro` deve ter o título **Multímetro** e o aviso: “Não meça tomadas, fontes energizadas ou corrente elétrica sem capacitação.” Para formatação: “Faça backup e procure ajuda antes de apagar ou redefinir o equipamento.”

Declarar `assets/data/` em `pubspec.yaml` depois que o JSON existir.

- [ ] **Step 5: Implementar leitura e validação**

Criar `abstract interface class ELixoDataSource` com `Future<List<ELixoTopic>> load()`. O repositório deve implementá-la, aceitar `AssetBundle bundle = rootBundle`, decodificar UTF-8, validar IDs únicos e retornar lista não modificável. Campos de lista ausentes viram listas vazias; `id`, `section`, `title`, `summary`, `whenToSeekHelp` e `destination` são obrigatórios. Nos testes de tela, usar `FakeELixoDataSource implements ELixoDataSource` que retorna uma lista recebida no construtor.

- [ ] **Step 6: Executar testes e commit**

Run: `dart format lib test && flutter analyze && flutter test test/features/elixo/elixo_repository_test.dart`

```bash
git add pubspec.yaml lib/features/elixo/domain lib/features/elixo/data assets/data/elixo.json test/features/elixo test/fixtures/elixo_valid.json
git commit -m "feat: adiciona conteudo seguro de e-lixo"
```

### Task 4: Construir as cinco categorias, cartões e detalhes do E-Lixo

**Files:**
- Create: `lib/shared/widgets/totem_scaffold.dart`
- Create: `lib/shared/widgets/asset_image_with_fallback.dart`
- Create: `lib/features/elixo/presentation/elixo_page.dart`
- Create: `lib/features/elixo/presentation/elixo_topic_page.dart`
- Create: `lib/features/elixo/presentation/elixo_detail_page.dart`
- Create: `lib/features/elixo/presentation/local_video_page.dart`
- Create: `test/features/elixo/elixo_navigation_test.dart`
- Modify: `lib/app/app_routes.dart`
- Modify: `lib/modules/e_lixo/e_lixo_page.dart` (delete after route migration)
- Modify: `lib/modules/educa/educa_page.dart` (delete after content migration)

**Interfaces:**
- Produces: `ELixoPage({ELixoDataSource? dataSource})`, `ELixoTopicPage(section, topics)`, `ELixoDetailPage(topic)`, `LocalVideoPage(assetPath, captionAsset, title)`.
- Consumes: `ELixoDataSource.load()`, `TotemScaffold`, `AppRoutes.home`.

- [ ] **Step 1: Escrever o teste de navegação por cartões**

```dart
testWidgets('abre componentes e exibe protocolo seguro da fonte', (tester) async {
  final source = FakeELixoDataSource([
    ELixoTopic.fromJson({
      'id': 'fonte-alimentacao',
      'section': 'components',
      'title': 'Fonte de alimentação',
      'summary': 'Converte e distribui energia para o computador.',
      'doNot': ['Não abra nem faça ligação direta na fonte.'],
      'whenToSeekHelp': 'Este procedimento deve ser realizado por uma pessoa capacitada.',
      'destination': 'Procure assistência antes de descartar.',
    }),
  ]);
  await tester.pumpWidget(MaterialApp(home: ELixoPage(dataSource: source)));
  await tester.tap(find.text('Componentes e conserto'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Fonte de alimentação'));
  await tester.pumpAndSettle();

  expect(find.text('O que não fazer'), findsOneWidget);
  expect(find.textContaining('pessoa capacitada'), findsOneWidget);
});

final class FakeELixoDataSource implements ELixoDataSource {
  FakeELixoDataSource(this.items);
  final List<ELixoTopic> items;

  @override
  Future<List<ELixoTopic>> load() async => items;
}
```

- [ ] **Step 2: Executar e confirmar falha por páginas ausentes**

Run: `flutter test test/features/elixo/elixo_navigation_test.dart`

- [ ] **Step 3: Implementar `TotemScaffold` e imagem resiliente**

`TotemScaffold` recebe `title`, `child`, `showBack` e `onHome`; deve fornecer botões com tooltip e `Semantics(label: ...)`. `AssetImageWithFallback` usa `Image.asset(..., errorBuilder: ...)` e nunca altera a proporção reservada.

- [ ] **Step 4: Implementar a grade das cinco categorias**

Rótulos exatos: “Componentes e conserto”, “Conheça as ferramentas”, “Cuidados com os dados”, “Entenda o e-lixo” e “Descarte correto”. Usar duas colunas e cartões com no mínimo 96 pontos lógicos de altura no perfil do totem.

- [ ] **Step 5: Implementar lista e detalhe padronizados**

O detalhe deve renderizar somente seções não vazias, sempre nesta ordem: função, problemas comuns, verificações seguras, o que não fazer, quando procurar um técnico e destino. O botão “Assistir ao vídeo” só aparece quando `videoAsset` e `captionAsset` apontarem para arquivos locais existentes. `LocalVideoPage` deve carregar a legenda WebVTT, iniciar somente após toque, oferecer reproduzir/pausar, volume, legenda visível e fechar; falha de mídia mostra mensagem curta e botão Voltar.

- [ ] **Step 6: Remover os módulos antigos e atualizar imports**

Excluir `lib/modules/e_lixo/e_lixo_page.dart` e `lib/modules/educa/educa_page.dart` somente depois que `AppRoutes.elixo` usar a nova página e os testes passarem.

- [ ] **Step 7: Verificar e commit**

Run: `dart format lib test && flutter analyze && flutter test`

```bash
git add -A lib test
git commit -m "feat: cria experiencia educativa do modulo e-lixo"
```

---

## Fase C — Acervo offline e comando de sincronização

### Task 5: Criar modelo e repositório offline do E-Museu

**Files:**
- Create: `lib/features/emuseu/domain/museum_item.dart`
- Create: `lib/features/emuseu/data/museum_repository.dart`
- Create: `assets/data/acervo.json`
- Create: `test/features/emuseu/museum_repository_test.dart`
- Modify: `pubspec.yaml`

**Interfaces:**
- Produces: `enum MuseumCategory`, `MuseumItem.fromJson`, `MuseumDataSource.load() -> Future<List<MuseumItem>>`, `MuseumRepository implements MuseumDataSource`.
- Consumes: `AssetBundle` injetável.

- [ ] **Step 1: Escrever testes do contrato do snapshot**

```dart
test('campos opcionais ausentes não invalidam o item', () {
  final item = MuseumItem.fromJson({
    'id': 'perifericos-mouse-logitech-m280',
    'category': 'perifericos',
    'name': 'Mouse sem fio Logitech M280',
    'image': 'assets/images/emuseu/mouse-logitech-m280.png',
    'sourceUrl': 'https://www3.unicentro.br/emuseu/perifericos-mouse-teclado-impressora-monitor/',
  });
  expect(item.year, isNull);
  expect(item.history, isNull);
});
```

Também testar ID duplicado, categoria inválida e lista vazia.

- [ ] **Step 2: Implementar o modelo e contrato de leitura**

Campos: `id`, `category`, `name`, `year`, `manufacturer`, `origin`, `description`, `history`, `imageAsset`, `sourceUrl`. Somente `id`, `category`, `name` e `sourceUrl` são obrigatórios; imagem ausente usa fallback. Criar `abstract interface class MuseumDataSource` com `Future<List<MuseumItem>> load()` e fazer `MuseumRepository` implementá-la. Os testes de widget usarão `FakeMuseumDataSource implements MuseumDataSource`.

- [ ] **Step 3: Migrar o snapshot inicial**

Mover os itens válidos hoje codificados em `e_museu_page.dart` para JSON, omitindo `olivetti.jpg` e `processador.jpg` enquanto esses arquivos não existirem. O sincronizador das tarefas seguintes substituirá esse snapshot por dados oficiais completos.

O diretório `assets/data/` já estará declarado pela Fase B; manter a declaração única e não duplicar entradas no `pubspec.yaml`.

- [ ] **Step 4: Executar testes e commit**

Run: `dart format lib test && flutter analyze && flutter test test/features/emuseu/museum_repository_test.dart`

```bash
git add pubspec.yaml lib/features/emuseu/domain lib/features/emuseu/data assets/data/acervo.json test/features/emuseu
git commit -m "feat: modela acervo offline do e-museu"
```

### Task 6: Implementar parser das quatro páginas oficiais com fixtures

**Files:**
- Create: `lib/sync/emuseu_page_config.dart`
- Create: `lib/sync/emuseu_parser.dart`
- Create: `test/sync/emuseu_parser_test.dart`
- Create: `test/fixtures/emuseu/computadores.html`
- Create: `test/fixtures/emuseu/perifericos.html`
- Create: `test/fixtures/emuseu/componentes.html`
- Create: `test/fixtures/emuseu/outros.html`
- Modify: `pubspec.yaml`

**Interfaces:**
- Produces: `EmuseuPageConfig(category, url)`, `ParsedMuseumItem`, `EmuseuParser.parse(String html, EmuseuPageConfig page) -> List<ParsedMuseumItem>`.
- Consumes: `package:html/parser.dart`.

- [ ] **Step 1: Adicionar dependências da ferramenta**

Run: `flutter pub add http html image crypto args path`

- [ ] **Step 2: Criar fixtures mínimas e testes de variações reais**

Cada fixture deve preservar um bloco real `.wpb_column.vc_column_container.vc_col-has-fill`, contendo título `h1`, `.vc_single_image-img`, painel “Descrição” e painel “História”. Incluir casos sem história, sem fabricante, com “Decrição” escrito incorretamente e nome recuperado do atributo `title` da imagem.

```dart
test('extrai nome, imagem, descrição e história por coluna', () {
  final items = parser.parse(fixture, EmuseuPages.peripherals);
  expect(items.first.name, 'Mouse sem fio Logitech M280');
  expect(items.first.imageUrl.host, 'www3.unicentro.br');
  expect(items.first.description, contains('Modelo: Logitech M280'));
});
```

- [ ] **Step 3: Confirmar que os testes falham sem parser**

Run: `flutter test test/sync/emuseu_parser_test.dart`

- [ ] **Step 4: Implementar parser limitado ao conteúdo do acervo**

Selecionar colunas dentro de `#wpb-content-root`. Em cada coluna, obter o primeiro `h1` não vazio, a primeira `.vc_single_image-img[src]` e painéis `.vc_tta-panel`; mapear o texto de `.vc_tta-title-text` para o corpo `.vc_tta-panel-body`. Normalizar espaços, preservar quebras entre parágrafos e extrair `Nome`, `Ano`, `Fabricante` e `Origem` por rótulo, sem remover o texto completo da descrição.

`ParsedMuseumItem` deve conter `id`, `MuseumCategory category`, `name`, `year`, `manufacturer`, `origin`, `description`, `history`, `Uri? imageUrl` e `sourceUrl`. `EmuseuPages.all` deve conter exatamente as quatro URLs da especificação; os atalhos `computers`, `peripherals`, `components` e `others` apontam para seus itens.

- [ ] **Step 5: Criar IDs determinísticos**

Gerar `id` como `<categoria>-<nome-normalizado>`. Se houver colisão, acrescentar os oito primeiros caracteres do SHA-256 da URL da imagem. Rejeitar qualquer imagem cujo host não seja `www3.unicentro.br`.

- [ ] **Step 6: Testar e commit**

Run: `dart format lib test && flutter analyze && flutter test test/sync/emuseu_parser_test.dart`

```bash
git add pubspec.yaml pubspec.lock lib/sync test/sync test/fixtures/emuseu
git commit -m "feat: interpreta paginas oficiais do acervo"
```

### Task 7: Criar sincronização transacional, otimização e relatório de diff

**Files:**
- Create: `lib/sync/emuseu_sync_service.dart`
- Create: `lib/sync/sync_report.dart`
- Create: `tool/sync_emuseu.dart`
- Create: `test/sync/emuseu_sync_service_test.dart`
- Modify: `.gitignore`
- Modify: `pubspec.yaml`

**Interfaces:**
- Produces: `EmuseuSyncService.sync({required bool checkOnly, required bool allowRemovals}) -> Future<SyncReport>`, `SyncReport({List<String> added, List<String> changed, List<String> removed, List<SyncRejection> rejected})`, `SyncException`.
- Consumes: `EmuseuParser`, quatro `EmuseuPageConfig`, `http.Client`, `package:image`.

- [ ] **Step 1: Escrever testes com `MockClient` e diretório temporário**

Cobrir: sucesso completo; uma página HTTP 500; imagem 404; JSON inválido anterior; `--check` sem escrita; remoção bloqueada sem confirmação; publicação completa com `allowRemovals`.

```dart
test('falha de uma página preserva snapshot e imagens anteriores', () async {
  final before = await snapshotFile.readAsString();
  await expectLater(service.sync(checkOnly: false, allowRemovals: false), throwsA(isA<SyncException>()));
  expect(await snapshotFile.readAsString(), before);
});
```

- [ ] **Step 2: Executar e confirmar falha**

Run: `flutter test test/sync/emuseu_sync_service_test.dart`

- [ ] **Step 3: Implementar staging e validação**

Baixar tudo para `.sync_tmp/<timestamp>/`; limitar respostas HTML a 10 MiB e imagens a 15 MiB; aceitar JPEG, PNG e WebP; corrigir orientação EXIF; reduzir somente imagens maiores que 1600 px no maior lado; salvar JPEG com qualidade 85. Não aumentar imagens pequenas. Qualquer item rejeitado impede a publicação e aparece no relatório, para não trocar um snapshot íntegro por um acervo incompleto.

- [ ] **Step 4: Implementar publicação transacional**

Ordenar itens por `category`, depois `name`; gerar JSON com indentação de dois espaços e newline final. Só substituir `assets/data/acervo.json` e `assets/images/emuseu/` após validar todas as páginas. Fazer backup temporário, renomear staging para destino e restaurar o backup se a segunda renomeação falhar.

- [ ] **Step 5: Implementar diff e política de remoções**

Comparar por `id`. `--check` não escreve. Execução normal aplica adições e alterações, mas se houver remoções deve sair com código 2 e listar os IDs; o responsável repete com `--allow-removals` para efetivá-las.

- [ ] **Step 6: Implementar CLI e mensagens**

Comandos aceitos:

```bash
dart run tool/sync_emuseu.dart --check
dart run tool/sync_emuseu.dart
dart run tool/sync_emuseu.dart --allow-removals
```

Saída final: quantidades de adicionados, alterados, removidos, rejeitados e caminho do snapshot. Nunca executar Git.

- [ ] **Step 7: Executar testes e check real**

Run: `dart format lib tool test && flutter analyze && flutter test test/sync && dart run tool/sync_emuseu.dart --check`

Expected: testes PASS; check real retorna relatório sem escrever arquivos.

- [ ] **Step 8: Revisar e aplicar a primeira sincronização oficial**

Run: `dart run tool/sync_emuseu.dart`

Se o comando listar remoções, não repetir com `--allow-removals` até comparar os IDs com o site. Depois de uma sincronização válida, declarar `assets/images/emuseu/` no `pubspec.yaml`, executar `flutter test` novamente e incluir `assets/data/acervo.json` e `assets/images/emuseu/` no commit.

```bash
git add .gitignore pubspec.yaml lib/sync tool test/sync assets/data/acervo.json assets/images/emuseu
git commit -m "feat: adiciona comando seguro de sincronizacao"
```

### Task 8: Migrar a interface E-Museu para o snapshot sincronizado

**Files:**
- Create: `lib/features/emuseu/presentation/emuseu_page.dart`
- Create: `lib/features/emuseu/presentation/museum_detail_page.dart`
- Create: `test/features/emuseu/emuseu_page_test.dart`
- Modify: `lib/app/app_routes.dart`
- Delete: `lib/modules/e_museu/e_museu_page.dart`

**Interfaces:**
- Produces: `EMuseuPage({MuseumDataSource? dataSource})`, `MuseumDetailPage(item)`.
- Consumes: `MuseumDataSource.load()`, `ResponsiveContent`, `TotemScaffold`, `AssetImageWithFallback`.

- [ ] **Step 1: Escrever teste de filtro, detalhe e campos opcionais**

```dart
testWidgets('filtra periféricos e abre item sem campos vazios', (tester) async {
  final source = FakeMuseumDataSource([
    MuseumItem.fromJson({
      'id': 'perifericos-mouse-logitech-m280',
      'category': 'perifericos',
      'name': 'Mouse sem fio Logitech M280',
      'sourceUrl': 'https://www3.unicentro.br/emuseu/perifericos-mouse-teclado-impressora-monitor/',
    }),
  ]);
  await tester.pumpWidget(MaterialApp(home: EMuseuPage(dataSource: source)));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Periféricos'));
  await tester.pumpAndSettle();
  expect(find.text('Mouse sem fio Logitech M280'), findsOneWidget);
  expect(find.text('Fabricante:'), findsNothing);
});

final class FakeMuseumDataSource implements MuseumDataSource {
  FakeMuseumDataSource(this.items);
  final List<MuseumItem> items;

  @override
  Future<List<MuseumItem>> load() async => items;
}
```

- [ ] **Step 2: Executar e confirmar falha da nova interface**

Run: `flutter test test/features/emuseu/emuseu_page_test.dart`

- [ ] **Step 3: Implementar categorias e grade responsiva**

Exibir Todos, Computadores, Periféricos, Componentes e Outros equipamentos em controles grandes. Usar duas colunas nas duas resoluções-alvo e preservar proporção da imagem com `BoxFit.contain`.

- [ ] **Step 4: Implementar detalhe sem rótulos vazios**

Mostrar imagem, nome e somente os campos presentes. Descrição e história usam seções legíveis, sem exigir expansão para o primeiro conteúdo relevante. Não abrir `sourceUrl` no totem.

- [ ] **Step 5: Remover tela antiga, verificar e commit**

Run: `dart format lib test && flutter analyze && flutter test`

```bash
git add -A lib test
git commit -m "feat: conecta e-museu ao acervo offline"
```

---

## Fase D — Android quiosque e validação final

### Task 9: Preparar orientação, modo imersivo e lock task opcional

**Files:**
- Modify: `lib/main.dart`
- Modify: `android/app/src/main/AndroidManifest.xml`
- Modify: `android/app/src/main/kotlin/com/example/e_lixo_app/MainActivity.kt`
- Create: `lib/shared/platform/kiosk_mode.dart`
- Create: `test/shared/platform/kiosk_mode_test.dart`

**Interfaces:**
- Produces: `KioskMode.enterImmersive()`, canal `e_lixo_app/kiosk` com métodos `canStartLockTask`, `startLockTask`, `stopLockTask`.
- Consumes: permissões do Android; lock task permanece opcional quando o aparelho não for device owner ou allowlisted.

- [ ] **Step 1: Escrever teste do wrapper do canal com `MethodChannel.setMockMethodCallHandler`**

Verificar que uma resposta `false` de `canStartLockTask` não chama `startLockTask` e não lança erro.

- [ ] **Step 2: Bloquear retrato e modo de sistema no Dart**

Antes de `runApp`, executar:

```dart
await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
```

- [ ] **Step 3: Ajustar Manifest e Activity**

Definir `android:screenOrientation="portrait"` e rótulo `E-Lixo`. Em Kotlin, aplicar `WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON`, restaurar flags imersivas em `onWindowFocusChanged`, expor o canal e somente chamar `startLockTask()` quando `DevicePolicyManager.isLockTaskPermitted(packageName)` retornar verdadeiro.

- [ ] **Step 4: Testar comportamento degradado**

Sem permissão administrativa, o aplicativo deve continuar em tela cheia e navegável, sem crash nem tentativa repetida de lock task.

- [ ] **Step 5: Verificar e commit**

Run: `dart format lib test && flutter analyze && flutter test`

```bash
git add lib/main.dart lib/shared/platform test/shared/platform android/app/src/main
git commit -m "feat: prepara android para modo totem"
```

### Task 10: Validar operação offline, resoluções, mídia e documentação

**Files:**
- Create: `test/app/totem_resolution_test.dart`
- Create: `test/app/offline_navigation_test.dart`
- Modify: `README.md`
- Modify: `pubspec.yaml`

**Interfaces:**
- Consumes: aplicativo completo, snapshots JSON e assets locais.
- Produces: documentação operacional e evidência de build.

- [ ] **Step 1: Escrever teste de navegação offline de ponta a ponta**

O teste deve abrir E-Lixo, acessar Fonte, voltar ao Início, abrir E-Museu, filtrar Periféricos e abrir um detalhe usando apenas repositórios locais. Verificar `tester.takeException() == null` em cada transição.

- [ ] **Step 2: Escrever matriz das duas resoluções**

Bombear Início, grade E-Lixo, detalhe E-Lixo, grade E-Museu e detalhe E-Museu em 1080 × 1920 e 2160 × 3840 com `devicePixelRatio = 1`; falhar em qualquer overflow ou exceção.

- [ ] **Step 3: Atualizar README operacional**

Documentar:

```bash
flutter pub get
dart run tool/sync_emuseu.dart --check
dart run tool/sync_emuseu.dart
flutter analyze
flutter test
flutter build apk --release
```

Explicar que o app do totem não precisa de internet, como inserir vídeo licenciado em `assets/videos/`, como alterar os 120 segundos e que lock task completo exige configuração administrativa do aparelho.

- [ ] **Step 4: Executar verificação completa**

Run:

```bash
flutter pub get
dart run tool/sync_emuseu.dart --check
flutter analyze
flutter test
flutter build apk --release
```

Expected: todos retornam código 0; APK em `build/app/outputs/flutter-apk/app-release.apk`. Se `--check` detectar mudanças ou remoções no site, registrar o relatório e revisar antes de atualizar o snapshot; isso não invalida os testes locais.

- [ ] **Step 5: Fazer teste manual no dispositivo**

Instalar o APK em Android físico, desativar a rede e percorrer todas as telas por toque. Deixar o vídeo ou fallback ativo por pelo menos duas horas; confirmar ausência de travamento, retorno após 120 segundos, orientação retrato e recuperação após alternar a tela.

- [ ] **Step 6: Commit final da documentação e testes**

```bash
git add README.md pubspec.yaml pubspec.lock test
git commit -m "test: valida experiencia completa do totem"
```

---

## Ordem de revisão

1. Revisar e integrar Fase A antes de iniciar conteúdo.
2. Revisar a segurança editorial da Fase B com a professora antes de publicar o APK.
3. Revisar o relatório do primeiro sync da Fase C antes de aceitar remoções.
4. Executar Fase D no modelo real do totem; configuração Android administrativa não deve ser presumida no emulador.

## Definição final de pronto

- Os dez tasks estão concluídos em commits isolados.
- `flutter analyze`, `flutter test` e `flutter build apk --release` retornam código 0.
- O teste offline e a matriz 1080 × 1920 / 2160 × 3840 passam sem overflow.
- Os protocolos públicos foram revisados e não contêm instruções perigosas.
- O snapshot do acervo foi revisado após o comando de sincronização.
- O APK foi validado no Android físico do totem ou as limitações específicas do aparelho foram registradas.
