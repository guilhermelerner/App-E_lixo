import 'package:flutter/material.dart';
import '../../core/totem_metrics.dart';

class EMuseuPage extends StatefulWidget {
  final String initialCategory;
  const EMuseuPage({super.key, this.initialCategory = 'Todos'});

  @override
  State<EMuseuPage> createState() => _EMuseuPageState();
}

class _EMuseuPageState extends State<EMuseuPage> {
  late String _categoriaSelecionada;

  @override
  void initState() {
    super.initState();
    _categoriaSelecionada = widget.initialCategory;
  }

  final List<String> _categorias = [
    'Todos',
    'Componentes',
    'Computadores - PC',
    'Outros',
    'Periféricos',
  ];

  // Lista atualizada com as imagens da pasta
  static const List<_MuseuItem> _items = [
    // --- PERIFÉRICOS (Mapeados do Print) ---
    _MuseuItem(
      name: 'Impressora Epson',
      category: 'Periféricos',
      description: 'Impressora jato de tinta para uso doméstico, combinando impressão, cópia e digitalização.',
      history: 'Equipamentos multifuncionais ajudaram a popularizar a impressão e a digitalização em residências e pequenos escritórios.',
      imagePath: 'assets/images/museu/epson-526x526.jpg',
      color: Color(0xFF8D5A3B),
      year: '1997',
      manufacturer: 'Seiko Epson Corporation',
      origin: 'Japão',
    ),
    _MuseuItem(
      name: 'Scanner Genius ColorPage HR7X',
      category: 'Periféricos',
      description: 'Scanner de mesa para digitalização de documentos e imagens.',
      history: 'Os scanners de mesa substituíram processos fotográficos e tornaram a digitalização acessível em escritórios e escolas.',
      imagePath: 'assets/images/museu/Genius-ColorPage-HR7X-Slim-526x526.jpg',
      color: Color(0xFFA0522D),
      year: '2002',
      manufacturer: 'KYE Systems Corporation',
      origin: 'China',
    ),
    _MuseuItem(
      name: 'Impressora HP Officejet J3680',
      category: 'Periféricos',
      description: 'Impressora multifuncional com recursos de impressão, cópia e digitalização.',
      history: 'Modelos multifuncionais marcaram a transição dos equipamentos separados para soluções integradas.',
      imagePath: 'assets/images/museu/HP-Officejet-J3680-All-in-One-526x526.jpg',
      color: Color(0xFF6D4935),
      year: '2006',
      manufacturer: 'HP (Hewlett-Packard)',
      origin: 'China',
    ),
    _MuseuItem(
      name: 'Impressora HP Photosmart C5580',
      category: 'Periféricos',
      description: 'Impressora colorida multifuncional para documentos e fotografias.',
      history: 'A linha Photosmart aproximou a impressão fotográfica digital do uso doméstico.',
      imagePath: 'assets/images/museu/HP-Photosmart-C5580-All-in-One-526x526.jpg',
      color: Color(0xFF9B6A45),
      year: '2008',
      manufacturer: 'HP',
      origin: 'Estados Unidos',
    ),
    _MuseuItem(
      name: 'Impressora Matricial RIMA XT-250',
      category: 'Periféricos',
      description: 'Impressora matricial de impacto, utilizada em ambientes comerciais e administrativos.',
      history: 'As impressoras matriciais foram importantes por sua durabilidade e pelo baixo custo de impressão contínua.',
      imagePath: 'assets/images/museu/Impressora-matricial-RIMA-XT-250.jpg',
      color: Color(0xFFC49A5A),
      year: '1980–1990',
      manufacturer: 'RIMA (Rima Indústria Mecânica e Eletrônica Ltda.)',
      origin: 'Brasil',
    ),
    _MuseuItem(
      name: 'Monitor Apple',
      category: 'Periféricos',
      description: 'Monitor de computador com design característico das primeiras gerações de equipamentos pessoais.',
      history: 'Monitores antigos registram a evolução dos padrões de imagem e do design dos computadores.',
      imagePath: 'assets/images/museu/monitor-appple-526x526.jpg', 
      color: Color(0xFF8D5A3B),
      year: '1997',
      manufacturer: 'Apple Computer',
      origin: 'Estados Unidos e Irlanda',
    ),
    _MuseuItem(
      name: 'Monitor BAK BK-TFT TV7150',
      category: 'Periféricos',
      description: 'Monitor CRT utilizado em computadores e televisores de gerações anteriores.',
      history: 'A tecnologia CRT dominou os monitores antes da popularização das telas finas.',
      imagePath: 'assets/images/museu/monitorbak.jpg',
      color: Color(0xFFA0522D),
      year: '2000–2010',
      manufacturer: 'BAK',
      origin: 'China/Japão',
    ),
    _MuseuItem(
      name: 'Monitor Philips 105S',
      category: 'Periféricos',
      description: 'Monitor CRT de 15 polegadas, representativo da informática dos anos 1990 e 2000.',
      history: 'Monitores CRT utilizavam tubos de raios catódicos e possuem materiais que exigem descarte especializado.',
      imagePath: 'assets/images/museu/Monitor-Philips-105S-526x526.jpg',
      color: Color(0xFF6D4935),
      year: '1997',
      manufacturer: 'Philips',
      origin: 'Brasil',
    ),
    _MuseuItem(
      name: 'Monitor CRT Positivo',
      category: 'Periféricos',
      description: 'Mouse óptico sem fio para navegação em computadores.',
      history: 'A popularização dos mouses ópticos e sem fio trouxe mais precisão e praticidade ao uso cotidiano.',
      imagePath: 'assets/images/museu/monitor-positivo.jpg',
      color: Color(0xFF9B6A45),
      year: '1990–2000 (estimado)',
      manufacturer: 'Positivo Tecnologia',
      origin: 'Brasil',
    ),
    _MuseuItem(
      name: 'Mouse Logitech sem fio',
      category: 'Periféricos',
      description: 'Modelo: Logitech M280\nSensor: Logitech Advanced Optical Tracking\nDPI: 1000\nBateria: 1 pilha AA\nQuantidade de botões: 3\nConexão: conexão sem fio de 2,4 GHz\nAlcance: 10 m\nDesign para destros.',
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
      history: 'Scanners compactos foram amplamente usados em escolas, escritórios e laboratórios.',
      imagePath: 'assets/images/museu/Scanner-Genius-EasyScan-Color-Deluxe-526x526.jpg',
      color: Color(0xFF8D5A3B),
      year: 'Década de 1990',
      manufacturer: 'Genius',
      origin: 'Taiwan',
    ),
    _MuseuItem(
      name: 'Scanner HP Scanjet Enterprise',
      category: 'Periféricos',
      description: 'Scanner profissional para digitalização de grande volume de documentos.',
      history: 'Scanners corporativos representam a transformação de arquivos físicos em acervos digitais.',
      imagePath: 'assets/images/museu/Scanner-HP-Scanjet-Enterprise-7000-s2-526x526.jpg',
      color: Color(0xFFA0522D),
      year: '2013',
      manufacturer: 'HP',
      origin: 'Estados Unidos',
    ),
    _MuseuItem(
      name: 'Teclado Positivo AT-486',
      category: 'Periféricos',
      description: 'Teclado de computador com padrão de conexão e construção característicos de equipamentos antigos.',
      history: 'O teclado permanece uma das principais interfaces entre as pessoas e os computadores.',
      imagePath: 'assets/images/museu/Teclado-Positivo-AT-486-526x526.jpg',
      color: Color(0xFF6D4935),
      year: 'Década de 1990',
      manufacturer: 'Positivo Informática',
      origin: 'Brasil',
    ),

    // --- COMPONENTES ---
    _MuseuItem(name: 'ASUS M2N68-AM SE2', category: 'Componentes', description: 'Placa-mãe AMD AM2/AM2+, com vídeo, áudio e rede integrados.', imagePath: 'assets/images/museu/acervo_site/full/ASUS-M2N68-AM-SE2.jpg', color: Color(0xFF964B00), year: '2009', manufacturer: 'ASUS', origin: 'Taiwan'),
    _MuseuItem(name: 'ASRock M266A', category: 'Componentes', description: 'Placa-mãe para Intel Pentium 4, soquete 478, vídeo integrado, memória DDR, PS/2 e IDE.', imagePath: 'assets/images/museu/acervo_site/full/ASRock-M266A.jpg', color: Color(0xFFB25900), year: '2003', manufacturer: 'ASRock', origin: 'Taiwan'),
    _MuseuItem(name: 'PCChips M925G v9.1B', category: 'Componentes', description: 'Placa-mãe para Intel Pentium 4 e Celeron, com vídeo, áudio e rede integrados.', imagePath: 'assets/images/museu/acervo_site/full/PCChips-M925G-v9.1B.jpg', color: Color(0xFFC7762C), year: '2004', manufacturer: 'PCChips / Hsin Tech', origin: 'Taiwan'),
    _MuseuItem(name: 'ASUS P5KPL-AM SE', category: 'Componentes', description: 'Placa-mãe LGA 775 para Intel Core 2 Duo. Suporta até 4 GB de memória DDR2.', imagePath: 'assets/images/museu/acervo_site/full/ASUS-P5KPL-AM-SE.jpg', color: Color(0xFF964B00), year: '2009', manufacturer: 'ASUS', origin: 'Taiwan'),
    _MuseuItem(name: 'Gigabyte GA-945GZM-S2', category: 'Componentes', description: 'Placa-mãe LGA 775 para Core 2 Duo, Pentium D e Celeron; vídeo, som e rede integrados.', imagePath: 'assets/images/museu/acervo_site/full/Gigabyte-GA-945GZM-S2.jpg', color: Color(0xFFB25900), year: '2006', manufacturer: 'Gigabyte Technology', origin: 'Taiwan'),
    _MuseuItem(name: 'ASUS P3W', category: 'Componentes', description: 'Placa-mãe Socket 370 para Intel Pentium III, com memória SDRAM.', imagePath: 'assets/images/museu/acervo_site/full/ASUS-P3W.jpg', color: Color(0xFFC7762C), year: '2000', manufacturer: 'ASUS', origin: 'Taiwan'),

    // --- COMPUTADORES ---
    _MuseuItem(name: 'UNICENTRO_EL_PC01', category: 'Computadores - PC', description: '4×512 MB DDR 400 MHz, placa-mãe ASUS P4C800, Intel Pentium 4 2.80 GHz, 2×80 GB, DVD, floppy e fonte ATX 450 W.', imagePath: 'assets/images/museu/acervo_site/full/pc-1.png', color: Color(0xFF964B00), year: '2004 (estimado)', manufacturer: 'Montagem com placa ASUS P4C800', origin: 'Componentes de origens diversas'),
    _MuseuItem(name: 'UNICENTRO_EL_PC04', category: 'Computadores - PC', description: 'Intel Celeron D 326 2.53 GHz, placa-mãe ASUS P5DC-MX, DDR2 667 MHz, HD Samsung 80 GB, DVD e floppy.', imagePath: 'assets/images/museu/acervo_site/full/pc-4.png', color: Color(0xFFB25900), year: '2005–2006 (estimado)', manufacturer: 'Montagem com placa ASUS P5DC-MX', origin: 'Taiwan / componentes diversos'),
    _MuseuItem(name: 'UNICENTRO_EL_PC08', category: 'Computadores - PC', description: 'Intel DX4 100 MHz, memória de 8 MB, placa-mãe 486 ISA, HD Quantum Fireball, drive óptico e floppy.', imagePath: 'assets/images/museu/acervo_site/full/pc-8.png', color: Color(0xFFC7762C), year: '1994–1996 (estimado)', manufacturer: 'Montagem compatível IBM PC', origin: 'Componentes de origens diversas'),
    _MuseuItem(name: 'UNICENTRO_EL_PC11', category: 'Computadores - PC', description: 'Intel Pentium Dual Core E5200 2.50 GHz, 2 GB DDR2, Foxconn G31MPX, HD Samsung 160 GB, DVD e floppy.', imagePath: 'assets/images/museu/acervo_site/full/PC-11.0.png', color: Color(0xFF964B00), year: '2008–2009 (estimado)', manufacturer: 'Foxconn / montagem diversa', origin: 'China/Taiwan'),
    _MuseuItem(name: 'Macintosh PowerBook G3', category: 'Computadores - PC', description: 'Notebook com processador PowerPC G3 e arquitetura modular para expansão de unidades.', imagePath: 'assets/images/museu/acervo_site/full/pc-2.png', color: Color(0xFFB25900), year: '1997', manufacturer: 'Apple Computer', origin: 'Estados Unidos/Irlanda'),
    _MuseuItem(name: 'Computador Prológica CP-500', category: 'Computadores - PC', description: 'Zilog Z80A de 2 MHz, 48 KiB expansíveis a 64 KiB, teclado integrado, monitor CRT e armazenamento por cassete ou disquete.', imagePath: 'assets/images/museu/acervo_site/full/prologica-cp500.jpg', color: Color(0xFFC7762C), year: '1982', manufacturer: 'Prológica', origin: 'Brasil'),
    _MuseuItem(name: 'Macintosh Classic', category: 'Computadores - PC', description: 'Tela integrada de 9 polegadas, Motorola 68000, disquete de 1,44 MB e 1 MB de RAM.', imagePath: 'assets/images/museu/acervo_site/full/Macintosh-Classic.jpg', color: Color(0xFF964B00), year: '1990', manufacturer: 'Apple Computer', origin: 'Estados Unidos'),
    _MuseuItem(name: 'Acer Aspire 3690', category: 'Computadores - PC', description: 'Notebook com tela de 15,4”, DDR2, gráficos integrados, Wi-Fi, webcam, DVD e USB.', imagePath: 'assets/images/museu/acervo_site/full/acer-3690.jpeg', color: Color(0xFFB25900), year: '2006', manufacturer: 'Acer', origin: 'Taiwan'),

    // --- OUTROS ---
    _MuseuItem(name: 'Leitor DVD Philco DV-PIX20', category: 'Outros', description: 'Leitor DVD com NTSC, DVD-R/RW, DVD+R/RW, SVCD, VCD, CD-DA e karaokê; saídas composto, S-Video e RCA.', imagePath: 'assets/images/museu/acervo_site/full/dvd-philco.jpg', color: Color(0xFF964B00), manufacturer: 'Philco'),
    _MuseuItem(name: 'Leitor VHS Panasonic NV-MV40', category: 'Outros', description: 'Videocassete VHS de 5 cabeças, Jet Navigator, Super Drive, mono e Auto NTSC/PAL-M.', imagePath: 'assets/images/museu/acervo_site/full/vhs-panasonic.jpg', color: Color(0xFFB25900), manufacturer: 'Panasonic', origin: 'Japão'),
    _MuseuItem(name: 'Secretária Eletrônica CCE TS-30', category: 'Outros', description: 'Controle remoto, entrada para fone, visor de recados, ajuste de volume e seletor 110/220 V.', imagePath: 'assets/images/museu/acervo_site/full/secretaria.jpg', color: Color(0xFFC7762C), year: 'Década de 1980', manufacturer: 'CCE', origin: 'Brasil'),
    _MuseuItem(name: 'Servidor HP 9000 K-Class', category: 'Outros', description: 'Arquitetura PA-RISC, até 6 CPUs e 8 GB de RAM, expansão modular e sistema HP-UX.', imagePath: 'assets/images/museu/acervo_site/full/hp-9000.jpg', color: Color(0xFF964B00), year: '1995', manufacturer: 'Hewlett-Packard', origin: 'Estados Unidos'),
    _MuseuItem(name: 'Projetor de Slides ProjeFix', category: 'Outros', description: 'Lâmpada halógena e carregamento automático de slides em carrossel lateral.', imagePath: 'assets/images/museu/acervo_site/full/projefix.jpg', color: Color(0xFFB25900), year: '1970', manufacturer: 'CCE', origin: 'Brasil'),
    _MuseuItem(name: 'Projetor de slides IEC P-37AF', category: 'Outros', description: 'Projetor óptico para exibição de fotografias em slides, com iluminação interna.', imagePath: 'assets/images/museu/acervo_site/full/iec-p37af.jpg', color: Color(0xFFC7762C), year: '1970', manufacturer: 'IEC', origin: 'Brasil'),
  ];

