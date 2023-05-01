import 'package:flutter/material.dart';

class Nodata extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text("No Data", style: TextStyle(color: Colors.grey, fontSize: 20),),
      ),
    );
  }
}
