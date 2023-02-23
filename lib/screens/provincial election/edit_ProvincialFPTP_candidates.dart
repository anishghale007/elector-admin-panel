import 'package:elector_admin_dashboard/controllers/federal_provider.dart';
import 'package:elector_admin_dashboard/controllers/provincial%20controller/bagmati_provider.dart';
import 'package:elector_admin_dashboard/controllers/provincial%20controller/gandaki_provider.dart';
import 'package:elector_admin_dashboard/controllers/provincial%20controller/karnali_provider.dart';
import 'package:elector_admin_dashboard/controllers/provincial%20controller/lumbini_provider.dart';
import 'package:elector_admin_dashboard/controllers/provincial%20controller/madhesh_provider.dart';
import 'package:elector_admin_dashboard/controllers/provincial%20controller/province1_provider.dart';
import 'package:elector_admin_dashboard/controllers/provincial%20controller/sudurpaschim_provider.dart';
import 'package:elector_admin_dashboard/models/federal_election.dart';
import 'package:elector_admin_dashboard/models/provincial_election.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class EditProvincialFPTPPage extends StatelessWidget {
  final ProvincialFPTP provincialFPTP;
  final String province;

  EditProvincialFPTPPage(this.provincialFPTP, this.province);

  final candidateController = TextEditingController();
  final partyController = TextEditingController();
  final barColorController = TextEditingController();
  final candidateInfoController = TextEditingController();
  final _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return Form(
          key: _form,
          child: Scaffold(
            body: SingleChildScrollView(
              child: Center(
                child: Container(
                  constraints: BoxConstraints(maxWidth: 800),
                  padding: EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 100,
                            width: 300,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: Image.asset(
                                "assets/images/elector_logo2.png",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        children: [
                          Text(
                            "FPTP Candidates Edit Form",
                            style: GoogleFonts.roboto(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text(
                            "Please fill out the form",
                            style: TextStyle(
                              color: Color(0xFFA4A6B3),
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      TextFormField(
                        controller: candidateController
                          ..text = provincialFPTP.candidateName,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Candidate Name is required';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            labelText: "Candidate Name",
                            hintText: "Full Name of the candidate",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20))),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: partyController
                          ..text = provincialFPTP.partyName,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Party Name is required';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            labelText: "Party Name",
                            hintText: "Name of the Political Party",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20))),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: barColorController
                          ..text = provincialFPTP.barColor,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Bar Color is required';
                          }
                          if (val.length > 15) {
                            return 'No more than 15 words';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            labelText: "Bar Color (Hex Value)",
                            hintText: "Color Hex Value (eg. 0xFF078787)",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20))),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        height: 200,
                        child: TextFormField(
                          controller: candidateInfoController
                            ..text = provincialFPTP.candidateInfo,
                          expands: true,
                          maxLines: null,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'Candidate Info is required';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              labelText: "Candidate Info",
                              hintText: "Personal Info of the candidate",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20))),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      InkWell(
                        onTap: () async {
                          _form.currentState!.save();
                          if (_form.currentState!.validate()) {
                            FocusScope.of(context).unfocus();
                            if (province == "Province 1") {
                              final response = await ref
                                  .read(province1Provider)
                                  .updateFPTP(
                                    candidateName:
                                        candidateController.text.toString(),
                                    partyName: partyController.text.toString(),
                                    candidateInfo:
                                        candidateInfoController.text.toString(),
                                    barColor:
                                        barColorController.text.toString(),
                                    postId: provincialFPTP.id,
                                  );
                              if (response == 'Success') {
                                Navigator.of(context).pop();
                              } else {
                                Get.showSnackbar(GetSnackBar(
                                  duration: Duration(seconds: 5),
                                  title: 'Some error occurred',
                                  message: response,
                                ));
                              }
                            } else if (province == "Gandaki") {
                              final response = await ref
                                  .read(gandakiProvider)
                                  .updateFPTP(
                                    candidateName:
                                        candidateController.text.toString(),
                                    partyName: partyController.text.toString(),
                                    candidateInfo:
                                        candidateInfoController.text.toString(),
                                    barColor:
                                        barColorController.text.toString(),
                                    postId: provincialFPTP.id,
                                  );
                              if (response == 'Success') {
                                Navigator.of(context).pop();
                              } else {
                                Get.showSnackbar(GetSnackBar(
                                  duration: Duration(seconds: 5),
                                  title: 'Some error occurred',
                                  message: response,
                                ));
                              }
                            } else if (province == "Lumbini") {
                              final response = await ref
                                  .read(lumbiniProvider)
                                  .updateFPTP(
                                    candidateName:
                                        candidateController.text.toString(),
                                    partyName: partyController.text.toString(),
                                    candidateInfo:
                                        candidateInfoController.text.toString(),
                                    barColor:
                                        barColorController.text.toString(),
                                    postId: provincialFPTP.id,
                                  );
                              if (response == 'Success') {
                                Navigator.of(context).pop();
                              } else {
                                Get.showSnackbar(GetSnackBar(
                                  duration: Duration(seconds: 5),
                                  title: 'Some error occurred',
                                  message: response,
                                ));
                              }
                            } else if (province == "Karnali") {
                              final response = await ref
                                  .read(karnaliProvider)
                                  .updateFPTP(
                                    candidateName:
                                        candidateController.text.toString(),
                                    partyName: partyController.text.toString(),
                                    candidateInfo:
                                        candidateInfoController.text.toString(),
                                    barColor:
                                        barColorController.text.toString(),
                                    postId: provincialFPTP.id,
                                  );
                              if (response == 'Success') {
                                Navigator.of(context).pop();
                              } else {
                                Get.showSnackbar(GetSnackBar(
                                  duration: Duration(seconds: 5),
                                  title: 'Some error occurred',
                                  message: response,
                                ));
                              }
                            } else if (province == "Madhesh") {
                              final response = await ref
                                  .read(madheshProvider)
                                  .updateFPTP(
                                    candidateName:
                                        candidateController.text.toString(),
                                    partyName: partyController.text.toString(),
                                    candidateInfo:
                                        candidateInfoController.text.toString(),
                                    barColor:
                                        barColorController.text.toString(),
                                    postId: provincialFPTP.id,
                                  );
                              if (response == 'Success') {
                                Navigator.of(context).pop();
                              } else {
                                Get.showSnackbar(GetSnackBar(
                                  duration: Duration(seconds: 5),
                                  title: 'Some error occurred',
                                  message: response,
                                ));
                              }
                            } else if (province == "Bagmati") {
                              final response = await ref
                                  .read(bagmatiProvider)
                                  .updateFPTP(
                                    candidateName:
                                        candidateController.text.toString(),
                                    partyName: partyController.text.toString(),
                                    candidateInfo:
                                        candidateInfoController.text.toString(),
                                    barColor:
                                        barColorController.text.toString(),
                                    postId: provincialFPTP.id,
                                  );
                              if (response == 'Success') {
                                Navigator.of(context).pop();
                              } else {
                                Get.showSnackbar(GetSnackBar(
                                  duration: Duration(seconds: 5),
                                  title: 'Some error occurred',
                                  message: response,
                                ));
                              }
                            } else {
                              final response = await ref
                                  .read(sudurpaschimProvider)
                                  .updateFPTP(
                                    candidateName:
                                        candidateController.text.toString(),
                                    partyName: partyController.text.toString(),
                                    candidateInfo:
                                        candidateInfoController.text.toString(),
                                    barColor:
                                        barColorController.text.toString(),
                                    postId: provincialFPTP.id,
                                  );
                              if (response == 'Success') {
                                Navigator.of(context).pop();
                              } else {
                                Get.showSnackbar(GetSnackBar(
                                  duration: Duration(seconds: 5),
                                  title: 'Some error occurred',
                                  message: response,
                                ));
                              }
                            }
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xFF3C19C0),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          alignment: Alignment.center,
                          width: double.maxFinite,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Text(
                            "Confirm Changes",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.normal,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
