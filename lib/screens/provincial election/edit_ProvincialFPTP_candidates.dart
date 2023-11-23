import 'package:elector_admin_dashboard/controllers/provincial%20controller/bagmati_provider.dart';
import 'package:elector_admin_dashboard/controllers/provincial%20controller/gandaki_provider.dart';
import 'package:elector_admin_dashboard/controllers/provincial%20controller/karnali_provider.dart';
import 'package:elector_admin_dashboard/controllers/provincial%20controller/lumbini_provider.dart';
import 'package:elector_admin_dashboard/controllers/provincial%20controller/madhesh_provider.dart';
import 'package:elector_admin_dashboard/controllers/provincial%20controller/province1_provider.dart';
import 'package:elector_admin_dashboard/controllers/provincial%20controller/sudurpaschim_provider.dart';
import 'package:elector_admin_dashboard/models/provincial_election.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class EditProvincialFPTPPage extends StatefulWidget {
  final ProvincialFPTP provincialFPTP;
  final String province;

  const EditProvincialFPTPPage(this.provincialFPTP, this.province, {super.key});

  @override
  State<EditProvincialFPTPPage> createState() => _EditProvincialFPTPPageState();
}

class _EditProvincialFPTPPageState extends State<EditProvincialFPTPPage> {
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
                  constraints: const BoxConstraints(maxWidth: 800),
                  padding: const EdgeInsets.all(24),
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
                      const SizedBox(
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
                      const SizedBox(
                        height: 10,
                      ),
                      const Row(
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
                      const SizedBox(
                        height: 40,
                      ),
                      TextFormField(
                        controller: candidateController
                          ..text = widget.provincialFPTP.candidateName,
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
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: partyController
                          ..text = widget.provincialFPTP.partyName,
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
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: barColorController
                          ..text = widget.provincialFPTP.barColor,
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
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        height: 200,
                        child: TextFormField(
                          controller: candidateInfoController
                            ..text = widget.provincialFPTP.candidateInfo,
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
                      const SizedBox(
                        height: 40,
                      ),
                      InkWell(
                        onTap: () async {
                          _form.currentState!.save();
                          if (_form.currentState!.validate()) {
                            FocusScope.of(context).unfocus();
                            if (widget.province == "Province 1") {
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
                                    postId: widget.provincialFPTP.id,
                                  );
                              if (response == 'Success') {
                                Navigator.of(context).pop();
                              } else {
                                Get.showSnackbar(GetSnackBar(
                                  duration: const Duration(seconds: 5),
                                  title: 'Some error occurred',
                                  message: response,
                                ));
                              }
                            } else if (widget.province == "Gandaki") {
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
                                    postId: widget.provincialFPTP.id,
                                  );
                              if (response == 'Success') {
                                Navigator.of(context).pop();
                              } else {
                                Get.showSnackbar(GetSnackBar(
                                  duration: const Duration(seconds: 5),
                                  title: 'Some error occurred',
                                  message: response,
                                ));
                              }
                            } else if (widget.province == "Lumbini") {
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
                                    postId: widget.provincialFPTP.id,
                                  );
                              if (response == 'Success') {
                                Navigator.of(context).pop();
                              } else {
                                Get.showSnackbar(GetSnackBar(
                                  duration: const Duration(seconds: 5),
                                  title: 'Some error occurred',
                                  message: response,
                                ));
                              }
                            } else if (widget.province == "Karnali") {
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
                                    postId: widget.provincialFPTP.id,
                                  );
                              if (response == 'Success') {
                                if (mounted) {
                                  Navigator.of(context).pop();
                                }
                              } else {
                                Get.showSnackbar(GetSnackBar(
                                  duration: const Duration(seconds: 5),
                                  title: 'Some error occurred',
                                  message: response,
                                ));
                              }
                            } else if (widget.province == "Madhesh") {
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
                                    postId: widget.provincialFPTP.id,
                                  );
                              if (response == 'Success') {
                                Navigator.of(context).pop();
                              } else {
                                Get.showSnackbar(GetSnackBar(
                                  duration: const Duration(seconds: 5),
                                  title: 'Some error occurred',
                                  message: response,
                                ));
                              }
                            } else if (widget.province == "Bagmati") {
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
                                    postId: widget.provincialFPTP.id,
                                  );
                              if (response == 'Success') {
                                Navigator.of(context).pop();
                              } else {
                                Get.showSnackbar(GetSnackBar(
                                  duration: const Duration(seconds: 5),
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
                                    postId: widget.provincialFPTP.id,
                                  );
                              if (response == 'Success') {
                                Navigator.of(context).pop();
                              } else {
                                Get.showSnackbar(GetSnackBar(
                                  duration: const Duration(seconds: 5),
                                  title: 'Some error occurred',
                                  message: response,
                                ));
                              }
                            }
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF3C19C0),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          alignment: Alignment.center,
                          width: double.maxFinite,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: const Text(
                            "Confirm Changes",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.normal,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
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
