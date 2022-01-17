import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionForm extends StatefulWidget {
  // String titleInput;
  // String amountInput;
  final Function addNewTransaction;

  TransactionForm(this.addNewTransaction);

  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  //TextEditingController is like v-model for textfields
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  DateTime formDate;

  void onSubmitData() {
    final title = titleController.text;
    final amount = double.parse(amountController.text);
    if (title.isEmpty || amount <= 0 || formDate == null) {
      return;
    }

    //widget passes data from stateful
    widget.addNewTransaction(title, amount, formDate);

    //close the bottomsheet after form action
    Navigator.of(context).pop();
  }

  void openDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime.now())
        .then((value) {
      if (value == null) {
        return;
      }

      setState(() {
        formDate = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
          elevation: 5,
          child: Container(
              padding: EdgeInsets.only(
                  top: 10,
                  left: 10,
                  right: 10,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 10),
              child:
                  Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                TextField(
                  // onChanged: (val) => titleInput = val,
                  controller: titleController,
                  decoration: InputDecoration(labelText: 'Title'),
                  onSubmitted: (_) => onSubmitData(),
                ),
                TextField(
                  // onChanged: (val) => amountInput = val,
                  controller: amountController,
                  decoration: InputDecoration(labelText: 'Amount'),
                  keyboardType: TextInputType.number,
                  onSubmitted: (_) => onSubmitData(),
                ),
                Container(
                  height: 70,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(formDate == null
                          ? 'No date choosen'
                          : DateFormat.yMd().format(formDate)),
                      FlatButton(
                          textColor: Theme.of(context).primaryColor,
                          onPressed: openDatePicker,
                          child: Text('Choose date',
                              style: TextStyle(fontWeight: FontWeight.bold)))
                    ],
                  ),
                ),
                RaisedButton(
                  // margin: EdgeInsets.symmetric(vertical: 15),
                  textColor: Theme.of(context).textTheme.button.color,
                  color: Theme.of(context).primaryColor,
                  child: Text('Add Transaction'),
                  onPressed: onSubmitData,
                )
              ]))),
    );
  }
}
