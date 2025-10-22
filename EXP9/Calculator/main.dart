import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'database_helper.dart';

void main() => runApp(const CalculatorApp());

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stylish Calculator',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: const CalculatorPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String input = '';
  String result = '';

  Future<void> buttonPressed(String value) async {
    if (value == 'C') {
      setState(() {
        input = '';
        result = '';
      });
    } else if (value == '=') {
      try {
        final p = ShuntingYardParser();
        Expression exp = p.parse(
          input.replaceAll('×', '*').replaceAll('÷', '/'),
        );
        ContextModel cm = ContextModel();
        double eval = exp.evaluate(EvaluationType.REAL, cm);

        setState(() {
          result = eval.toString();
        });

        await DatabaseHelper().insertCalculation(input, result);
      } catch (e) {
        setState(() {
          result = 'Error';
        });
      }
    } else {
      setState(() {
        input += value;
      });
    }
  }

  Widget buildButton(String text, {Color? color}) {
    return ElevatedButton(
      onPressed: () => buttonPressed(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? const Color.fromARGB(255, 147, 209, 214),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.all(24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 6,
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  void showHistory() async {
    final history = await DatabaseHelper().getHistory();
    if (!mounted) return; // ✅ Fix for warning 3

    showModalBottomSheet(
      context: context,
      builder: (_) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              '🧮 Calculation History',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: history.length,
                itemBuilder: (context, index) {
                  final entry = history[index];
                  return ListTile(
                    leading: const Icon(Icons.history),
                    title: Text(entry['input']),
                    subtitle: Text('= ${entry['result']}'),
                  );
                },
              ),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                await DatabaseHelper().clearHistory();
                if (!mounted) return; // ✅ Fix for warning 4
                Navigator.pop(context);
              },
              icon: const Icon(Icons.delete),
              label: const Text('Clear History'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final buttonLabels = [
      ['7', '8', '9', '÷'],
      ['4', '5', '6', '×'],
      ['1', '2', '3', '-'],
      ['C', '0', '=', '+'],
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Calculator')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
              child: Text(
                input,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                result,
                style: const TextStyle(fontSize: 28, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                itemCount: buttonLabels.expand((row) => row).length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                ),
                itemBuilder: (context, index) {
                  final flatList = buttonLabels.expand((row) => row).toList();
                  final label = flatList[index];
                  final isOperator = [
                    '+',
                    '-',
                    '×',
                    '÷',
                    '=',
                    'C',
                  ].contains(label);
                  final color = isOperator
                      ? Colors.orangeAccent
                      : Colors.deepPurpleAccent;
                  return buildButton(label, color: color);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showHistory,
        child: const Icon(Icons.history),
      ),
    );
  }
}
