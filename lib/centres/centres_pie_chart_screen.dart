import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:skiome_admin_web_portal/widgets/nav_appbar.dart';

class CentresPieChartScreen extends StatefulWidget {
  const CentresPieChartScreen({super.key});

  @override
  State<CentresPieChartScreen> createState() => _CentresPieChartScreenState();
}

class _CentresPieChartScreenState extends State<CentresPieChartScreen> {
  int totalNumberOfVerifiedCentres = 0;
  int totalNumberOfBlockedCentres = 0;
  getTotalNumberOfVerifiedCentres() async {
    FirebaseFirestore.instance
        .collection("Centres")
        .where("status", isEqualTo: "approved")
        .get()
        .then((allVerifiedCentres) {
      setState(() {
        totalNumberOfVerifiedCentres = allVerifiedCentres.docs.length;
      });
    });
  }

  getTotalNumberOfBlockedCentres() async {
    FirebaseFirestore.instance
        .collection("Centres")
        .where("status", isEqualTo: "not approved")
        .get()
        .then((allBlockedCentres) {
      setState(() {
        totalNumberOfBlockedCentres = allBlockedCentres.docs.length;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTotalNumberOfBlockedCentres();
    getTotalNumberOfVerifiedCentres();
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
          {'domain': 'Blocked Centres', 'measure': totalNumberOfBlockedCentres},
          {
            'domain': 'Verified Centres',
            'measure': totalNumberOfVerifiedCentres
          },
        ],
        fillColor: (pieData, index) {
          switch (pieData['domain']) {
            case 'Blocked Centres':
              return Colors.pinkAccent;
            case 'Verified Centres':
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
