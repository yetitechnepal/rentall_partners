import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rental_partners/OperatorScreen/OperatorDashboardScreen/Widgets/operator_information_part.dart';
import 'package:rental_partners/Screens/DashboardScreen/Models/orders_summary_model.dart';

class OperatorSummarySectiion extends StatefulWidget {
  final String title;
  final bool isBoth;
  const OperatorSummarySectiion(
      {Key? key, required this.title, this.isBoth = true})
      : super(key: key);
  @override
  State<OperatorSummarySectiion> createState() => _SummarySectiionState();
}

class _SummarySectiionState extends State<OperatorSummarySectiion>
    with AutomaticKeepAliveClientMixin {
  Future<OrdersSummaryModel> fetchSummary() async {
    final orderSummaryModel = OrdersSummaryModel();
    if (widget.title == 'Today’s Books') {
      return await orderSummaryModel.fetchOperatorsTodaysOrder();
    } else if (widget.title == "This Week's Books") {
      return await orderSummaryModel.fetchOperatorsThisWeekOrder();
    } else if (widget.title == "Operate this week") {
      return await orderSummaryModel.fetchThisWeek();
    } else if (widget.title == "Completed this Week") {
      return await orderSummaryModel.fetchOperatorsComplatedOrder();
    } else {
      return await orderSummaryModel.fetchOperatorsCancelledOrder();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder<OrdersSummaryModel>(
      future: fetchSummary(),
      builder: (context, AsyncSnapshot<OrdersSummaryModel> asyncSnapshot) {
        if (asyncSnapshot.hasData) {
          OrdersSummaryModel model = asyncSnapshot.data!;
          return OperatorInformationpart(
            title: widget.title,
            value: model.value.toString(),
          );
        } else if (asyncSnapshot.hasError) {
          if (kDebugMode) {
            return Text(asyncSnapshot.error.toString());
          } else {
            return OperatorInformationpart(
              title: widget.title,
              value: "-",
            );
          }
        } else {
          return OperatorInformationpart(
            title: widget.title,
            value: "-",
          );
        }
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
