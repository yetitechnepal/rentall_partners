import 'package:dio/dio.dart';
import 'package:rental_partners/Singletons/api_call.dart';

class OrdersSummaryModel {
  int equipmentTotal = 0, attachmentTotal = 0;
  int value = 0;
//Vender fetching
  Future<OrdersSummaryModel> fetchTodaysOrder() async {
    Response response = await API().get(endPoint: "book/book-today/");

    if (response.statusCode == 200) {
      var data = response.data['data'];
      equipmentTotal = data['equipment_total'];
      attachmentTotal = data['attachment_total'];
    }
    return this;
  }

  Future<OrdersSummaryModel> fetchThisWeek() async {
    Response response = await API().get(endPoint: "book/this-week/");
    if (response.statusCode == 200) {
      var data = response.data['total_count'];
      equipmentTotal = data['equipment_total'];
      attachmentTotal = data['attachment_total'];
    }
    return this;
  }

  Future<OrdersSummaryModel> fetchOrder2Dispatch() async {
    Response response = await API().get(endPoint: "book/order2dispatch/");
    if (response.statusCode == 200) {
      var data = response.data;
      equipmentTotal = data['total_count'];
    }
    return this;
  }

  Future<OrdersSummaryModel> fetchOrder2Complete() async {
    Response response = await API().get(endPoint: "book/order2complete/");
    if (response.statusCode == 200) {
      var data = response.data;
      equipmentTotal = data['total_count'];
    }
    return this;
  }

  Future<OrdersSummaryModel> fetchTotalCancelled() async {
    Response response = await API().get(endPoint: "book/total-cancelled/");
    if (response.statusCode == 200) {
      var data = response.data;
      equipmentTotal = data['total_count'];
    }
    return this;
  }

  // operator fetching

  Future<OrdersSummaryModel> fetchOperatorsTodaysOrder() async {
    Response response = await API().get(endPoint: "book/book-today/");

    if (response.statusCode == 200) {
      var data = response.data['data'];
      value = data['total_count'];
    }
    return this;
  }

  Future<OrdersSummaryModel> fetchOperatorsThisWeekOrder() async {
    Response response = await API().get(endPoint: "book/this-week/");

    if (response.statusCode == 200) {
      var data = response.data['total_count'];
      value = data['total_count'];
    }
    return this;
  }

  Future<OrdersSummaryModel> fetchOperatorsCancelledOrder() async {
    Response response = await API().get(endPoint: "book/total-cancelled/");

    if (response.statusCode == 200) {
      var data = response.data['total_count'];
      value = data;
    }
    return this;
  }

  Future<OrdersSummaryModel> fetchOperatorsComplatedOrder() async {
    Response response = await API().get(endPoint: "book/order2complete/");
    if (response.statusCode == 200) {
      var data = response.data['total_count'];
      value = data;
    }
    return this;
  }
}
