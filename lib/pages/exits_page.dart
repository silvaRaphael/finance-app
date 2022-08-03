import 'dart:async';

import 'package:finance_app/components/bill_list_item.dart';
import 'package:finance_app/components/calendar.dart';
import 'package:finance_app/components/input_outline.dart';
import 'package:finance_app/constants/consts.dart';
import 'package:finance_app/models/bills_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class ExitsPage extends StatefulWidget {
  const ExitsPage({Key? key}) : super(key: key);

  @override
  State<ExitsPage> createState() => _ExitsPageState();
}

class _ExitsPageState extends State<ExitsPage> {
  final box = Hive.box('bills');
  final boxName = 'exits_user_1';
  final entry = false;

  final TextEditingController _billNameController = TextEditingController();
  final TextEditingController _billValueController = TextEditingController();
  double totalOfMonth = 0;
  DateTime focusedDay = DateTime.now();
  List<BillsModel> billsOfMonth = [];
  List<BillsModel> billsList = [];

  void updateDatabase(DateTime date) {
    List res = [];
    for (var element in billsList) {
      res.add({
        'name': element.name,
        'date': element.date,
        'value': element.value,
        'type': element.type,
        'entry': element.entry,
      });
    }

    box.put(boxName, res).then((value) => getMonthBills(date));
  }

  void getMonthBills(DateTime date) {
    var result = box.get(boxName);

    if (result != null) {
      setState(() {
        totalOfMonth = 0;
        focusedDay = date;
        billsList = [];
        billsOfMonth = [];
        for (var element in result) {
          billsList.add(BillsModel(
            name: element['name'],
            date: element['date'],
            value: element['value'],
            type: element['type'],
            entry: element['entry'],
          ));
          if (element['date'].month == date.month) {
            billsOfMonth.add(BillsModel(
              name: element['name'],
              date: element['date'],
              value: element['value'],
              type: element['type'],
              entry: element['entry'],
            ));
            totalOfMonth += element['value'];
          }
        }
        billsOfMonth = billsOfMonth..sort((a, b) => a.date.compareTo(b.date));
      });
    }
  }

  void openBillOptionAlert(DateTime date) {
    bool fixedBill = false;
    double billsFixedMonths = 12;
    int billType = 0;

    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.white,
      barrierColor: Colors.transparent,
      elevation: 32,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 20, top: 30, right: 20, bottom: 20),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Column(
                      children: [
                        // header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Adicionar conta',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              '${date.day.toString().padLeft(2, '0')} ${monthsList[date.month - 1]} ${date.year}',
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // input infos
                        InputOutline(
                          label: 'Nome',
                          prefixIcon: Icons.info_outline,
                          controller: _billNameController,
                          keyboardType: TextInputType.text,
                        ),
                        const SizedBox(height: 12),
                        InputOutline(
                          label: 'Valor',
                          prefixIcon: Icons.paid_outlined,
                          controller: _billValueController,
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      fixedBill
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 6),
                                  child: billsFixedMonths == 1
                                      ? Text(
                                          '${billsFixedMonths.toInt()} Mês',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey[700],
                                          ),
                                        )
                                      : Text(
                                          '${billsFixedMonths.toInt()} Meses',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                ),
                                CupertinoSlider(
                                  min: 0,
                                  max: 12,
                                  value: billsFixedMonths,
                                  onChanged: (value) {
                                    if (value > 0) {
                                      setState(() {
                                        billsFixedMonths = value;
                                      });
                                    }
                                  },
                                  divisions: 12,
                                ),
                              ],
                            )
                          : const SizedBox(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Conta fixa?',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[700],
                            ),
                          ),
                          Transform.scale(
                            scale: .7,
                            child: CupertinoSwitch(
                              value: fixedBill,
                              onChanged: (value) {
                                setState(() {
                                  fixedBill = value;
                                });
                              },
                              activeColor: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // bill type options
                  SizedBox(
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: billsTypes.length <= 5 ? billsTypes.length : 5,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                billType = index;
                              });
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                color: billType == index
                                    ? billsTypesColors[index]
                                    : billsTypesColors[index].withOpacity(.5),
                                width: 50,
                                height: 50,
                                child: Center(
                                  child: Icon(
                                    billsTypes[index],
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 12),

                  // add button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Material(
                      color: Colors.orange[600],
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        splashColor: Colors.orange[900],
                        highlightColor: Colors.orange[700],
                        onTap: () {
                          addNewBill(date, billType, fixedBill,
                              billsFixedMonths.toInt());
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  'Adicionar',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                                Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ).whenComplete(() {
      Timer(const Duration(milliseconds: 200), () {
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          systemNavigationBarColor: Theme.of(context).primaryColor,
          systemNavigationBarIconBrightness: Brightness.light,
        ));

        _billNameController.clear();
        _billValueController.clear();
      });
    });
    Timer(const Duration(milliseconds: 50), () {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.light,
      ));
    });
  }

  void addNewBill(
      DateTime date, int billType, bool fixedBill, int billsFixedMonths) {
    if (_billNameController.text.trim().isNotEmpty &&
        _billValueController.text.trim().isNotEmpty) {
      double value = double.parse(_billValueController.text
          .replaceAll('.', '')
          .replaceAll(',', '.')
          .trim());
      setState(() {
        if (fixedBill) {
          int month = date.month;
          int year = date.year;
          for (var i = 0; i < billsFixedMonths; i++) {
            billsList.add(BillsModel(
              name: _billNameController.text.trim(),
              date: DateTime.parse(
                  '$year-${month.toString().padLeft(2, '0')}-${date.day}'),
              value: value,
              type: billType,
              entry: entry,
            ));
            if (month == 12) {
              month = 1;
              year++;
            } else {
              month++;
            }
          }
        } else {
          billsList.add(BillsModel(
            name: _billNameController.text.trim(),
            date: date,
            value: value,
            type: billType,
            entry: entry,
          ));
        }

        billType = 0;
      });
      updateDatabase(date);

      Navigator.pop(context);
    }
  }

  void deleteBill(int index) {
    setState(() {
      billsList.removeAt(billsList.indexWhere((e) =>
          e.name == billsOfMonth[index].name &&
          e.date == billsOfMonth[index].date &&
          e.type == billsOfMonth[index].type &&
          e.value == billsOfMonth[index].value));
    });
    updateDatabase(billsOfMonth[index].date);
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    getMonthBills(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // calendar
          MyCalendar(
            focusedDay: focusedDay,
            billsOfMonth: billsOfMonth,
            onDaySelected: (selectedDay, focusedDay) {
              openBillOptionAlert(selectedDay);
            },
            onPageChanged: (focusedDay) {
              getMonthBills(
                  DateTime.parse(focusedDay.toString().substring(0, 23)));
            },
          ),

          // total bills values of month
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
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
                      ).format(totalOfMonth),
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

          // bills list
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: billsOfMonth.length,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            itemBuilder: (context, index) {
              return BillListItem(
                bill: billsOfMonth[index],
                deleteBill: () {
                  deleteBill(index);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
