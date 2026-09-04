import 'package:flutter/material.dart';
import '../../core/totem_metrics.dart';

enum _ViewMode { carousel, grid }

class EMuseuPage extends StatefulWidget {
  final String initialCategory;
  const EMuseuPage({super.key, this.initialCategory = 'Todos'});

  @override
  State<EMuseuPage> createState() => _EMuseuPageState();
}

class _EMuseuPageState extends State<EMuseuPage> {
  late String _categoriaSelecionada;
  _ViewMode _viewMode = _ViewMode.carousel;
  _MuseuItem? _focusItem;

  @override
  void initState() {
    super.initState();
    _categoriaSelecionada = widget.initialCategory;
  }

  // Lista atualizada com as imagens da pasta
  static const List<_MuseuItem> _items = [
    // --- PERIFÉRICOS (Mapeados do Print) ---
    _MuseuItem(
      name: 'Impressora Epson',
      category: 'Periféricos',
      description:
          'Impressora jato de tinta para uso doméstico, combinando impressão, cópia e digitalização.',
      history:
          'Equipamentos multifuncionais ajudaram a popularizar a impressão e a digitalização em residências e pequenos escritórios.',
      imagePath: 'assets/images/museu/epson-526x526.jpg',
      color: Color(0xFF8D5A3B),
      year: '1997',
      manufacturer: 'Seiko Epson Corporation',
      origin: 'Japão',
    ),
    _MuseuItem(
      name: 'Scanner Genius ColorPage HR7X',
      category: 'Periféricos',
      description:
          'Scanner de mesa para digitalização de documentos e imagens.',
      history:
          'Os scanners de mesa substituíram processos fotográficos e tornaram a digitalização acessível em escritórios e escolas.',
      imagePath: 'assets/images/museu/Genius-ColorPage-HR7X-Slim-526x526.jpg',
      color: Color(0xFFA0522D),
      year: '2002',
      manufacturer: 'KYE Systems Corporation',
      origin: 'China',
    ),
    _MuseuItem(
      name: 'Impressora HP Officejet J3680',
      category: 'Periféricos',
      description:
          'Impressora multifuncional com recursos de impressão, cópia e digitalização.',
      history:
          'Modelos multifuncionais marcaram a transição dos equipamentos separados para soluções integradas.',
      imagePath:
          'assets/images/museu/HP-Officejet-J3680-All-in-One-526x526.jpg',
      color: Color(0xFF6D4935),
      year: '2006',
      manufacturer: 'HP (Hewlett-Packard)',
      origin: 'China',
    ),
    _MuseuItem(
      name: 'Impressora HP Photosmart C5580',
      category: 'Periféricos',
      description:
          'Impressora colorida multifuncional para documentos e fotografias.',
      history:
          'A linha Photosmart aproximou a impressão fotográfica digital do uso doméstico.',
      imagePath:
          'assets/images/museu/HP-Photosmart-C5580-All-in-One-526x526.jpg',
      color: Color(0xFF9B6A45),
      year: '2008',
      manufacturer: 'HP',
      origin: 'Estados Unidos',
    ),
    _MuseuItem(
      name: 'Impressora Matricial RIMA XT-250',
      category: 'Periféricos',
      description:
          'Impressora matricial de impacto, utilizada em ambientes comerciais e administrativos.',
      history:
          'As impressoras matriciais foram importantes por sua durabilidade e pelo baixo custo de impressão contínua.',
      imagePath: 'assets/images/museu/Impressora-matricial-RIMA-XT-250.jpg',
      color: Color(0xFFC49A5A),
      year: '1980–1990',
      manufacturer: 'RIMA (Rima Indústria Mecânica e Eletrônica Ltda.)',
      origin: 'Brasil',
    ),
    _MuseuItem(
      name: 'Monitor Apple',
      category: 'Periféricos',
      description:
          'Monitor de computador com design característico das primeiras gerações de equipamentos pessoais.',
      history:
          'Monitores antigos registram a evolução dos padrões de imagem e do design dos computadores.',
      imagePath: 'assets/images/museu/monitor-appple-526x526.jpg',
      color: Color(0xFF8D5A3B),
      year: '1997',
      manufacturer: 'Apple Computer',
      origin: 'Estados Unidos e Irlanda',
    ),
    _MuseuItem(
      name: 'Monitor BAK BK-TFT TV7150',
      category: 'Periféricos',
      description:
          'Monitor CRT utilizado em computadores e televisores de gerações anteriores.',
      history:
          'A tecnologia CRT dominou os monitores antes da popularização das telas finas.',
      imagePath: 'assets/images/museu/monitorbak.jpg',
      color: Color(0xFFA0522D),
      year: '2000–2010',
      manufacturer: 'BAK',
      origin: 'China/Japão',
    ),
    _MuseuItem(
      name: 'Monitor Philips 105S',
      category: 'Periféricos',
      description:
          'Monitor CRT de 15 polegadas, representativo da informática dos anos 1990 e 2000.',
      history:
          'Monitores CRT utilizavam tubos de raios catódicos e possuem materiais que exigem descarte especializado.',
      imagePath: 'assets/images/museu/Monitor-Philips-105S-526x526.jpg',
      color: Color(0xFF6D4935),
      year: '1997',
      manufacturer: 'Philips',
      origin: 'Brasil',
    ),
    _MuseuItem(
      name: 'Monitor CRT Positivo',
      category: 'Periféricos',
      description:
          'Monitor de tubo de raios catódicos (CRT) utilizado em computadores de mesa antes da popularização das telas LCD.',
      history:
          'Os monitores CRT formavam imagens por meio de um feixe de elétrons dentro de um tubo. Por conterem vidro e componentes que exigem cuidado, precisam de descarte especializado.',
      imagePath: 'assets/images/museu/monitor-positivo.jpg',
      color: Color(0xFF9B6A45),
      year: '1990–2000 (estimado)',
      manufacturer: 'Positivo Tecnologia',
      origin: 'Brasil',
    ),
    _MuseuItem(
      name: 'Mouse Logitech sem fio',
      category: 'Periféricos',
      description:
          'Modelo: Logitech M280\nSensor: Logitech Advanced Optical Tracking\nDPI: 1000\nBateria: 1 pilha AA\nQuantidade de botões: 3\nConexão: conexão sem fio de 2,4 GHz\nAlcance: 10 m\nDesign para destros.',
      history: 'Informação histórica não cadastrada para este item.',
      imagePath: 'assets/images/museu/mouselogitech.png',
      color: Color(0xFFC49A5A),
      year: 'Não registrado no acervo',
      manufacturer: 'Logitech',
    ),
    _MuseuItem(
      name: 'Scanner Genius EasyScan Deluxe',
      category: 'Periféricos',
      description: 'Scanner de mesa compacto para documentos e imagens.',
      history:
          'Scanners compactos foram amplamente usados em escolas, escritórios e laboratórios.',
      imagePath:
          'assets/images/museu/Scanner-Genius-EasyScan-Color-Deluxe-526x526.jpg',
      color: Color(0xFF8D5A3B),
      year: 'Década de 1990',
      manufacturer: 'Genius',
      origin: 'Taiwan',
    ),
    _MuseuItem(
      name: 'Scanner HP Scanjet Enterprise',
      category: 'Periféricos',
      description:
          'Scanner profissional para digitalização de grande volume de documentos.',
      history:
          'Scanners corporativos representam a transformação de arquivos físicos em acervos digitais.',
      imagePath:
          'assets/images/museu/Scanner-HP-Scanjet-Enterprise-7000-s2-526x526.jpg',
      color: Color(0xFFA0522D),
      year: '2013',
      manufacturer: 'HP',
      origin: 'Estados Unidos',
    ),
    _MuseuItem(
      name: 'Teclado Positivo AT-486',
      category: 'Periféricos',
      description:
          'Teclado de computador com padrão de conexão e construção característicos de equipamentos antigos.',
      history:
          'O teclado permanece uma das principais interfaces entre as pessoas e os computadores.',
      imagePath: 'assets/images/museu/Teclado-Positivo-AT-486-526x526.jpg',
      color: Color(0xFF6D4935),
      year: 'Década de 1990',
      manufacturer: 'Positivo Informática',
      origin: 'Brasil',
    ),

    // --- COMPONENTES ---
    _MuseuItem(
      name: 'ASUS M2N68-AM SE2',
      category: 'Componentes',
      description:
          'Placa-mãe AMD AM2/AM2+, com vídeo, áudio e rede integrados.',
      imagePath: 'assets/images/museu/acervo_site/full/ASUS-M2N68-AM-SE2.jpg',
      color: Color(0xFF964B00),
      year: '2009',
      manufacturer: 'ASUS',
      origin: 'Taiwan',
    ),
    _MuseuItem(
      name: 'ASRock M266A',
      category: 'Componentes',
      description:
          'Placa-mãe para Intel Pentium 4, soquete 478, vídeo integrado, memória DDR, PS/2 e IDE.',
      imagePath: 'assets/images/museu/acervo_site/full/ASRock-M266A.jpg',
      color: Color(0xFFB25900),
      year: '2003',
      manufacturer: 'ASRock',
      origin: 'Taiwan',
    ),
    _MuseuItem(
      name: 'PCChips M925G v9.1B',
      category: 'Componentes',
      description:
          'Placa-mãe para Intel Pentium 4 e Celeron, com vídeo, áudio e rede integrados.',
      imagePath: 'assets/images/museu/acervo_site/full/PCChips-M925G-v9.1B.jpg',
      color: Color(0xFFC7762C),
      year: '2004',
      manufacturer: 'PCChips / Hsin Tech',
      origin: 'Taiwan',
    ),
    _MuseuItem(
      name: 'ASUS P5KPL-AM SE',
      category: 'Componentes',
      description:
          'Placa-mãe LGA 775 para Intel Core 2 Duo. Suporta até 4 GB de memória DDR2.',
      imagePath: 'assets/images/museu/acervo_site/full/ASUS-P5KPL-AM-SE.jpg',
      color: Color(0xFF964B00),
      year: '2009',
      manufacturer: 'ASUS',
      origin: 'Taiwan',
    ),
    _MuseuItem(
      name: 'Gigabyte GA-945GZM-S2',
      category: 'Componentes',
      description:
          'Placa-mãe LGA 775 para Core 2 Duo, Pentium D e Celeron; vídeo, som e rede integrados.',
      imagePath:
          'assets/images/museu/acervo_site/full/Gigabyte-GA-945GZM-S2.jpg',
      color: Color(0xFFB25900),
      year: '2006',
      manufacturer: 'Gigabyte Technology',
      origin: 'Taiwan',
    ),
    _MuseuItem(
      name: 'ASUS P3W',
      category: 'Componentes',
      description:
          'Placa-mãe Socket 370 para Intel Pentium III, com memória SDRAM.',
      imagePath: 'assets/images/museu/acervo_site/full/ASUS-P3W.jpg',
      color: Color(0xFFC7762C),
      year: '2000',
      manufacturer: 'ASUS',
      origin: 'Taiwan',
    ),

    // --- COMPUTADORES ---
    _MuseuItem(
      name: 'UNICENTRO_EL_PC01',
      category: 'Computadores - PC',
      description:
          '4×512 MB DDR 400 MHz, placa-mãe ASUS P4C800, Intel Pentium 4 2.80 GHz, 2×80 GB, DVD, floppy e fonte ATX 450 W.',
      imagePath: 'assets/images/museu/acervo_site/full/pc-1.png',
      color: Color(0xFF964B00),
      year: '2004 (estimado)',
      manufacturer: 'Montagem com placa ASUS P4C800',
      origin: 'Componentes de origens diversas',
    ),
    _MuseuItem(
      name: 'UNICENTRO_EL_PC04',
      category: 'Computadores - PC',
      description:
          'Intel Celeron D 326 2.53 GHz, placa-mãe ASUS P5DC-MX, DDR2 667 MHz, HD Samsung 80 GB, DVD e floppy.',
      imagePath: 'assets/images/museu/acervo_site/full/pc-4.png',
      color: Color(0xFFB25900),
      year: '2005–2006 (estimado)',
      manufacturer: 'Montagem com placa ASUS P5DC-MX',
      origin: 'Taiwan / componentes diversos',
    ),
    _MuseuItem(
      name: 'UNICENTRO_EL_PC08',
      category: 'Computadores - PC',
      description:
          'Intel DX4 100 MHz, memória de 8 MB, placa-mãe 486 ISA, HD Quantum Fireball, drive óptico e floppy.',
      imagePath: 'assets/images/museu/acervo_site/full/pc-8.png',
      color: Color(0xFFC7762C),
      year: '1994–1996 (estimado)',
      manufacturer: 'Montagem compatível IBM PC',
      origin: 'Componentes de origens diversas',
    ),
    _MuseuItem(
      name: 'UNICENTRO_EL_PC11',
      category: 'Computadores - PC',
      description:
          'Intel Pentium Dual Core E5200 2.50 GHz, 2 GB DDR2, Foxconn G31MPX, HD Samsung 160 GB, DVD e floppy.',
      imagePath: 'assets/images/museu/acervo_site/full/PC-11.0.png',
      color: Color(0xFF964B00),
      year: '2008–2009 (estimado)',
      manufacturer: 'Foxconn / montagem diversa',
      origin: 'China/Taiwan',
    ),
    _MuseuItem(
      name: 'Macintosh PowerBook G3',
      category: 'Computadores - PC',
      description:
          'Notebook com processador PowerPC G3 e arquitetura modular para expansão de unidades.',
      imagePath: 'assets/images/museu/acervo_site/full/pc-2.png',
      color: Color(0xFFB25900),
      year: '1997',
      manufacturer: 'Apple Computer',
      origin: 'Estados Unidos/Irlanda',
    ),
    _MuseuItem(
      name: 'Computador Prológica CP-500',
      category: 'Computadores - PC',
      description:
          'Zilog Z80A de 2 MHz, 48 KiB expansíveis a 64 KiB, teclado integrado, monitor CRT e armazenamento por cassete ou disquete.',
      imagePath: 'assets/images/museu/acervo_site/full/prologica-cp500.jpg',
      color: Color(0xFFC7762C),
      year: '1982',
      manufacturer: 'Prológica',
      origin: 'Brasil',
    ),
    _MuseuItem(
      name: 'Macintosh Classic',
      category: 'Computadores - PC',
      description:
          'Tela integrada de 9 polegadas, Motorola 68000, disquete de 1,44 MB e 1 MB de RAM.',
      imagePath: 'assets/images/museu/acervo_site/full/Macintosh-Classic.jpg',
      color: Color(0xFF964B00),
      year: '1990',
      manufacturer: 'Apple Computer',
      origin: 'Estados Unidos',
    ),
    _MuseuItem(
      name: 'Acer Aspire 3690',
      category: 'Computadores - PC',
      description:
          'Notebook com tela de 15,4”, DDR2, gráficos integrados, Wi-Fi, webcam, DVD e USB.',
      imagePath: 'assets/images/museu/acervo_site/full/acer-3690.jpeg',
      color: Color(0xFFB25900),
      year: '2006',
      manufacturer: 'Acer',
      origin: 'Taiwan',
    ),

    // --- OUTROS ---
    _MuseuItem(
      name: 'Leitor DVD Philco DV-PIX20',
      category: 'Outros',
      description:
          'Leitor DVD com NTSC, DVD-R/RW, DVD+R/RW, SVCD, VCD, CD-DA e karaokê; saídas composto, S-Video e RCA.',
      imagePath: 'assets/images/museu/acervo_site/full/dvd-philco.jpg',
      color: Color(0xFF964B00),
      manufacturer: 'Philco',
    ),
    _MuseuItem(
      name: 'Leitor VHS Panasonic NV-MV40',
      category: 'Outros',
      description:
          'Videocassete VHS de 5 cabeças, Jet Navigator, Super Drive, mono e Auto NTSC/PAL-M.',
      imagePath: 'assets/images/museu/acervo_site/full/vhs-panasonic.jpg',
      color: Color(0xFFB25900),
      manufacturer: 'Panasonic',
      origin: 'Japão',
    ),
    _MuseuItem(
      name: 'Secretária Eletrônica CCE TS-30',
      category: 'Outros',
      description:
          'Controle remoto, entrada para fone, visor de recados, ajuste de volume e seletor 110/220 V.',
      imagePath: 'assets/images/museu/acervo_site/full/secretaria.jpg',
      color: Color(0xFFC7762C),
      year: 'Década de 1980',
      manufacturer: 'CCE',
      origin: 'Brasil',
    ),
    _MuseuItem(
      name: 'Servidor HP 9000 K-Class',
      category: 'Outros',
      description:
          'Arquitetura PA-RISC, até 6 CPUs e 8 GB de RAM, expansão modular e sistema HP-UX.',
      imagePath: 'assets/images/museu/acervo_site/full/hp-9000.jpg',
      color: Color(0xFF964B00),
      year: '1995',
      manufacturer: 'Hewlett-Packard',
      origin: 'Estados Unidos',
    ),
    _MuseuItem(
      name: 'Projetor de Slides ProjeFix',
      category: 'Outros',
      description:
          'Lâmpada halógena e carregamento automático de slides em carrossel lateral.',
      imagePath: 'assets/images/museu/acervo_site/full/projefix.jpg',
      color: Color(0xFFB25900),
      year: '1970',
      manufacturer: 'CCE',
      origin: 'Brasil',
    ),
    _MuseuItem(
      name: 'Projetor de slides IEC P-37AF',
      category: 'Outros',
      description:
          'Projetor óptico para exibição de fotografias em slides, com iluminação interna.',
      imagePath: 'assets/images/museu/acervo_site/full/iec-p37af.jpg',
      color: Color(0xFFC7762C),
      year: '1970',
      manufacturer: 'IEC',
      origin: 'Brasil',
    ),
  ];

