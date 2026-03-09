import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

// Main App Widget
class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Modern Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        // Add a clean modern background
        scaffoldBackgroundColor: Colors.grey[100],
        useMaterial3: true,
      ),
      home: const CalculatorScreen(),
    );
  }
}

// Calculator Screen Stateful Widget
class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  // Controllers for the input fields
  final TextEditingController _num1Controller = TextEditingController();
  final TextEditingController _num2Controller = TextEditingController();

  // Variable to hold the result or error message
  String _result = "0";

  // --- Operation Functions ---

  // Function to perform Addition
  void _add() {
    _calculate((num1, num2) => num1 + num2);
  }

  // Function to perform Subtraction
  void _subtract() {
    _calculate((num1, num2) => num1 - num2);
  }

  // Function to perform Multiplication
  void _multiply() {
    _calculate((num1, num2) => num1 * num2);
  }

  // Function to perform Division
  void _divide() {
    _calculate((num1, num2) {
      if (num2 == 0) {
        throw Exception("Cannot divide by zero");
      }
      return num1 / num2;
    });
  }

  // Helper function to handle the common logic of all operations
  void _calculate(double Function(double, double) operation) {
    // 1. Validate inputs to make sure they are not empty
    if (_num1Controller.text.isEmpty || _num2Controller.text.isEmpty) {
      setState(() {
        _result = "Error: Please enter both numbers";
      });
      return;
    }

    try {
      // 2. Parse inputs to double
      double num1 = double.parse(_num1Controller.text);
      double num2 = double.parse(_num2Controller.text);

      // 3. Perform the requested operation
      double calcResult = operation(num1, num2);

      // 4. Update the UI with the result
      setState(() {
        // Display integers without decimal points if possible
        if (calcResult == calcResult.toInt()) {
          _result = "Result: ${calcResult.toInt()}";
        } else {
          // Limit to 4 decimal places for cleaner UI
          _result = "Result: ${calcResult.toStringAsFixed(4)}";
        }
      });
    } catch (e) {
      // Catch exceptions like divide by zero or invalid letter inputs
      setState(() {
        if (e is FormatException) {
          _result = "Error: Invalid number format";
        } else {
          // Extract the exception message directly (e.g., division by zero)
          _result = e.toString().replaceAll("Exception: ", "Error: ");
        }
      });
    }
  }

  // Helper method to build calculation buttons nicely
  Widget _buildButton(String label, VoidCallback onPressed, Color color) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 20), // Button height
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), // Rounded modern buttons
        ),
        elevation: 4,
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modern Calculator'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16),
          ),
        ),
      ),
      // Padding around the entire content ensures it doesn't touch the edges
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          // SingleChildScrollView makes the UI scrollable and responsive on smaller screens
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Result Display Area using a Card
                Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
                    child: Text(
                      _result,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        // Red text for errors, deep purple for valid results
                        color: _result.startsWith("Error") ? Colors.redAccent : Colors.deepPurple,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // 2. Input Fields Area
                // First Number Input
                TextField(
                  controller: _num1Controller,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: 'First number',
                    prefixIcon: const Icon(Icons.calculate_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),

                // Second Number Input
                TextField(
                  controller: _num2Controller,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: 'Second number',
                    prefixIcon: const Icon(Icons.calculate_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 40),

                // 3. Operations Buttons Area
                // Using Row to place buttons side by side
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Addition Button
                    Expanded(
                      child: _buildButton('+', _add, Colors.blueAccent),
                    ),
                    const SizedBox(width: 16),
                    // Subtraction Button
                    Expanded(
                      child: _buildButton('-', _subtract, Colors.orangeAccent),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Multiplication Button
                    Expanded(
                      child: _buildButton('×', _multiply, Colors.green),
                    ),
                    const SizedBox(width: 16),
                    // Division Button
                    Expanded(
                      child: _buildButton('÷', _divide, Colors.redAccent),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed to prevent memory leaks
    _num1Controller.dispose();
    _num2Controller.dispose();
    super.dispose();
  }
}
