# Redesign do aplicativo E-Lixo para totem Android 4K

**Data:** 13 de agosto de 2026  
**Repositório:** `guilhermelerner/App-E_lixo`  
**Estado:** design aprovado para elaboração do plano de implementação

## 1. Objetivo

Reorganizar o aplicativo Flutter para funcionar como uma experiência pública de museu em um totem Android com tela vertical, tendo 2160 × 3840 como resolução principal. O aplicativo deve permanecer utilizável sem internet, ser simples para visitantes de diferentes idades e não expor procedimentos de manutenção perigosos como instruções práticas.

O produto final terá dois módulos principais: **E-Museu** e **E-Lixo**. O módulo **Educa** deixa de existir como área independente; seu conteúdo educativo será incorporado ao E-Lixo.

## 2. Público e princípios

O público é composto por visitantes do e-Museu, não por técnicos de manutenção. A experiência seguirá estes princípios:

- interação curta, visual e adequada ao toque;
- linguagem simples e pouco texto por tela;
- imagens reais dos equipamentos e componentes sempre que possível;
- conteúdo educativo, sem transformar o totem em manual técnico;
- funcionamento offline durante a visita;
- navegação recuperável, com retorno fácil ao início;
- interface responsiva, sem depender de medidas fixas da tela 4K.

## 3. Arquitetura de informação

```text
Início
├── E-Museu
│   ├── Computadores
│   ├── Periféricos
│   ├── Componentes
│   └── Outros equipamentos
│
└── E-Lixo
    ├── Componentes e conserto
    ├── Conheça as ferramentas
    ├── Cuidados com os dados
    ├── Entenda o e-lixo
    └── Descarte correto
```

A tela inicial exibirá dois botões grandes, E-Museu e E-Lixo, sobre um vídeo ambiente local. Um botão **Início** ficará disponível em todas as telas internas. Após 120 segundos sem interação, valor que deverá ser configurável, o aplicativo encerrará qualquer mídia aberta e retornará à tela inicial.

## 4. Tela inicial e mídia

O vídeo de fundo deverá:

- estar incluído no aplicativo e funcionar offline;
- ter entre 15 e 30 segundos;
- repetir continuamente e sem áudio automático;
- usar movimentos lentos;
- receber uma camada escura para preservar o contraste dos botões;
- possuir uma imagem estática de reserva para falhas de carregamento.

Vídeos educativos completos somente serão reproduzidos após uma ação explícita do visitante. Eles deverão ter controles grandes, legenda, volume e botão de fechar.

Vídeos do YouTube não serão baixados, traduzidos ou redistribuídos sem autorização compatível. Enquanto não houver uma mídia aprovada para o fundo, a interface usará a imagem estática de reserva. Essa dependência de conteúdo não impedirá a implementação e os testes da tela.

## 5. Módulo E-Museu

O acervo será organizado nas quatro categorias publicadas pelo e-Museu da Unicentro:

- computadores;
- periféricos;
- componentes;
- outros equipamentos.

Cada item deverá apresentar foto, nome, fabricante ou marca quando disponível, período ou ano quando disponível e descrição. A ausência de um campo opcional não poderá quebrar o cartão nem a tela de detalhes.

### 5.1 Fonte dos dados

O sincronizador consultará exclusivamente as páginas oficiais:

- `https://www3.unicentro.br/emuseu/computador-pc/`
- `https://www3.unicentro.br/emuseu/perifericos-mouse-teclado-impressora-monitor/`
- `https://www3.unicentro.br/emuseu/componente-placas-processador-memoria/`
- `https://www3.unicentro.br/emuseu/outros-equipamentos-tv-dvd-mesa-de-som-e-outros/`

O aplicativo não fará raspagem durante a visita. Os dados e as imagens válidos serão empacotados no APK.

### 5.2 Comando de atualização

O comando será:

```bash
dart run tool/sync_emuseu.dart
```

Ele deverá:

1. consultar somente as páginas permitidas;
2. extrair e normalizar os registros;
3. baixar e otimizar imagens;
4. validar campos obrigatórios e arquivos;
5. gerar `assets/data/acervo.json` de forma determinística;
6. informar itens adicionados, alterados, removidos e rejeitados;
7. substituir os dados locais apenas quando o resultado completo for válido;
8. preservar a última versão válida em qualquer falha;
9. não executar commit, push ou publicação automaticamente.

Itens removidos do site aparecerão no relatório antes de sua retirada dos dados locais. A execução deverá aceitar um modo de verificação que não grave alterações, para testes e revisão.

## 6. Módulo E-Lixo

O E-Lixo absorverá o conteúdo educativo do módulo Educa e organizará os protocolos em cartões informativos, sem questionários ou diagnósticos em sequência.

### 6.1 Componentes e conserto

Os cartões serão organizados por componente:

- monitor e imagem;
- fonte de alimentação;
- HD e armazenamento;
- cabos e conexões SATA;
- processador;
- placa de vídeo.

Cada detalhe seguirá a mesma estrutura:

1. foto do componente;
2. nome e função;
3. problemas mais comuns;
4. verificações seguras;
5. o que não fazer;
6. quando procurar um técnico;
7. orientação final entre reparar, reutilizar, doar ou descartar.

O protocolo chamado “teste de monitor” no documento de origem será apresentado como **Computador sem imagem**, pois o conteúdo trata principalmente do computador e de suas conexões.

### 6.2 Conheça as ferramentas

O multímetro será mantido como conteúdo educativo. A tela explicará sua função e as grandezas que pode medir, sem orientar visitantes a medir tomadas, fontes energizadas ou corrente em circuitos. Um aviso indicará que medições elétricas devem ser realizadas por pessoa capacitada.

### 6.3 Cuidados com os dados

