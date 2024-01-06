import 'package:agritech/features/auth/controller/user_data_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/order.dart';
import '../../../utils/colors.dart';
import '../../../utils/contants.dart';
import '../controller/order_controller.dart';

class OrderDetailScreen extends StatefulWidget {
  const OrderDetailScreen({Key? key}) : super(key: key);
  static const routeName = 'order-details-user';

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  final Order order = Get.arguments as Order;
  String status = orderEnum.first;
  final OrderController _orderController = Get.put(OrderController());
  @override
  void initState() {
    super.initState();
    _orderController.getUserDataById(order.userID);
  }

  @override
  Widget build(BuildContext context) {
    final List<DataRow> temp = [];

    final size = MediaQuery.of(context).size;
    for (var product in order.products) {
      temp.add(DataRow(
        cells: [
          DataCell(Text(product.productName)),
          DataCell(Text(product.quantity.toString())),
          DataCell(Text('${product.totalPrice.toStringAsFixed(2)}Rs.')),
        ],
      ));
    }
    temp.add(DataRow(
      cells: [
        const DataCell(Text(
          'Delivery',
          style: TextStyle(fontWeight: FontWeight.bold),
        )),
        const DataCell(Text('')), // Leave this cell empty
        DataCell(Text('\$${OrderController.instance.deliveryCharges}')),
      ],
    ));
    temp.add(DataRow(
      cells: [
        const DataCell(Text('')), // Leave this cell empty
        const DataCell(
            Text('Total:', style: TextStyle(fontWeight: FontWeight.bold))),
        DataCell(Text('${order.totalAmount.toStringAsFixed(2)}Rs.')),
      ],
    ));
    temp.add(DataRow(
      cells: [
        const DataCell(
            Text('Status:', style: TextStyle(fontWeight: FontWeight.bold))),
        const DataCell(Text('')), // Leave this cell empty

        DataCell(Text(order.status.status)),
      ],
    ));
    temp.add(DataRow(
      cells: [
        const DataCell(
            Text('Order Date:', style: TextStyle(fontWeight: FontWeight.bold))),
        const DataCell(Text('')), // Leave this cell empty

        DataCell(Text(order.orderDate.toLocal().toString())),
      ],
    ));
    temp.add(DataRow(
      cells: [
        const DataCell(Text('Delivery Date:',
            style: TextStyle(fontWeight: FontWeight.bold))),
        const DataCell(Text('')), // Leave this cell empty

        DataCell(Text(order.deliveryDate.toLocal().toString())),
      ],
    ));
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          "Order Details",
          style: textStyle,
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (UserDataController.instance.appUser.value!.type ==
                userTypes[1]) ...{
              FutureBuilder(
                future: _orderController.getUserDataById(order.userID),
                builder: (builder, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error.toString()}: خرابی:');
                  } else if (!snapshot.hasData) {
                    // Check if there's no data or the data is empty
                    return const Text('کوئی آرڈر دستیاب نہیں');
                  }
                  final customer = snapshot.data!;

                  return Padding(
                    padding: EdgeInsets.all(Get.width * 0.05),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ترسیل کا پتہ',
                          style:
                              textStyle.copyWith(fontSize: Get.height * 0.024),
                        ),
                        SizedBox(
                          height: Get.height * 0.02,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border:
                                Border.all(color: lightGrayColor, width: 0.7),
                          ),
                          padding: EdgeInsets.all(Get.width * 0.04),
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                customer.address,
                                style: textStyle.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: Get.height * 0.019,
                                ),
                                textAlign: TextAlign.justify,
                              ),
                              Text(
                                '${customer.phone} : فون',
                                style: textStyle.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: Get.height * 0.019,
                                ),
                                textAlign: TextAlign.justify,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              )
            },
            Center(
              child: DataTable(
                columns: const [
                  DataColumn(
                    label: Text(
                      'Name',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Quantity',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Price',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
                rows: temp,
              ),
            ),
            if (UserDataController.instance.appUser.value!.type ==
                userTypes[1]) ...[
              SizedBox(
                width: size.width * 0.5,
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          OrderController.instance.selectDate(
                            context,
                            order.id,
                          );
                        },
                        child: const Text("Change Delivery Date"),
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.5,
                      child: DropdownButtonFormField(
                        validator: (value) {
                          if (value == null) {
                            return 'Category is required';
                          }
                          return null;
                        },
                        decoration: fieldStyle.copyWith(
                            focusColor: Colors.white,
                            fillColor: Colors.white,
                            hintText: 'Category'),
                        items: orderEnum.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(items),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            OrderController.instance
                                .updateOrderDelivery(order.id, null, val);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
