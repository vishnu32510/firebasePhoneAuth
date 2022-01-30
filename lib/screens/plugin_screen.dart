import 'dart:math';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_task/screens/last_login_screen.dart';
import 'package:flutter_task/screens/login_screen.dart';
import 'package:flutter_task/utils/utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PluginScreen extends StatefulWidget {
  static const String routeName = '/pluginScreen';

  // final UserCredential userCredential;
  static Route route({required PluginScreen arguments}) {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (context) => PluginScreen(
              userId: arguments.userId,
              loginId: arguments.loginId,
            ));
  }

  const PluginScreen({
    Key? key,
    required this.userId,
    required this.loginId,
  }) : super(key: key);

  final String userId;
  final String loginId;

  @override
  _PluginScreenState createState() => _PluginScreenState();
}

class _PluginScreenState extends State<PluginScreen> {
  Random random = Random();
  List randomNumbers = [0, 0, 0, 0, 0, 0];
  late String data;
  late String userId;
  late String loginId;

  @override
  void initState() {
    super.initState();
    loginId = widget.loginId;
    userId = widget.userId;
    for (int i = 0; i < 5; i++) {
      randomNumbers[i] = random.nextInt(9);
    }
    data = randomNumbers.join();
    getUser();
  }

  Future getUser() async {
    print(FirebaseAuth.instance.currentUser!.phoneNumber);
  }

  GlobalKey globalKey = GlobalKey();

  // Future<void> _captureAndSharePng() async {
  //   try {
  //     RenderObject? boundary =
  //     globalKey.currentContext!.findRenderObject();
  //     var image = await boundary!.toImage();
  //     ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
  //     Uint8List pngBytes = byteData!.buffer.asUint8List();
  //
  //     // final tempDir = await getTemporaryDirectory();
  //     // final file = await new File('${tempDir.path}/image.png').create();
  //     // await file.writeAsBytes(pngBytes);
  //
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

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
              top: 40,
              right: 30,
              child: InkWell(
                onTap: () {
                  FirebaseAuth.instance.signOut().then((value) {
                    print("Sigh out");
                    Navigator.pushReplacementNamed(
                        context, LoginScreen.routeName);
                  }).onError((error, stackTrace) {
                    print(error);
                  });
                },
                child: Text(
                  'Logout',
                  style: TextStyle(color: Colors.white, fontSize: 16),
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
                "PLUGIN",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
          Positioned.fill(
            top: 100,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              alignment: Alignment.center,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      margin: const EdgeInsets.only(top: 20, bottom: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white),
                      child: RepaintBoundary(
                        key: globalKey,
                        child: QrImage(
                          data: data,
                          version: QrVersions.auto,
                          size: 150.0,
                          backgroundColor: Colors.white,
                          errorStateBuilder: (cxt, err) {
                            return Container(
                              child: Center(
                                child: Text(
                                  "Uh oh! Something went wrong...",
                                  style: TextStyle(color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 10),
                      child: Text(
                        "Generated Number",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 10),
                      child: Text(
                        data,
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                            LastLoginScreen.routeName,
                            arguments: LastLoginScreen(userId: userId));
                      },
                      child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection("users")
                              .doc(userId)
                              .collection("login_details").orderBy("date_time",descending: true)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Text(
                                'No Data...',
                              );
                            }
                            DateTime dateTime = (snapshot
                                    .data!.docs.first["date_time"] as Timestamp)
                                .toDate();
                            // print(dateTime.);
                            // var date = DateTime.fromMillisecondsSinceEpoch(dateTime);
                            String formattedDate =
                                DateFormat('dd MMM , hh a').format(dateTime);
                            return Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 10),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.white)),
                              child: Text(
                                "Last login at $formattedDate",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            );
                          }),
                    ),
                    InkWell(
                      onTap: () {
                        takePicture(context: context);
                        // Navigator.of(context)
                        //     .pushReplacementNamed(PluginScreen.routeName);
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 10),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.grey[800],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "SAVE",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> takePicture({required BuildContext context}) async {
    final RenderRepaintBoundary boundary =
        globalKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    final ui.Image image = await boundary.toImage();
    final ByteData? byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List pngBytes = byteData!.buffer.asUint8List();
    // File imgFile = new File('$directory/photo.png');
    final tempDir = await getTemporaryDirectory();
    final file = await new File('${tempDir.path}/image.png').create();
    file.writeAsBytes(pngBytes);
    uploadImageToFirebase(context, file);
  }

  Future uploadImageToFirebase(BuildContext context, File _imageFile) async {
    final _firebaseStorage = FirebaseStorage.instance;
    var snapshot =
        await _firebaseStorage.ref().child('$userId/qr').putFile(_imageFile);
    var downloadUrl = await snapshot.ref.getDownloadURL().then((value) async {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection("login_details")
          .doc(loginId)
          .set({
        "qrImage": value,
      },SetOptions(merge: true)).then((value) {
        print("dome");
      });
    });

    print(downloadUrl);
  }
}
