import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:rental_partners/Screens/NotificationScreen/Model/notification_model.dart';
import 'package:rental_partners/Screens/OrdersScreens/Models/orders_model.dart';
import 'package:rental_partners/Screens/OrdersScreens/orders_detail_screen.dart';
import 'package:rental_partners/Theme/button.dart';
import 'package:rental_partners/Theme/dropshadows.dart';
import 'package:rental_partners/Utils/loading_widget.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationScreen extends StatelessWidget {
  NotificationScreen({Key? key}) : super(key: key);

  final NotificationsModel _notificationsModel = NotificationsModel();

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      useDefaultLoading: false,
      overlayWidget: loader(context),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("NOTIFICATIONS"),
        ),
        body: FutureBuilder<NotificationsModel>(
            future: _notificationsModel.fetchNotificaions(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CupertinoActivityIndicator());
              } else if (snapshot.hasData) {
                List<NotificationModel> notifications =
                    snapshot.data!.notifications;
                return ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  itemCount: notifications.length,
                  itemBuilder: (ctx, index) {
                    return _notificationBox(
                      context,
                      notification: notifications[index],
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(height: 10),
                );
              } else {
                return const SizedBox();
              }
            }),
      ),
    );
  }

  Widget _notificationBox(
    BuildContext context, {
    required NotificationModel notification,
  }) {
    return SizedBox(
      height: 100,
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: BoxShadows.dropShadow(context),
            ),
            child: Row(
              children: [
                const SizedBox(width: 25),
                ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: notification.image!,
                    height: 100,
                    width: 80,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const Center(child: CupertinoActivityIndicator()),
                    errorWidget: (_, __, ___) =>
                        Image.asset("assets/images/placeholder.png"),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification.title,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 9,
                            color: Color(0xffF52E4C)),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        notification.message,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Theme.of(context).textTheme.bodyLarge!.color,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        timeago.format(notification.dateTime!),
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 10,
                          color: Color(0xffB1A0A8),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 25),
              ],
            ),
          ),
          TextButton(
            onPressed: notification.invoiceNumber != null
                ? () async {
                    Order order = Order();
                    await order.fetchOrderDetail(
                        context, notification.invoiceNumber!);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            OrdersDetailScreen(order: order),
                      ),
                    );
                  }
                : null,
            style: TextButtonStyles.overlayButtonStyle().copyWith(
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
              ),
            ),
            child: const SizedBox(
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        ],
      ),
    );
  }
}
