import 'package:elector_admin_dashboard/constants.dart';
import 'package:elector_admin_dashboard/controllers/ongoingElection_provider.dart';
import 'package:elector_admin_dashboard/controllers/upcoming_election_provider.dart';
import 'package:elector_admin_dashboard/screens/ongoing%20election/add_ongoingElection_page.dart';
import 'package:elector_admin_dashboard/screens/upcoming%20election/add_upcomingElection_page.dart';
import 'package:elector_admin_dashboard/screens/ongoing%20election/edit_ongoingElection_page.dart';
import 'package:elector_admin_dashboard/screens/upcoming%20election/edit_upcomingElection_page.dart';
import 'package:elector_admin_dashboard/widgets/custom_button.dart';
import 'package:elector_admin_dashboard/widgets/ongoingElection_header.dart';
import 'package:elector_admin_dashboard/widgets/upcomingElection_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

class AddElectionPage extends StatefulWidget {
  const AddElectionPage({super.key});

  @override
  State<AddElectionPage> createState() => _AddElectionPageState();
}

class _AddElectionPageState extends State<AddElectionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(
        builder: (context, ref, child) {
          final ongoingElectionStream = ref.watch(ongoingElectionProvider);
          final upcomingElectionStream = ref.watch(upcomingElectionProvider);
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  const Center(
                    child: Text(
                      'Add Election Page',
                      style: kHeadingTextStyle,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Ongoing Election',
                        style: kSubHeadingTextStyle,
                      ),
                      CustomButton(
                        color: Colors.blue,
                        text: 'Add Ongoing Election',
                        onPress: () {
                          Get.to(() => AddOngoingElectionPage());
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Container(
                    constraints: const BoxConstraints(
                      maxHeight: double.infinity,
                    ),
                    decoration: BoxDecoration(
                      color: secondaryColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        OngoingElectionHeader(),
                        ongoingElectionStream.when(
                          data: (data) {
                            return data.isEmpty
                                ? const Column(
                                    children: [
                                      SizedBox(height: 20),
                                      Center(
                                        child: Text('No ongoing election atm'),
                                      ),
                                      SizedBox(height: 20),
                                    ],
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: data.length,
                                    itemBuilder: (context, index) {
                                      final dat = data[index];
                                      return Container(
                                        constraints: const BoxConstraints(
                                          maxHeight: double.infinity,
                                        ),
                                        decoration: BoxDecoration(
                                          color: secondaryColor,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 20),
                                              child: Container(
                                                height: 80,
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  color: bgColor,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 20),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        dat.electionType,
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      const Spacer(),
                                                      Text(
                                                        dat.candidates,
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                      const Spacer(),
                                                      Text(
                                                          '${dat.startDate} at ${dat.startTime}'),
                                                      const Spacer(),
                                                      Text(
                                                          '${dat.endDate} at ${dat.endTime}'),
                                                      const Spacer(),
                                                      dat.canVote == false
                                                          ? const Text(
                                                              'Stopped')
                                                          : const Text(
                                                              'Started'),
                                                      Switch(
                                                        value: dat.canVote,
                                                        activeColor:
                                                            Colors.grey,
                                                        activeTrackColor:
                                                            Colors.blue,
                                                        inactiveThumbColor:
                                                            Colors.grey,
                                                        inactiveTrackColor:
                                                            Colors.blueGrey,
                                                        onChanged:
                                                            (value) async {
                                                          if (dat.canVote ==
                                                              true) {
                                                            await ref
                                                                .read(
                                                                    ongoingProvider)
                                                                .endElection(
                                                                    postId:
                                                                        dat.id,
                                                                    canVote:
                                                                        false);
                                                          } else {
                                                            await ref
                                                                .read(
                                                                    ongoingProvider)
                                                                .startElection(
                                                                    postId:
                                                                        dat.id,
                                                                    canVote:
                                                                        true);
                                                          }
                                                        },
                                                      ),
                                                      const Spacer(),
                                                      IconButton(
                                                        onPressed: () {
                                                          Get.defaultDialog(
                                                            title:
                                                                'Customize your post',
                                                            content: const Text(
                                                                'Actions'),
                                                            actions: [
                                                              IconButton(
                                                                onPressed: () {
                                                                  Get.to(() =>
                                                                      EditOngoingElectionPage(
                                                                          dat));
                                                                },
                                                                icon: const Icon(
                                                                    Icons.edit),
                                                              ),
                                                              IconButton(
                                                                onPressed:
                                                                    () async {
                                                                  await ref
                                                                      .read(
                                                                          ongoingProvider)
                                                                      .removeOngoingElection(
                                                                          postId:
                                                                              dat.id);
                                                                  if (mounted) {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  }
                                                                },
                                                                icon: const Icon(
                                                                    Icons
                                                                        .delete),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                        icon: const Icon(
                                                            Icons.more_vert),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                          },
                          error: (err, stack) => Text('$err'),
                          loading: () => const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 80),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Upcoming Election',
                        style: kSubHeadingTextStyle,
                      ),
                      CustomButton(
                          text: 'Add Upcoming Election',
                          onPress: () {
                            Get.to(() => AddUpcomingElectionPage());
                          },
                          color: Colors.blue),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Container(
                    constraints: const BoxConstraints(
                      maxHeight: double.infinity,
                    ),
                    decoration: BoxDecoration(
                      color: secondaryColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        UpcomingElectionHeader(),
                        upcomingElectionStream.when(
                          data: (data) {
                            return data.isEmpty
                                ? const Center(
                                    child: Text('No upcoming election atm'),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: data.length,
                                    itemBuilder: (context, index) {
                                      final dat = data[index];
                                      return Container(
                                        constraints: const BoxConstraints(
                                          maxHeight: double.infinity,
                                        ),
                                        decoration: BoxDecoration(
                                          color: secondaryColor,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 20),
                                              child: Container(
                                                height: 80,
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  color: bgColor,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 20),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        dat.electionType,
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                          '${dat.startDate} at ${dat.startTime}'),
                                                      IconButton(
                                                        onPressed: () {
                                                          Get.defaultDialog(
                                                            title:
                                                                'Customize your post',
                                                            content: const Text(
                                                                'Actions'),
                                                            actions: [
                                                              IconButton(
                                                                onPressed: () {
                                                                  Get.to(() =>
                                                                      EditUpcomingElectionPage(
                                                                          dat));
                                                                },
                                                                icon: const Icon(
                                                                    Icons.edit),
                                                              ),
                                                              IconButton(
                                                                onPressed:
                                                                    () async {
                                                                  await ref
                                                                      .read(
                                                                          upcomingProvider)
                                                                      .removeUpcomingElection(
                                                                          postId:
                                                                              dat.id);
                                                                  if (mounted) {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  }
                                                                },
                                                                icon: const Icon(
                                                                    Icons
                                                                        .delete),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                        icon: const Icon(
                                                            Icons.more_vert),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                          },
                          error: (err, stack) => Text('$err'),
                          loading: () => const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
