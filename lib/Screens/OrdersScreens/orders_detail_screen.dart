import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rental_partners/Enums/orders_types.dart';
import 'package:rental_partners/Screens/OrdersScreens/Models/orders_model.dart';
import 'package:rental_partners/Screens/OrdersScreens/Popups/invoice_popup.dart';
import 'package:rental_partners/Theme/button.dart';
import 'package:rental_partners/Theme/dropshadows.dart';

var newRegExp = RegExp(r'(\d{1,3})(?=(\d{3})+$)');

class OrdersDetailScreen extends StatelessWidget {
  final Order order;
  OrdersDetailScreen({Key? key, required this.order}) : super(key: key);
  final f = NumberFormat("#,##,###.0#", "en_US");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("ORDER DETAIL")),
        body: Container(
          alignment: Alignment.topCenter,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            child: ListView(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(13),
                    color: Theme.of(context).scaffoldBackgroundColor,
                    boxShadow: BoxShadows.dropShadow(context),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Ordered By",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        order.orderBy,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Divider(thickness: 1, color: Color(0xffE5E5E5)),
                      const SizedBox(height: 8),
                      const Text(
                        "Items Details",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: order.items.length,
                        itemBuilder: (context, index) {
                          var item = order.items[index];
                          return Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.name,
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "${item.frequency}pc${item.priceBreakDown}",
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "NPR " +
                                          f
                                              .format(item.bookingAmount)
                                              .toString(),
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: BoxShadows.dropShadow(context),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        "https://www.worldhighways.com/sites/ropl-wh/files/109509.jpg",
                                    fit: BoxFit.contain,
                                    height: 80,
                                    width: 80,
                                    placeholder: (context, url) => const Center(
                                        child: CupertinoActivityIndicator()),
                                    errorWidget: (context, url, error) =>
                                        const Center(child: Icon(Icons.error)),
                                  ),
                                ),
                              )
                            ],
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(),
                      ),
                      const SizedBox(height: 8),
                      const Divider(thickness: 1, color: Color(0xffE5E5E5)),
                      const SizedBox(height: 8),
                      rowTextBox(
                        context,
                        title: "Discount Amount",
                        value: "NPR ${order.discountAmount}",
                      ),
                      rowTextBox(
                        context,
                        title: "Tax 13%",
                        value: "NPR ${order.taxAmount}",
                      ),
                      rowTextBox(
                        context,
                        title: "Promo",
                        value: "NPR ${order.promotionDiscount}",
                      ),
                      const SizedBox(height: 8),
                      const Divider(thickness: 1, color: Color(0xffE5E5E5)),
                      const SizedBox(height: 8),
                      rowTextBox(
                        context,
                        title: "Total",
                        value: "NPR ${order.totalAmount}",
                        isRightAlign: true,
                      ),
                      rowTextBox(
                        context,
                        title: "Paid",
                        value: "NPR ${order.paid}",
                        isRightAlign: true,
                      ),
                      rowTextBox(
                        context,
                        title: "Due",
                        value: "NPR ${order.due}",
                        isRightAlign: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                _buttonBox(context, order.orderType),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ));
  }

  Widget rowTextBox(BuildContext context,
      {required String title,
      required String value,
      bool isRightAlign = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              title,
              textAlign: isRightAlign ? TextAlign.end : TextAlign.start,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buttonBox(BuildContext context, OrderTypes type) {
    if (type == OrderTypes.pending) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            style: TextButtonStyles.overlayOrderDetailButtonStyle(),
            onPressed: () {
              showCupertinoDialog(
                context: context,
                builder: (ctx) => CupertinoAlertDialog(
                  title: const Text("Are you sure to confirm order?"),
                  actions: [
                    CupertinoDialogAction(
                      child: const Text("Yes"),
                      onPressed: () {},
                    ),
                    CupertinoDialogAction(
                      child: const Text("No"),
                      onPressed: () {
                        Navigator.pop(ctx);
                      },
                    ),
                  ],
                ),
              );
            },
            child: const Text("Confirm"),
          ),
          const SizedBox(width: 30),
          TextButton(
            style: TextButtonStyles.overlayOrderDetailButtonStyle(
                isRedColor: true),
            onPressed: () {
              showCupertinoDialog(
                context: context,
                builder: (ctx) => CupertinoAlertDialog(
                  title: const Text("Are you sure to cancel order?"),
                  actions: [
                    CupertinoDialogAction(
                      child: const Text("Yes"),
                      onPressed: () {},
                    ),
                    CupertinoDialogAction(
                      child: const Text("No"),
                      onPressed: () {
                        Navigator.pop(ctx);
                      },
                    ),
                  ],
                ),
              );
            },
            child: const Text("Cancel"),
          ),
        ],
      );
    } else if (type == OrderTypes.confirmed) {
      return Center(
        child: TextButton(
          style: TextButtonStyles.overlayOrderDetailButtonStyle(),
          onPressed: () {
            showCupertinoDialog(
              context: context,
              builder: (ctx) => CupertinoAlertDialog(
                title: const Text("Are you sure to dispatch order?"),
                actions: [
                  CupertinoDialogAction(
                    child: const Text("Yes"),
                    onPressed: () {},
                  ),
                  CupertinoDialogAction(
                    child: const Text("No"),
                    onPressed: () {
                      Navigator.pop(ctx);
                    },
                  ),
                ],
              ),
            );
          },
          child: const Text("Dispatch"),
        ),
      );
    } else if (type == OrderTypes.completed) {
      return Center(
        child: TextButton(
          style: TextButtonStyles.overlayOrderDetailButtonStyle(),
          onPressed: () {
            showInvoiceModel(context, 0);
          },
          child: const Text("View Invoice"),
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}
