import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:rental_partners/Blocs/filter_bloc.dart';
import 'package:rental_partners/Blocs/order_status_bloc.dart';
import 'package:rental_partners/Enums/orders_types.dart';
import 'package:rental_partners/Singletons/api_call.dart';
import 'package:rental_partners/main.dart';

final f = NumberFormat("#,##,###.0#", "en_US");

// {
//   invoice_number: 1000,
//   fuel_included: false,
//   order_location: kathmandu,
//   company: Testing garne account ho hora,
//   profile:  billing_address: Nepal,Lalitpur,Bagmati, i
//   tem: [
//     {
//       item_id: 5,
//       item_name: equip 22, price_list:
//       [
//       {per/hr: 1050.0, total_hr: 1},
//       {per/day: , total_day: }, {per/mon: , total_month: }],

//       bookitem_amount: 1050.0,
//       frequency: 1,
//       image: http://192.168.1.71:4000/media/media/gallery/equipment1651137062230.png
//     }
//   ],
//   correction_item: [], breakdown: [], status: Completed, status_id: 4,
//   invoice_amounts: 1050.0,
//   total_amounts: 1186.5,
//   book_id: 217,
//   order_by: admin panel,
//   tax_amount: 136.5,
//   promotion_discount: 105.0,
//   offer_discount: 0.0,
//   paid: 0.0,
//   due: 1186.5,
//   order_date: 2022-05-16,
//   date_from: 2021-01-02T03:05:06+05:45,
//   date_to: 2021-01-02T04:05:06+05:45
// }

class Adjustment {
  late String type;
  late double amount;

  Adjustment.fromMap(map) {
    type = map['correction_type'];
    amount = map['amount'];
  }
}

class Breakdown {
  late String type;
  late double amount;

  Breakdown.fromMap(map) {
    type = map['item'];
    amount = map['amount'];
  }
}

class OrderItem {
  late int id;
  late String name;
  late double bookingAmount;
  late int frequency;
  late String image;
  String priceBreakDown = "";

  OrderItem.fromMap(map) {
    id = map['item_id'] ?? 0;
    name = map['item_name'] ?? "";
    bookingAmount = map['base_rate'] ?? 0;
    frequency = map['frequency'] ?? 0;
    image = map['image'] ?? "";
    map["price_list"].forEach((price) {
      if (price.containsKey("total_month")) {
        if (price["total_month"] != "") {
          bookingAmount *= price['total_month'] * 8 * 26;
          priceBreakDown += "X" + price['total_month'].toString() + "months";
        }
      }
      if (price.containsKey("total_day")) {
        if (price["total_day"] != "") {
          bookingAmount *= price['total_day'] * 8;
          priceBreakDown += "X" + price['total_day'].toString() + "days";
        }
      }
      if (price.containsKey("total_hr")) {
        if (price["total_hr"] != "") {
          bookingAmount *= price['total_hr'];
          priceBreakDown += "X" + price['total_hr'].toString() + "hrs";
        }
      }
    });
    bookingAmount *= frequency;
  }
}

class Order {
  late String invoiceNumber,
      orderLocation,
      company,
      profile,
      bilingAddress,
      status,
      invoiceAmount,
      totalAmount,
      orderBy,
      taxAmount,
      paid,
      due;
  late int statusId, bookId;
  late bool isFuelIncluded;
  late DateTime orderDate, dateFrom, dateTo;
  late OrderTypes orderType;

  late double promo, offer, subTotal, grandTotal, tax;

  List<OrderItem> items = [];
  List<Adjustment> adjustments = [];
  List<Breakdown> breakdowns = [];

