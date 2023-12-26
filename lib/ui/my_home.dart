import 'package:boilerplate/constants/colors.dart';
import 'package:boilerplate/ui/account/account.dart';
import 'package:boilerplate/ui/catalogue/catalogue.dart';
import 'package:boilerplate/ui/home/home.dart';
import 'package:boilerplate/ui/mcp/mcp.dart';
import 'package:flutter/material.dart';

import 'kpi/kpi.dart';

class MyHome extends StatefulWidget {
  final int? tabIndex;

  const MyHome({
    Key? key,
    this.tabIndex
  }) : super(key: key);

  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    HomeScreen(),
    McpScreen(),
    KpiScreen(),
    CatalogueScreen(),
    AccountScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _selectedIndex = widget.tabIndex ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        children: _pages,
        index: _selectedIndex,
      ),
      bottomNavigationBar: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: (AppColors.green[200])!, width: 0.5, style: BorderStyle.solid))),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined, size: 26, color: AppColors.greyPrice),
              activeIcon: Icon(Icons.home, color: AppColors.green[500], size: 26,),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.content_paste_outlined, size: 24, color: AppColors.greyPrice),
              activeIcon: Icon(Icons.content_paste, color: AppColors.green[500], size: 24,),
              label: 'MCP',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_outlined, size: 26, color: AppColors.greyPrice),
              activeIcon: Icon(Icons.bar_chart, color: AppColors.green[500], size: 26,),
              label: 'KPI',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book_outlined, size: 26, color: AppColors.greyPrice),
              activeIcon: Icon(Icons.book, color: AppColors.green[500], size: 26,),
              label: 'Catalogue',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_outlined, size: 26, color: AppColors.greyPrice),
              activeIcon: Icon(Icons.account_circle, color: AppColors.green[500], size: 26,),
              label: 'Account',
            ),
          ],
          selectedLabelStyle: TextStyle(fontSize: 12),
          selectedItemColor: AppColors.textColor,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}