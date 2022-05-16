import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rental_partners/Screens/OrdersScreens/Models/invoice_model.dart';
import 'package:rental_partners/Screens/OrdersScreens/Models/orders_model.dart';

void showInvoiceModel(BuildContext context, String id) {
  showGeneralDialog(
      context: context,
      pageBuilder: (ctx, _, __) {
        return InvoiceBox(id: id);
      });
}

class InvoiceBox extends StatefulWidget {
  final String id;

  const InvoiceBox({Key? key, required this.id}) : super(key: key);

  @override
  State<InvoiceBox> createState() => _InvoiceBoxState();
}

class _InvoiceBoxState extends State<InvoiceBox> {
  final InvoiceModel _invoiceModel = InvoiceModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Invoice")),
      body: FutureBuilder<InvoiceModel>(
        future: _invoiceModel.fetchInvoice(widget.id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            InvoiceModel model = snapshot.data!;
            return SingleChildScrollView(
              child: Container(
                alignment: Alignment.topCenter,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Center(
                        child: Image.asset(
                          "assets/images/Rental.png",
                          height: 100,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const SizedBox(height: 5),
                      _rowText(
                        title: "Invoice number: ",
                        value: "#" + model.invoiceNumber.toString(),
                      ),
                      const SizedBox(height: 5),
                      _rowText(
                        title: "Date from: ",
                        value: DateFormat("MMM dd, yyyy hh:mm aa")
                            .format(model.dateFrom!),
                      ),
                      const SizedBox(height: 5),
                      _rowText(
                        title: "Date to: ",
                        value: DateFormat("MMM dd, yyyy hh:mm aa")
                            .format(model.dateTo!),
                      ),
                      const Divider(),
                      _rowText(
                        title: "Company name: ",
                        value: model.companyName,
                      ),
                      const Divider(),
                      const SizedBox(height: 5),
                      _rowText(
                        title: "Client name: ",
                        value: model.client.toString(),
                      ),
                      const SizedBox(height: 5),
                      _rowText(
                        title: "Client address: ",
                        value: model.clientAddress.toString(),
                      ),
                      const SizedBox(height: 5),
                      _rowText(
                        title: "Billing address: ",
                        value: model.billingAddress,
                      ),
                      const Divider(),
                      Text(
                        "Items",
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyText1!.color,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 6),
                      DataTable(
                        columnSpacing: 10,
                        border: TableBorder.all(
                          color: Theme.of(context).highlightColor,
                        ),
                        columns: const [
                          DataColumn(
                            label: Text(
                              'SN',
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
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            numeric: true,
                          ),
                          DataColumn(
                            label: Text(
                              'Total Amount',
                              style: TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            numeric: true,
                          ),
                        ],
                        rows: snapshot.data!.items.map((e) {
                          int index = snapshot.data!.items.indexOf(e) + 1;
                          return DataRow(cells: [
                            DataCell(Text(
                              index.toString(),
                              style: const TextStyle(fontSize: 11),
                            )),
                            DataCell(Text(
                              e.name + " (" + e.timePeriod + ")",
                              style: const TextStyle(fontSize: 11),
                            )),
                            DataCell(Text(
                              e.quantity.toString(),
                              textAlign: TextAlign.right,
                              style: const TextStyle(fontSize: 11),
                            )),
                            DataCell(
                              Text(
                                "NRs. " + f.format(e.unitPrice),
                                textAlign: TextAlign.right,
                                style: const TextStyle(fontSize: 11),
                              ),
                            ),
                            DataCell(
                              Text(
                                "NRs. " + f.format(e.totalAmount),
                                style: const TextStyle(fontSize: 11),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ]);
                        }).toList(),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Correction",
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyText1!.color,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 6),
                      DataTable(
                        columnSpacing: 10,
                        border: TableBorder.all(
                          color: Theme.of(context).highlightColor,
                        ),
                        columns: const [
                          DataColumn(
                            label: Text(
                              'SN',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            numeric: true,
                          ),
                          DataColumn(
                            label: Text(
                              'Type',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Amount',
                              style: TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            numeric: true,
                          ),
                        ],
                        rows: snapshot.data!.corrections.map((e) {
                          int index = snapshot.data!.corrections.indexOf(e) + 1;
                          return DataRow(cells: [
                            DataCell(Text(
                              index.toString(),
                              style: const TextStyle(fontSize: 11),
                            )),
                            DataCell(Text(
                              e.type,
                              style: const TextStyle(fontSize: 11),
                            )),
                            DataCell(Text(
                              "NRs. " + f.format(e.amount),
                              textAlign: TextAlign.right,
                              style: const TextStyle(fontSize: 11),
                            )),
                          ]);
                        }).toList(),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Breakdown",
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyText1!.color,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 6),
                      DataTable(
                        columnSpacing: 10,
                        border: TableBorder.all(
                          color: Theme.of(context).highlightColor,
                        ),
                        columns: const [
                          DataColumn(
                            label: Text(
                              'SN',
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
                              'Amount',
                              style: TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            numeric: true,
                          ),
                        ],
                        rows: snapshot.data!.breakdowns.map((e) {
                          int index = snapshot.data!.breakdowns.indexOf(e) + 1;
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
                              "(NRs. " + f.format(e.amount) + ")",
                              textAlign: TextAlign.right,
                              style: const TextStyle(fontSize: 11),
                            )),
                          ]);
                        }).toList(),
                      ),
                      const SizedBox(height: 20),
                      _rowText(
                        title: "Sub-total: ",
                        value: "NRs. " + f.format(snapshot.data!.subTotal),
                      ),
                      const SizedBox(height: 4),
                      _rowText(
                        title: "Tax(13%): ",
                        value: "NRs. " + f.format(snapshot.data!.taxAmount),
                      ),
                      const Divider(),
                      _rowText(
                        title: "Grand total: ",
                        value: "NRs. " + f.format(snapshot.data!.totalAmount),
                        isBold: true,
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return const Center(child: CupertinoActivityIndicator());
          }
        },
      ),
    );
  }

  Widget _rowText(
      {required String title, required String value, bool isBold = false}) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 3),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).textTheme.bodyText1!.color,
                fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
