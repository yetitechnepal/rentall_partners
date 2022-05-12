import 'package:dio/dio.dart';
import 'package:rental_partners/Singletons/api_call.dart';

class InvoiceItemModel {
  late int id;
  late String name;
  late int quantity;
  late double unitPrice, totalAmount;
  InvoiceItemModel.fromMap(map) {
    id = map['item_id'] ?? 0;
    name = map['item_name'] ?? "";
    quantity = map['frequency'] ?? 0;
    unitPrice = map['unit_price'] ?? 0;
    totalAmount = map['bookitem_amount'] ?? 0;
  }
}

class InvoiceModel {
  late int invoiceId, invoiceNumber;
  late String companyName, logo, billingAddress, client, clientAddress, footer;
  late double promotionDiscount,
      offerDiscount,
      subTotal,
      totalAmount,
      taxAmount;
  late DateTime? invoiceDate, dueDate, dateFrom, dateTo;
  List<InvoiceItemModel> items = [];

  fromMap(map) {
    invoiceId = map['invoice_id'] ?? 0;
    invoiceNumber = map['invoice_number'] ?? 0;
    companyName = map['company'] ?? "";
    logo = map['logo'] ?? "";
    billingAddress = map['billing_address'] ?? "";
    client = map['client'] ?? "";
    clientAddress = map['client_address'] ?? "";
    footer = map['footer'] ?? "";
    promotionDiscount = map['promo'] ?? 0.0;
    offerDiscount = map['discount_amount'] ?? 0;
    subTotal = map['sub_total'] ?? 0.0;
    totalAmount = map['total_amounts'] ?? 0.0;
    taxAmount = map['tax_amount'] ?? 0.0;
    invoiceDate = DateTime.tryParse(map['invoice_date']);
    dueDate = DateTime.tryParse(map['due_date']);
    dateFrom = DateTime.tryParse(map['date_from']);
    dateTo = DateTime.tryParse(map['date_to']);
    map['items'].forEach((mapp) {
      items.add(InvoiceItemModel.fromMap(mapp));
    });
  }

  Future<InvoiceModel> fetchInvoice(String id) async {
    Response response =
        await API().get(endPoint: "payment/$id/invoice-details/");
    if (response.statusCode == 200) {
      fromMap(response.data['data']);
    }
    return this;
  }
}
