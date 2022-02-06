import 'package:flutter/material.dart';

import 'orderPendingList.dart';
import 'orderProgressList.dart';

class OrderTabScreen extends StatelessWidget {
  
  OrderTabScreen({ Key key }) : super(key: key);
  static const routeName = '/orderTabScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Orders'),
            bottom: const TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.pending),
                  text: 'Pending Order',
                ),
                Tab(
                  icon: Icon(Icons.drag_indicator),
                  text: 'Progress Order',
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              CusPendingOrderList(),
              CusProgressOrderList(),
            ],
          ),
        ),
      ),
    );
  }
}