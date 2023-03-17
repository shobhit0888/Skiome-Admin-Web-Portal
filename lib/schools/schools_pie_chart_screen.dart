import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:skiome_admin_web_portal/widgets/nav_appbar.dart';

class SchoolsPieChartScreen extends StatefulWidget {
  const SchoolsPieChartScreen({super.key});

  @override
  State<SchoolsPieChartScreen> createState() => _SchoolsPieChartScreenState();
}

class _SchoolsPieChartScreenState extends State<SchoolsPieChartScreen> {
  int totalNumberOfVerifiedSchools = 0;
  int totalNumberOfBlockedSchools = 0;
  getTotalNumberOfVerifiedSchools() async {
    FirebaseFirestore.instance
        .collection("UsersSchools")
        .where("status", isEqualTo: "approved")
        .get()
        .then((allVerifiedCentres) {
      setState(() {
        totalNumberOfVerifiedSchools = allVerifiedCentres.docs.length;
      });
    });
  }

  getTotalNumberOfBlockedSchools() async {
    FirebaseFirestore.instance
        .collection("UsersSchools")
        .where("status", isEqualTo: "not approved")
        .get()
        .then((allBlockedCentres) {
      setState(() {
        totalNumberOfBlockedSchools = allBlockedCentres.docs.length;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTotalNumberOfBlockedSchools();
    getTotalNumberOfVerifiedSchools();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: NavAppBar(
        title: "Skiome",
      ),
      body: DChartPie(
        data: [
          {'domain': 'Blocked Schools', 'measure': totalNumberOfBlockedSchools},
          {
            'domain': 'Verified Schools',
            'measure': totalNumberOfVerifiedSchools
          },
        ],
        fillColor: (pieData, index) {
          switch (pieData['domain']) {
            case 'Blocked Schools':
              return Colors.pinkAccent;
            case 'Verified Schools':
              return Colors.deepPurpleAccent;
            default:
              return Colors.grey;
          }
        },
        labelFontSize: 20,
        animate: false,
        pieLabel: (pieData, index) {
          return "${pieData['domain']}";
        },
        labelColor: Colors.white,
        strokeWidth: 6,
        donutWidth: 30,
      ),
    );
  }
}
