import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:money_manager/database/category.dart';
import 'package:money_manager/database/payment_database.dart';
import 'package:money_manager/page/categories_page.dart';
import 'package:money_manager/page/category_detail_page.dart';
import 'package:money_manager/page/edit_category_page.dart';
import 'package:money_manager/page/edit_payment_page.dart';
import 'package:money_manager/page/payment_detail_page.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../database/payment.dart';
import '../widget/payment_card_widget.dart';

class PaymentsPage extends StatefulWidget {
  @override
  _PaymentsPageState createState() => _PaymentsPageState();
}

class _PaymentsPageState extends State<PaymentsPage> {
  late List<Payment> payments = [];
  late List<Category> categories = [];
  late Map<String, ChartData> chartData2 = {};
  late double total = 0;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    print("inited");

    refreshCategories().whenComplete(() =>
        refreshPayments().whenComplete(() => {refreshChart(), refreshTotal()}));
  }

  @override
  void dispose() {
    PaymentDatabase.instance.close();

    super.dispose();
  }

  void refreshChart() {
    categories.forEach((element) {
      chartData2[element.category] =
          ChartData(element.category, 0, Color(element.color));
    });

    payments.forEach((element) {
      chartData2[element.type]?.y += element.import;
    });
  }

  Future refreshPayments() async {
    setState(() => isLoading = true);

    this.payments = await PaymentDatabase.instance.readAllPayments();

    setState(() => isLoading = false);
  }

  Future refreshCategories() async {
    setState(() => isLoading = true);

    this.categories = await PaymentDatabase.instance.readAllCategories();

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(
            'Payments',
            style: TextStyle(fontSize: 24),
          ),
          actions: [
            TextButton(
                onPressed: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => CategoriesPage()),
                  );

                  refreshCategories()
                      .whenComplete(() => {refreshChart(), refreshTotal()});
                },
                child: Text(
                  "aggiungi categoria",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                )),
            SizedBox(width: 12)
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          verticalDirection: VerticalDirection.down,
          children: [
            Container(
              height: 300,
              child: Stack(
                children: [
                  SfCircularChart(
                    series: <CircularSeries>[
                      // Renders doughnut chart
                      DoughnutSeries<ChartData, String>(
                        animationDuration: 2000,
                        legendIconType: LegendIconType.horizontalLine,
                        explode: true,
                        explodeGesture: ActivationMode.singleTap,
                        innerRadius: "70%",
                        dataSource:
                            chartData2.entries.map((e) => e.value).toList(),
                        pointColorMapper: (ChartData data, _) => data.color,
                        xValueMapper: (ChartData data, _) => data.x,
                        yValueMapper: (ChartData data, _) => data.y,
                        onPointTap: (ChartPointDetails details) {
                          print(details.pointIndex);
                          //print(details.seriesIndex);
                        },
                        dataLabelSettings: DataLabelSettings(
                          showZeroValue: false,
                          isVisible: true,
                          color: Colors.white,
                          // Avoid labels intersection
                          labelPosition: ChartDataLabelPosition.outside,
                        ),
                      ),
                    ],
                    legend: Legend(
                      height: "10%",
                      position: LegendPosition.top,
                      isVisible: true,
                      textStyle: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      verticalDirection: VerticalDirection.down,
                      children: [
                        SizedBox(
                          height: 40,
                        ),
                        Text(
                          "hai speso",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "${total.toStringAsFixed(2)} €",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: isLoading
                  ? CircularProgressIndicator()
                  : payments.isEmpty
                      ? Text(
                          'No Payments',
                          style: TextStyle(color: Colors.white, fontSize: 24),
                        )
                      : buildPayments(),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          child: Icon(Icons.add),
          onPressed: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => AddEditPaymentPage(
                        categories: categories,
                      )),
            );

            refreshPayments()
                .whenComplete(() => {refreshChart(), refreshTotal()});
          },
        ),
      );

  Widget buildPayments() => StaggeredGridView.countBuilder(
        staggeredTileBuilder: (index) => StaggeredTile.fit(2),
        itemCount: payments.length,
        crossAxisCount: 4,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        itemBuilder: (context, index) {
          final payment = payments[index];

          return GestureDetector(
            onTap: () async {
              await Navigator.of(context)
                  .push(MaterialPageRoute(
                    builder: (context) => PaymentDetailPage(
                      paymentId: payment.id!,
                      categories: categories,
                    ),
                  ))
                  .whenComplete(() => refreshPayments()
                      .whenComplete(() => {refreshChart(), refreshTotal()}));
            },
            child: PaymentCartdWidget(payment: payment, index: index),
          );
        },
      ); /* StaggeredGrid.count(
        crossAxisCount: 2,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        children: buildGrid(),
      ); */

  List<Widget> buildCategories() {
    List<Widget> list;

    return this
        .categories
        .map(
          (item) => new ElevatedButton(
            onPressed: () async {
              await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => CategoryDetailPage(categoryId: item.id!),
              ));

              refreshCategories();
            },
            child: Text(
              item.category,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
        )
        .toList();
  }

  refreshTotal() {
    total = 0;
    payments.forEach((element) {
      total += element.import;
    });

    total.truncateToDouble();
  }

  List<Widget> buildGrid() {
    int index = 0;
    return payments
        .map(
          (element) => GestureDetector(
            onTap: () async {
              await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => PaymentDetailPage(
                  paymentId: element.id!,
                  categories: categories,
                ),
              ));

              refreshPayments()
                  .whenComplete(() => {refreshChart(), refreshTotal()});
            },
            child: PaymentCartdWidget(payment: element, index: index++),
          ),
        )
        .toList();
  }
}

class ChartData {
  ChartData(this.x, this.y, this.color);
  final String x;
  double y;
  final Color color;
}

List<ChartData> chartData = [
  ChartData('David', 25, Color.fromRGBO(9, 0, 136, 1)),
  ChartData('Steve', 38, Color.fromRGBO(147, 0, 119, 1)),
  ChartData('Jack', 34, Color.fromRGBO(228, 0, 124, 1)),
  ChartData('Others', 52, Color.fromRGBO(255, 189, 57, 1))
];
