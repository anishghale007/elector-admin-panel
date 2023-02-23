import 'dart:html';
import 'package:elector_admin_dashboard/constants.dart';
import 'package:elector_admin_dashboard/controllers/federal_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controllers/provincial controller/bagmati_provider.dart';
import '../../controllers/provincial controller/gandaki_provider.dart';
import '../../controllers/provincial controller/karnali_provider.dart';
import '../../controllers/provincial controller/lumbini_provider.dart';
import '../../controllers/provincial controller/madhesh_provider.dart';
import '../../controllers/provincial controller/province1_provider.dart';
import '../../controllers/provincial controller/sudurpaschim_provider.dart';

class AddProvincialFPTPCandidates extends StatefulWidget {
  @override
  State<AddProvincialFPTPCandidates> createState() =>
      _AddProvincialFPTPCandidatesState();
}

class _AddProvincialFPTPCandidatesState
    extends State<AddProvincialFPTPCandidates> {
  final candidateController = TextEditingController();

  final partyController = TextEditingController();

  final barColorController = TextEditingController();

  final candidateInfoController = TextEditingController();

  final _form = GlobalKey<FormState>();

  String? candidateUrl;
  String? partyUrl;

  String _selectedProvince = "";
  var province = {
    'Province No.1',
    'Madhesh',
    'Bagmati',
    'Gandaki',
    'Lumbini',
    'Karnali',
    'Sudurpaschim',
  };

  uploadCandidateImage() {
    final imageId = DateTime.now().toString();
    FileUploadInputElement input = FileUploadInputElement()..accept = 'image/*';
    FirebaseStorage fs = FirebaseStorage.instance;
    input.click();
    input.onChange.listen((event) {
      final file = input.files?.first;
      final reader = FileReader();
      reader.readAsDataUrl(file!);
      reader.onLoadEnd.listen((event) async {
        var snapshot = await fs
            .ref()
            .child('provincialCandidateImage/$imageId')
            .putBlob(file);
        String downloadUrl = await snapshot.ref.getDownloadURL();
        setState(() {
          candidateUrl = downloadUrl;
          print(candidateUrl);
        });
      });
    });
  }

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
          print(partyUrl);
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
                            "Provincial FPTP Form",
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
                      DropdownButtonFormField(
                          value: _selectedProvince.isNotEmpty
                              ? _selectedProvince
                              : null,
                          validator: (value) {
                            if (value == null) {
                              return 'Please select a province';
                            }
                          },
                          hint: Text(
                            "Select Province",
                          ),
                          decoration: InputDecoration(
                            fillColor: bgColor,
                            filled: true,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                          ),
                          items: province.map((String election) {
                            return DropdownMenuItem(
                              child: Text(election),
                              value: election,
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedProvince = "$newValue";
                              print(_selectedProvince);
                            });
                          }),
                      SizedBox(height: 15),
                      TextFormField(
                        controller: candidateController,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Candidate Name is required';
                          }
                          if (val.length > 30) {
                            return 'No more than 30 words';
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
                        controller: partyController,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Party Name is required';
                          }
                          if (val.length > 30) {
                            return 'No more than 30 words';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            labelText: "Party Name",
                            hintText: "Party Name of the candidate",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20))),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: barColorController,
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
                          controller: candidateInfoController,
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
                      SizedBox(height: 40),
                      Text(
                        "Candidate Profile Picture",
                        style: TextStyle(
                          color: Color(0xFFA4A6B3),
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      SizedBox(height: 20),
                      InkWell(
                        onTap: () {
                          uploadCandidateImage();
                        },
                        child: Container(
                          height: 300,
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                            color: bgColor,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.grey, width: 1),
                          ),
                          child: candidateUrl == null
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Please upload the candidate profile picture',
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
                                    Container(
                                        height: 280,
                                        width: 400,
                                        child: Image.network(
                                          candidateUrl!,
                                          fit: BoxFit.contain,
                                        )),
                                  ],
                                ),
                        ),
                      ),
                      SizedBox(height: 40),
                      Text(
                        "Candidate Party Picture",
                        style: TextStyle(
                          color: Color(0xFFA4A6B3),
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      SizedBox(height: 20),
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
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Please upload the candidate party picture',
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
                                    Container(
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
                      SizedBox(height: 40),
                      InkWell(
                        onTap: () async {
                          _form.currentState!.save();
                          if (_form.currentState!.validate()) {
                            if (_selectedProvince == "Province No.1") {
                              FocusScope.of(context).unfocus();
                              final response = await ref
                                  .read(province1Provider)
                                  .addFPTPPost(
                                    candidateName:
                                        candidateController.text.toString(),
                                    barColor:
                                        barColorController.text.toString(),
                                    partyName: partyController.text.toString(),
                                    candidateInfo:
                                        candidateInfoController.text.toString(),
                                    imageUrl: candidateUrl!,
                                    partyUrl: partyUrl!,
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
                            } else if (_selectedProvince == "Bagmati") {
                              FocusScope.of(context).unfocus();
                              final response = await ref
                                  .read(bagmatiProvider)
                                  .addFPTPPost(
                                    barColor:
                                        barColorController.text.toString(),
                                    candidateName:
                                        candidateController.text.toString(),
                                    partyName: partyController.text.toString(),
                                    candidateInfo:
                                        candidateInfoController.text.toString(),
                                    imageUrl: candidateUrl!,
                                    partyUrl: partyUrl!,
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
                            } else if (_selectedProvince == "Gandaki") {
                              FocusScope.of(context).unfocus();
                              final response = await ref
                                  .read(gandakiProvider)
                                  .addFPTPPost(
                                    barColor:
                                        barColorController.text.toString(),
                                    candidateName:
                                        candidateController.text.toString(),
                                    partyName: partyController.text.toString(),
                                    candidateInfo:
                                        candidateInfoController.text.toString(),
                                    imageUrl: candidateUrl!,
                                    partyUrl: partyUrl!,
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
                            } else if (_selectedProvince == "Madhesh") {
                              FocusScope.of(context).unfocus();
                              final response = await ref
                                  .read(madheshProvider)
                                  .addFPTPPost(
                                    candidateName:
                                        candidateController.text.toString(),
                                    partyName: partyController.text.toString(),
                                    barColor:
                                        barColorController.text.toString(),
                                    candidateInfo:
                                        candidateInfoController.text.toString(),
                                    imageUrl: candidateUrl!,
                                    partyUrl: partyUrl!,
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
                            } else if (_selectedProvince == "Lumbini") {
                              FocusScope.of(context).unfocus();
                              final response = await ref
                                  .read(lumbiniProvider)
                                  .addFPTPPost(
                                    candidateName:
                                        candidateController.text.toString(),
                                    partyName: partyController.text.toString(),
                                    barColor:
                                        barColorController.text.toString(),
                                    candidateInfo:
                                        candidateInfoController.text.toString(),
                                    imageUrl: candidateUrl!,
                                    partyUrl: partyUrl!,
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
                            } else if (_selectedProvince == "Karnali") {
                              FocusScope.of(context).unfocus();
                              final response = await ref
                                  .read(karnaliProvider)
                                  .addFPTPPost(
                                    candidateName:
                                        candidateController.text.toString(),
                                    partyName: partyController.text.toString(),
                                    barColor:
                                        barColorController.text.toString(),
                                    candidateInfo:
                                        candidateInfoController.text.toString(),
                                    imageUrl: candidateUrl!,
                                    partyUrl: partyUrl!,
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
                              FocusScope.of(context).unfocus();
                              final response = await ref
                                  .read(sudurpaschimProvider)
                                  .addFPTPPost(
                                    candidateName:
                                        candidateController.text.toString(),
                                    partyName: partyController.text.toString(),
                                    barColor:
                                        barColorController.text.toString(),
                                    candidateInfo:
                                        candidateInfoController.text.toString(),
                                    imageUrl: candidateUrl!,
                                    partyUrl: partyUrl!,
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
                            "Add Candidate",
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
