import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:rental_partners/Blocs/filter_bloc.dart';
import 'package:rental_partners/Enums/orders_types.dart';
import 'package:rental_partners/Singletons/api_call.dart';

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
    bookingAmount = map['bookitem_amount'] ?? 0;
    frequency = map['frequency'] ?? 0;
    image = map['image'] ?? "";
    map["price_list"].forEach((price) {
      if (price.containsKey("total_month")) {
        if (price["total_month"] != "") {
          priceBreakDown += "X" + price['total_month'].toString() + "months";
        }
      }
      if (price.containsKey("total_day")) {
        if (price["total_day"] != "") {
          priceBreakDown += "X" + price['total_day'].toString() + "days";
        }
      }
      if (price.containsKey("total_hr")) {
        if (price["total_hr"] != "") {
          priceBreakDown += "X" + price['total_hr'].toString() + "hrs";
        }
      }
    });
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
      discountAmount,
      promotionDiscount,
      offerDiscount,
      paid,
      due;
  late int statusId, bookId;
  late bool isFuelIncluded;
  late DateTime orderDate, dateFrom, dateTo;

  late OrderTypes orderType;

  List<OrderItem> items = [];

  final f = NumberFormat("#,##,###.0#", "en_US");
  Order();
  Order.fromMap(map) {
    fromMap(map);
  }
  fromMap(map) {
    log(map.toString());
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
    bookId = map['book_id'] ?? 0;
    orderBy = map['order_by'] ?? "";
    if (map.containsKey("client")) {
      orderBy = map['client'] ?? "";
    }
    taxAmount = f.format(map['tax_amount']).toString();
    discountAmount = f.format(map['discount_amount']).toString();
    promotionDiscount = f.format(map['promotion_discount']).toString();
    offerDiscount = f.format(map['offer_discount']).toString();
    paid = f.format(map['paid'] ?? 0).toString();
    due = f.format(map['due'] ?? 0).toString();
    orderDate = DateTime.tryParse(map['order_date'] ?? "") ?? DateTime.now();
    dateFrom = DateTime.tryParse(map['date_from'] ?? "") ?? DateTime.now();
    dateTo = DateTime.tryParse(map['date_to'] ?? "") ?? DateTime.now();
    if (status == "Pending") {
      orderType = OrderTypes.pending;
    } else if (status == "Dispatch") {
      orderType = OrderTypes.dispatch;
    } else if (status == "Confirmed") {
      orderType = OrderTypes.confirmed;
    } else if (status == "Completed") {
      orderType = OrderTypes.completed;
    } else {
      orderType = OrderTypes.cancelled;
    }
    log(map.containsKey("item").toString());
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
  }

  Future<void> fetchOrderDetail(BuildContext context, int id) async {
    context.loaderOverlay.show();
    Response response =
        await API().get(endPoint: "payment/invoice/$id/details/");
    context.loaderOverlay.hide();
    if (response.statusCode == 200) {
      var data = response.data['data'];
      fromMap(data);
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
              "v2/payment/my-order/?status=$orderTypeId&category=All&start_date=$startDate&end_date=$endDate");
    } else {
      response = await API().get(
          endPoint:
              "v2/payment/my-order/?query=$key&status=$orderTypeId&category=All");
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
