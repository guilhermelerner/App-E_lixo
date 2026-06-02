import 'package:flutter/material.dart';

class EMuseuPage extends StatefulWidget {
  const EMuseuPage({super.key});

  @override
  State<EMuseuPage> createState() => _EMuseuPageState();
}

class _EMuseuPageState extends State<EMuseuPage> {
  // Estado para guardar a categoria escolhida no Menu suspenso
  String _categoriaSelecionada = 'Todos';

  // As categorias disponíveis para o filtro
  final List<String> _categorias = [
    'Todos',
    'Componentes',
    'Computadores - PC',
    'Outros',
    'Periféricos',
  ];

  static const List<_MuseuItem> _items = [
    _MuseuItem(
      name: 'Olivetti Linea 98',
      category: 'Outros',
      description:
          'Máquina de escrever manual (1971). Fabricada na Itália, foi muito utilizada em escritórios.',
      history:
          'A Olivetti Linea 98 foi um marco na datilografia mundial. Lançada na década de 70, tornou-se o padrão em escritórios e instituições educacionais antes da popularização dos computadores pessoais. É um símbolo da transição tecnológica do século XX.',
      imagePath: 'assets/images/museu/olivetti.jpg',
      color: Color(0xFFC2185B),
    ),
    _MuseuItem(
      name: 'IBM 6746',
      category: 'Outros',
      description:
          'Máquina de escrever elétrica (1984). Usa um microprocessador para automatizar funções.',
      history:
          'Este modelo revolucionou a digitação ao introduzir componentes eletrônicos que permitiam correções rápidas e formatação automática. A impressão do tipo "daisy wheel" garantia uma qualidade de texto impecável para a época.',
      imagePath: 'assets/images/museu/ibm.jpg',
      color: Color(0xFF0288D1),
    ),
    _MuseuItem(
      name: 'Teclado',
      category: 'Periféricos',
      description:
          'Periférico de entrada composto por teclas e circuitos. Seu descarte inadequado pode liberar substâncias tóxicas.',
      history:
          'Os teclados evoluíram dos modelos mecânicos barulhentos para as membranas silenciosas. Por conterem trilhas de prata e plásticos de diferentes densidades, sua reciclagem exige a separação minuciosa de cada camada.',
      imagePath: 'assets/images/museu/teclado.jpg',
      color: Color(0xFF7B1FA2),
    ),
    _MuseuItem(
      name: 'Processador',
      category: 'Componentes',
      description:
          'Cérebro do computador. Contém ouro, cobre e silício. Um dos componentes com maior valor na cadeia de reciclagem.',
      history:
          'A evolução dos processadores dita o ritmo da Lei de Moore. As versões mais antigas (como os 386 e 486) possuíam uma concentração de ouro muito maior em seus pinos do que os modelos atuais, o que os torna peças cobiçadas na mineração urbana.',
      imagePath: 'assets/images/museu/processador.jpg',
      color: Color(0xFF7B1FA2),
    ),
  ];

  // Função que retorna apenas os itens da categoria escolhida
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
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF6A1B9A))),
              const SizedBox(height: 16),
              const Text('📍 Localização:\nNovatec (Agência de Inovação Tecnológica), Campus Cedeteg.',
                  style: TextStyle(fontSize: 16)),
              const SizedBox(height: 12),
              const Text('🕒 Horário de Visitação:\nSegunda a Sexta, 09h às 12h e 13h às 17h.',
                  style: TextStyle(fontSize: 16)),
              const SizedBox(height: 12),
              const Text(
                  '♻️ Doações:\nAceitamos tecnologias antiquadas (não precisam estar funcionando). Agende através do telefone (42) 3629-8144.',
                  style: TextStyle(fontSize: 16)),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6A1B9A),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('E-MUSEU', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF6A1B9A),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            tooltip: 'Informações e Doações',
            onPressed: () => _showInfoModal(context),
          )
        ],
      ),
      backgroundColor: const Color(0xFFF3E5F5),
      body: Column(
        children: [
          // Bloco do Menu suspenso de filtro
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.white,
            child: Row(
              children: [
                const Icon(Icons.filter_list, color: Color(0xFF6A1B9A)),
                const SizedBox(width: 12),
                const Text(
                  'Filtrar por:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _categoriaSelecionada,
                      isExpanded: true,
                      icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF6A1B9A)),
                      items: _categorias.map((String categoria) {
                        return DropdownMenuItem<String>(
                          value: categoria,
                          child: Text(categoria, style: const TextStyle(fontSize: 15)),
                        );
                      }).toList(),
                      onChanged: (String? novaCategoria) {
                        if (novaCategoria != null) {
                          // O setState avisa o Flutter para desenhar a tela de novo com o novo filtro
                          setState(() {
                            _categoriaSelecionada = novaCategoria;
                          });
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Grade de Imagens (Agora usando a lista _itensFiltrados)
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.82,
              ),
              itemCount: _itensFiltrados.length,
              itemBuilder: (context, index) {
                return _MuseuCard(item: _itensFiltrados[index]);
              },
            ),
          ),
        ],
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
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _openDetail(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                color: item.color.withOpacity(0.1),
                child: Icon(
                  Icons.image_outlined,
                  size: 52,
                  color: item.color.withOpacity(0.4),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: item.color,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.category,
                    style: TextStyle(fontSize: 11, color: Colors.grey[600]),
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
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000022),
      appBar: AppBar(
        title: Text(item.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF000022),
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
              child: Center(
                child: Icon(
                  Icons.image_outlined,
                  size: 80,
                  color: item.color.withOpacity(0.3),
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildExpandableSection('+ Descrição', item.description),
            _buildExpandableSection('+ História', item.history),
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

  const _MuseuItem({
    required this.name,
    required this.category,
    required this.description,
    required this.history,
    required this.imagePath,
    required this.color,
  });
}