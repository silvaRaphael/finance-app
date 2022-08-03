import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final box = Hive.box('bills');

  void resetBills(bill) {
    box.put(bill, null);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                resetBills('entries_user_1');
              },
              child: const Text('Limpar entradas'),
            ),
            TextButton(
              onPressed: () {
                resetBills('exits_user_1');
              },
              child: const Text('Limpar saídas'),
            ),
          ],
        ),
      ),
    );
  }
}
