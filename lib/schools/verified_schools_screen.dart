import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:skiome_admin_web_portal/functions/functions.dart';
import 'package:skiome_admin_web_portal/homeScreen/home_screen.dart';
import 'package:skiome_admin_web_portal/widgets/nav_appbar.dart';

class VerifiedSchoolsScreen extends StatefulWidget {
  const VerifiedSchoolsScreen({super.key});

  @override
  State<VerifiedSchoolsScreen> createState() => _VerifiedSchoolsScreenState();
}

class _VerifiedSchoolsScreenState extends State<VerifiedSchoolsScreen> {
  QuerySnapshot? allApprovedSchools;

  showDialogBox(schoolDocumentId) {
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
                    Map<String, dynamic> schoolDataMap = {
                      "status": "not approved"
                    };
                    FirebaseFirestore.instance
                        .collection("UsersSchools")
                        .doc(schoolDocumentId)
                        .update(schoolDataMap)
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

  getAllVerifiedSchools() async {
    FirebaseFirestore.instance
        .collection("UsersSchools")
        .where("status", isEqualTo: "approved")
        .get()
        .then((allVerifiedSchools) {
      setState(() {
        allApprovedSchools = allVerifiedSchools;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllVerifiedSchools();
  }

  @override
  Widget build(BuildContext context) {
    Widget verifiedSchoolsDesign() {
      if (allApprovedSchools == null) {
        return Center(
          child: Text(
            "No Record Found",
            style: TextStyle(fontSize: 30),
          ),
        );
      } else {
        return ListView.builder(
            padding: EdgeInsets.all(10),
            itemCount: allApprovedSchools!.docs.length,
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
                                image: NetworkImage(allApprovedSchools!
                                    .docs[index]
                                    .get("photoUrl")))),
                      ),
                    ),
                    Text(allApprovedSchools!.docs[index].get("name")),
                    Text(
                      allApprovedSchools!.docs[index].get("email"),
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    GestureDetector(
                      onTap: () {
                        showDialogBox(allApprovedSchools!.docs[index].id);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 18.0, bottom: 8.0),
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
                    )
                  ],
                ),
              );
            });
      }
    }

    return Scaffold(
      appBar: NavAppBar(
        title: "Verified Schools Accounts",
      ),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * .5,
          child: verifiedSchoolsDesign(),
        ),
      ),
    );
  }
}
