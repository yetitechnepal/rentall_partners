import 'package:dio/dio.dart';
import 'package:rental_partners/Singletons/api_call.dart';

class InvoiceItemModel {
  late int id;
  late String name, timePeriod = "";
  late int quantity;
  late double unitPrice, totalAmount, subTotal;
  InvoiceItemModel.fromMap(map) {
    id = map['item_id'] ?? 0;
    name = map['item_name'] ?? "";
    quantity = map['frequency'] ?? 0;
    unitPrice = map['unit_price'] ?? 0;
    var priceList = map['price_list'];
    subTotal = unitPrice;
    for (var price in priceList) {
      if (price.containsKey("total_month") && price['total_month'] != "") {
        subTotal *= price['total_month'] * 8 * 26;
        timePeriod += "X" + price['total_month'].toString() + " Mon ";
      }
      if (price.containsKey("total_day") && price['total_day'] != "") {
        subTotal *= price['total_day'] * 8;
        timePeriod += "X" + price['total_day'].toString() + " Days ";
      }
      if (price.containsKey("total_hr") && price['total_hr'] != "") {
        subTotal *= price['total_hr'];
        timePeriod += "X" + price['total_hr'].toString() + " Hr ";
      }
    }
    totalAmount = subTotal * quantity;
  }
}

class Correction {
  late String type;
  late double amount;
  Correction.fromMap(json) {
    type = json['correction_type'] ?? "";
    amount = json['amount'] ?? 0;
  }
}

class Breakdown {
  late String name;
  late double amount;
  Breakdown.frommap(map) {
    name = map['item'] ?? "";
    amount = map['amount'] ?? 0;
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

  List<Correction> corrections = [];
  List<Breakdown> breakdowns = [];

  double subtotal = 0;

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
    items = [];
    map['items'].forEach((mapp) {
      items.add(InvoiceItemModel.fromMap(mapp));
    });
    corrections = [];
    for (var json in map['correction_item']) {
      corrections.add(Correction.fromMap(json));
    }
    breakdowns = [];
    for (var json in map['breakdown']) {
      breakdowns.add(Breakdown.frommap(json));
    }
    calculate();
  }

  calculate() {
    subTotal = 0;
    for (var item in items) {
      subTotal += item.totalAmount;
    }
    for (var correction in corrections) {
      subTotal += correction.amount;
    }

    for (var breakdown in breakdowns) {
      subTotal -= breakdown.amount;
    }
    taxAmount = subTotal * 0.13;
    totalAmount = subTotal + taxAmount;
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
