import 'package:expressions/expressions.dart';
import 'package:flutter/material.dart';
import 'package:my_calculator_app/history_screen.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  bool isDarkMode = true;
  String input = '';
  String result = '0';
  bool isNewOperation = true;
  bool decimalAdded = false;
  List<String> history = [];

  void onButtonPressed(String buttonText){
    setState(() {
      if(buttonText =='C'){
        input = '';
        result = '0';
        isNewOperation = true;
        decimalAdded = false;
      }
      else if (buttonText == '⌫'){
        if(input.isNotEmpty) {
          input = input.substring(0, input.length - 1);
          if(input.isEmpty) result = '0';
        }
        if(!input.endsWith('.')) decimalAdded = false;
      }
      else if('+-x/'.contains(buttonText)){
        if(isNewOperation) {
          input = result;
          isNewOperation = false;
        }
        if(input.isNotEmpty && !'+-x/'.contains(input[input.length - 1])) {
          input += buttonText;
          decimalAdded = false;
        }
      } else if(buttonText == '='){
        calculate();
        isNewOperation = true;
        decimalAdded = false;
        history.add('$input = $result');
      } else if(buttonText == '.'){
        if(!decimalAdded){
          if(input.isEmpty || "+-x/".contains(input[input.length - 1])) {
            input += '0.';
          } else {
            input += '.';
          }
          decimalAdded = true;
          isNewOperation = false;
        }
      } else if(buttonText == '%'){
        if(input.isNotEmpty && double.tryParse(input) != null){
          applyStandalonePercentage();
        } else {
          input += '%';
        }
      } else if(buttonText =='+/-'){
        if(input.isNotEmpty && double.tryParse(input) != null){
          double number = double.parse(input);
          number = -number;
          input = number == number.toInt() ? number.toInt().toString() : number.toString();
          result = input;
        }
      } else {
        if (isNewOperation) {
          input = buttonText == '0' ? '0' : buttonText;
          isNewOperation = false;
        }
        else{
          input += buttonText;
        }
      }
    },
    );
  }

  void applyStandalonePercentage() {
    if (input.isNotEmpty && double.tryParse(input) !=null){
      double standalonePercentage =double.parse(input) /100;
      result = _formatResult(standalonePercentage);
    }
  }


  void calculate() {
    try {
      String expression = input.replaceAllMapped(RegExp(r'(\d+(\.\d+)?)%'), (match) {
        double percentage = double.parse(match.group(1)!);
        int lastIndex = match.start - 1;
        String prefix = input.substring(0, lastIndex);
        String precedingNumberPattern = r'(\d+(\.\d+)?)$';
        final matchPreceding = RegExp(precedingNumberPattern).firstMatch(prefix);
        if(matchPreceding != null){
          double precedingValue = double.parse(matchPreceding.group(1)!);
          double result = precedingValue * (percentage /100);
          return result.toString();
        }else {
          return '${percentage / 100}';
        }
    },
      );
    expression = expression.replaceAll('x', '*');
    const evaluator = ExpressionEvaluator();
    final parseExpression = Expression.parse(expression);
    final resultValue = evaluator.eval(parseExpression, {});
    result = _formatResult(resultValue.toDouble());
    }
    catch(e){
    result = 'Error';
  }
}

String _formatResult(double result){
    return result == result.toInt() ? result.toInt().toString() : result.toString();
}

  Widget buildButton(String text, Color color, double fontSize, double padding,
      bool isLandscape) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(isLandscape ? padding * 2.5 : padding * 3),
        shape: const CircleBorder(),
        backgroundColor: color,
        elevation: 6,
      ),
      onPressed: () => onButtonPressed(text),
      child: Text(
        text,
        style: TextStyle(
          fontSize: isLandscape ? fontSize * 0.8 : fontSize,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
  void openHistoryScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => HistoryScreen(
        history : history,
        onHistoryCleared: (clearedHistory) {
          setState(() {
            history = clearedHistory;
          });
        }
      ))
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    bool isLandscape = screenWidth > screenHeight;

    double fontSize = isLandscape ? screenHeight * 0.06 : screenWidth * 0.07;
    double padding = isLandscape ? screenHeight * 0.01 : screenWidth * 0.015;
    double buttonFontSize =
        isLandscape ? screenHeight * 0.08 : screenWidth * 0.09;

    final backgroundColor = isDarkMode ? const Color(0xFF121212) : const Color(0xFFFAFAFA);
    final buttonColor = isDarkMode ? const Color(0xFAF39CC2) : const Color(0xFF00FF07);
    final operatorColor = isDarkMode ? const Color(0xFF6A4EFB) : const Color(0xFF5B67E3);
    final equalsColor = isDarkMode ? const Color(0xFFFF6F61) : const Color(0xFFE34234);
    final textColor = isDarkMode ? Colors.white : Colors.black;

    List<List<String>> buttonLayout = isLandscape
        ? [
            ['C', '⌫', '%', '/', 'x', '-', '+', '='],
            ['7', '8', '9', '4', '5', '6', '.', '0'],
            ['1', '2', '3', '+/-'],
          ]
        : [
            ['C', '⌫', '%', '/'],
            ['7', '8', '9', 'x'],
            ['4', '5', '6', '-'],
            ['1', '2', '3', '+'],
            ['+/-', '0', '.', '='],
          ];

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(padding * 1.5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: openHistoryScreen,
                    icon: const Icon(
                      Icons.history,
                      color: Colors.pinkAccent,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        isDarkMode ? 'Light' : 'Dark',
                        style: TextStyle(
                            color: textColor, fontSize: fontSize * 0.5),
                      ),
                      Switch(
                        value: isDarkMode,
                        onChanged: (value) {
                          setState(() {
                            isDarkMode = value;
                          });
                        },
                        activeColor: Colors.pinkAccent,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: padding * 2),
              color: backgroundColor,
              height: 150,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          input.isNotEmpty ? input : '0',
                          style: TextStyle(
                            fontSize: fontSize * 1.5,
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: padding * 1.5),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          result,
                          style: TextStyle(
                            fontSize: fontSize * 2,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: buttonLayout.map((row) {
                return Flexible(
                  child: Row(
                    mainAxisAlignment: isLandscape
                        ? MainAxisAlignment.spaceEvenly
                        : MainAxisAlignment.spaceAround,
                    children: row.map(
                      (buttonText) {
                        return buildButton(
                            buttonText,
                            buttonText == '='
                                ? equalsColor
                                : ['+', '-', '*', '/', '%', '+/-']
                                        .contains(buttonText)
                                    ? operatorColor
                                    : buttonColor,
                            buttonFontSize * (isLandscape ? 0.8 : 1.0),
                            padding * (isLandscape ? 0.6 : 0.8),
                            isLandscape);
                      },
                    ).toList(),
                  ),
                );
              }).toList(),
            ))
          ],
        ),
      ),
    );
  }
}
