
import 'package:flutter/material.dart';

class CounterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CounterState();
  }
}

class _CounterState extends State<CounterPage> {
  final TextStyle _textStyle = TextStyle( fontSize: 25 );
  int _numberOfClicks = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Counter Page"),
        centerTitle: true,
      ),
      body: Center(
          child: Column(
            children: <Widget>[
              Text("Number of clicks: ", style: _textStyle),
              Text("$_numberOfClicks",  style: _textStyle),
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          )
      ),
      floatingActionButton: _createActionButtons(),
    );
  }

  Widget _createActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        SizedBox(width: 30.0),
        FloatingActionButton(
          child: Icon(Icons.clear),
          onPressed: this._resetCounter,
        ),
        Expanded(child: SizedBox()),
        FloatingActionButton(
          child: Icon(Icons.remove),
          onPressed: this._removeFromCounter,
        ),
        SizedBox(width: 5.0),
        FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: this._addToCounter,
        ),
      ],
    );
  }

  void _addToCounter() {
    setState(() => _numberOfClicks++);
  }

  void _removeFromCounter() {
    setState(() {
      if (_numberOfClicks == 0) {
        return;
      }
      _numberOfClicks--;
    });
  }

  void _resetCounter() {
    setState(() => _numberOfClicks = 0);
  }
}