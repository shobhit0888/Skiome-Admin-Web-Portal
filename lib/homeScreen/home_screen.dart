import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';
import 'package:skiome_admin_web_portal/centres/blocked_centres_screen.dart';
import 'package:skiome_admin_web_portal/centres/verified_centres_screen.dart';
import 'package:skiome_admin_web_portal/schools/blocked_schools_screen.dart';
import 'package:skiome_admin_web_portal/schools/verified_schools_screen.dart';
import 'package:skiome_admin_web_portal/widgets/nav_appbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String liveTime = "";
  String liveDate = "";
  String formatCurrentLiveTime(DateTime time) {
    return DateFormat("hh:mm:ss a").format(time);
  }

  String formatCurrentLiveDate(DateTime time) {
    return DateFormat("dd MMMM, yyyy").format(time);
  }

  getCurrentLiveTimeDate() {
    liveTime = formatCurrentLiveTime(DateTime.now());
    liveDate = formatCurrentLiveDate(DateTime.now());
    setState(() {
      liveTime;
      liveDate;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      getCurrentLiveTimeDate();
    });
    getCurrentLiveTimeDate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: NavAppBar(
        title: "Skiome",
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                liveTime + "\n" + liveDate,
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    letterSpacing: 3,
                    fontWeight: FontWeight.bold),
              ),
            ),
            //schools activae and block button ui
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //active users
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (c) => VerifiedSchoolsScreen()));
                  },
                  child: Image.asset(
                    "images/verified_users.png",
                    width: MediaQuery.of(context).size.width * .1,
                  ),
                ),
                const SizedBox(
                  width: 200,
                ),
                //blocked users
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (c) => BlockedSchoolsScreen()));
                  },
                  child: Image.asset(
                    "images/blocked_users.png",
                    width: MediaQuery.of(context).size.width * .1,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            //active and blocked centres ui
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //active users
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (c) => VerifiedCentresScreen()));
                  },
                  child: Image.asset(
                    "images/verified_centre.png",
                    width: MediaQuery.of(context).size.width * .1,
                  ),
                ),
                const SizedBox(
                  width: 200,
                ),
                //blocked users
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (c) => BlockedCentresScreen()));
                  },
                  child: Image.asset(
                    "images/blocked_centre.png",
                    width: MediaQuery.of(context).size.width * .1,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
