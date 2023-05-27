import 'package:flutter/material.dart';

class CounterTextFormField extends StatefulWidget {
  TextEditingController controller = TextEditingController();
   CounterTextFormField({Key key,this.controller}) : super(key: key);
  @override
  CounterTextFormFieldState createState() => CounterTextFormFieldState();
}

class CounterTextFormFieldState extends State<CounterTextFormField> {

  void _incrementCounter() {
    setState(() {
      double currentValue = double.parse(widget.controller.text != null ? widget.controller.text : 0);
      setState(() {
        currentValue++;
        widget.controller.text = (currentValue)
            .toString(); // incrementing value
      });
    });
  }

  void _decrementCounter() {
    setState(() {
      double currentValue = double.parse(widget.controller.text != null ? widget.controller.text : 0);
      currentValue--;
      widget.controller.text =
          (currentValue > 0 ? currentValue : 0)
              .toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 5,),
        GestureDetector(
          onTap: () {
            _incrementCounter();
          },
            child: Icon(Icons.add,color: Colors.grey,size: 18,)),
        Spacer(),
        Expanded(
          child: TextFormField(
            textAlign: TextAlign.center,
            cursorHeight: 0,
            cursorWidth: 0,
            controller: widget.controller,
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
          ),
        ),
        Spacer(),
        GestureDetector(
          onTap: (){
            _decrementCounter();
          },
            child: Icon(Icons.remove,color: Colors.grey,size: 18,)),
        SizedBox(width: 5,)
      ],
    );
  }
}