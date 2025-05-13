import 'package:flutter/material.dart';
import '../pages/kalkulator_button.dart';
import '../controllers/kalkulator_controller.dart';

class KalkulatorPage extends StatefulWidget {
  const KalkulatorPage({super.key});

  @override
  _KalkulatorPageState createState() => _KalkulatorPageState();
}

class _KalkulatorPageState extends State<KalkulatorPage> {
  late KalkulatorController _controller;

  static const Color operatorColor = Color(0xFFF18F01);
  static const Color numberColor = Color(0xFF9E9E9E);
  static const Color actionColor = Color(0xFFE04E39);
  static const Color backspaceColor = Color.fromARGB(255, 224, 88, 34);
  static const Color equalColor = Color(0xFF4CAF50);

  void _controllerListener() => setState(() {});

  @override
  void initState() {
    super.initState();
    _controller = KalkulatorController();
    _controller.addListener(_controllerListener);
  }

  @override
  void dispose() {
    _controller.removeListener(_controllerListener);
    super.dispose();
  }

  String _formatInputDisplay(String input) {
    return input.replaceAll('*', '×').replaceAll('/', '÷');
  }

  Widget _buildButtonRow(List<Map<String, dynamic>> rowButtons) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
      child: Row(
        children: rowButtons.map((btn) {
          return KalkulatorButton(
            label: btn['label'],
            onTap: () => _controller.onButtonPressed(btn['value']),
            color: btn['color'],
            textColor:
                btn.containsKey('textColor') ? btn['textColor'] : Colors.white,
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Layout button kalkulator
    final buttonLayout = [
      [
        {'label': 'AC', 'value': 'AC', 'color': actionColor},
        {'label': 'π', 'value': 'π', 'color': numberColor},
        {'label': '%', 'value': '%', 'color': numberColor},
        {
          'label': '+',
          'value': '+',
          'color': operatorColor,
          'textColor': Colors.white
        },
      ],
      [
        {'label': '1', 'value': '1', 'color': numberColor},
        {'label': '2', 'value': '2', 'color': numberColor},
        {'label': '3', 'value': '3', 'color': numberColor},
        {'label': '-', 'value': '-', 'color': operatorColor},
      ],
      [
        {'label': '4', 'value': '4', 'color': numberColor},
        {'label': '5', 'value': '5', 'color': numberColor},
        {'label': '6', 'value': '6', 'color': numberColor},
        {'label': '×', 'value': '*', 'color': operatorColor},
      ],
      [
        {'label': '7', 'value': '7', 'color': numberColor},
        {'label': '8', 'value': '8', 'color': numberColor},
        {'label': '9', 'value': '9', 'color': numberColor},
        {'label': '÷', 'value': '/', 'color': operatorColor},
      ],
      [
        {'label': '0', 'value': '0', 'color': numberColor},
        {'label': '.', 'value': '.', 'color': numberColor},
        {'label': '⌫', 'value': '⌫', 'color': backspaceColor},
        {'label': '=', 'value': '=', 'color': equalColor},
      ],
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Kalkulator')),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: _controller.history.isEmpty
                          ? const Center(
                              child: Text('Tidak ada riwayat',
                                  style: TextStyle(color: Colors.grey)))
                          : ListView.builder(
                              reverse: true,
                              itemCount: _controller.history.length,
                              itemBuilder: (context, index) {
                                final item = _controller.history.reversed
                                    .toList()[index];
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 2.0),
                                  child: Text(
                                    '${item['input']} = ${item['output']}',
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.grey),
                                    textAlign: TextAlign.right,
                                  ),
                                );
                              },
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, right: 0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: () async {
                            final shouldDelete = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Konfirmasi'),
                                content: const Text(
                                    'Apakah kamu yakin ingin menghapus semua riwayat?'),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text('Batal'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: const Text('Hapus'),
                                  ),
                                ],
                              ),
                            );

                            if (shouldDelete == true) {
                              _controller.clearHistory();
                            }
                          },
                          child: const Icon(Icons.delete, size: 20),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.only(
                                left: 1, right: 1, top: 8, bottom: 8),
                            minimumSize: const Size(36, 36),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(24),
                alignment: Alignment.bottomRight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _formatInputDisplay(_controller.input),
                      style: const TextStyle(fontSize: 32),
                    ),
                    if (_controller.isResultShown &&
                        _controller.output.isNotEmpty)
                      Text(
                        _controller.output,
                        style:
                            const TextStyle(fontSize: 24, color: Colors.grey),
                      ),
                  ],
                ),
              ),
            ),
            for (var row in buttonLayout) _buildButtonRow(row),
            Padding(padding: const EdgeInsets.all(20.0)),
          ],
        ),
      ),
    );
  }
}
