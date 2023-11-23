// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:html';
import 'package:elector_admin_dashboard/constants.dart';
import 'package:elector_admin_dashboard/controllers/federal_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AddFederalPRParties extends StatefulWidget {
  const AddFederalPRParties({super.key});

  @override
  State<AddFederalPRParties> createState() => _AddFederalPRPartiesState();
}

class _AddFederalPRPartiesState extends State<AddFederalPRParties> {
  final partyController = TextEditingController();
  final partyFullNameController = TextEditingController();

  final barColorController = TextEditingController();

  final partyInfoController = TextEditingController();

  final _form = GlobalKey<FormState>();

  String? partyUrl;

  uploadPartyImage() {
    final imageId = DateTime.now().toString();
    FileUploadInputElement input = FileUploadInputElement()..accept = 'image/*';
    FirebaseStorage fs = FirebaseStorage.instance;
    input.click();
    input.onChange.listen((event) {
      final file = input.files?.first;
      final reader = FileReader();
      reader.readAsDataUrl(file!);
      reader.onLoadEnd.listen((event) async {
        var snapshot =
            await fs.ref().child('federalPartyImage/$imageId').putBlob(file);
        String downloadUrl = await snapshot.ref.getDownloadURL();
        setState(() {
          partyUrl = downloadUrl;
        });
      });
    });
  }

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
                            "Federal PR Form",
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
                        controller: partyFullNameController,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Party Full Name is required';
                          }
                          if (val.length > 30) {
                            return 'No more than 30 words';
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
                        controller: partyController,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Party Short Form Name is required';
                          }
                          if (val.length > 5) {
                            return 'No more than 5 words';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            labelText: "Party Name (Short Form)",
                            hintText: "Short Form Name of the party",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20))),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: barColorController,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Party Name is required';
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
                          controller: partyInfoController,
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
                      const SizedBox(height: 40),
                      const Text(
                        "Political Party Picture",
                        style: TextStyle(
                          color: Color(0xFFA4A6B3),
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      const SizedBox(height: 20),
                      InkWell(
                        onTap: () {
                          uploadPartyImage();
                        },
                        child: Container(
                          height: 300,
                          width: 800,
                          decoration: BoxDecoration(
                            color: bgColor,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.grey, width: 1),
                          ),
                          child: partyUrl == null
                              ? const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Please upload the party picture',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                        height: 280,
                                        width: 400,
                                        child: Image.network(
                                          partyUrl!,
                                          fit: BoxFit.contain,
                                        )),
                                  ],
                                ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      InkWell(
                        onTap: () async {
                          _form.currentState!.save();
                          if (_form.currentState!.validate()) {
                            FocusScope.of(context).unfocus();
                            final response = await ref
                                .read(federalProvider)
                                .addPRPost(
                                  partyFull:
                                      partyFullNameController.text.toString(),
                                  partyName: partyController.text.toString(),
                                  barColor: barColorController.text.toString(),
                                  partyInfo:
                                      partyInfoController.text.toString(),
                                  imageUrl: partyUrl!,
                                );
                            if (response == 'Success') {
                              if (mounted) {
                                Navigator.of(context).pop();
                              }
                            } else if (response ==
                                'Barcolor is already taken') {
                              Get.dialog(AlertDialog(
                                title: const Text('Bar Color already taken'),
                                content: const Text(
                                    'Enter new bar color to avoid any confusion'),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Close')),
                                ],
                              ));
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
                            "Add Party",
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
