import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:skiome_admin_web_portal/functions/functions.dart';
import 'package:skiome_admin_web_portal/homeScreen/home_screen.dart';
import 'package:skiome_admin_web_portal/widgets/nav_appbar.dart';

class VerifiedCentresScreen extends StatefulWidget {
  const VerifiedCentresScreen({super.key});

  @override
  State<VerifiedCentresScreen> createState() => _VerifiedCentresScreenState();
}

class _VerifiedCentresScreenState extends State<VerifiedCentresScreen> {
  QuerySnapshot? allApprovedCentres;

  showDialogBox(centreDocumentId) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              "Block Account",
              style: TextStyle(
                fontSize: 25,
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: const Text(
              "Do you want to block this account",
              style: TextStyle(fontSize: 16, letterSpacing: 2),
            ),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("No")),
              ElevatedButton(
                  onPressed: () {
                    Map<String, dynamic> centreDataMap = {
                      "status": "not approved"
                    };
                    FirebaseFirestore.instance
                        .collection("Centres")
                        .doc(centreDocumentId)
                        .update(centreDataMap)
                        .whenComplete(() {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (c) => HomeScreen()));
                      showReusableSnackBar(context, "Blocked Successfuylly");
                    });
                  },
                  child: Text("Yes"))
            ],
          );
        });
  }

  getAllVerifiedCentres() async {
    FirebaseFirestore.instance
        .collection("Centres")
        .where("status", isEqualTo: "approved")
        .get()
        .then((allVerifiedCentres) {
      setState(() {
        allApprovedCentres = allVerifiedCentres;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllVerifiedCentres();
  }

  @override
  Widget build(BuildContext context) {
    Widget verifiedCentresDesign() {
      if (allApprovedCentres == null) {
        return Center(
          child: Text(
            "No Record Found",
            style: TextStyle(fontSize: 30),
          ),
        );
      } else {
        return ListView.builder(
            padding: EdgeInsets.all(10),
            itemCount: allApprovedCentres!.docs.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 10,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 180,
                        height: 140,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: NetworkImage(allApprovedCentres!
                                    .docs[index]
                                    .get("photoUrl")))),
                      ),
                    ),
                    Text(allApprovedCentres!.docs[index].get("name")),
                    Text(
                      allApprovedCentres!.docs[index].get("email"),
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        //block now
                        GestureDetector(
                          onTap: () {
                            showDialogBox(allApprovedCentres!.docs[index].id);
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.only(top: 18.0, bottom: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "images/block.png",
                                  width: 56,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Block Now",
                                  style: TextStyle(color: Colors.redAccent),
                                )
                              ],
                            ),
                          ),
                        ),

                        //earnings
                        GestureDetector(
                          onTap: () {
                            showReusableSnackBar(
                              context,
                              "Total Earnings = ".toUpperCase() +
                                  "Rs." +
                                  allApprovedCentres!.docs[index]
                                      .get("earnings")
                                      .toString(),
                            );
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.only(top: 18.0, bottom: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "images/earnings.png",
                                  width: 56,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Rs." +
                                      allApprovedCentres!.docs[index]
                                          .get("earnings")
                                          .toString(),
                                  style: TextStyle(color: Colors.redAccent),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              );
            });
      }
    }

    return Scaffold(
      appBar: NavAppBar(
        title: "Verified Centres Accounts",
      ),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * .5,
          child: verifiedCentresDesign(),
        ),
      ),
    );
  }
}