  List<_MuseuItem> get _itensFiltrados {
    if (_categoriaSelecionada == 'Todos') {
      return _items;
    }
    return _items.where((item) => item.category == _categoriaSelecionada).toList();
  }

  void _showInfoModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Sobre o E-Museu',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF5D4037))),
              const SizedBox(height: 16),
              const Text('📍 Localização:\nNovatec (Agência de Inovação Tecnológica), Campus Cedeteg.',
                  style: TextStyle(fontSize: 16)),
              const SizedBox(height: 12),
              const Text('🕒 Horário de Visitação:\nSegunda a Sexta, 09h às 12h e 13h às 17h.',
                  style: TextStyle(fontSize: 16)),
              const SizedBox(height: 12),
              const Text(
                  '♻️ Doações:\nAceitamos tecnologias antiquadas. Agende através do telefone (42) 3629-8144.',
                  style: TextStyle(fontSize: 16)),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFA0522D),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Fechar', style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = TotemMetrics.scale(context);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 112 * s,
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12 * s),
              decoration: BoxDecoration(
                color: const Color(0xFFC7762C),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.account_balance, color: const Color(0xFF422100), size: 34 * s),
            ),
            SizedBox(width: 18 * s),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('E-MUSEU', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, letterSpacing: 2, fontSize: 27 * s)),
                Text('Acervo de tecnologia', style: TextStyle(color: const Color(0xFFE8C7A2), fontSize: 17 * s, letterSpacing: .6)),
              ],
            ),
          ],
        ),
        backgroundColor: const Color(0xFF422100),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline, color: Colors.white, size: 34 * s),
            tooltip: 'Informações e Doações',
            onPressed: () => _showInfoModal(context),
          )
        ],
      ),
      backgroundColor: const Color(0xFFF3E4D1),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(64 * s, 34 * s, 64 * s, 30 * s),
            decoration: const BoxDecoration(
              color: Color(0xFFF3E4D1),
              border: Border(bottom: BorderSide(color: Color(0xFFC7762C), width: 3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('GALERIA DE MEMÓRIA TECNOLÓGICA', style: TextStyle(color: const Color(0xFF966B46), fontSize: 16 * s, letterSpacing: 2, fontWeight: FontWeight.bold)),
                SizedBox(height: 10 * s),
                Row(
                  children: [
                    Expanded(child: Text('Exposição de tecnologia', style: TextStyle(color: const Color(0xFF422100), fontSize: 38 * s, fontWeight: FontWeight.w800))),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20 * s, vertical: 14 * s),
                      decoration: BoxDecoration(color: const Color(0xFF663300), borderRadius: BorderRadius.circular(8)),
                      child: Row(children: [Icon(Icons.collections_bookmark_outlined, color: const Color(0xFFF3E4D1), size: 26 * s), SizedBox(width: 10 * s), Text(_categoriaSelecionada, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 19 * s))]),
                    ),
                  ],
                ),
                SizedBox(height: 8 * s),
                Text('Use a barra lateral para escolher uma categoria e iniciar a visita.', style: TextStyle(color: const Color(0xFF805936), fontSize: 21 * s)),
              ],
            ),
          ),
          Expanded(
            child: _MuseumCarousel(items: _itensFiltrados),
          ),
        ],
      ),
    );
  }
}

