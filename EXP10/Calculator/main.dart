// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart'
    show Parser, Expression, ContextModel, EvaluationType;
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart'; // ✅ Added

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseAnalytics.instance.logEvent(name: 'app_started'); // ✅ Analytics event
  runApp(const CalculatorApp());
}

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

  void saveCalculation(String input, String result) {
    FirebaseFirestore.instance.collection('calculations').add({
      'input': input,
      'result': result,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  void buttonPressed(String value) {
    setState(() {
      if (value == 'C') {
        input = '';
        result = '';
      } else if (value == '=') {
        try {
          Parser p = Parser();
          Expression exp = p.parse(
            input.replaceAll('×', '*').replaceAll('÷', '/'),
          );
          ContextModel cm = ContextModel();
          double eval = exp.evaluate(EvaluationType.REAL, cm);
          result = eval.toString();
          saveCalculation(input, result); // 🔥 Save to Firestore
        } catch (e) {
          result = 'Error';
        }
      } else {
        input += value;
      }
    });
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

  @override
  Widget build(BuildContext context) {
    final buttonLabels = [
      ['7', '8', '9', '÷'],
      ['4', '5', '6', '×'],
      ['1', '2', '3', '-'],
      ['C', '0', '=', '+'],
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CalculationHistoryPage(),
                ),
              );
            },
          ),
        ],
      ),
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
    );
  }
}

class CalculationHistoryPage extends StatelessWidget {
  const CalculationHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calculation History')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('calculations')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading history'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(child: Text('No history yet'));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final input = data['input'] ?? '';
              final result = data['result'] ?? '';
              final timestamp = data['timestamp']?.toDate();

              return ListTile(
                title: Text('$input = $result'),
                subtitle: timestamp != null
                    ? Text('${timestamp.toLocal()}')
                    : null,
              );
            },
          );
        },
      ),
    );
  }
}
