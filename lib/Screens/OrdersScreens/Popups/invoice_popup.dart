import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rental_partners/Screens/OrdersScreens/Models/invoice_model.dart';

void showInvoiceModel(BuildContext context, int id) {
  showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return InvoiceBox();
      });
}

class InvoiceBox extends StatelessWidget {
  final InvoiceModel _invoiceModel = InvoiceModel();

  InvoiceBox({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    int index = 0;
    return FutureBuilder<InvoiceModel>(
      future: _invoiceModel.fetchInvoice(10),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SafeArea(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(
                    label: Text(
                      'ID',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    numeric: true,
                  ),
                  DataColumn(
                    label: Text(
                      'Name',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Quantity',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    numeric: true,
                  ),
                  DataColumn(
                    label: Text(
                      'Unit Amount',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    numeric: true,
                  ),
                  DataColumn(
                    label: Text(
                      'Total Amount',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    numeric: true,
                  ),
                ],
                rows: snapshot.data!.items.map((e) {
                  index++;
                  return DataRow(cells: [
                    DataCell(Text(
                      index.toString(),
                      style: const TextStyle(fontSize: 11),
                    )),
                    DataCell(Text(
                      e.name,
                      style: const TextStyle(fontSize: 11),
                    )),
                    DataCell(Text(
                      e.quantity.toString(),
                      style: const TextStyle(fontSize: 11),
                    )),
                    DataCell(Text(
                      e.unitPrice.toString(),
                      style: const TextStyle(fontSize: 11),
                    )),
                    DataCell(Text(
                      e.totalAmount.toString(),
                      style: const TextStyle(fontSize: 11),
                    )),
                  ]);
                }).toList(),
              ),
            ),
          );
        } else {
          return SafeArea(
              child: Container(
                  padding: const EdgeInsets.all(20),
                  child: const CupertinoActivityIndicator()));
        }
      },
    );
  }
}
