import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elector_admin_dashboard/constants.dart';
import 'package:elector_admin_dashboard/screens/voter%20id/add_voter_id_form.dart';
import 'package:elector_admin_dashboard/screens/voter%20id/remove_voter_id_form.dart';
import 'package:elector_admin_dashboard/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddVoterIDPage extends StatelessWidget {
  const AddVoterIDPage({super.key});

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
              const SizedBox(height: 80),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Electoral Roll (Vote List)',
                    style: kSubHeadingTextStyle,
                  ),
                  const Spacer(),
                  CustomButton(
                      text: 'Add Voter ID',
                      onPress: () {
                        Get.to(() => const AddVoterIDForm());
                      },
                      color: Colors.blue),
                  const SizedBox(width: 15),
                  CustomButton(
                      text: 'Remove Voter ID',
                      onPress: () {
                        Get.to(() => const RemoveVoterIDForm());
                      },
                      color: Colors.red),
                ],
              ),
              const SizedBox(height: 50),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      constraints: const BoxConstraints(
                        maxHeight: double.infinity,
                      ),
                      decoration: BoxDecoration(
                          color: secondaryColor,
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        children: [
                          const SizedBox(height: 25),
                          const Text(
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
                                    const SizedBox(height: 30),
                                    for (value in output['Voter ID'])
                                      Container(
                                        width: double.infinity,
                                        decoration: const BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                                width: 0.5, color: Colors.grey),
                                            top: BorderSide(
                                                width: 0.5, color: Colors.grey),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 25, vertical: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                value.toString(),
                                                style: const TextStyle(
                                                  fontSize: 19,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    const SizedBox(height: 20),
                                  ],
                                );
                              } else {
                                return const Center(
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
                  const SizedBox(width: 30),
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
                            const SizedBox(height: 25),
                            const Text(
                              'Total Registered Voter ID',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            StreamBuilder<
                                DocumentSnapshot<Map<String, dynamic>>>(
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
                                      const SizedBox(height: 25),
                                      Text(
                                        value.toString(),
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30,
                                        ),
                                      ),
                                    ],
                                  );
                                } else {
                                  return const Center(
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
