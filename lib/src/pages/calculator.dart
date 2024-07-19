import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:math_expressions/math_expressions.dart' as math_expressions;

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final TextEditingController _controller = TextEditingController();
  double _result = 0.0;

  void _calculate(String value) {
    setState(() {
      _controller.text += value;
    });
  }

  void _clear() {
    setState(() {
      _controller.clear();
      _result = 0.0;
    });
  }

  void _evaluate() {
    setState(() {
      String expression = _controller.text.trim();

      if (expression.isEmpty) {
        _result = 0.0;
      } else {
        try {
          // Evaluate the expression
          math_expressions.Parser parser = math_expressions.Parser();
          math_expressions.Expression exp = parser.parse(expression);
          _result = exp.evaluate(math_expressions.EvaluationType.REAL,
              math_expressions.ContextModel());
        } catch (e) {
          print('Error evaluating expression: $e');
          _result = 0.0;
        }
      }

      // Store result in Firestore
      _storeResult(_result);

      // Clear input field
      _controller.clear();
    });
  }

  void _storeResult(double result) async {
    await FirebaseFirestore.instance.collection('calculations').add({
      'result': result,
      'timestamp': Timestamp.now(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator'),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HistoryScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              alignment: Alignment.centerRight,
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: SingleChildScrollView(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        style: const TextStyle(fontSize: 24),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter expression',
                        ),
                        readOnly: true,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      '$_result',
                      style: const TextStyle(
                          fontSize: 24, color: Colors.deepPurple),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: GridView.count(
              crossAxisCount: 4,
              padding: const EdgeInsets.all(16.0),
              children: [
                _buildButton('7'),
                _buildButton('8'),
                _buildButton('9'),
                _buildButton('/'),
                _buildButton('4'),
                _buildButton('5'),
                _buildButton('6'),
                _buildButton('*'),
                _buildButton('1'),
                _buildButton('2'),
                _buildButton('3'),
                _buildButton('-'),
                _buildButton('0'),
                _buildButton('.'),
                _buildButton('='),
                _buildButton('+'),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _clear,
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.clear),
      ),
    );
  }

  Widget _buildButton(String value) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          if (value == '=') {
            _evaluate();
          } else {
            _calculate(value);
          }
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(20.0),
          iconColor: Colors.deepPurple,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(value, style: const TextStyle(fontSize: 24)),
      ),
    );
  }
}

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculation History'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('calculations')
                .orderBy('timestamp', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No history available.'));
              }

              final calculations = snapshot.data!.docs;

              return ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: calculations.length,
                itemBuilder: (context, index) {
                  final data =
                      calculations[index].data() as Map<String, dynamic>;
                  final result = data['result'];
                  final timestamp = (data['timestamp'] as Timestamp).toDate();

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16.0),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple[50],
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 3,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.history, color: Colors.deepPurple),
                            const SizedBox(width: 10),
                            Text(
                              'Result: $result',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(Icons.access_time,
                                color: Colors.deepPurple),
                            const SizedBox(width: 10),
                            Text(
                              'Timestamp: ${timestamp.toLocal()}',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
