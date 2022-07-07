import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rental_partners/Screens/DashboardScreen/Models/orders_summary_model.dart';
import 'package:rental_partners/Screens/DashboardScreen/Widgets/information_part.dart';

class SummarySectiion extends StatefulWidget {
  final String title;
  final bool isBoth;
  const SummarySectiion({Key? key, required this.title, this.isBoth = true})
      : super(key: key);
  @override
  State<SummarySectiion> createState() => _SummarySectiionState();
}

class _SummarySectiionState extends State<SummarySectiion>
    with AutomaticKeepAliveClientMixin {
  Future<OrdersSummaryModel> fetchSummary() async {
    final orderSummaryModel = OrdersSummaryModel();
    if (widget.title == 'Today’s Order') {
      return await orderSummaryModel.fetchTodaysOrder();
    } else if (widget.title == "Order to Dispatch this Week") {
      return await orderSummaryModel.fetchOrder2Dispatch();
    } else if (widget.title == "This Week’s Order") {
      return await orderSummaryModel.fetchThisWeek();
    } else if (widget.title == "Order to Complete this Week") {
      return await orderSummaryModel.fetchOrder2Complete();
    } else {
      return await orderSummaryModel.fetchTotalCancelled();
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
          return Informationpart(
            title: widget.title,
            attachmentValue: model.attachmentTotal.toString(),
            equipmentValue: model.equipmentTotal.toString(),
            isBoth: widget.isBoth,
          );
        } else if (asyncSnapshot.hasError) {
          if (kDebugMode) {
            return Text(asyncSnapshot.error.toString());
          } else {
            return Informationpart(
              title: widget.title,
              attachmentValue: "-",
              equipmentValue: "-",
              isBoth: widget.isBoth,
            );
          }
        } else {
          return Informationpart(
            title: widget.title,
            attachmentValue: "-",
            equipmentValue: "-",
            isBoth: widget.isBoth,
          );
        }
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