  Order();
  Order.fromMap(map) {
    fromMap(map);
  }
  fromMap(map) {
    invoiceNumber = map['invoice_number'].toString();
    isFuelIncluded = map['fuel_included'] ?? false;
    orderLocation = map['order_location'] ?? "";
    company = map['company'] ?? "";
    profile = map['profile'] ?? "";
    bilingAddress = map['billing_address'] ?? "";
    status = map['status'] ?? "";
    statusId = map['status_id'] ?? 0;
    invoiceAmount = f.format(map['invoice_amounts'] ?? 0).toString();
    totalAmount = f.format(map['total_amounts'] ?? 0).toString();

    subTotal = map['total_amounts'];

    bookId = map['book_id'] ?? 0;
    orderBy = map['order_by'] ?? "";
    if (map.containsKey("client")) {
      orderBy = map['client'] ?? "";
    }
    taxAmount = f.format(map['tax_amount']).toString();
    tax = map['tax_amount'];
    promo = map['promotion_discount'];
    offer = map['offer_discount'];
    paid = f.format(map['paid'] ?? 0).toString();
    due = f.format(map['due'] ?? 0).toString();
    orderDate = DateTime.tryParse(map['order_date'] ?? "") ?? DateTime.now();
    dateFrom = DateTime.tryParse(map['date_from'] ?? "") ?? DateTime.now();
    dateTo = DateTime.tryParse(map['date_to'] ?? "") ?? DateTime.now();
    if (status == "Pending") {
      orderType = OrderTypes.pending;
    } else if (status == "Dispatch") {
      orderType = OrderTypes.dispatch;
    } else if (status == "Confirm") {
      orderType = OrderTypes.confirmed;
    } else if (status == "Completed") {
      orderType = OrderTypes.completed;
    } else {
      orderType = OrderTypes.cancelled;
    }
    if (map.containsKey("item")) {
      map['item'].forEach((mapp) {
        items.add(OrderItem.fromMap(mapp));
      });
    }
    if (map.containsKey("items")) {
      map['items'].forEach((mapp) {
        items.add(OrderItem.fromMap(mapp));
      });
    }

    if (map.containsKey("correction_item")) {
      for (var json in map['correction_item']) {
        adjustments.add(Adjustment.fromMap(json));
      }
    }
    if (map.containsKey("breakdown")) {
      for (var json in map['breakdown']) {
        breakdowns.add(Breakdown.fromMap(json));
      }
    }
    calculate();
  }

  calculate() {
    subTotal = 0;
    for (var item in items) {
      subTotal += item.bookingAmount;
    }
    for (var adjust in adjustments) {
      subTotal += adjust.amount;
    }
    for (var breakdown in breakdowns) {
      subTotal -= breakdown.amount;
    }
    taxAmount = f.format(0.13 * subTotal);
    grandTotal = subTotal + 0.13 * subTotal;
  }

  Future<void> fetchOrderDetail(BuildContext context, int id) async {
    context.loaderOverlay.show();
    Response response =
        await API().get(endPoint: "superuser/invoice/$id/details/");
    context.loaderOverlay.hide();
    if (response.statusCode == 200) {
      var data = response.data['data'];
      fromMap(data);
    }
  }

  Future<bool> dispatch(BuildContext context) async {
    context.loaderOverlay.show();
    int statusId = context.read<OrderStatusesCubit>().getStatusId("Dispatch");
    Response response = await API().post(
        endPoint: "book/book-status/",
        data: {"book_id": bookId, "status": statusId});

    context.loaderOverlay.hide();
    scaffoldMessageKey.currentState!
        .showSnackBar(SnackBar(content: Text(response.data['message'])));
    if (response.statusCode == 200) {
      orderType = OrderTypes.dispatch;
      return true;
    } else {
      return false;
    }
  }

  Future<bool> complete(BuildContext context) async {
    context.loaderOverlay.show();
    int statusId = context.read<OrderStatusesCubit>().getStatusId("Completed");
    Response response = await API().post(
        endPoint: "book/book-status/",
        data: {"book_id": bookId, "status": statusId});
    context.loaderOverlay.hide();
    scaffoldMessageKey.currentState!
        .showSnackBar(SnackBar(content: Text(response.data['message'])));
    if (response.statusCode == 200) {
      orderType = OrderTypes.completed;
      return true;
    } else {
      return false;
    }
  }
}

class OrderList {
  List<Order> orders = [];
  Future<OrderList> fetchOrders(BuildContext context, FilterBloc filter) async {
    String startDate = DateFormat("yyyy-MM-dd").format(filter.startDate);
    String endDate = DateFormat("yyyy-MM-dd").format(filter.endDate);
    int orderTypeId = filter.orderTypeId;
    String key = filter.searchKey;
    Response response;
    orders = [];
    if (key == "") {
      response = await API().get(
          endPoint:
              "vendor/my-order/?status=$orderTypeId&category=All&start_date=$startDate&end_date=$endDate");
    } else {
      response = await API().get(
          endPoint:
              "vendor/my-order/?query=$key&status=$orderTypeId&category=All");
    }
    if (response.statusCode == 200) {
      orders = [];
      var data = response.data['data'];
      for (int index = 0; index < data.length; index++) {
        try {
          orders.add(Order.fromMap(data[index]));
        } catch (e) {
          log(e.toString());
        }
      }
    }
    context.read<OrderListCubit>().setOrders(orders);
    return this;
  }
}

class OrderListCubit extends Cubit<OrderList> {
  OrderListCubit() : super(OrderList());

  Future<void> setOrders(List<Order> orders) async {
    OrderList newState = OrderList();
    for (int index = 0; index < orders.length; index++) {
      newState.orders.add(orders[index]);
    }
    emit(newState);
  }
}