class _MuseumCarousel extends StatefulWidget {
  final List<_MuseuItem> items;

  const _MuseumCarousel({required this.items});

  @override
  State<_MuseumCarousel> createState() => _MuseumCarouselState();
}

class _MuseumCarouselState extends State<_MuseumCarousel> {
  int _index = 0;

  @override
  void didUpdateWidget(covariant _MuseumCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.items != widget.items) _index = 0;
  }

  void _move(int amount) {
    if (widget.items.isEmpty) return;
    setState(() => _index = (_index + amount + widget.items.length) % widget.items.length);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) {
      return const Center(child: Text('Nenhuma peça cadastrada nesta categoria.', style: TextStyle(color: Color(0xFF663300), fontSize: 20)));
    }

    final item = widget.items[_index];
    return LayoutBuilder(
      builder: (context, constraints) {
        final s = TotemMetrics.scale(context);
        final portrait = MediaQuery.sizeOf(context).height > MediaQuery.sizeOf(context).width * 1.25;
        final compact = constraints.maxWidth < 1000;
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: (compact ? 24 : 70) * s, vertical: (compact ? 24 : 42) * s),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.collections_bookmark_outlined, color: const Color(0xFF964B00), size: 30 * s),
                  SizedBox(width: 14 * s),
                  Text('EXPOSIÇÃO • ${item.category.toUpperCase()}', style: TextStyle(color: const Color(0xFF663300), fontSize: 18 * s, letterSpacing: 1.8, fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(height: 24 * s),
              Expanded(
                child: Row(
                  children: [
                    _CarouselArrow(icon: Icons.chevron_left_rounded, onTap: () => _move(-1)),
                    SizedBox(width: 24 * s),
                    Expanded(
                      child: Center(
                        child: SizedBox(
                          height: constraints.maxHeight * (portrait ? .62 : .76),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 350),
                            switchInCurve: Curves.easeOutCubic,
                            transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: ScaleTransition(scale: Tween(begin: .96, end: 1.0).animate(animation), child: child)),
                            child: _MuseumExhibitCard(key: ValueKey(item.name), item: item),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 24 * s),
                    _CarouselArrow(icon: Icons.chevron_right_rounded, onTap: () => _move(1)),
                  ],
                ),
              ),
              SizedBox(height: 22 * s),
              Text('${_index + 1} de ${widget.items.length}', style: TextStyle(color: const Color(0xFF966B46), fontWeight: FontWeight.bold, fontSize: 19 * s, letterSpacing: 1)),
              SizedBox(height: 14 * s),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(widget.items.length > 12 ? 12 : widget.items.length, (dot) => AnimatedContainer(duration: const Duration(milliseconds: 200), margin: EdgeInsets.symmetric(horizontal: 4 * s), width: dot == _index % 12 ? 30 * s : 10 * s, height: 10 * s, decoration: BoxDecoration(color: dot == _index % 12 ? const Color(0xFF964B00) : const Color(0xFFD6A36A), borderRadius: BorderRadius.circular(10))))),
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
        child: SizedBox(width: 92 * s, height: 160 * s, child: Icon(icon, color: const Color(0xFFF3E4D1), size: 74 * s)),
      ),
    );
  }
}

