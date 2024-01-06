import 'package:agritech/features/company/controllers/company_controller.dart';
import 'package:agritech/features/order/screens/order_history.dart';
import 'package:agritech/utils/colors.dart';
import 'package:agritech/utils/contants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/app_drawer.dart';
import '../../auth/controller/user_data_controller.dart';

class CompanyDashboard extends StatelessWidget {
  CompanyDashboard({super.key});
  final CompanyController _adminController = Get.put(CompanyController());
  final UserDataController userDataController = Get.put(UserDataController());

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    _adminController.calculateMonthlyEarning();
    _adminController.countOrdersInProgress();
    return Scaffold(
      backgroundColor: Colors.white,
      endDrawer: AppDrawer(),
      appBar: AppBar(
        foregroundColor: Colors.black,
        centerTitle: true,
        title: Align(
          alignment: Alignment.centerRight,
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                userDataController.appUser.value?.fullName != null
                    ? Text(
                        "!${userDataController.appUser.value?.fullName} السلام علیکم",
                        style: textStyle.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: Get.height * 0.015,
                        ),
                      )
                    : Container(),
                Text(
                  "اپنی خدمات سے لطف اندوز ہوں۔",
                  style: textStyle.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: Get.height * 0.02),
                ),
              ],
            ),
          ),

          // IconButton(
          //   onPressed: () {
          //     Get.to(AddProductScreen());
          //   },
          //   icon: const Icon(
          //     Icons.notifications_none_sharp,
          //     color: primaryColor,
          //   ),
          // ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            // elevation: 5,
            margin: EdgeInsets.all(Get.width * 0.05),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: const <BoxShadow>[
                BoxShadow(
                  color: lightGrayColor,
                  blurRadius: 4,
                  offset: Offset(2, 1), // Shadow position
                ),
              ],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: Get.height * 0.04,
                  // width: Get.width * 0.9,
                ),
                Text(
                  "کل کمائی",
                  style: textStyle.copyWith(
                    fontSize: Get.height * 0.025,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: Get.height * 0.02,
                ),
                Obx(() => Text(
                      "${_adminController.totalSales.value.toInt()} Rs",
                      style: textStyle.copyWith(
                        fontSize: Get.height * 0.05,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                SizedBox(
                  height: Get.height * 0.04,
                ),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Get.toNamed(OrderHistoryScreen.routeName);
                  },
                  child: Container(
                    // elevation: 5,
                    margin: EdgeInsets.all(Get.width * 0.05),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: const <BoxShadow>[
                        BoxShadow(
                          color: lightGrayColor,
                          blurRadius: 4,
                          offset: Offset(2, 1), // Shadow position
                        ),
                      ],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(Get.width * 0.00),
                      child: Column(
                        children: [
                          SizedBox(
                            height: Get.height * 0.04,
                            // width: Get.width * 0.9,
                          ),
                          Text(
                            "کل آرڈرز",
                            style: textStyle.copyWith(
                              fontSize: Get.height * 0.025,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: Get.height * 0.02,
                          ),
                          Obx(() => Text(
                                _adminController.totalOrders.toString(),
                                style: textStyle.copyWith(
                                  fontSize: Get.height * 0.06,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                          SizedBox(
                            height: Get.height * 0.04,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.all(Get.width * 0.05),
            child: Stack(children: [
              SizedBox(
                child: Image.asset("assets/images/discount.png"),
              ),
              Positioned(
                bottom: height * 0.01,
                // left: width * 0.025,
                child: SizedBox(
                  width: width * 1 - width * 0.085,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Get.width * 0.03,
                        vertical: Get.width * 0.02),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: width * 0.4,
                            child: Text(
                              "اپنے بیج بہترین قیمت پر حاصل کریں",
                              style: textStyle.copyWith(
                                  color: Colors.white,
                                  fontSize: Get.height * 0.0223),
                            ),
                          ),
                          // // SizedBox(
                          // //   width: width * 0.2,
                          // // ),
                          // Text(
                          //   "10% Discount",
                          //   style: textStyle.copyWith(
                          //     color: Colors.white,
                          //     fontSize: Get.height * 0.018,
                          //   ),
                          // ),
                        ]),
                  ),
                ),
              ),
            ]),
          ),
        ]),
      ),
    );
  }
}
