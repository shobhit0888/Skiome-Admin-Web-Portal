import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:skiome_admin_web_portal/functions/functions.dart';
import 'package:skiome_admin_web_portal/homeScreen/home_screen.dart';
import 'package:skiome_admin_web_portal/widgets/nav_appbar.dart';

class BlockedSchoolsScreen extends StatefulWidget {
  const BlockedSchoolsScreen({super.key});

  @override
  State<BlockedSchoolsScreen> createState() => _BlockedSchoolsScreenState();
}

class _BlockedSchoolsScreenState extends State<BlockedSchoolsScreen> {
  QuerySnapshot? allBlockedSchools;

  showDialogBox(schoolDocumentId) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              "Activate Account",
              style: TextStyle(
                fontSize: 25,
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: const Text(
              "Do you want to activate this account",
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
                    Map<String, dynamic> schoolDataMap = {"status": "approved"};
                    FirebaseFirestore.instance
                        .collection("UsersSchools")
                        .doc(schoolDocumentId)
                        .update(schoolDataMap)
                        .whenComplete(() {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (c) => HomeScreen()));
                      showReusableSnackBar(context, "Activated Successfuylly");
                    });
                  },
                  child: Text("Yes"))
            ],
          );
        });
  }

  getAllBlockedSchools() async {
    FirebaseFirestore.instance
        .collection("UsersSchools")
        .where("status", isEqualTo: "not approved")
        .get()
        .then((getAllBlockedSchools) {
      setState(() {
        allBlockedSchools = getAllBlockedSchools;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllBlockedSchools();
  }

  @override
  Widget build(BuildContext context) {
    Widget blockedSchoolsDesign() {
      if (allBlockedSchools == null) {
        return Center(
          child: Text(
            "No Record Found",
            style: TextStyle(fontSize: 30),
          ),
        );
      } else {
        return ListView.builder(
            padding: EdgeInsets.all(10),
            itemCount: allBlockedSchools!.docs.length,
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
                                image: NetworkImage(allBlockedSchools!
                                    .docs[index]
                                    .get("photoUrl")))),
                      ),
                    ),
                    Text(allBlockedSchools!.docs[index].get("name")),
                    Text(
                      allBlockedSchools!.docs[index].get("email"),
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    GestureDetector(
                      onTap: () {
                        showDialogBox(allBlockedSchools!.docs[index].id);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 18.0, bottom: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "images/activate.png",
                              width: 56,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Activate Now",
                              style: TextStyle(color: Colors.greenAccent),
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
        title: "Blocked Schools Accounts",
      ),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * .5,
          child: blockedSchoolsDesign(),
        ),
      ),
    );
  }
}
