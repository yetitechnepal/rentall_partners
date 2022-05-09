import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_partners/Singletons/api_call.dart';

class OrderStatus {
  late int id;
  late String value, description;
  OrderStatus.fromMap(map) {
    id = map['id'];
    value = map['value'];
    description = map['description'];
  }
}

class OrderStatuses {
  List<OrderStatus> statuses = [];
  fetchStatus() async {
    Response response = await API().get(endPoint: "status/");
    if (response.statusCode == 200) {
      for (var element in response.data['data']) {
        statuses.add(OrderStatus.fromMap(element));
      }
    }
  }
}

class OrderStatusesCubit extends Cubit<OrderStatuses> {
  OrderStatusesCubit() : super(OrderStatuses());
  fetchOrders() async {
    OrderStatuses orderStatuses = OrderStatuses();
    await orderStatuses.fetchStatus();
    emit(orderStatuses);
  }

  int getStatusId(String value) {
    int id = 0;
    for (var status in state.statuses) {
      if (value == status.value) {
        id = status.id;
      }
    }
    return id;
  }
}
