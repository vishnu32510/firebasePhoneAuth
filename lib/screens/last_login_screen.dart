import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task/screens/login_screen.dart';
import 'package:flutter_task/screens/screens.dart';
import 'package:flutter_task/utils/utils.dart';
import 'package:intl/intl.dart';

class LastLoginScreen extends StatefulWidget {
  static const String routeName = '/lastLoginScreen';

  static Route route({required LastLoginScreen arguments}) {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (context) => LastLoginScreen(
              userId: arguments.userId,
            ));
  }

  const LastLoginScreen({Key? key, required this.userId}) : super(key: key);

  final String userId;

  @override
  _LastLoginScreenState createState() => _LastLoginScreenState();
}

class _LastLoginScreenState extends State<LastLoginScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late String userId;

  @override
  void initState() {
    super.initState();
    userId = widget.userId;
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            color: primaryColor,
          ),
          Positioned(
              top: -40,
              right: -10,
              child: Container(
                height: 130,
                width: 130,
                decoration: BoxDecoration(
                  color: secondaryColor,
                  shape: BoxShape.circle,
                  // borderRadius: BorderRadius.circular(10),
                ),
              )),
          Positioned(
              top: 20,
              left: 0,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back_ios_new_sharp,
                          color: Colors.white,
                        )),
                    // Expanded(child: SizedBox()),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamedAndRemoveUntil(
                            context,
                            LoginScreen.routeName,
                            (Route<dynamic> route) => false);
                      },
                      child: Text(
                        'Logout',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              )),
          Positioned.fill(
            top: 90,
            left: 0,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  )),
            ),
          ),
          Positioned(
            top: 80,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(7),
              ),
              child: Text(
                "Last Login",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
          Positioned.fill(
              top: 100,
              left: 0,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding:
                          const EdgeInsets.only(top: 40, left: 20, right: 20),
                      alignment: Alignment.topLeft,
                      child: TabBar(
                        isScrollable: true,
                        indicatorColor: Colors.white,
                        controller: _tabController,
                        indicatorWeight: 3,
                        indicatorSize: TabBarIndicatorSize.label,
                        tabs: [
                          Text(
                            "TODAY",
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          Text("Yesterday"),
                          Text("Other"),
                        ],
                      ),
                    ),
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("users")
                            .doc(userId)
                            .collection("login_details").orderBy("date_time",descending: true)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if(!snapshot.hasData){
                            return Center(child: CircularProgressIndicator(),);
                          }
                          return ListView.builder(
                              primary: false,
                              shrinkWrap: true,
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                DateTime dateTime = (snapshot.data!.docs[index]
                                        ["date_time"] as Timestamp)
                                    .toDate();
                                String ip = snapshot.data!.docs[index]["ip"];
                                String location =
                                    snapshot.data!.docs[index]["location"];
                                String formattedDate =
                                    DateFormat('hh:mm a').format(dateTime);
                                String qrImage = snapshot
                                    .data!.docs[index]["qrImage"];
                                print(qrImage=="");
                                print(qrImage);
                                return Container(
                                  padding: const EdgeInsets.only(
                                      top: 10,bottom: 20, left: 40, right: 20),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              formattedDate,
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              "IP : $ip",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              location,
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: 70,
                                        width: 70,
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          color: qrImage==""?Colors.black:Colors.white,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Image.network(
                                          qrImage,
                                          loadingBuilder: (BuildContext context, Widget child,
                                              ImageChunkEvent? loadingProgress) {
                                            if (loadingProgress == null) return child;
                                            return Center(
                                              child: CircularProgressIndicator(
                                                value: loadingProgress.expectedTotalBytes != null
                                                    ? loadingProgress.cumulativeBytesLoaded /
                                                    loadingProgress.expectedTotalBytes!
                                                    : null,
                                              ),
                                            );
                                          },
                                          errorBuilder: (BuildContext context,
                                              Object exception,
                                              StackTrace? stackTrace) {
                                            return const SizedBox.shrink();
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              });
                        })
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
