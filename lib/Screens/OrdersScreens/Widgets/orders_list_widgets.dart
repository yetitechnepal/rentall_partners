import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:rental_partners/Enums/orders_types.dart';
import 'package:rental_partners/Screens/OrdersScreens/Models/orders_model.dart';
import 'package:rental_partners/Screens/OrdersScreens/orders_detail_screen.dart';
import 'package:rental_partners/Theme/colors.dart';

class OrdersListSection extends StatelessWidget {
  const OrdersListSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderListCubit, OrderList>(
      builder: (context, state) {
        return GridView.builder(
          padding: MediaQuery.of(context).size.width > 500
              ? const EdgeInsets.symmetric(horizontal: 20)
              : EdgeInsets.zero,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          itemCount: state.orders.length,
          itemBuilder: (context, index) {
            return _orderBox(context, state.orders[index]);
          },
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 500,
            childAspectRatio:
                MediaQuery.of(context).size.width > 500 ? 500 / 150 : 500 / 200,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
          ),
        );
      },
    );
  }

  Widget _orderBox(BuildContext context, Order order) {
    return TextButton(
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => OrdersDetailScreen(order: order)),
      ),
      style: TextButton.styleFrom(
        primary: primaryColor,
        padding: const EdgeInsets.all(20),
        shape: const RoundedRectangleBorder(),
        backgroundColor: Theme.of(context).brightness == Brightness.light
            ? const Color(0xffF8F8F8)
            : const Color(0xFF343434),
        elevation: 0,
      ).copyWith(foregroundColor: MaterialStateProperty.all(Colors.black)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Order No",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).textTheme.bodyText1!.color,
                      ),
                    ),
                    Text(
                      "#" + order.invoiceNumber.toString(),
                      style: TextStyle(
                          fontSize: 13,
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? const Color(0xff4F5251)
                                  : const Color(0xFFACABAB)),
                    ),
                  ],
                ),
                Text(
                  DateFormat("MMM dd").format(order.dateFrom) +
                      " - " +
                      DateFormat("MMM dd").format(order.dateTo),
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).textTheme.bodyText1!.color,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Text(
            "Order Amount",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).textTheme.bodyText1!.color,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "NPR ${f.format(order.grandTotal).toString()}",
                style: TextStyle(
                  fontSize: 13,
                  color: primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: getOrderTypeColorCode(context, order.orderType),
                ),
                child: Text(
                  getOrderTypeString(order.orderType),
                  style: const TextStyle(fontSize: 13, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