  List<_MuseuItem> get _itensFiltrados {
    if (_categoriaSelecionada == 'Todos') {
      return _items;
    }
    return _items
        .where((item) => item.category == _categoriaSelecionada)
        .toList();
  }

  void _showInfoModal(BuildContext context) {
    final s = TotemMetrics.scale(context);
    showDialog<void>(
      context: context,
      builder: (context) {
        return Dialog(
          key: const Key('museum-about-dialog'),
          insetPadding: EdgeInsets.symmetric(
            horizontal: 26 * s,
            vertical: 36 * s,
          ),
          backgroundColor: const Color(0xFFFFFBF5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: const BorderSide(color: Color(0xFFC7762C), width: 2),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 920),
            child: SingleChildScrollView(
              padding: EdgeInsets.all(42 * s),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(
                    Icons.account_balance,
                    size: 58 * s,
                    color: const Color(0xFFB25900),
                  ),
                  SizedBox(height: 18 * s),
                  Text(
                    'Sobre o E-Museu',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 38 * s,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF422100),
                    ),
                  ),
                  SizedBox(height: 30 * s),
                  _AboutInfo(
                    icon: Icons.location_on_outlined,
                    title: 'Localização',
                    text:
                        'Novatec (Agência de Inovação Tecnológica), Campus Cedeteg.',
                  ),
                  SizedBox(height: 18 * s),
                  _AboutInfo(
                    icon: Icons.schedule,
                    title: 'Horário de visitação',
                    text: 'Segunda a sexta, das 09h às 12h e das 13h às 17h.',
                  ),
                  SizedBox(height: 18 * s),
                  _AboutInfo(
                    icon: Icons.volunteer_activism_outlined,
                    title: 'Doações',
                    text:
                        'Aceitamos tecnologias antigas. Agende pelo telefone (42) 3629-8144.',
                  ),
                  SizedBox(height: 30 * s),
                  SizedBox(
                    height: 64 * s,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF663300),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Fechar',
                        style: TextStyle(
                          fontSize: 22 * s,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = TotemMetrics.scale(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF3E4D1),
      body: SafeArea(
        child: Column(
          children: [
            _MuseumHeaderBar(
              scale: s,
              viewMode: _viewMode,
              onToggleView: () => setState(() {
                _viewMode = _viewMode == _ViewMode.carousel
                    ? _ViewMode.grid
                    : _ViewMode.carousel;
              }),
              onInfo: () => _showInfoModal(context),
            ),
            Expanded(
              child: _viewMode == _ViewMode.carousel
                  ? _MuseumCarousel(
                      items: _itensFiltrados,
                      focusItem: _focusItem,
                    )
                  : _MuseumGalleryGrid(
                      items: _itensFiltrados,
                      onSelect: (item) => setState(() {
                        _focusItem = item;
                        _viewMode = _ViewMode.carousel;
                      }),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MuseumHeaderBar extends StatelessWidget {
  final double scale;
  final _ViewMode viewMode;
  final VoidCallback onToggleView;
  final VoidCallback onInfo;

  const _MuseumHeaderBar({
    required this.scale,
    required this.viewMode,
    required this.onToggleView,
    required this.onInfo,
  });

  @override
  Widget build(BuildContext context) {
    final s = scale;
    return Container(
      padding: EdgeInsets.fromLTRB(22 * s, 16 * s, 22 * s, 16 * s),
      decoration: const BoxDecoration(
        color: Color(0xFFFFFBF5),
        border: Border(bottom: BorderSide(color: Color(0xFFE2BA8A))),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'EXPOSIÇÃO DE TECNOLOGIA',
              style: TextStyle(
                color: const Color(0xFF663300),
                fontSize: 18 * s,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2 * s,
              ),
            ),
          ),
          SizedBox(width: 12 * s),
          _HeaderIconButton(
            icon: viewMode == _ViewMode.carousel
                ? Icons.grid_view_rounded
                : Icons.view_carousel_outlined,
            tooltip: viewMode == _ViewMode.carousel
                ? 'Ver em grade'
                : 'Ver em carrossel',
            scale: s,
            onTap: onToggleView,
          ),
          SizedBox(width: 10 * s),
          _HeaderIconButton(
            icon: Icons.info_outline,
            tooltip: 'Sobre o acervo',
            scale: s,
            onTap: onInfo,
            keyValue: const Key('museum-about-button'),
          ),
        ],
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final double scale;
  final VoidCallback onTap;
  final Key? keyValue;

  const _HeaderIconButton({
    required this.icon,
    required this.tooltip,
    required this.scale,
    required this.onTap,
    this.keyValue,
  });

  @override
  Widget build(BuildContext context) {
    final s = scale;
    return Material(
      color: const Color(0xFF663300),
      borderRadius: BorderRadius.circular(14),
      child: IconButton(
        key: keyValue,
        icon: Icon(icon, color: Colors.white, size: 26 * s),
        iconSize: 26 * s,
        padding: EdgeInsets.all(12 * s),
        tooltip: tooltip,
        onPressed: onTap,
      ),
    );
  }
}

class _MuseumGalleryGrid extends StatelessWidget {
  final List<_MuseuItem> items;
  final ValueChanged<_MuseuItem> onSelect;

  const _MuseumGalleryGrid({required this.items, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final s = TotemMetrics.scale(context);
    if (items.isEmpty) {
      return const Center(
        child: Text(
          'Nenhuma peça cadastrada nesta categoria.',
          style: TextStyle(color: Color(0xFF663300), fontSize: 20),
        ),
      );
    }
    return GridView.builder(
      padding: EdgeInsets.all(24 * s),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 320 * s,
        mainAxisSpacing: 20 * s,
        crossAxisSpacing: 20 * s,
        childAspectRatio: 0.82,
      ),
      itemCount: items.length,
      itemBuilder: (context, i) {
        final item = items[i];
        return InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () => onSelect(item),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFFFBF5),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFE2BA8A)),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    color: const Color(0xFFF3E4D1),
                    padding: EdgeInsets.all(16 * s),
                    child: Image.asset(
                      item.imagePath,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.inventory_2_outlined,
                        size: 60 * s,
                        color: item.color.withValues(alpha: .55),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(14 * s),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: const Color(0xFF422100),
                          fontWeight: FontWeight.bold,
                          fontSize: 16 * s,
                        ),
                      ),
                      SizedBox(height: 4 * s),
                      Text(
                        item.category,
                        style: TextStyle(
                          color: const Color(0xFF966B46),
                          fontSize: 13 * s,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _MuseumCarousel extends StatefulWidget {
  final List<_MuseuItem> items;
  final _MuseuItem? focusItem;

  const _MuseumCarousel({required this.items, this.focusItem});

  @override
  State<_MuseumCarousel> createState() => _MuseumCarouselState();
}

class _MuseumCarouselState extends State<_MuseumCarousel> {
  int _index = 0;
  double _scale = 1.0;
  final ScrollController _thumbController = ScrollController();

  @override
  void initState() {
    super.initState();
    if (widget.focusItem != null) {
      final idx = widget.items.indexWhere(
        (i) => i.name == widget.focusItem!.name,
      );
      if (idx >= 0) _index = idx;
    }
  }

  @override
  void dispose() {
    _thumbController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant _MuseumCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.items != widget.items) _index = 0;
  }

  void _move(int amount) {
    if (widget.items.isEmpty) return;
    setState(
      () => _index =
          (_index + amount + widget.items.length) % widget.items.length,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollThumbInto());
  }

  void _select(int index) {
    setState(() => _index = index);
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollThumbInto());
  }

  void _scrollThumbInto() {
    if (!_thumbController.hasClients) return;
    final thumbExtent = 106.0 * _scale;
    final target =
        (thumbExtent * _index) -
        (_thumbController.position.viewportDimension / 2) +
        (thumbExtent / 2);
    _thumbController.animateTo(
      target.clamp(0.0, _thumbController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) {
      return const Center(
        child: Text(
          'Nenhuma peça cadastrada nesta categoria.',
          style: TextStyle(color: Color(0xFF663300), fontSize: 20),
        ),
      );
    }

    final item = widget.items[_index];
    return LayoutBuilder(
      builder: (context, constraints) {
        final s = TotemMetrics.scale(context);
        _scale = s;
        final portrait =
            MediaQuery.sizeOf(context).height >
            MediaQuery.sizeOf(context).width * 1.25;
        final compact = constraints.maxWidth < 1000;
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: (compact ? 24 : 70) * s,
            vertical: (compact ? 24 : 42) * s,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    item.category.toUpperCase(),
                    style: TextStyle(
                      color: const Color(0xFF663300),
                      fontSize: 18 * s,
                      letterSpacing: 1.8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24 * s),
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: (portrait ? 18 : 72) * s,
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        height: constraints.maxHeight * (portrait ? .72 : .78),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 350),
                          switchInCurve: Curves.easeOutCubic,
                          transitionBuilder: (child, animation) =>
                              FadeTransition(
                                opacity: animation,
                                child: ScaleTransition(
                                  scale: Tween(
                                    begin: .96,
                                    end: 1.0,
                                  ).animate(animation),
                                  child: child,
                                ),
                              ),
                          child: _MuseumExhibitCard(
                            key: ValueKey(item.name),
                            item: item,
                            allItems: widget.items,
                            onSelectRelated: _select,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      child: _CarouselArrow(
                        icon: Icons.chevron_left_rounded,
                        onTap: () => _move(-1),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      child: _CarouselArrow(
                        icon: Icons.chevron_right_rounded,
                        onTap: () => _move(1),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 22 * s),
              Text(
                '${_index + 1} de ${widget.items.length}',
                style: TextStyle(
                  color: const Color(0xFF966B46),
                  fontWeight: FontWeight.bold,
                  fontSize: 19 * s,
                  letterSpacing: 1,
                ),
              ),
              SizedBox(height: 16 * s),
              SizedBox(
                height: 96 * s,
                child: ListView.separated(
                  controller: _thumbController,
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.items.length,
                  separatorBuilder: (_, __) => SizedBox(width: 12 * s),
                  itemBuilder: (context, i) {
                    final thumb = widget.items[i];
                    final selected = i == _index;
                    return GestureDetector(
                      onTap: () => _select(i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        width: 90 * s,
                        height: 90 * s,
                        padding: EdgeInsets.all(8 * s),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFFBF5),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: selected
                                ? const Color(0xFF964B00)
                                : const Color(0xFFE2BA8A),
                            width: selected ? 3 : 1.4,
                          ),
                          boxShadow: selected
                              ? const [
                                  BoxShadow(
                                    color: Color(0x33422100),
                                    blurRadius: 10,
                                    offset: Offset(0, 3),
                                  ),
                                ]
                              : null,
                        ),
                        child: Image.asset(
                          thumb.imagePath,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.inventory_2_outlined,
                            color: thumb.color.withValues(alpha: .55),
                            size: 30 * s,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CarouselArrow extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CarouselArrow({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final s = TotemMetrics.scale(context);
    return Material(
      color: const Color(0xFF663300),
      borderRadius: BorderRadius.circular(18),
      elevation: 5,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: SizedBox(
          width: 76 * s,
          height: 144 * s,
          child: Icon(icon, color: const Color(0xFFF3E4D1), size: 64 * s),
        ),
      ),
    );
  }
}

class _MuseumExhibitCard extends StatelessWidget {
  final _MuseuItem item;
  final List<_MuseuItem> allItems;
  final ValueChanged<int> onSelectRelated;

  const _MuseumExhibitCard({
    super.key,
    required this.item,
    required this.allItems,
    required this.onSelectRelated,
  });

  @override
  Widget build(BuildContext context) {
    final s = TotemMetrics.scale(context);
    final related = allItems
        .where((i) => i.category == item.category && i.name != item.name)
        .take(3)
        .toList();
    Widget imagePanel() => Container(
      height: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF3E4D1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2BA8A), width: 2),
      ),
      padding: EdgeInsets.all(22 * s),
      child: Image.asset(
        item.imagePath,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => Icon(
          Icons.inventory_2_outlined,
          size: 150 * s,
          color: item.color.withValues(alpha: .55),
        ),
      ),
    );

    Widget detailsPanel() => SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'PEÇA EM DESTAQUE',
            style: TextStyle(
              color: const Color(0xFFB25900),
              fontSize: 17 * s,
              letterSpacing: 2,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 18 * s),
          Text(
            item.name,
            style: TextStyle(
              color: const Color(0xFF422100),
              fontSize: 42 * s,
              height: 1.1,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 28 * s),
          _ExhibitInfo(label: 'ANO', value: item.year),
          _ExhibitInfo(label: 'FABRICANTE', value: item.manufacturer),
          _ExhibitInfo(label: 'ORIGEM', value: item.origin),
          SizedBox(height: 24 * s),
          Text(
            'CARACTERÍSTICAS TÉCNICAS',
            style: TextStyle(
              color: const Color(0xFFB25900),
              fontSize: 16 * s,
              letterSpacing: 1.4,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12 * s),
          Text(
            item.description,
            style: TextStyle(
              color: const Color(0xFF663300),
              fontSize: 23 * s,
              height: 1.45,
            ),
          ),
          if (item.history.isNotEmpty) ...[
            SizedBox(height: 24 * s),
            Text(
              'HISTÓRIA DA PEÇA',
              style: TextStyle(
                color: const Color(0xFFB25900),
                fontSize: 16 * s,
                letterSpacing: 1.4,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12 * s),
            Text(
              item.history,
              style: TextStyle(
                color: const Color(0xFF663300),
                fontSize: 23 * s,
                height: 1.45,
              ),
            ),
          ],
          if (related.isNotEmpty) ...[
            SizedBox(height: 28 * s),
            Text(
              'PEÇAS RELACIONADAS',
              style: TextStyle(
                color: const Color(0xFFB25900),
                fontSize: 16 * s,
                letterSpacing: 1.4,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 14 * s),
            Row(
              children: [
                for (final r in related) ...[
                  _RelatedItemTile(
                    item: r,
                    scale: s,
                    onTap: () => onSelectRelated(allItems.indexOf(r)),
                  ),
                  if (r != related.last) SizedBox(width: 14 * s),
                ],
              ],
            ),
          ],
        ],
      ),
    );

    return Card(
      key: const Key('museum-exhibit-card'),
      color: const Color(0xFFFFFBF5),
      elevation: 9,
      shadowColor: const Color(0x77422100),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
        side: const BorderSide(color: Color(0xFFC7762C), width: 2),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: EdgeInsets.all(26 * s),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final viewport = MediaQuery.sizeOf(context);
            final compact =
                constraints.maxWidth < 900 ||
                viewport.height > viewport.width * 1.25;
            if (compact) {
              return Column(
                children: [
                  Expanded(flex: 5, child: imagePanel()),
                  SizedBox(height: 22 * s),
                  Expanded(flex: 4, child: detailsPanel()),
                ],
              );
            }
            return Row(
              children: [
                Expanded(flex: 6, child: imagePanel()),
                SizedBox(width: 34 * s),
                Expanded(flex: 4, child: detailsPanel()),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _RelatedItemTile extends StatelessWidget {
  final _MuseuItem item;
  final double scale;
  final VoidCallback onTap;

  const _RelatedItemTile({
    required this.item,
    required this.scale,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final s = scale;
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(8 * s),
          decoration: BoxDecoration(
            color: const Color(0xFFF3E4D1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2BA8A)),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 56 * s,
                width: double.infinity,
                child: Image.asset(
                  item.imagePath,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.inventory_2_outlined,
                    size: 26 * s,
                    color: item.color.withValues(alpha: .55),
                  ),
                ),
              ),
              SizedBox(height: 6 * s),
              Text(
                item.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: const Color(0xFF422100),
                  fontSize: 12 * s,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AboutInfo extends StatelessWidget {
  final IconData icon;
  final String title;
  final String text;

  const _AboutInfo({
    required this.icon,
    required this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final s = TotemMetrics.scale(context);
    return Container(
      padding: EdgeInsets.all(22 * s),
      decoration: BoxDecoration(
        color: const Color(0xFFF3E4D1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2BA8A)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFFB25900), size: 34 * s),
          SizedBox(width: 18 * s),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: const Color(0xFF422100),
                    fontSize: 23 * s,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 6 * s),
                Text(
                  text,
                  style: TextStyle(
                    color: const Color(0xFF663300),
                    fontSize: 20 * s,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ExhibitInfo extends StatelessWidget {
  final String label;
  final String value;

  const _ExhibitInfo({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final s = TotemMetrics.scale(context);
    return Padding(
      padding: EdgeInsets.only(bottom: 12 * s),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 145 * s,
            child: Text(
              label,
              style: TextStyle(
                color: const Color(0xFF966B46),
                fontSize: 15 * s,
                fontWeight: FontWeight.bold,
                letterSpacing: .8,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: const Color(0xFF422100),
                fontSize: 21 * s,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MuseuItem {
  final String name;
  final String category;
  final String description;
  final String history;
  final String imagePath;
  final Color color;
  final String year;
  final String manufacturer;
  final String origin;

  const _MuseuItem({
    required this.name,
    required this.category,
    required this.description,
    this.history = '',
    required this.imagePath,
    required this.color,
    this.year = 'Não registrado no acervo',
    this.manufacturer = 'Não identificado',
    this.origin = 'Não identificada',
  });

  String get metadata =>
      'Ano: $year\nFabricante: $manufacturer\nOrigem: $origin';
}
