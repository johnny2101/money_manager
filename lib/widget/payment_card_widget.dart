import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../database/payment.dart';

final _lightColors = [
  Color(0xFF50354D),
  Color(0xFF965264),
  Color(0xFFD57967),
  Color(0xFFFAB361),
  Color(0xFFF9F871),
];

class PaymentCartdWidget extends StatelessWidget {
  PaymentCartdWidget({
    Key? key,
    required this.payment,
    required this.index,
  }) : super(key: key);

  final Payment payment;
  final int index;

  @override
  Widget build(BuildContext context) {
    /// Pick colors from the accent colors based on index
    final color = _lightColors[index % _lightColors.length];
    final time = DateFormat.yMMMd().format(payment.createdTime);
    final minHeight = getMinHeight(index);

    return Card(
      color: color,
      child: Container(
        constraints: BoxConstraints(minHeight: minHeight),
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              time,
              style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
            ),
            SizedBox(height: 4),
            Text(
              payment.title,
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              payment.import.toString(),
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              payment.type,
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// To return different height for different widgets
  double getMinHeight(int index) {
    switch (index % 4) {
      case 0:
        return 100;
      case 1:
        return 150;
      case 2:
        return 150;
      case 3:
        return 100;
      default:
        return 100;
    }
  }
}
