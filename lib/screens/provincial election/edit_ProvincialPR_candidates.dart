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

class EditProvincialPRPage extends StatelessWidget {
  final ProvincialPR provincialPR;
  final String province;

  EditProvincialPRPage(this.provincialPR, this.province, {super.key});

  final partyController = TextEditingController();
  final barColorController = TextEditingController();
  final partyInfoController = TextEditingController();
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
                          SizedBox(
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
                            "PR Candidates Edit Form",
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
                        controller: partyController
                          ..text = provincialPR.partyName,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Party Short Name is required';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            labelText: "Party Short Name",
                            hintText: "Short Form of the Party name",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20))),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: barColorController
                          ..text = provincialPR.barColor,
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
                          controller: partyInfoController
                            ..text = provincialPR.partyInfo,
                          expands: true,
                          maxLines: null,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'Party Info is required';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              labelText: "Party Info",
                              hintText: "Info of the party",
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
                            if (province == "Province 1") {
                              final response = await ref
                                  .read(province1Provider)
                                  .updatePR(
                                    partyName: partyController.text.toString(),
                                    partyInfo:
                                        partyInfoController.text.toString(),
                                    barColor:
                                        barColorController.text.toString(),
                                    postId: provincialPR.id,
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
                            } else if (province == "Gandaki") {
                              final response = await ref
                                  .read(gandakiProvider)
                                  .updatePR(
                                    partyName: partyController.text.toString(),
                                    partyInfo:
                                        partyInfoController.text.toString(),
                                    barColor:
                                        barColorController.text.toString(),
                                    postId: provincialPR.id,
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
                            } else if (province == "Lumbini") {
                              final response = await ref
                                  .read(lumbiniProvider)
                                  .updatePR(
                                    partyName: partyController.text.toString(),
                                    partyInfo:
                                        partyInfoController.text.toString(),
                                    barColor:
                                        barColorController.text.toString(),
                                    postId: provincialPR.id,
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
                            } else if (province == "Karnali") {
                              final response = await ref
                                  .read(karnaliProvider)
                                  .updatePR(
                                    partyName: partyController.text.toString(),
                                    partyInfo:
                                        partyInfoController.text.toString(),
                                    barColor:
                                        barColorController.text.toString(),
                                    postId: provincialPR.id,
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
                            } else if (province == "Madhesh") {
                              final response = await ref
                                  .read(madheshProvider)
                                  .updatePR(
                                    partyName: partyController.text.toString(),
                                    partyInfo:
                                        partyInfoController.text.toString(),
                                    barColor:
                                        barColorController.text.toString(),
                                    postId: provincialPR.id,
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
                            } else if (province == "Bagmati") {
                              final response = await ref
                                  .read(bagmatiProvider)
                                  .updatePR(
                                    partyName: partyController.text.toString(),
                                    partyInfo:
                                        partyInfoController.text.toString(),
                                    barColor:
                                        barColorController.text.toString(),
                                    postId: provincialPR.id,
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
                                  .updatePR(
                                    partyName: partyController.text.toString(),
                                    partyInfo:
                                        partyInfoController.text.toString(),
                                    barColor:
                                        barColorController.text.toString(),
                                    postId: provincialPR.id,
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
