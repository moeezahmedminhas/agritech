// import 'package:agritech/features/admin/manage_products/view/edit_orders_screen.dart';
import 'package:agritech/features/auth/controller/user_data_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agritech/features/order/controller/order_controller.dart';
import 'package:agritech/features/order/screens/order_detail_screen.dart';
import 'package:agritech/utils/order_enum.dart';

import '../../../models/order.dart';
import '../../../utils/contants.dart';

class OrderHistoryScreen extends StatelessWidget {
  static const routeName = 'order-history';

  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final OrderController orderController = OrderController.instance;

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          "آرڈر کی تاریخ",
          style: textStyle,
        ),
        backgroundColor: Colors.white,
        actions: [
          PopupMenuButton<OrderStatusEnum>(
            onSelected: (status) {
              orderController.selectedStatus.value = status;
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem(
                  value: OrderStatusEnum.processing,
                  child: Text("عمل درآمد"),
                ),
                const PopupMenuItem(
                  value: OrderStatusEnum.cancelled,
                  child: Text('منسوخ'),
                ),
                const PopupMenuItem(
                  value: OrderStatusEnum.completed,
                  child: Text('مکمل'),
                ),
              ];
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Obx(() {
          final selectedStatus = orderController.selectedStatus.value;
          return StreamBuilder<List<Order>>(
            stream:
                UserDataController.instance.appUser.value!.type != userTypes[0]
                    ? orderController.getCompanyOrdersStream(selectedStatus)
                    : orderController.getUserOrdersStream(selectedStatus),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              final List<Order> orderList = snapshot.data ?? [];
              if (orderList.isEmpty) {
                return Center(
                  child: Text(
                    "کوئی احکامات نہیں",
                    style: textStyle.copyWith(fontSize: Get.height * 0.03),
                  ),
                );
              }
              return ListView.builder(
                shrinkWrap: true,
                itemCount: orderList.length,
                itemBuilder: (context, index) {
                  Order order = orderList[index];
                  return ListTile(
                    title: Text(order.id.toString()),
                    onTap: () {
                      Get.toNamed(OrderDetailScreen.routeName,
                          arguments: order);
                    },
                    // trailing: authUser.email == adminEmail
                    //     ? IconButton(
                    //         splashRadius: 20,
                    //         onPressed: () {
                    //           Get.toNamed(EditOrderScreen.routeName,
                    //               arguments: order);
                    //         },
                    //         icon: const Icon(Icons.edit))
                    //     : const SizedBox(),
                  );
                },
              );
            },
          );
        }),
      ),
    );
  }
}
