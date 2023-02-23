import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elector_admin_dashboard/constants.dart';
import 'package:flutter/material.dart';

class UsersPage extends StatefulWidget {
  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  String name = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Users',
                style: kSubHeadingTextStyle,
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    color: secondaryColor,
                  ),
                  hintText: 'Search by voter ID...',
                ),
                onChanged: (val) {
                  setState(() {
                    name = val;
                  });
                },
              ),
              SizedBox(height: 25),
              Container(
                constraints: BoxConstraints(
                  maxHeight: double.infinity,
                ),
                decoration: BoxDecoration(
                  color: secondaryColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Row(
                      children: [
                        SizedBox(width: 225),
                        Text(
                          'Full Name',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 75),
                        Text(
                          'Voter ID',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 150),
                        Text(
                          'Email',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 195),
                        Text(
                          'District',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 80),
                        Text(
                          'Province',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .snapshots(),
                        builder: (context, snapshots) {
                          return (snapshots.connectionState ==
                                  ConnectionState.waiting)
                              ? Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : ListView.builder(
                                  itemCount: snapshots.data!.docs.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    var data = snapshots.data!.docs[index]
                                        .data() as Map<String, dynamic>;
                                    if (name.isEmpty) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 20),
                                        child: Container(
                                          height: 80,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: bgColor,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceAround,
                                              children: [
                                                CircleAvatar(
                                                  backgroundImage: NetworkImage(
                                                      data['imageUrl']),
                                                ),
                                                Text(
                                                  data['Full Name'],
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                Text(
                                                  data['Voter ID'],
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                Text(
                                                  data['email'],
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                Text(
                                                  data['District'],
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                Text(
                                                  data['Province'],
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                    if (data['Voter ID']
                                        .toString()
                                        .startsWith(name)) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 20),
                                        child: Container(
                                          height: 80,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: bgColor,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                CircleAvatar(
                                                  backgroundImage: NetworkImage(
                                                      data['imageUrl']),
                                                ),
                                                Text(
                                                  data['Full Name'],
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                Text(
                                                  data['Voter ID'],
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                Text(
                                                  data['email'],
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                Text(
                                                  data['District'],
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                Text(
                                                  data['Province'],
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                IconButton(
                                                    onPressed: () {},
                                                    icon:
                                                        Icon(Icons.more_vert)),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                    return Container();
                                  });
                        }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
