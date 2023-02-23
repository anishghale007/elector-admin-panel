import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elector_admin_dashboard/constants.dart';
import 'package:elector_admin_dashboard/screens/voter%20id/add_voterID_form.dart';
import 'package:elector_admin_dashboard/screens/voter%20id/remove_voterID_form.dart';
import 'package:elector_admin_dashboard/widgets/custom_button.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddVoterIDPage extends StatelessWidget {
  Future<DocumentSnapshot<Map<String, dynamic>>> getData() async {
    var firestore = FirebaseFirestore.instance
        .collection('electoral roll')
        .doc('electoralRoll')
        .get();
    return firestore;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            children: [
              SizedBox(height: 80),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Electoral Roll (Vote List)',
                    style: kSubHeadingTextStyle,
                  ),
                  Spacer(),
                  CustomButton(
                      text: 'Add Voter ID',
                      onPress: () {
                        Get.to(() => AddVoterIDForm());
                      },
                      color: Colors.blue),
                  SizedBox(width: 15),
                  CustomButton(
                      text: 'Remove Voter ID',
                      onPress: () {
                        Get.to(() => RemoveVoterIDForm());
                      },
                      color: Colors.red),
                ],
              ),
              SizedBox(height: 50),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      constraints: BoxConstraints(
                        maxHeight: double.infinity,
                      ),
                      decoration: BoxDecoration(
                          color: secondaryColor,
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        children: [
                          SizedBox(height: 25),
                          Text(
                            'Voter ID',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                            stream: FirebaseFirestore.instance
                                .collection('electoral roll')
                                .doc('electoralRoll')
                                .snapshots(),
                            builder: (_, snapshot) {
                              if (snapshot.hasData) {
                                var output = snapshot.data!.data();
                                var value = output!['Voter ID'];
                                return Column(
                                  children: [
                                    SizedBox(height: 30),
                                    for (value in output!['Voter ID'])
                                      Container(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 25, vertical: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                value.toString(),
                                                style: TextStyle(
                                                  fontSize: 19,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                                width: 0.5, color: Colors.grey),
                                            top: BorderSide(
                                                width: 0.5, color: Colors.grey),
                                          ),
                                        ),
                                      ),
                                    SizedBox(height: 20),
                                  ],
                                );
                              } else {
                                return Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 30),
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: 150,
                      decoration: BoxDecoration(
                          color: secondaryColor,
                          borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 25),
                            Text(
                              'Total Registered Voter ID',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                              stream: FirebaseFirestore.instance
                                  .collection('electoral roll')
                                  .doc('electoralRoll')
                                  .snapshots(),
                              builder: (_, snapshot) {
                                if (snapshot.hasData) {
                                  var output = snapshot.data!.data();
                                  var value = output!['totalVoterID'];
                                  return Column(
                                    children: [
                                      SizedBox(height: 25),
                                      Text(
                                        value.toString(),
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30,
                                        ),
                                      ),
                                    ],
                                  );
                                } else {
                                  return Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
