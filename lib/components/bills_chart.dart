// ignore_for_file: must_be_immutable

import 'package:finance_app/constants/consts.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double y;
}

class BillChart extends StatelessWidget {
  BillChart({
    Key? key,
    required this.exitsBillsOfMonthChartData,
    required this.exitsTotalOfMonth,
  }) : super(key: key);

  List<ChartData> exitsBillsOfMonthChartData = [];
  double exitsTotalOfMonth = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SfCircularChart(
          palette: billsTypesColors,
          title: ChartTitle(
            textStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
          ),
          legend: Legend(
            isVisible: true,
            position: LegendPosition.right,
            width: '20%',
            padding: 8,
          ),
          series: <CircularSeries>[
            PieSeries<ChartData, String>(
              dataSource: exitsBillsOfMonthChartData,
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y,
              dataLabelMapper: (ChartData data, _) =>
                  '${NumberFormat.currency(locale: 'pt_BR', name: 'R\$').format(data.y)}\n${(data.y / exitsTotalOfMonth * 100).toStringAsFixed(0)}%',
              dataLabelSettings: const DataLabelSettings(
                isVisible: true,
                showZeroValue: false,
                labelPosition: ChartDataLabelPosition.inside,
                textStyle: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
              animationDuration: 1500,
              explode: true,
              explodeIndex: 0,
              radius: '72%',
              selectionBehavior: SelectionBehavior(
                enable: true,
                toggleSelection: true,
                unselectedOpacity: 1,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