class _MuseumExhibitCard extends StatelessWidget {
  final _MuseuItem item;

  const _MuseumExhibitCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final s = TotemMetrics.scale(context);
    Widget imagePanel() => Container(
          height: double.infinity,
          decoration: BoxDecoration(color: const Color(0xFFF3E4D1), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE2BA8A), width: 2)),
          padding: EdgeInsets.all(22 * s),
          child: Image.asset(item.imagePath, fit: BoxFit.contain, errorBuilder: (context, error, stackTrace) => Icon(Icons.inventory_2_outlined, size: 150 * s, color: item.color.withOpacity(.55))),
        );

    Widget detailsPanel() => SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
            Text('PEÇA EM DESTAQUE', style: TextStyle(color: const Color(0xFFB25900), fontSize: 17 * s, letterSpacing: 2, fontWeight: FontWeight.bold)),
            SizedBox(height: 18 * s),
            Text(item.name, style: TextStyle(color: const Color(0xFF422100), fontSize: 42 * s, height: 1.1, fontWeight: FontWeight.w800)),
            SizedBox(height: 28 * s),
            _ExhibitInfo(label: 'ANO', value: item.year),
            _ExhibitInfo(label: 'FABRICANTE', value: item.manufacturer),
            _ExhibitInfo(label: 'ORIGEM', value: item.origin),
            SizedBox(height: 24 * s),
            Text('CARACTERÍSTICAS TÉCNICAS', style: TextStyle(color: const Color(0xFFB25900), fontSize: 16 * s, letterSpacing: 1.4, fontWeight: FontWeight.bold)),
            SizedBox(height: 12 * s),
            Text(item.description, style: TextStyle(color: const Color(0xFF663300), fontSize: 23 * s, height: 1.45)),
          ]),
        );

    return Card(
      color: const Color(0xFFFFFBF5),
      elevation: 9,
      shadowColor: const Color(0x77422100),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22), side: const BorderSide(color: Color(0xFFC7762C), width: 2)),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: EdgeInsets.all(26 * s),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final viewport = MediaQuery.sizeOf(context);
            final compact = constraints.maxWidth < 900 || viewport.height > viewport.width * 1.25;
            if (compact) {
              return Column(children: [
                Expanded(flex: 5, child: imagePanel()),
                SizedBox(height: 22 * s),
                Expanded(flex: 4, child: detailsPanel()),
              ]);
            }
            return Row(children: [
              Expanded(flex: 6, child: imagePanel()),
              SizedBox(width: 34 * s),
              Expanded(flex: 4, child: detailsPanel()),
            ]);
          },
        ),
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
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(width: 145 * s, child: Text(label, style: TextStyle(color: const Color(0xFF966B46), fontSize: 15 * s, fontWeight: FontWeight.bold, letterSpacing: .8))),
        Expanded(child: Text(value, style: TextStyle(color: const Color(0xFF422100), fontSize: 21 * s, fontWeight: FontWeight.w600))),
      ]),
    );
  }
}

