import 'package:flutter/material.dart';
import '../game.dart';

class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  var _input = '';
  var _feedback = '';
  var count = 0;
  final _game = Game();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GUESS THE NUMBER')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(50.0),
                decoration: BoxDecoration(
                  color: Colors.purple.shade50,
                  border: Border.all(
                    color: Colors.purple.shade50,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Expanded(flex: 1, child: _buildLogoPanel()),
              ),
              if (_input != '') Text(_input),
              if (_feedback != '') Text(_feedback),
              _buildButtonPanel(),
              ElevatedButton(
                onPressed: () {
                  var guess = int.tryParse(_input);
                  if (guess == null) {
                    // todo: ดัก error กรณีแปลง _input เป็น int ไม่ได้ (เช่น มีตัวอักษรที่ไม่ใช่ตัวเลขใน _input)
                  }
                  var result = _game.doGuess(guess!);
                  if (result == Result.correct) {
                    setState(() {
                      count++;
                      _feedback = '$_input : ถูกต้อง 🎉 (ทาย $count ครั้ง)';
                      count=0;
                    });
                  } else if (result == Result.tooHigh) {
                    setState(() {
                      count++;
                      _feedback = '$_input : มากเกินไป';
                      _input = '';
                    });
                  } else if (result == Result.tooLow) {
                    setState(() {
                      count++;
                      _feedback = '$_input : น้อยเกินไป';
                      _input = '';
                    });
                  }
                },
                child: const Text('GUESS'), )
            ]
        )
      )
    );
  }

  Row _buildLogoPanel() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/images/guess_logo.png', width: 70.0),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('GUESS',style: TextStyle(fontSize: 28.0, color: Colors.purpleAccent)),
            Text('THE NUMBER', style: TextStyle(color: Colors.purple)),
          ],
        )
      ],
    );
  }

  void _handleClickButton(item) {
    setState(() {
      if (item == -1) {
        _input = _input.substring(0, _input.length - 1);
      } else if (item == -2) {
        _input = '';
      } else {
        _input += item.toString();
      }
    });
  }

  Widget _buildButtonPanel() {
    return Column(
      children: [
        const Text('ทายเลขตั้งแต่ 1 ถึง 100'),
        Column(
          children: [
            [1, 2, 3],
            [4, 5, 6],
            [7, 8, 9],
            [-2, 0, -1],
          ].map((row) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: row.map((item) {
                return MyButton(
                  num: item,
                  callback: () {
                    _handleClickButton(item);
                  },
                );
              }).toList(),
            );
          }).toList(),
        )
      ],
    );
  }
}

class MyButton extends StatelessWidget {
  final int num;
  final Function() callback;

  const MyButton({
    Key? key,
    required this.num,
    required this.callback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (num == -1) {
      child = const Icon(Icons.backspace_outlined, size: 16.0);
    } else if (num == -2) {
      child = const Icon(Icons.close, size: 16.0);
    } else {
      child = Text(num.toString());
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: OutlinedButton(
        onPressed: callback,
        child: child,
      ),
    );
  }
}