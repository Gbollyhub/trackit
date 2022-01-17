import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transaction_array;
  final Function deleteTransaction;
  TransactionList(this.transaction_array, this.deleteTransaction);

  @override
  Widget build(BuildContext context) {
    return transaction_array.isEmpty
        ? LayoutBuilder(builder: (ctx, contraints) {
            return Column(
              children: [
                Container(
                    margin: EdgeInsets.symmetric(vertical: 50, horizontal: 0),
                    height: contraints.maxHeight * 0.3,
                    child: Image.asset('assets/images/waiting.png',
                        fit: BoxFit.cover)),
                Container(
                  height: contraints.maxHeight * 0.05,
                  child: Text("No Transaction was found",
                      style: TextStyle(
                          fontSize:
                              20 * MediaQuery.of(context).textScaleFactor)),
                ),
              ],
            );
          })
        //ListViewBuilder is a preset layout for listing
        : ListView.builder(
            //return the list you want to loop
            itemBuilder: (ctx, index) {
              return Card(
                elevation: 5,
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: ListTile(
                  leading: CircleAvatar(
                      radius: 30,
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: FittedBox(
                            child: Text(
                                '\$ ${transaction_array[index].amount.toStringAsFixed(2)}')),
                      )),
                  title: Text(transaction_array[index].title,
                      style: Theme.of(context).textTheme.title),
                  subtitle: Text(
                    DateFormat.yMMMd().format(transaction_array[index].date),
                  ),
                  trailing: MediaQuery.of(context).size.width > 360
                      ? FlatButton.icon(
                          icon: Icon(Icons.delete),
                          label: const Text('Delete'),
                          textColor: Theme.of(context).errorColor,
                          onPressed: () {
                            deleteTransaction(transaction_array[index].id);
                          })
                      : IconButton(
                          icon: Icon(Icons.delete),
                          color: Colors.red,
                          onPressed: () {
                            deleteTransaction(transaction_array[index].id);
                          }),
                ),
              );
            },
            //length of your list
            itemCount: transaction_array.length);
  }
}

//
// Card(
// child: Container(
// margin: EdgeInsets.all(20),
// child: Row(
// mainAxisAlignment: MainAxisAlignment.spaceBetween,
// children: [
// Container(
// padding: EdgeInsets.all(20),
// decoration: BoxDecoration(
// border: Border.all(
// color: Theme.of(context).primaryColor,
// width: 2)),
// child: Text(
// //roundup to the nearest 2 decimal place
// '\$ ${transaction_array[index].amount.toStringAsFixed(2)}',
// style: TextStyle(
// fontWeight: FontWeight.bold,
// fontSize: 20,
// color: Colors.purple),
// ),
// ),
// Column(
// mainAxisAlignment: MainAxisAlignment.spaceBetween,
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// Container(
// child: Text(
// transaction_array[index].title,
// style: Theme.of(context).textTheme.title,
// ),
// ),
// Container(
// //formats date
// child: Text(
// DateFormat.yMMMd()
// .format(transaction_array[index].date),
// style: TextStyle(
// fontSize: 15, color: Colors.grey),
// ),
// )
// ],
// )
// ],
// ),
// ),
// elevation: 5,
// );
