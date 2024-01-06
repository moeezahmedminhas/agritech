import 'package:agritech/utils/colors.dart';
import 'package:flutter/material.dart';

Future<String?> customAlertDialog(
    BuildContext context, Size screenSize, String title, String description) {
  return showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      content: SizedBox(
        height: screenSize.height * 0.35,
        width: 345,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icons/approved.png',
              height: 71,
              width: 71,
            ),
            Container(
              margin: const EdgeInsets.only(top: 17, bottom: 12),
              child: Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w900,
                  color: grayColor,
                  fontSize: 24,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Text(
              description,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ),
  );
}