class _MuseumFilter extends StatelessWidget {
  final String value;
  final List<String> categories;
  final ValueChanged<String> onChanged;

  const _MuseumFilter({required this.value, required this.categories, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF3E4D1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFDE924F), width: 1.5),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4))],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF663300)),
          dropdownColor: const Color(0xFFFFF8EF),
          onChanged: (selected) {
            if (selected != null) onChanged(selected);
          },
          items: categories.map((category) {
            return DropdownMenuItem<String>(
              value: category,
              child: Row(
                children: [
                  const Icon(Icons.collections_bookmark_outlined, color: Color(0xFF964B00), size: 20),
                  const SizedBox(width: 10),
                  Text(category, style: const TextStyle(color: Color(0xFF422100), fontWeight: FontWeight.w600)),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _MuseuCard extends StatelessWidget {
  final _MuseuItem item;

  const _MuseuCard({required this.item});

  void _openDetail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _MuseuDetailPage(item: item),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFFFFBF5),
      elevation: 5,
      shadowColor: const Color(0x66422100),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: Color(0xFFD6A36A), width: 1.2),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _openDetail(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: const Color(0xFF422100),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
              child: Row(
                children: [
                  const Icon(Icons.museum_outlined, color: Color(0xFFDE924F), size: 17),
                  const SizedBox(width: 8),
                  const Text('PEÇA DO ACERVO', style: TextStyle(color: Color(0xFFF3E4D1), fontSize: 11, letterSpacing: 1.3, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  Text(item.year, style: const TextStyle(color: Color(0xFFE8C7A2), fontSize: 11)),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3E4D1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE8C7A2)),
                  ),
                  child: Image.asset(
                    item.imagePath,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Icon(Icons.inventory_2_outlined, size: 58, color: item.color.withOpacity(0.55)),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(16, 2, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: const Color(0xFF663300),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.category,
                    style: const TextStyle(fontSize: 12, color: Color(0xFF966B46), letterSpacing: .4),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MuseuDetailPage extends StatelessWidget {
  final _MuseuItem item;

  const _MuseuDetailPage({super.key, required this.item});

  Widget _buildExpandableSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        child: Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          iconColor: const Color(0xFF000033),
          collapsedIconColor: Colors.grey[700],
          title: Text(
            title,
            style: const TextStyle(fontSize: 18, color: Colors.black87),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  content,
                  style: const TextStyle(fontSize: 15, height: 1.5, color: Colors.black54),
                ),
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3E2723),
      appBar: AppBar(
        title: Text(item.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF3E2723),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 250,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  item.imagePath,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.image_not_supported_outlined,
                      size: 80,
                      color: item.color.withOpacity(0.3),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildExpandableSection('Características técnicas', item.description),
            _buildExpandableSection('Ficha do acervo', item.metadata),
          ],
        ),
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

  String get metadata => 'Ano: $year\nFabricante: $manufacturer\nOrigem: $origin';
}
