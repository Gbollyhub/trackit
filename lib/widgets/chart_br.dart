import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String label;
  final double spendingAmount;
  final double spendingPer;

  ChartBar(this.label, this.spendingAmount, this.spendingPer);
  @override
  Widget build(BuildContext context) {
    //used to control layouts in respect to heights so its responsive across screens
    return LayoutBuilder(builder: (ctx, contraints) {
      return Column(
        children: [
          Container(
              height: contraints.maxHeight * 0.15,
              //FittedBox is for tet responsiveness so its shrinks if it overflows
              child: FittedBox(
                  child: Text('\$${spendingAmount.toStringAsFixed(0)}'))),
          //Sizedbox is like <BR> to create a space
          SizedBox(height: contraints.maxHeight * 0.05),
          Container(
            height: contraints.maxHeight * 0.6,
            width: 10,
            //Stack is like an Overflow Content, place widget on widget
            child: Stack(
              children: [
                Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1.0),
                        color: Color.fromRGBO(220, 220, 220, 1),
                        borderRadius: BorderRadius.circular(10))),
                //FractionBox take a dynamic height, from the name take a particular fraction- 0-1
                FractionallySizedBox(
                  heightFactor: spendingPer,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.purple,
                        borderRadius: BorderRadius.circular(10)),
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: contraints.maxHeight * 0.05),
          Container(
              height: contraints.maxHeight * 0.15,
              child: FittedBox(child: Text(label)))
        ],
      );
    });
  }
}
