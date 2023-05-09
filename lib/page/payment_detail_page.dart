import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_manager/database/category.dart';
import 'package:money_manager/page/edit_payment_page.dart';

import '../database/payment.dart';
import '../database/payment_database.dart';

class PaymentDetailPage extends StatefulWidget {
  final int paymentId;

  final List<Category> categories;

  const PaymentDetailPage({
    Key? key,
    required this.paymentId,
    required this.categories,
  }) : super(key: key);

  @override
  _PaymentDetailPageState createState() => _PaymentDetailPageState();
}

class _PaymentDetailPageState extends State<PaymentDetailPage> {
  late Payment payment;
  late List<Category> categories;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshPayment();
    categories = widget.categories;
  }

  Future refreshPayment() async {
    setState(() => isLoading = true);

    this.payment = await PaymentDatabase.instance.readPayment(widget.paymentId);

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          actions: [editButton(), deleteButton()],
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: EdgeInsets.all(12),
                child: ListView(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  children: [
                    Text(
                      payment.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      payment.import.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      DateFormat.yMMMd().format(payment.createdTime),
                      style: TextStyle(color: Colors.white38),
                    ),
                    SizedBox(height: 8),
                    Text(
                      payment.description,
                      style: TextStyle(color: Colors.white70, fontSize: 18),
                    )
                  ],
                ),
              ),
      );

  Widget editButton() => IconButton(
      icon: Icon(Icons.edit_outlined),
      onPressed: () async {
        if (isLoading) return;

        await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AddEditPaymentPage(
            payment: payment,
            categories: categories,
          ),
        ));

        refreshPayment();
      });

  Widget deleteButton() => IconButton(
        icon: Icon(Icons.delete),
        onPressed: () async {
          await PaymentDatabase.instance.delete(widget.paymentId);

          Navigator.of(context).pop();
        },
      );
}