Esta categoria explicará:

- importância e formas gerais de backup;
- diferença entre restauração, redefinição e formatação;
- proteção de dados pessoais antes de doar ou descartar;
- necessidade de assistência quando houver risco de perda de arquivos.

O aplicativo não oferecerá um passo a passo destrutivo para apagar discos ou formatar equipamentos.

### 6.4 Entenda o e-lixo

Esta categoria reunirá os vídeos e textos educativos antes associados ao Educa. Os conteúdos abordarão impactos ambientais, reparo, reutilização, doação e reciclagem. Vídeos deverão ser iniciados pelo visitante e funcionar localmente depois de incluídos legalmente no aplicativo.

### 6.5 Descarte correto

Esta categoria mostrará o que é lixo eletrônico, como preparar um equipamento, como proteger os dados pessoais e como procurar canais oficiais de coleta. Informações que mudam com frequência, como endereços de coleta, somente serão mostradas quando existir uma fonte local validada e um processo definido de atualização.

## 7. Política de segurança do conteúdo

O documento `PROTOCOLOS_CONSERTO_E_lIXO.doc` será usado como fonte editorial, não publicado diretamente no aplicativo. Antes da inclusão, o texto passará por simplificação e revisão técnica.

O aplicativo não instruirá o público a:

- abrir ou fazer ligação direta em fontes de alimentação;
- interligar pinos com clipes ou fios;
- medir rede elétrica ou equipamentos energizados;
- improvisar reparos de pinos de processadores;
- abrir aparelhos sem cuidados técnicos e eletrostáticos;
- formatar ou apagar dados sem compreender as consequências.

Quando um procedimento exigir ferramenta, abertura do equipamento, contato elétrico ou risco de perda de dados, a orientação será interrompida com a mensagem: **“Este procedimento deve ser realizado por uma pessoa capacitada.”**

## 8. Interface para o totem

O alvo principal é Android, orientação retrato e resolução física de 2160 × 3840. O layout usará restrições e proporções responsivas, não coordenadas ou tamanhos fixos baseados nessa resolução.

Diretrizes de interface:

- cartões em duas colunas no totem 4K vertical;
- tipografia e áreas de toque grandes;
- contraste alto e fundos controlados;
- imagens com proporção preservada;
- rolagem vertical simples quando necessária;
- ações principais em regiões alcançáveis;
- botões Voltar e Início consistentes;
- orientação retrato bloqueada;
- nenhum link externo acessível durante a visita;
- nenhuma saída acidental por elementos da interface do aplicativo.

O aplicativo será preparado para uso em modo quiosque. O bloqueio completo do Android, a inicialização automática e o modo *lock task* serão configurados de acordo com o modelo do equipamento e com as permissões administrativas disponíveis no totem.

## 9. Organização do código

Flutter e Dart serão mantidos. Código Android nativo será usado somente quando necessário para integração de quiosque, inicialização ou permissões do aparelho.

Estrutura pretendida:

```text
lib/
├── app/
├── features/
│   ├── home/
│   ├── emuseu/
│   └── elixo/
├── models/
├── services/
├── shared/
└── data/
```

As telas não conterão grandes listas de dados codificadas diretamente. Acervo, protocolos e conteúdos educativos usarão modelos e arquivos de dados validados. Componentes compartilhados cuidarão de cartões, mídia, navegação, estados vazios e imagens substitutas.

## 10. Fluxos de erro

- **Imagem ausente:** mostrar imagem substituta sem alterar o espaço do cartão.
- **Vídeo indisponível:** usar fundo estático na tela inicial ou mensagem simples nos vídeos educativos.
- **Dados locais inválidos:** impedir a geração da versão ou usar a última versão validada.
- **Site indisponível durante a sincronização:** encerrar sem sobrescrever arquivos existentes.
- **Sem internet no totem:** manter todo o conteúdo principal operacional.
- **Inatividade:** fechar mídia, limpar a pilha de navegação e retornar ao início.
- **Campo opcional ausente:** omitir o campo sem exibir rótulo vazio.

## 11. Verificação e testes

A implementação deverá incluir:

- testes dos modelos e da leitura dos dados locais;
- testes do parser com páginas ou amostras versionadas;
- teste de sincronização que confirme a preservação da versão válida em caso de erro;
- teste de navegação entre Início, E-Museu e E-Lixo;
- teste do temporizador de inatividade;
- teste das imagens e fundos substitutos;
- testes visuais em 2160 × 3840 e 1080 × 1920;
- teste de textos extensos e escala de fonte;
- teste offline de todas as telas principais;
- teste prolongado de repetição do vídeo inicial;
- `flutter analyze`, `flutter test` e geração do APK de release.

## 12. Critérios de aceitação

O redesign será considerado pronto quando:

1. a tela inicial apresentar somente E-Museu e E-Lixo;
2. o conteúdo do antigo Educa estiver corretamente incorporado ao E-Lixo;
3. os protocolos forem apresentados por componente e sem instruções perigosas;
4. o multímetro permanecer como explicação educativa segura;
5. o acervo estiver disponível offline e puder ser atualizado pelo comando definido;
6. nenhuma falha de mídia ou campo ausente quebrar a navegação;
7. o layout funcionar sem cortes e sobreposições nas duas resoluções de teste;
8. o aplicativo retornar ao início após inatividade;
9. análise, testes automatizados e build Android terminarem com sucesso.

## 13. Fora do escopo deste redesign

- painel administrativo dentro do totem;
- sincronização automática durante a visita;
- diagnóstico técnico automatizado;
- instruções de reparo elétrico para visitantes;
- dependência de transmissão do YouTube;
- escolha ou licenciamento de um vídeo protegido específico;
- publicação automática na Play Store.
