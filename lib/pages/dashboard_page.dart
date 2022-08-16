import 'package:finance_app/components/bills_chart.dart';
import 'package:finance_app/constants/consts.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final box = Hive.box('bills');
  final boxName1 = 'exits_user_1';
  final boxName2 = 'entries_user_1';

  List<ChartData> exitsBillsOfMonthChartData = [];
  double exitsTotalOfMonth = 0;
  double entriesTotalOfMonth = 0;

  void getMonthExitsBills(DateTime date) {
    var result = box.get(boxName1);

    if (result != null) {
      double totalBillsType1 = 0;
      double totalBillsType2 = 0;
      double totalBillsType3 = 0;
      double totalBillsType4 = 0;
      double totalBillsType5 = 0;
      int index = 0;

      setState(() {
        result.forEach((element) {
          index++;
          if (element['date'].month == date.month) {
            totalBillsType1 += element['type'] == 0 ? element['value'] : 0;
            totalBillsType2 += element['type'] == 1 ? element['value'] : 0;
            totalBillsType3 += element['type'] == 2 ? element['value'] : 0;
            totalBillsType4 += element['type'] == 3 ? element['value'] : 0;
            totalBillsType5 += element['type'] == 4 ? element['value'] : 0;

            exitsTotalOfMonth += element['value'];
          }

          if (index == result.length) {
            exitsBillsOfMonthChartData.addAll([
              ChartData(billsTypesLabel[0], totalBillsType1),
              ChartData(billsTypesLabel[1], totalBillsType2),
              ChartData(billsTypesLabel[2], totalBillsType3),
              ChartData(billsTypesLabel[3], totalBillsType4),
              ChartData(billsTypesLabel[4], totalBillsType5),
            ]);
          }
        });
      });
    }
  }

  void getTotalEntriesOfMonth(DateTime date) {
    var result = box.get(boxName2);

    if (result != null) {
      setState(() {
        result.forEach((element) {
          if (element['date'].month == date.month) {
            entriesTotalOfMonth += element['value'];
          }
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getMonthExitsBills(DateTime.now());
    getTotalEntriesOfMonth(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          exitsBillsOfMonthChartData.isNotEmpty
              ? BillChart(
                  exitsBillsOfMonthChartData: exitsBillsOfMonthChartData,
                  exitsTotalOfMonth: exitsTotalOfMonth,
                )
              : const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total saídas',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.arrow_downward,
                      color: Colors.red,
                      size: 20,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      NumberFormat.currency(
                        locale: 'pt_BR',
                        name: 'R\$',
                      ).format(exitsTotalOfMonth),
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // total entries of month
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total entradas',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.arrow_upward,
                      color: Colors.green,
                      size: 20,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      NumberFormat.currency(
                        locale: 'pt_BR',
                        name: 'R\$',
                      ).format(entriesTotalOfMonth),
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // end value
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Saldo',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
                Row(
                  children: [
                    entriesTotalOfMonth > exitsTotalOfMonth
                        ? const Icon(
                            Icons.add,
                            color: Colors.green,
                            size: 20,
                          )
                        : entriesTotalOfMonth < exitsTotalOfMonth
                            ? const Icon(
                                Icons.remove,
                                color: Colors.red,
                                size: 20,
                              )
                            : const SizedBox(),
                    const SizedBox(width: 4),
                    Text(
                      NumberFormat.currency(
                        locale: 'pt_BR',
                        name: 'R\$',
                      ).format((entriesTotalOfMonth - exitsTotalOfMonth).abs()),
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
