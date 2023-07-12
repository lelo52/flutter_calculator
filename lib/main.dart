import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '간단한 계산기',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Calculator(),
    );
  }
}

class Calculator extends StatefulWidget {
  const Calculator({ Key? key }) : super(key: key);

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {

  String statement ="";
  String result = '0';
  final List<String> buttons = <String>[
    'C','(',')','/',
    '7','8','9','*',
    '4','5','6','+',
    '1','2','3','-',
    'AC','0','.','='
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea (
      child: Scaffold(
        backgroundColor: Colors.lightGreen[50],
        body: Column(
          children: [
            Flexible(flex:2 ,child: _resultView()),
            Expanded(flex: 4, child: _buttons()),
          ],
        ),
      ),
    );
  }

  Widget _resultView() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          padding: EdgeInsets.all(20),
          alignment: Alignment.centerRight,
          child: Text(statement,style: TextStyle(fontSize: 32),),
        ),
        Container(
          padding: EdgeInsets.all(20),
          alignment: Alignment.centerRight,
          child: Text(result,style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),),
        ),
      ],
    );
  }

  Widget _buttons() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
      itemBuilder: (context, index) {
        return _myButton(buttons[index]);
      },
      itemCount: buttons.length,
    );
  }
  Widget _myButton(String text) {
    return Container(
      margin: EdgeInsets.all(6),
      child: MaterialButton(
        onPressed: () {
          setState(() {
            clickButton(text);
          });
        },
        color: _getColor(text),
        textColor: Colors.white,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 24,
          ),
        ),
        shape: CircleBorder(),
      ),
    );
  }

  _getColor(String text) { //색을 정해주는 함수
    if(text == '=' || text=='*' || text=='-'|| text=='+' || text=='/'){
      return Colors.orangeAccent;
    }
    if(text=='C' || text=='AC'){
      return Colors.red;
    }
    if(text=='(' || text == ')') {
      return Colors.blueGrey;
    }
    
    return Colors.blueAccent;
  }

  clickButton(String text) {
    if(text =='AC') {
      statement='';
      result = '0';
      return;
    }
    if(text == 'C') {
      statement = statement.substring(0,statement.length-1);
      return;
    }
    if(text == '=') {
      result = calculate();
      return;
    }
    statement = statement+text;
  }

  calculate() {
    try {
      var exp = Parser().parse(statement);
      var ans = exp.evaluate(EvaluationType.REAL, ContextModel());
      
      return ans.toString();
    }catch(e) {
      return '에러발생';
    }
  }
}

