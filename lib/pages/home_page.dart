import 'package:finance_app/pages/dashboard_page.dart';
import 'package:finance_app/pages/entries_page.dart';
import 'package:finance_app/pages/exits_page.dart';
import 'package:finance_app/pages/settings_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPage = 0;

  List<Widget> pages = [
    const DashboardPage(),
    const EntriesPage(),
    const ExitsPage(),
    const SettingsPage(),
  ];

  List<String> pagesTitles = [
    'D A S H B O A R D',
    'E N T R A D A S',
    'S A Í D A S',
    'P R E F E R Ê N C I A S',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          pagesTitles[currentPage],
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      bottomNavigationBar: Container(
        color: Theme.of(context).primaryColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            BottomButton(
              onTap: () {
                setState(() {
                  currentPage = 0;
                });
              },
              label: 'Dashboard',
              icon: Icons.space_dashboard_outlined,
              selected: currentPage == 0,
            ),
            BottomButton(
              onTap: () {
                setState(() {
                  currentPage = 1;
                });
              },
              label: 'Entradas',
              icon: Icons.login_outlined,
              selected: currentPage == 1,
            ),
            BottomButton(
              onTap: () {
                setState(() {
                  currentPage = 2;
                });
              },
              label: 'Saídas',
              icon: Icons.logout_outlined,
              selected: currentPage == 2,
            ),
            BottomButton(
              onTap: () {
                setState(() {
                  currentPage = 3;
                });
              },
              label: 'Preferências',
              icon: Icons.settings_outlined,
              selected: currentPage == 3,
            ),
          ],
        ),
      ),
      body: pages[currentPage],
    );
  }
}

class BottomButton extends StatelessWidget {
  const BottomButton({
    Key? key,
    required this.onTap,
    required this.label,
    required this.icon,
    required this.selected,
  }) : super(key: key);

  final void Function()? onTap;
  final String label;
  final IconData icon;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 4,
        height: 60,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: selected ? Colors.white : Colors.white70,
            ),
            AnimatedDefaultTextStyle(
              style: selected
                  ? const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    )
                  : const TextStyle(
                      fontSize: 0,
                    ),
              duration: const Duration(milliseconds: 200),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}
