import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp2/models/admin_view.dart';
import 'package:fyp2/widgets/admin/cancel_order_list.dart';
import 'package:fyp2/widgets/admin/order_list.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/admin/race.dart';
import '../widgets/admin/religion.dart';
import '../widgets/admin/vegetarian.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key key}) : super(key: key);

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  AdminView view;
  dynamic doc;
  Stream<QuerySnapshot<Map<String, dynamic>>> stream;
  double price = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: const Icon(
                Icons.logout,
                color: Colors.red,
              ))
        ],
        backgroundColor: Colors.grey[100],
      ),
      body: SafeArea(
        child: Column(
          children: [
            listOfTitle(context),
            getWidget(),
          ],
        ),
      ),
    );
  }

  Widget getWidget() {
    switch (view) {
      case AdminViews.cl:
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 10),
              alignment: Alignment.centerLeft,
              child: Text(
                'Confinement Lady',
                style: GoogleFonts.archivo(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            clWidget(),
          ],
        );
        break;
      case AdminViews.mother:
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 10),
              alignment: Alignment.centerLeft,
              child: Text(
                'Mother',
                style: GoogleFonts.archivo(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            motherWidget(),
          ],
        );
        break;
      case AdminViews.cancel:
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 10),
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cancel Order Request',
                    style: GoogleFonts.archivo(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  Row(
                    children: [
                      const Text(
                        '\u2713 ',
                        style: TextStyle(color: Colors.green),
                      ),
                      Text(
                        'to approve the request, \u274C to decline the request.',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            cancelWidget(),
          ],
        );
        break;
      case AdminViews.completed:
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 10),
              alignment: Alignment.centerLeft,
              child: Text(
                'Completed Order Information',
                style: GoogleFonts.archivo(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            orderWidget(),
          ],
        );
        break;
      case AdminViews.onGoing:
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 10),
              alignment: Alignment.centerLeft,
              child: Text(
                'On-Going Order Information',
                style: GoogleFonts.archivo(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            orderWidget(),
          ],
        );
        break;
      case AdminViews.pending:
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 10),
              alignment: Alignment.centerLeft,
              child: Text(
                'Pending Order Information',
                style: GoogleFonts.archivo(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            orderWidget(),
          ],
        );
        break;
      case AdminViews.declined:
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 10),
              alignment: Alignment.centerLeft,
              child: Text(
                'Declined Order Information',
                style: GoogleFonts.archivo(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            orderWidget(),
          ],
        );
        break;
      default:
        return Container(
          height: MediaQuery.of(context).size.height * 0.45,
          padding: const EdgeInsets.all(12),
          alignment: Alignment.center,
          child: const Text(
            'Press the listing on top to view more information.',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
    }
  }

  Widget clWidget() {
    return Container(
      padding: const EdgeInsets.all(10),
      height: MediaQuery.of(context).size.height * 0.48,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Race(doc: doc),
            Vegatarian(doc: doc),
            Religion(doc: doc),
          ],
        ),
      ),
    );
  }

  Widget motherWidget() {
    return Container(
      padding: const EdgeInsets.all(10),
      height: MediaQuery.of(context).size.height * 0.48,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Race(doc: doc),
            Vegatarian(doc: doc),
            Religion(doc: doc),
          ],
        ),
      ),
    );
  }

  Widget cancelWidget() {
    return Container(
      padding: const EdgeInsets.all(5),
      height: MediaQuery.of(context).size.height * 0.484,
      child: const CancelOrderList(),
    );
  }

  Widget orderWidget() {
    return Container(
        padding: const EdgeInsets.all(10),
        height: MediaQuery.of(context).size.height * 0.48,
        child: OrderList(
          stream: stream,
        ));
  }

  Widget listOfTitle(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        height: MediaQuery.of(context).size.height * 0.26,
        width: double.infinity,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            //no of confinement lady
            Container(
              margin: const EdgeInsets.all(8),
              width: 170,
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .where('userType', isEqualTo: 'Confinement Lady')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      final data = snapshot.data.docs;
                      return InkWell(
                        onTap: () {
                          setState(() {
                            view = AdminViews.cl;
                            doc = data;
                          });
                        },
                        child: Card(
                          elevation: 10,
                          color: Colors.amber[600],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'No. of\nService Provider',
                                    softWrap: true,
                                    style: GoogleFonts.archivo(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.centerRight,
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 10, 5),
                                  child: Text(
                                    data.length.toString(),
                                    softWrap: true,
                                    style: GoogleFonts.archivo(
                                      fontSize: 70,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                    return Card(
                      elevation: 10,
                      color: Colors.amber[600],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'No. of\nService Provider',
                                softWrap: true,
                                style: GoogleFonts.archivo(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                '0',
                                softWrap: true,
                                style: GoogleFonts.archivo(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
            //no of mother
            Container(
              margin: const EdgeInsets.all(8),
              width: 170,
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .where('userType', isEqualTo: 'Buyer')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      final data = snapshot.data.docs;
                      return InkWell(
                        onTap: (() {
                          setState(() {
                            view = AdminViews.mother;
                            doc = data;
                          });
                        }),
                        child: Card(
                          elevation: 10,
                          color: Colors.blue[900],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'No. of\nBuyer',
                                    softWrap: true,
                                    style: GoogleFonts.archivo(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.centerRight,
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 10, 5),
                                  child: Text(
                                    data.length.toString(),
                                    softWrap: true,
                                    style: GoogleFonts.archivo(
                                      fontSize: 70,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                    return Card(
                      elevation: 10,
                      color: Colors.blue[900],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'No. of\nBuyer',
                                softWrap: true,
                                style: GoogleFonts.archivo(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                '0',
                                softWrap: true,
                                style: GoogleFonts.archivo(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
            //no of cancel order
            Container(
              margin: const EdgeInsets.all(8),
              width: 170,
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('cancelOrder')
                      .orderBy('status', descending: true)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      final data = snapshot.data.docs;
                      return InkWell(
                        onTap: (() {
                          setState(() {
                            view = AdminViews.cancel;
                          });
                        }),
                        child: Card(
                          elevation: 10,
                          color: Colors.red[900],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Cancel\nOrder',
                                    softWrap: true,
                                    style: GoogleFonts.archivo(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.centerRight,
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 10, 5),
                                  child: Text(
                                    data.length.toString(),
                                    softWrap: true,
                                    style: GoogleFonts.archivo(
                                      fontSize: 70,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                    return Card(
                      elevation: 10,
                      color: Colors.red[900],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Cancel\nOrder',
                                softWrap: true,
                                style: GoogleFonts.archivo(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                '0',
                                softWrap: true,
                                style: GoogleFonts.archivo(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
            //no of pending order
            Container(
              margin: const EdgeInsets.all(8),
              width: 170,
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('onPendingOrder')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      final data = snapshot.data.docs;
                      return InkWell(
                        onTap: () {
                          setState(() {
                            view = AdminViews.pending;
                            stream = FirebaseFirestore.instance
                                .collection('onPendingOrder')
                                .orderBy('endDate', descending: true)
                                .snapshots();
                          });
                        },
                        child: Card(
                          elevation: 10,
                          color: Colors.lightBlue[200],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Pending Order',
                                    softWrap: true,
                                    style: GoogleFonts.archivo(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.centerRight,
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 10, 5),
                                  child: Text(
                                    data.length.toString(),
                                    softWrap: true,
                                    style: GoogleFonts.archivo(
                                      fontSize: 70,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                    return Card(
                      elevation: 10,
                      color: Colors.lightBlue[200],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Pending Order',
                                softWrap: true,
                                style: GoogleFonts.archivo(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                '0',
                                softWrap: true,
                                style: GoogleFonts.archivo(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
            //no of progress order
            Container(
              margin: const EdgeInsets.all(8),
              width: 170,
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('onProgressOrder')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      final data = snapshot.data.docs;
                      return InkWell(
                        onTap: () {
                          setState(() {
                            view = AdminViews.onGoing;
                            stream = FirebaseFirestore.instance
                                .collection('onProgressOrder')
                                .orderBy('endDate', descending: true)
                                .snapshots();
                          });
                        },
                        child: Card(
                          elevation: 10,
                          color: Colors.orange[800],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'On-Going Order',
                                    softWrap: true,
                                    style: GoogleFonts.archivo(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.centerRight,
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 10, 5),
                                  child: Text(
                                    data.length.toString(),
                                    softWrap: true,
                                    style: GoogleFonts.archivo(
                                      fontSize: 70,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                    return Card(
                      elevation: 10,
                      color: Colors.orange[800],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'On-Going Order',
                                softWrap: true,
                                style: GoogleFonts.archivo(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                '0',
                                softWrap: true,
                                style: GoogleFonts.archivo(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
            //no of success order
            Container(
              margin: const EdgeInsets.all(8),
              width: 170,
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('customerOrderHistory')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      final data = snapshot.data.docs;
                      return InkWell(
                        onTap: (() {
                          setState(() {
                            view = AdminViews.completed;
                            stream = FirebaseFirestore.instance
                                .collection('customerOrderHistory')
                                .orderBy('endDate', descending: true)
                                .snapshots();
                          });
                        }),
                        child: Card(
                          elevation: 10,
                          color: Colors.green[500],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Completed Order',
                                    softWrap: true,
                                    style: GoogleFonts.archivo(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.centerRight,
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 10, 5),
                                  child: Text(
                                    data.length.toString(),
                                    softWrap: true,
                                    style: GoogleFonts.archivo(
                                      fontSize: 70,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                    return Card(
                      elevation: 10,
                      color: Colors.green[500],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Completed Order',
                                softWrap: true,
                                style: GoogleFonts.archivo(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                '0',
                                softWrap: true,
                                style: GoogleFonts.archivo(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
            //no of declined order
            Container(
              margin: const EdgeInsets.all(8),
              width: 170,
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('declinedOrder')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      final data = snapshot.data.docs;
                      return InkWell(
                        onTap: () {
                          setState(() {
                            view = AdminViews.declined;
                            stream = FirebaseFirestore.instance
                                .collection('declinedOrder')
                                .orderBy('endDate', descending: true)
                                .snapshots();
                          });
                        },
                        child: Card(
                          elevation: 10,
                          color: Colors.purple[800],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Declined Order',
                                    softWrap: true,
                                    style: GoogleFonts.archivo(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.centerRight,
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 10, 5),
                                  child: Text(
                                    data.length.toString(),
                                    softWrap: true,
                                    style: GoogleFonts.archivo(
                                      fontSize: 70,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                    return Card(
                      elevation: 10,
                      color: Colors.purple[800],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Declined Order',
                                softWrap: true,
                                style: GoogleFonts.archivo(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                '0',
                                softWrap: true,
                                style: GoogleFonts.archivo(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ));
  }
}
