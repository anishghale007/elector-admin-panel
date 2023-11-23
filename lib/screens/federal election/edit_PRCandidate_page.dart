import 'package:elector_admin_dashboard/controllers/federal_provider.dart';
import 'package:elector_admin_dashboard/models/federal_election.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class EditPRCandidatePage extends StatefulWidget {
  final FederalPR federalPR;

  const EditPRCandidatePage(this.federalPR, {super.key});

  @override
  State<EditPRCandidatePage> createState() => _EditPRCandidatePageState();
}

class _EditPRCandidatePageState extends State<EditPRCandidatePage> {
  final partyFullNameController = TextEditingController();

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
                        controller: partyFullNameController
                          ..text = widget.federalPR.partyFull,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Party Full Name is required';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            labelText: "Party Name",
                            hintText: "Full Name of the party",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20))),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: partyController
                          ..text = widget.federalPR.partyName,
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
                          ..text = widget.federalPR.barColor,
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
                            ..text = widget.federalPR.partyInfo,
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
                            final response = await ref
                                .read(federalProvider)
                                .updatePR(
                                  partyName: partyController.text.toString(),
                                  partyFull:
                                      partyFullNameController.text.toString(),
                                  partyInfo:
                                      partyInfoController.text.toString(),
                                  barColor: barColorController.text.toString(),
                                  postId: widget.federalPR.id,
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
