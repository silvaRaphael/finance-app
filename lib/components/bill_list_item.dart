// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:finance_app/constants/consts.dart';
import 'package:finance_app/models/bills_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BillListItem extends StatelessWidget {
  const BillListItem({
    Key? key,
    required this.bill,
    required this.deleteBill,
  }) : super(key: key);

  final BillsModel bill;
  final deleteBill;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 60,
            height: 60,
            alignment: Alignment.centerLeft,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${bill.date.day}'.padLeft(2, '0'),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  ' ${monthsList[bill.date.month - 1].substring(0, 3)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Material(
              color: billsTypesColors[bill.type],
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onLongPress: () {
                  showDialog(
                    context: context,
                    barrierColor: Colors.transparent,
                    builder: (context) => AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 32,
                      contentPadding: const EdgeInsets.all(20),
                      actionsPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      title: Text(
                        'Excluir ${bill.name}?',
                        style: const TextStyle(fontSize: 16),
                      ),
                      actions: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                'Cancelar',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: deleteBill,
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.resolveWith(
                                  (states) => Theme.of(context).primaryColor,
                                ),
                              ),
                              child: const Text(
                                'Excluir',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
                child: Container(
                  height: 60,
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        billsTypes[bill.type],
                        color: Colors.white,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              bill.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  bill.date.isAfter(DateTime.now())
                                      ? billsStatus[0]
                                      : billsStatus[1],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  NumberFormat.currency(
                                    locale: 'pt_BR',
                                    name: 'R\$',
                                  ).format(bill.value).toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
