// ignore_for_file: implementation_imports, must_be_immutable, unnecessary_import

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/src/provider.dart';
import 'package:rental_partners/Blocs/filter_bloc.dart';
import 'package:rental_partners/Blocs/order_status_bloc.dart';
import 'package:rental_partners/Screens/OrdersScreens/Models/orders_model.dart';
import 'package:rental_partners/Screens/OrdersScreens/Widgets/orders_list_widgets.dart';
import 'package:rental_partners/Theme/date_picker_theme.dart';
import 'package:rental_partners/Theme/dropshadows.dart';
import 'package:rental_partners/Utils/image_icon.dart';
import 'package:rental_partners/Utils/text_field.dart';

class OrdersListScreen extends StatelessWidget {
  String selectedType = "";
  final OrderList _orderList = OrderList();

  OrdersListScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    context.read<OrderStatusesCubit>().fetchOrders();
    context.read<FliterBlocCubit>().reset();
    return Scaffold(
      appBar: AppBar(
        title: const Text("ORDERS"),
        actions: [
          IconButton(
            onPressed: () async {
              DateTimeRange? range = await showDateRangePicker(
                context: context,
                initialDateRange: DateTimeRange(
                  start: context.read<FliterBlocCubit>().state.startDate,
                  end: context.read<FliterBlocCubit>().state.endDate,
                ),
                firstDate:
                    DateTime.now().subtract(const Duration(days: 100 * 365)),
                lastDate: DateTime.now(),
                builder: (ctx, child) {
                  return Theme(
                    data: datePickerTheme(context),
                    child: child!,
                  );
                },
              );
              if (range == null) {
                return;
              } else {
                context.read<FliterBlocCubit>().setDateRange(range);
              }
            },
            icon: AEMPLIcon(
              AEMPLIcons.filter,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 15),
          AEMPLTextField(
            hintText: "Search order.....",
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.search,
            prefix: const AEMPLIcon(AEMPLIcons.search, size: 20),
            onChanged: (value) =>
                context.read<FliterBlocCubit>().setSearch(value),
          ),
          SizedBox(
            height: 70,
            child: BlocBuilder<OrderStatusesCubit, OrderStatuses>(
                builder: (context, state) {
              return BlocBuilder<FliterBlocCubit, FilterBloc>(
                  builder: (context, filter) {
                return ListView.builder(
                  itemCount: state.statuses.length,
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemBuilder: (ctx, index) => _orderTypePill(
                    context,
                    title: state.statuses[index].value,
                    id: state.statuses[index].id,
                    isSelected: filter.orderTypeId == state.statuses[index].id,
                  ),
                );
              });
            }),
          ),
          Expanded(
            child: BlocBuilder<FliterBlocCubit, FilterBloc>(
                builder: (context, filter) {
              return FutureBuilder<OrderList>(
                future: _orderList.fetchOrders(context, filter),
                builder: (context, AsyncSnapshot asyncSnapshot) {
                  return const OrdersListSection();
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _orderTypePill(
    BuildContext context, {
    String title = "",
    required int id,
    required bool isSelected,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 17),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        boxShadow: BoxShadows.dropShadow(context),
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: TextButton(
        onPressed: () {
          selectedType = title;
          int selectedId = id;
          if (isSelected) selectedId = 0;
          context.read<FliterBlocCubit>().setOrderTypeId(selectedId);
        },
        style: TextButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 8),
          backgroundColor: isSelected
              ? Theme.of(context).primaryColor
              : Theme.of(context).scaffoldBackgroundColor,
        ).copyWith(
          foregroundColor: MaterialStateProperty.all(
            isSelected
                ? Colors.white
                : Theme.of(context).textTheme.bodyLarge!.color,
          ),
        ),
        child: Text(title),
      ),
    );
  }
}
