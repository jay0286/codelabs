
//구글파이어스토어 로그
import 'dart:async';                                    // new
import 'dart:convert';
//import 'dart:io';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';  // new

import 'package:firebase_core/firebase_core.dart'; // new
import 'package:firebase_auth/firebase_auth.dart'; // new
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';           // new

import 'src/authentication.dart';                  // new

import 'src/widgets.dart';

import 'dart:math';
import 'package:flutter_blue/flutter_blue.dart';
import 'widgets.dart';
import 'package:just_audio/just_audio.dart';


import 'package:geolocator/geolocator.dart';



import 'package:intl/intl.dart';

import '/constant/constant.dart';
import '/pages/splashScreen.dart';
//DeviceOrientation 관련 서비스
import 'package:flutter/services.dart';

import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:flutter/gestures.dart';
import 'package:map/map.dart';
import 'package:latlng/latlng.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
//import 'package:page_transition/page_transition.dart';

List<GuestBookMessage> _iaLogMessages = [];

List<GuestBookMessage> _ffLogMessages = [];

List<GuestBookMessage> _imLogMessages = [];

List<GuestBookMessage> get emLogMessages => _emLogMessages;
List<GuestBookMessage> _emLogMessages = [];

List<GuestBookMessage> get uemLogMessages => _uemLogMessages;
List<GuestBookMessage> _uemLogMessages = [];

List<GuestBookMessage> get ucnLogMessages => _ucnLogMessages;
List<GuestBookMessage> _ucnLogMessages = [];

List<GuestBookMessage> get rcnLogMessages => _rcnLogMessages;
List<GuestBookMessage> _rcnLogMessages = [];

List<GuestBookMessage> get beltLogMessages => _beltLogMessages;
List<GuestBookMessage> _beltLogMessages = [];

List<GuestBookMessage> get ubeltLogMessages => _ubeltLogMessages;
List<GuestBookMessage> _ubeltLogMessages = [];

List<GuestBookMessage> get etcLogMessages => _etcLogMessages;
List<GuestBookMessage> _etcLogMessages = [];

BluetoothDeviceState? btState =BluetoothDeviceState.disconnected;

/*
SnackBar basicSnackBar(String message) {

  return SnackBar(
    duration: const Duration(seconds: 2),
    content: Text(message),
    action: SnackBarAction(
      label: "닫기",
      textColor: Colors.white,
      onPressed: () {},
    ),
  );
}
*/


class Profile extends StatelessWidget {
  @override

  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    /*
    basicSnackBar(String message) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return SnackBar(
              duration: const Duration(seconds: 2),
              content: Text(message),
              action: SnackBarAction(
                label:message ,
                textColor: Colors.white,
                onPressed: () {},
              ),
            );
          }
      );
    }*/

    logoutDialogue() {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          // return object of type Dialog
          return Dialog(
            elevation: 0.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: Container(
              height: 150.0,
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "로그아웃 하시겠습니까?",
                    style: headingStyle,
                  ),
                  Text(
                    "( 장치연결이 해제됩니다 )",
                    style: deepPurpleHeadingStyle,
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: (width / 3.5),
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Text(
                            '취소',
                            style: buttonBlackTextStyle,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          if(btState==BluetoothDeviceState.disconnected) {
                            FirebaseAuth.instance.signOut();
                            Navigator.pop(context);
                          }
                          else {
                            // ignore: deprecated_member_use
                            Fluttertoast.showToast(
                              msg: '먼저 스마트헬멧 연결을 종료해 주세요',
                              backgroundColor: Colors.black,
                              textColor: whiteColor,
                            );
                            //scaffoldKey.currentState!.showSnackBar(
                             // basicSnackBar('먼저 스마트헬멧 연결을 종료해 주세요'));
                          }
                          // Navigator.push(context, MaterialPageRoute(builder: (context)=>Home()));
                        },
                        child: Container(
                          width: (width / 3.5),
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: Colors.deepPurple,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Text(
                            '로그아웃',
                            style: wbuttonWhiteTextStyle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: scaffoldBgColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: whiteColor,
        elevation: 0.0,
        title: Text(
          '인적사항',
          style: bigHeadingStyle,
        ),
      ),
      body: ListView(
        children: <Widget>[
          InkWell(
            onTap: () {
              ;//jay Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: EditProfile()));
            },
            child: Container(
              width: width,
              padding: EdgeInsets.all(fixPadding),
              color: whiteColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 70.0,
                        height: 70.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          image: const DecorationImage(
                            image: AssetImage('assets/image/up2.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      widthSpace,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            displayName!,
                            style: headingStyle,
                          ),
                          heightSpace,
                          Text(
                            displayEmail!,
                            style: lightGreyStyle,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16.0,
                    color: Colors.grey.withOpacity(0.6),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(fixPadding),
            padding: EdgeInsets.all(fixPadding),
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: <BoxShadow>[
                const BoxShadow(
                  blurRadius: 1.5,
                  spreadRadius: 1.5,
                  color: Colors.grey,
                ),
              ],
            ),
            child: Column(
              children: <Widget>[
                InkWell(
                  onTap: () {
                    ;//jayNavigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: Notifications()));
                  },
                  child: getTile(
                      Icon(Icons.notifications,
                          color: Colors.grey.withOpacity(0.6)),
                      '안내 사항'),
                ),
                InkWell(
                  onTap: () {},
                  child: getTile(
                      Icon(Icons.language, color: Colors.grey.withOpacity(0.6)),
                      '작업 이력'),
                ),
                InkWell(
                  onTap: () {},
                  child: getTile(
                      Icon(Icons.settings, color: Colors.grey.withOpacity(0.6)),
                      '개인 설정'),
                ),
                InkWell(
                  onTap: () {},
                  child: getTile(
                      Icon(Icons.group_add,
                          color: Colors.grey.withOpacity(0.6)),
                      '관리자 추가'),
                ),
                InkWell(
                  onTap: () {},
                  child: getTile(
                      Icon(Icons.headset_mic,
                          color: Colors.grey.withOpacity(0.6)),
                      '시스템 문의'),
                ),
              ],
            ),
          ),

          (logState==true)?
          Container(
            margin: EdgeInsets.all(fixPadding),
            padding: EdgeInsets.all(fixPadding),
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: <BoxShadow>[
                const BoxShadow(
                  blurRadius: 1.5,
                  spreadRadius: 1.5,
                  color: Colors.grey,
                ),
              ],
            ),
            child: Column(
              children: <Widget>[
                InkWell(
                  onTap: logoutDialogue,
                  child: getTile(
                      Icon(Icons.exit_to_app,
                          color: Colors.grey.withOpacity(0.6)),
                          '로그아웃',),
                ),
              ],
            ),
          ):Container(),
        ],
      ),
    );
  }

  Widget getTile(Icon icon, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 40.0,
              width: 40.0,
              alignment: Alignment.center,
              child: icon,
            ),
            widthSpace,
            Text(
              title,
              style: listItemTitleStyle,
            ),
          ],
        ),
        Icon(
          Icons.arrow_forward_ios,
          size: 16.0,
          color: Colors.grey.withOpacity(0.6),
        ),
      ],
    );
  }

}

bool logState = false;

bool beltState = false;

String? logEmail ;
String? displayName = '무명';
String? displayEmail = '없음';
String? displayPhoneNumber = '없음';

class FlutterBlueApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.lightBlue,
      home: StreamBuilder<BluetoothState>(
          stream: FlutterBlue.instance.state,
          initialData: BluetoothState.unknown,
          builder: (c, snapshot) {
            final state = snapshot.data;
            if (state == BluetoothState.on) {
              return FindDevicesScreen();
            }
            return BluetoothOffScreen(state: state);
          }),
    );
  }
}

class BluetoothOffScreen extends StatelessWidget {
  const BluetoothOffScreen({Key? key, this.state}) : super(key: key);

  final BluetoothState? state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(
              Icons.bluetooth_disabled,
              size: 200.0,
              color: Colors.white54,
            ),
            Text(
              'Bluetooth Adapter is ${state != null ? state.toString().substring(15) : 'not available'}.',
              style: Theme.of(context)
                  .primaryTextTheme
                  .subhead
                  ?.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class FindDevicesScreen extends StatefulWidget {

  @override
  _FindDevicesScreenState createState() => _FindDevicesScreenState();
}

class _FindDevicesScreenState extends State<FindDevicesScreen> {
  @override
  void initState() {
    // TODO: implement initState
    FlutterBlue.instance.startScan(timeout: const Duration(seconds: 4));
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:(logState==true)?
         const Text('내 스마트안전모 찾기'):const Text('로그인 후 장치 연결 가능'),

      ),
      body: RefreshIndicator(
        onRefresh: () =>
            FlutterBlue.instance.startScan(timeout: const Duration(seconds: 4)),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              StreamBuilder<List<BluetoothDevice>>(
                stream: Stream.periodic(const Duration(seconds: 2))
                    .asyncMap((_) => FlutterBlue.instance.connectedDevices),
                initialData: [],
                builder: (c, snapshot) => Column(
                  children: snapshot.data!
                      .map((d) => ListTile(
                    title: Text(d.name),
                    subtitle: Text(d.id.toString()),
                    trailing: StreamBuilder<BluetoothDeviceState>(
                      stream: d.state,
                      initialData: BluetoothDeviceState.disconnected,
                      builder: (c, snapshot) {
                        if (snapshot.data ==
                            BluetoothDeviceState.connected) {
                          return RaisedButton(
                            child: const Text('연결재설정'),
                            onPressed: () async => await d.disconnect(),
                            /*Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        DeviceScreen(device: d))),*/
                          );
                        }
                        return Text(snapshot.data.toString());
                      },
                    ),
                  ),
                  )
                      .toList(),
                ),
              ),
              StreamBuilder<List<ScanResult>>(
                stream: FlutterBlue.instance.scanResults,
                initialData: [],
                builder: (c, snapshot) => Column(
                  children: snapshot.data!
                      .map((r) => ScanResultTile(
                      result: r,
                      onTap: () async {
                        if(logState==true) {
                          bTdevice = r.device;
                          await bTdevice?.connect();
                        }
                        Navigator.pop(context, false);
                        },
                          /*Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        r.device.connect();
                        return DeviceScreen(device: r.device);
                      })),*/

                    ),
                  )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: StreamBuilder<bool>(
        stream: FlutterBlue.instance.isScanning,
        initialData: false,
        builder: (c, snapshot) {
          if (snapshot.data!) {
            return FloatingActionButton(
              child: const Icon(Icons.stop),
              onPressed: () => FlutterBlue.instance.stopScan(),
              backgroundColor: Colors.red,
            );
          } else {
            return FloatingActionButton(
                child: const Icon(Icons.search),
                onPressed: () => FlutterBlue.instance
                    .startScan(timeout: const Duration(seconds: 4)));
          }
        },
      ),
    );
  }
}

class ShowDataLogerScreen extends StatefulWidget {
  const ShowDataLogerScreen({Key? key,required this.itemname}): super(key: key);
  final String itemname;
  @override
  _ShowDataLogerScreenState createState() => _ShowDataLogerScreenState();
}

class _ShowDataLogerScreenState extends State<ShowDataLogerScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  List<GuestBookMessage> get iaLogMessages => _iaLogMessages;
  List<GuestBookMessage> get ffLogMessages => _ffLogMessages;
  List<GuestBookMessage> get imLogMessages => _imLogMessages;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('로그 데이터'),
      ),
      body: ListView(
        children: [
          Image.asset('assets/image/log.png'),
          //Image.asset('assets/image/caring-nurse-and-the-girl-FPAX4FK.png'),
          Consumer<ApplicationState>(
            builder: (context, appState, _) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (appState.loginState == ApplicationLoginState.loggedIn/*&&btState==BluetoothDeviceState.connected*/) ...[
                  //appState.guestBookMessages,
                  GuestBook(
                      messages:
                      (widget.itemname=='무활동반응')?iaLogMessages:
                      (widget.itemname=='추락사고')?ffLogMessages:
                      (widget.itemname=='충격사고')?imLogMessages:
                      (widget.itemname=='위급상황')?emLogMessages:
                      (widget.itemname=='상황해제')?uemLogMessages:
                      (widget.itemname=='연결해제')?ucnLogMessages:
                      (widget.itemname=='연결복귀')?rcnLogMessages:
                      (widget.itemname=='턱끈연결')?beltLogMessages:
                      (widget.itemname=='턱끈해제')?ubeltLogMessages:
                      (widget.itemname=='그밖의긴급상황')?etcLogMessages:
                      iaLogMessages,
                      addMessage: (String message) =>
                        appState.addMessageToGuestBook(message),
                  ),
                ],
              ],
            ),
          ),
          heightSpace,
        ],
      ),
    );
  }
}

class DeviceScreen extends StatelessWidget {
  const DeviceScreen({Key? key, required this.device}) : super(key: key);
  final BluetoothDevice device;
  List<int> _getRandomBytes() {
    final math = Random();
    return [
      math.nextInt(255),
      math.nextInt(255),
      math.nextInt(255),
      math.nextInt(255)
    ];
  }

  List<Widget> _buildServiceTiles(List<BluetoothService> services) {
    return services
        .map(
          (s) => ServiceTile(
        service: s,
        characteristicTiles: s.characteristics
            .map(
              (c) => CharacteristicTile(
            characteristic: c,
            onReadPressed: () => c.read(),
            onWritePressed: () async {
              await c.write(_getRandomBytes(), withoutResponse: true);
              await c.read();
            },
            onNotificationPressed: () async {
              await c.setNotifyValue(!c.isNotifying);
              await c.read();
            },
            descriptorTiles: c.descriptors
                .map(
                  (d) => DescriptorTile(
                descriptor: d,
                onReadPressed: () => d.read(),
                onWritePressed: () => d.write(_getRandomBytes()),
              ),
            )
                .toList(),
          ),
        )
            .toList(),
      ),
    )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(device.name),
        actions: <Widget>[
          StreamBuilder<BluetoothDeviceState>(
            stream: device.state,
            initialData: BluetoothDeviceState.disconnected,
            builder: (c, snapshot) {
              VoidCallback? onPressed;
              String text;
              switch (snapshot.data) {
                case BluetoothDeviceState.connected:
                  onPressed = () => device.disconnect();
                  text = 'DISCONNECT';
                  break;
                case BluetoothDeviceState.disconnected:
                  onPressed = () => device.connect();
                  text = '연결';
                  break;
                default:
                  onPressed = null;
                  text = snapshot.data.toString().substring(21).toUpperCase();
                  break;
              }
              return FlatButton(
                  onPressed: onPressed,
                  child: Text(
                    text,
                    style: Theme.of(context)
                        .primaryTextTheme
                        .button
                        ?.copyWith(color: Colors.white),
                  ));
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            StreamBuilder<BluetoothDeviceState>(
              stream: device.state,
              initialData: BluetoothDeviceState.connecting,
              builder: (c, snapshot) => ListTile(
                leading: (snapshot.data == BluetoothDeviceState.connected)
                    ? const Icon(Icons.bluetooth_connected)
                    : const Icon(Icons.bluetooth_disabled),
                title: Text(
                    'Device is ${snapshot.data.toString().split('.')[1]}.'),
                subtitle: Text('${device.id}'),
                trailing: StreamBuilder<bool>(
                  stream: device.isDiscoveringServices,
                  initialData: false,
                  builder: (c, snapshot) => IndexedStack(
                    index: snapshot.data! ? 1 : 0,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.refresh),
                        onPressed: () => device.discoverServices(),
                      ),
                      const IconButton(
                        icon: SizedBox(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.grey),
                          ),
                          width: 18.0,
                          height: 18.0,
                        ),
                        onPressed: null,
                      )
                    ],
                  ),
                ),
              ),
            ),
            StreamBuilder<int>(
              stream: device.mtu,
              initialData: 0,
              builder: (c, snapshot) => ListTile(
                title: Text('MTU Size'),
                subtitle: Text('${snapshot.data} bytes'),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => device.requestMtu(223),
                ),
              ),
            ),
            StreamBuilder<List<BluetoothService>>(
              stream: device.services,
              // ignore: prefer_const_literals_to_create_immutables
              initialData: [],
              builder: (c, snapshot) {
                return Column(
                  children: _buildServiceTiles(snapshot.data!),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

enum Attending { yes, no, unknown }
class YesNoSelection extends StatefulWidget {
  const YesNoSelection({required this.state, required this.onSelection});
  final Attending state;
  final void Function(Attending selection) onSelection;

  @override
  _YesNoSelectionState createState() => _YesNoSelectionState();
}
class _YesNoSelectionState extends State<YesNoSelection> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

//ble instance 생성
    flutterBlue = FlutterBlue.instance;
  }


  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    switch (widget.state) {
      case Attending.yes:
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(elevation: 0),
                onPressed: () => widget.onSelection(Attending.yes),
                child: const Text('YES'),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: () {  player.setAsset('assets/audio/moo.mp3');
                //player.play();
               // widget.addMessage(_controller.text);
                widget.onSelection(Attending.no);},
                child: const Text('NO'),
              ),
            ],
          ),
        );
      case Attending.no:
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              TextButton(
                onPressed: () {/*_startscan();*/widget.onSelection(Attending.yes);},
                child: Text('YES'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(elevation: 0),
                //widget.addMessage(_controller.text);
                onPressed: ()  {  player.setAsset('assets/audio/moo.mp3');
                player.play();
                widget.onSelection(Attending.no);},
                child: const Text('NO'),
              ),
            ],
          ),
        );
      default:
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              StyledButton(
                onPressed: () {/*_startscan();*/widget.onSelection(Attending.yes);},
                child: const Text('YES'),
              ),
              const SizedBox(width: 8),
              StyledButton(
                onPressed: ()  {  player.setAsset('assets/audio/moo.mp3');
                player.play();
                widget.onSelection(Attending.no);},
                child: const Text('NO'),
              ),
            ],
          ),
        );
    }
  }
}

late AudioPlayer player;

void _playSound() {
  // ignore: avoid_print
  print('_playSound');
  player.play();
}

void _stopSound() {
  // ignore: avoid_print
  print('_stopSound');
  player.stop();
}
void _setAsset(String str) {
  // ignore: avoid_print
  print('_setAsset');
  player.setAsset(str);
}

void _setLoopMode(LoopMode mode) {
  // ignore: avoid_print
  print('_setLoopMode');
  player.setLoopMode(mode);
}



Future<DocumentReference> addStateToGuestBook(String message) {
  message = message;

  print('tmrGeo_geolocation ${geolatitude}, ${geolongitude}');
  return FirebaseFirestore.instance.collection('guestbook').add({
    'text': message,
    'timestamp': DateTime.now().millisecondsSinceEpoch,
    'name': FirebaseAuth.instance.currentUser!.displayName,
    'userId': FirebaseAuth.instance.currentUser!.uid,
    'latitude': geolatitude,
    'longitude': geolongitude,
  });
}

final navigatorKey = GlobalKey<NavigatorState>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(MyApp2());
  });
}

class MyApp2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Helmet',
      theme: ThemeData(
        primarySwatch: Colors.red,
        primaryColor: primaryColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(),
      navigatorKey: navigatorKey,
    );
  }
}

/*
void main() {
  //FlutterBlue flutterBlue = FlutterBlue.instance;
// Start scanning
  //flutterBlue.startScan(timeout: Duration(seconds: 4));


  runApp(
    ChangeNotifierProvider(
      create: (context) => ApplicationState(),
      builder: (context, _) => App(),
    ),
  );


  //runApp(FlutterBlueApp());

  //runApp(MyApp());
}
*/

class MyApp extends StatelessWidget {

  @override

  Widget build(BuildContext context) {

    return MaterialApp(

      title: 'Flutter Demo',

      theme: ThemeData(

        primarySwatch: Colors.blue,

        visualDensity: VisualDensity.adaptivePlatformDensity,

      ),

      home: const MyHomePage(title: 'Flutter Demo Home Page'),

    );

  }

}


class MyHomePage extends StatefulWidget {

  const MyHomePage({Key? key, this.title}) : super(key: key);
  //MyHomePage({Key key, this.title}) : super(key: key);

  final String? title;

  @override

  _MyHomePageState createState() => _MyHomePageState();

}


class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    super.initState();

    //ble instance 생성
    flutterBlue = FlutterBlue.instance;

  }


  void _startscan() {


  }

  @override

  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

       // title: Text(widget.title),

      ),

      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,

          children: <Widget>[],

        ),

      ),

      floatingActionButton: FloatingActionButton(

        onPressed: _startscan,

        tooltip: 'Increment',

        child: const Icon(Icons.bluetooth),

      ), // This trailing comma makes auto-formatting nicer for build methods.

    );

  }

}

// ^^^&&&&$%&%&%#%$*#$%*

class GuestBookMessage {
  GuestBookMessage({required this.name, required this.message, required this.timestamp,required this.location});
  final String name;
  final String message;
  final String timestamp;
  final String location;
}


class GuestBook extends StatefulWidget {
  // Modify the following line
  const GuestBook({required this.addMessage, required this.messages, this.logcount});
  final List<GuestBookMessage> messages; // new
  final FutureOr<void> Function(String message) addMessage;
  final int? logcount;


  @override
  _GuestBookState createState() => _GuestBookState();
}

class _GuestBookState extends State<GuestBook> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_GuestBookState');
  final _controller = TextEditingController();
  rejectreasonDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return Dialog(
          elevation: 0.0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0)),
          child: Wrap(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    //width: width,
                    padding: EdgeInsets.all(fixPadding),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10.0),
                        topLeft: Radius.circular(10.0),
                      ),
                    ),
                    child: Text(
                      'Reason to Reject',
                      style: wbuttonWhiteTextStyle,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(fixPadding),
                    alignment: Alignment.center,
                    child: const Text('Write a specific reason to reject order'),
                  ),
                  Container(
                    //width: width,
                    padding: EdgeInsets.all(fixPadding),
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: 2,
                      decoration: InputDecoration(
                        hintText: 'Enter Reason Here',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        fillColor: Colors.grey.withOpacity(0.1),
                        filled: true,
                      ),
                    ),
                  ),
                  heightSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          // width: (width / 3.5),
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Text(
                            'Cancel',
                            style: buttonBlackTextStyle,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          // width: (width / 3.5),
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Text(
                            'Send',
                            style: wbuttonWhiteTextStyle,
                          ),
                        ),
                      ),
                    ],
                  ),
                  heightSpace,
                ],
              ),
            ],
          ),
        );
      },
    );
  }


  @override
  // Modify from here
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.messages.isEmpty) Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Icon(
                  Icons.sticky_note_2_outlined,
                  color: Colors.deepPurple,
                  size: 60.0,
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Text(
                  '기록된 사고상황이 없습니다',
                  style: greyHeadingStyle,
                ),
              ],
            ),
          ) else ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: (widget.logcount==null)? widget.messages.length
                :widget.logcount,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final item = widget.messages[index];
              return Container(
                padding: EdgeInsets.all(fixPadding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(5.0),
                        // ignore: prefer_const_literals_to_create_immutables
                        boxShadow: <BoxShadow>[
                          const BoxShadow(
                            blurRadius: 0,
                            spreadRadius: 0.2,
                            //jay color: Colors.grey[200],
                          ),
                        ],
                      ),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(fixPadding),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    const Icon(Icons.notifications,
                                        color: Colors.deepPurple, size: 25.0),
                                    widthSpace,
                                    Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(item.timestamp,
                                            style: headingStyle),
                                        heightSpace,
                                        heightSpace,
                                        Text('작업자명',
                                            style: blackStyle),
                                        Text(item.name,
                                            style: headingStyle),
                                      ],
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    /*
                                    InkWell(
                                      borderRadius: BorderRadius.circular(5.0),
                                      onTap: () {
                                       // Navigator.pop(context);
                                      rejectreasonDialog();},
                                      child: Container(
                                        height: 40.0,
                                        width: 100.0,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(5.0),
                                          color: primaryColor,
                                        ),
                                        child: Text(
                                          '확인',
                                          style: wbuttonWhiteTextStyle,
                                        ),
                                      ),
                                    ),
                                    */
                                    heightSpace,
                                    heightSpace,
                                    heightSpace,
                                    heightSpace,
                                    Text('발생상황', style: blackStyle),
                                    Text(item.message,
                                        style: priceStyle),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              List<String> strLocation;
                              strLocation= item.location.split(', ');
                              print(item.location);
                              print(double.parse(strLocation[0]));
                              print(double.parse(strLocation[1]));
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>Second(latitude:double.parse(strLocation[0]) , longitude: double.parse(strLocation[1]))));
                            },
                            child: Container(
                              padding: EdgeInsets.all(fixPadding),
                              decoration: BoxDecoration(
                                color: lightGreyColor,
                                borderRadius: const BorderRadius.only(
                                  bottomRight: Radius.circular(5.0),
                                  bottomLeft: Radius.circular(5.0),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  /* Container(
                                    //jay width: (width - fixPadding * 4.0) / 3.2,
                                    child: Text(
                                      item.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: buttonBlackTextStyle,
                                    ),
                                  ),*/
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      const Icon(
                                        Icons.location_on,
                                        color: Colors.deepPurple,
                                        size: 20.0,
                                      ),
                                      Text(
                                        '  지도에서 위치확인 ('+item.location+')',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: buttonBlackTextStyle,
                                      ),
                                      //getDot(),
                                      //getDot(),
                                      //getDot(),
                                      //getDot(),
                                      //getDot(),
                                      /* Icon(
                                        Icons.navigation,
                                        color: primaryColor,
                                        size: 20.0,
                                      ),*/
                                    ],
                                  ),
                                  /* Container(
                                    //jay width: (width - fixPadding * 4.0) / 3.2,
                                    child: Text(
                                      item.location,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: buttonBlackTextStyle,
                                    ),
                                  )*/
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // to here.
        Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: _formKey,
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: '작업간 발생한 \'기타\' 위험상황을 기록 할 수 있어요',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '위험 상황을 남겨주세요';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(width: 8),
            StyledButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                    /*await*/ widget.addMessage(_controller.text);
                    _controller.clear();
                }
              },
              child: Row(
                children: [
                  const Icon(Icons.send),
                  SizedBox(width: 4),
                  Text('기록 남기기'),
                ],
              ),
            ),
          ],
        ),
      ),

        ),
          // Modify from here
          const SizedBox(height: 8),
/*
          for (var message in widget.messages)
            Paragraph('${message.name}: ${message.message} ${widget.messages.length}' ),
*/
          const SizedBox(height: 8),

          // to here.
        ],
    );
  }
}


final scaffoldKey = GlobalKey<ScaffoldState>();

int _attendees = 0;
int get attendees => _attendees;


int _attendeesim = 0;
int get attendeesim => _attendeesim;


int _attendeesem = 0;
int get attendeesem => _attendeesem;

int _attendeesemrels = 0;
int get attendeesemrels => _attendeesemrels;


int _attendeesff = 0;
int get attendeesff => _attendeesff;


int _attendeesbelt = 0;
int get attendeesbelt => _attendeesbelt;

int _attendeesDissbelt = 0;
int get attendeesDissbelt => _attendeesDissbelt;


int _attendeesRecorvline = 0;
int get attendeesRecorvline => _attendeesRecorvline;

int _attendeesoffline = 0;
int get attendeesoffline => _attendeesoffline;


int _attendeesia = 0;
int get attendeesia => _attendeesia;

int _attendeesetc = 0;
int get attendeesetc => _attendeesetc;


int _attendeesall = 0;
int get attendeesall => _attendeesall;


class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  Timer? _timer;
  StreamController<int>? _eventsA;
  int _counterA = 0;

  void alertManager(BuildContext context,String name, var formattedDate, String State, int time) async {
    isDialogAlive = true;
    var alert = await AlertDialog(
      //title: Center(child:Text('${State} 상황 발생', style: TextStyle(fontSize:30,fontWeight: FontWeight.bold, color: Colors.deepOrange),)),
      content:  StreamBuilder<int>(
          stream: _eventsA?.stream,
          builder: (context, snapshot) {
            print(snapshot.data.toString());
            return Container(
              height: 400,
              width: 300,
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      color: Colors.white70,
                      child: SizedBox.expand(
                        child: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //SizedBox(height: 80,),
                              Container(
                                color: Colors.white54,
                                child: const Icon(
                                  Icons.health_and_safety, size: 100,
                                  color: Colors.deepOrange,),
                              ),
                              /*const Text("상황발생",
                                style: TextStyle(
                                  color: Colors.deepPurple,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 23,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 20,),*/
                              Text(State +'발생',
                                style: const TextStyle(
                                  color: Colors.deepOrange,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                ),
                                textAlign: TextAlign.center,
                              ),

                          const SizedBox(height: 20,),
                              Text(name,
                                style: const TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 23,
                                ),
                              ),
                              Text(formattedDate,
                                style: const TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    (State=='연결해제')?
                    "알람 소리를 해제하려면 \'해제\'버튼을 눌러주세요"
                        :(State=='상황해제')?
                    "응급상황이 해제 되었습니다":
                    "장치연결이 해제 되었습니다",
                    //Text("상황을 해제하려면 \'해제\'버튼을 눌러주세요\n \'해제\'하지 않으면 자동 승인됩니다",
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 13,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20,),
                  Text("- ${snapshot.data} -",
                    style: const TextStyle(
                      color: Colors.deepOrange,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }),
      actions: <Widget>[
        Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children:<Widget>[
              Center(
                child: SizedBox(
                  width : 350,
                  // height: 50,
                  child:Padding(
                    padding: const EdgeInsets.only(left: 20,right: 20),
                    child: (State!='연결해제'||logEmail=='jay@tinkerbox.kr')?ElevatedButton(
                      child: const Text('확인'),
                      style: ElevatedButton.styleFrom(
                          primary: Colors.deepOrange,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                          textStyle: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                      onPressed:() {
                        _stopSound();

                        _counterA=0;
                        _timer?.cancel();
                        isDialogAlive =false;
                        Navigator.of(context, rootNavigator: true).pop(false);
                      },
                    ):Container(),
                  ),
                ),
              ),

              const SizedBox(height: 15,),
              /*TextButton(
                child: Text('승인',style: TextStyle(fontSize:18,color: Colors.deepPurple /*,fontWeight: FontWeight.bold*/)),
                onPressed: () {
                  double? latitude;
                  double? longitude;
                  player.stop;
                  _counter=0;
                  _timer?.cancel();
                  Navigator.of(context, rootNavigator: true).pop(false);
                },
              ),*/
            ]
        ),
      ],
    );

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (builderContext) {
          _counterA = time;
          _timer?.cancel();
          _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
            if(_counterA > 0) {
              _counterA--;
            }
            else {
              addStateToGuestBook(State);
              _counterA=0;
              _timer?.cancel();
              _stopSound();
              isDialogAlive =false;
              Navigator.of(context, rootNavigator: true).pop(true);
            }
            print(_counterA);
            _eventsA?.add(_counterA);
          });
          return alert;
        }
    );
  }

  void addNPopupManager(String name, var formattedDate,String state, int time)  {
    print('addNewPopup time:'+time.toString()+', State:'+ state);
    if(_eventsA!=null) {
      _eventsA?.close();
    }
    _eventsA = StreamController<int>();
    _eventsA?.add(time);
    alertManager(navigatorKey.currentContext!,name,  formattedDate, state, time);
  }

  StreamSubscription<User?>? listenUser;

  StreamSubscription<QuerySnapshot>? listenIa;
  StreamSubscription<QuerySnapshot>? listenFf;
  StreamSubscription<QuerySnapshot>? listenIm;
  StreamSubscription<QuerySnapshot>? listenEm;
  StreamSubscription<QuerySnapshot>? listenUEm;
  StreamSubscription<QuerySnapshot>? listenUCn;
  StreamSubscription<QuerySnapshot>? listenRCn;
  StreamSubscription<QuerySnapshot>? listenBelt;
  StreamSubscription<QuerySnapshot>? listenUBelt;
  StreamSubscription<QuerySnapshot>? listenEtc;

  Future<void> init() async {
    await Firebase.initializeApp();

    // Add from here
    FirebaseFirestore.instance
        .collection('attendees')
        .where('attending', isEqualTo: true)
        .snapshots()
        .listen((snapshot) {
      _attendees = snapshot.docs.length;
      notifyListeners();
    });
    // To here

    listenUser?.cancel();
    listenUser= FirebaseAuth.instance.userChanges().listen((user) async {

      if (user != null) {
        displayPhoneNumber = user.phoneNumber;
        displayName = user.displayName;
        displayEmail = user.email;
        print(user.email);
        print(user.displayName);
        print(user.phoneNumber);
        logState = true;
        _loginState = ApplicationLoginState.loggedIn;
        // Add from here
        logEmail =user.email;
        if(logEmail=='jay@tinkerbox.kr')
          {
/*
            await FirebaseFirestore.instance
                .collection("guestbook")
                .where("text",whereIn: ['위급상황','상황해제','턱끈연결','턱끈해제'])
                .get().then((value){
                  value.docs.forEach((element) async {
                    print(element.data()['text']);
                     //sleep(Duration(seconds: 1));
                     await FirebaseFirestore.instance.collection("guestbook").doc(element.id).delete().then((value){
                       print('deleted');
                  });
              });
            });

*/

            _attendeesia=0;
            listenIa?.cancel();
            listenIa = FirebaseFirestore.instance
                .collection('guestbook')
                .where('text',isEqualTo:'무활동반응') //jay user
                .orderBy("timestamp", descending: true)
                .snapshots()
                .listen((snapshot) {
                  /*
                  List<GuestBookMessage> _iaLogMessages = [];
                  List<GuestBookMessage> _ffLogMessages = [];
                  List<GuestBookMessage> _imLogMessages = [];
                  List<GuestBookMessage> _emLogMessages = [];
                  List<GuestBookMessage> _uemLogMessages = [];
                  List<GuestBookMessage> _ucnLogMessages = [];
                  List<GuestBookMessage> _rcnLogMessages = [];
                  List<GuestBookMessage> _beltLogMessages = [];
                  List<GuestBookMessage> _ubeltLogMessages = [];
                  List<GuestBookMessage> _etcLogMessages = [];*/
                  _iaLogMessages = [];
                  // ignore: avoid_function_literals_in_foreach_calls
                  int lastone=0;
                  snapshot.docs.forEach((document) {
                    var date = DateTime.fromMillisecondsSinceEpoch(
                        document.data()['timestamp']);
                    var formattedDate = DateFormat('MM월dd일 HH시mm분').format(date);
                    if(lastone==0) {
                      lastone=1;
                      print('무활동반응');
                      print(snapshot.docs.length);
                      if(_attendeesia>0) {
                        print('stored:'+document.data()['timestamp']);

                        print('now: $DateTime.now().millisecondsSinceEpoch');

                        _stopSound();
                        _setAsset('assets/audio/alram1.mp3');
                        _setLoopMode(LoopMode.one);
                        _playSound();
                        addNPopupManager(document.data()['name'],formattedDate,'무활동반응',300);
                      }
                      _attendeesia = snapshot.docs.length;
                      //basicSnackBar(document.data()['text'] +'이 발생했습니, 작업자: '+document.data()['name']));
                    }
                    _iaLogMessages.add(
                      GuestBookMessage(
                          name: document.data()['name'],
                          message: document.data()['text'],
                          timestamp: formattedDate,
                          location: document.data()['latitude'].toString() + ', ' +
                              document.data()['longitude'].toString()
                      ),
                    );
                  }
                );
              notifyListeners();
            });
            _attendeesff=0;
            listenFf?.cancel();
            listenFf = FirebaseFirestore.instance
                .collection('guestbook')
                .where('text',isEqualTo:'추락사고') //jay user
                .orderBy("timestamp", descending: true)
                .snapshots()
                .listen((snapshot) {
              /*
                  List<GuestBookMessage> _iaLogMessages = [];
                  List<GuestBookMessage> _ffLogMessages = [];
                  List<GuestBookMessage> _imLogMessages = [];
                  List<GuestBookMessage> _emLogMessages = [];
                  List<GuestBookMessage> _uemLogMessages = [];
                  List<GuestBookMessage> _ucnLogMessages = [];
                  List<GuestBookMessage> _rcnLogMessages = [];
                  List<GuestBookMessage> _beltLogMessages = [];
                  List<GuestBookMessage> _ubeltLogMessages = [];
                  List<GuestBookMessage> _etcLogMessages = [];*/
              _ffLogMessages = [];
              // ignore: avoid_function_literals_in_foreach_calls

              int lastone=0;
              snapshot.docs.forEach((document) {
                var date = DateTime.fromMillisecondsSinceEpoch(
                    document.data()['timestamp']);
                var formattedDate = DateFormat('MM월dd일 HH시mm분').format(date);
                if(lastone==0) {
                  lastone=1;
                  print('추락사고');
                  print(snapshot.docs.length);
                  if(_attendeesff>0 &&document.data()['timestamp']+60000>DateTime.now().millisecondsSinceEpoch) {
                    _stopSound();
                    _setAsset('assets/audio/alram1.mp3');
                    _setLoopMode(LoopMode.one);
                    _playSound();
                    addNPopupManager(document.data()['name'],formattedDate,'추락사고',300);
                  }
                  _attendeesff = snapshot.docs.length;
                  //basicSnackBar(document.data()['text'] +'이 발생했습니, 작업자: '+document.data()['name']));
                }
                _ffLogMessages.add(
                  GuestBookMessage(
                      name: document.data()['name'],
                      message: document.data()['text'],
                      timestamp: formattedDate,
                      location: document.data()['latitude'].toString() + ', ' +
                          document.data()['longitude'].toString()
                  ),
                );
              }
              );
              notifyListeners();
            });

            _attendeesim=0;
            listenIm?.cancel();
            listenIm = FirebaseFirestore.instance
                .collection('guestbook')
                .where('text',isEqualTo:'충격사고') //jay user
                .orderBy("timestamp", descending: true)
                .snapshots()
                .listen((snapshot) {

              /*
                  List<GuestBookMessage> _iaLogMessages = [];
                  List<GuestBookMessage> _ffLogMessages = [];
                  List<GuestBookMessage> _imLogMessages = [];
                  List<GuestBookMessage> _emLogMessages = [];
                  List<GuestBookMessage> _uemLogMessages = [];
                  List<GuestBookMessage> _ucnLogMessages = [];
                  List<GuestBookMessage> _rcnLogMessages = [];
                  List<GuestBookMessage> _beltLogMessages = [];
                  List<GuestBookMessage> _ubeltLogMessages = [];
                  List<GuestBookMessage> _etcLogMessages = [];*/
              _imLogMessages = [];
              // ignore: avoid_function_literals_in_foreach_calls

              int lastone=0;
              snapshot.docs.forEach((document) {
                var date = DateTime.fromMillisecondsSinceEpoch(
                    document.data()['timestamp']);
                var formattedDate = DateFormat('MM월dd일 HH시mm분').format(date);
                if(lastone==0) {
                  lastone=1;
                  print('충격사고');
                  print(snapshot.docs.length);
                  if(_attendeesim>0 &&document.data()['timestamp']+60000>DateTime.now().millisecondsSinceEpoch) {
                    _stopSound();
                    _setAsset('assets/audio/alram1.mp3');
                    _setLoopMode(LoopMode.one);
                    _playSound();
                    addNPopupManager(document.data()['name'],formattedDate,'충격사고',300);
                  }
                  _attendeesim = snapshot.docs.length;
                  //basicSnackBar(document.data()['text'] +'이 발생했습니, 작업자: '+document.data()['name']));
                }
                _imLogMessages.add(
                  GuestBookMessage(
                      name: document.data()['name'],
                      message: document.data()['text'],
                      timestamp: formattedDate,
                      location: document.data()['latitude'].toString() + ', ' +
                          document.data()['longitude'].toString()
                  ),
                );
              }
              );
              notifyListeners();
            });


            _attendeesem=0;
            listenEm?.cancel();
            listenEm = FirebaseFirestore.instance
                .collection('guestbook')
                .where('text',isEqualTo:'위급상황') //jay user
                .orderBy("timestamp", descending: true)
                .snapshots()
                .listen((snapshot) {
              print('위급상황');
              print(snapshot.docs.length);
              /*
                List<GuestBookMessage> _iaLogMessages = [];
                List<GuestBookMessage> _ffLogMessages = [];
                List<GuestBookMessage> _imLogMessages = [];
                List<GuestBookMessage> _emLogMessages = [];
                List<GuestBookMessage> _uemLogMessages = [];
                List<GuestBookMessage> _ucnLogMessages = [];
                List<GuestBookMessage> _rcnLogMessages = [];
                List<GuestBookMessage> _beltLogMessages = [];
                List<GuestBookMessage> _ubeltLogMessages = [];
                List<GuestBookMessage> _etcLogMessages = [];*/
                _emLogMessages = [];
                // ignore: avoid_function_literals_in_foreach_calls
                int lastone=0;
                snapshot.docs.forEach((document) {
                  var date = DateTime.fromMillisecondsSinceEpoch(
                      document.data()['timestamp']);
                  var formattedDate = DateFormat('MM월dd일 HH시mm분').format(date);
                  if(lastone==0) {
                    lastone=1;
                    if(_attendeesem>0 &&document.data()['timestamp']+60000>DateTime.now().millisecondsSinceEpoch ) {

                      _stopSound();
                      _setAsset('assets/audio/alram1.mp3');
                      _setLoopMode(LoopMode.one);
                      _playSound();
                      addNPopupManager(document.data()['name'],formattedDate,'위급상황',300);
                    }
                    _attendeesem = snapshot.docs.length;
                    //basicSnackBar(document.data()['text'] +'이 발생했습니, 작업자: '+document.data()['name']));
                  }
                  _emLogMessages.add(
                    GuestBookMessage(
                        name: document.data()['name'],
                        message: document.data()['text'],
                        timestamp: formattedDate,
                        location: document.data()['latitude'].toString() + ', ' +
                            document.data()['longitude'].toString()
                    ),
                  );
                }
              );
              notifyListeners();
            });

            _attendeesemrels=0;
            listenUEm?.cancel();
            listenUEm = FirebaseFirestore.instance
                .collection('guestbook')
                .where('text',isEqualTo:'상황해제')  //jay user
                .orderBy("timestamp", descending: true)
                .snapshots()
                .listen((snapshot) {
              print('상황해제');
              print(snapshot.docs.length);

              /*
                  List<GuestBookMessage> _iaLogMessages = [];
                  List<GuestBookMessage> _ffLogMessages = [];
                  List<GuestBookMessage> _imLogMessages = [];
                  List<GuestBookMessage> _emLogMessages = [];
                  List<GuestBookMessage> _uemLogMessages = [];
                  List<GuestBookMessage> _ucnLogMessages = [];
                  List<GuestBookMessage> _rcnLogMessages = [];
                  List<GuestBookMessage> _beltLogMessages = [];
                  List<GuestBookMessage> _ubeltLogMessages = [];
                  List<GuestBookMessage> _etcLogMessages = [];*/
              _uemLogMessages = [];

              // ignore: avoid_function_literals_in_foreach_calls

              int lastone=0;
              snapshot.docs.forEach((document) {
                var date = DateTime.fromMillisecondsSinceEpoch(
                    document.data()['timestamp']);
                var formattedDate = DateFormat('MM월dd일 HH시mm분').format(date);
                if(lastone==0) {
                  lastone=1;
                  print('상황해제');
                  print(snapshot.docs.length);
                  if(_attendeesemrels>0 &&document.data()['timestamp']+60000>DateTime.now().millisecondsSinceEpoch) {
                    _stopSound();
                    _setAsset('assets/audio/relEvent.mp3');
                    _setLoopMode(LoopMode.off);
                    _playSound();
                    addNPopupManager(document.data()['name'],formattedDate,'상황해제',300);
                  }
                  _attendeesemrels = snapshot.docs.length;
                  //basicSnackBar(document.data()['text'] +'이 발생했습니, 작업자: '+document.data()['name']));
                }
                _uemLogMessages.add(
                  GuestBookMessage(
                      name: document.data()['name'],
                      message: document.data()['text'],
                      timestamp: formattedDate,
                      location: document.data()['latitude'].toString() + ', ' +
                          document.data()['longitude'].toString()
                  ),
                );
              }
              );
              notifyListeners();
            });

            _attendeesoffline=0;
            listenUCn?.cancel();
            listenUCn = FirebaseFirestore.instance
                .collection('guestbook')
                .where('text', isEqualTo:'연결해제')  //jay user
                .orderBy("timestamp", descending: true)
                .snapshots()
                .listen((snapshot) {
              /*
                  List<GuestBookMessage> _iaLogMessages = [];
                  List<GuestBookMessage> _ffLogMessages = [];
                  List<GuestBookMessage> _imLogMessages = [];
                  List<GuestBookMessage> _emLogMessages = [];
                  List<GuestBookMessage> _uemLogMessages = [];
                  List<GuestBookMessage> _ucnLogMessages = [];
                  List<GuestBookMessage> _rcnLogMessages = [];
                  List<GuestBookMessage> _beltLogMessages = [];
                  List<GuestBookMessage> _ubeltLogMessages = [];
                  List<GuestBookMessage> _etcLogMessages = [];*/
              _ucnLogMessages = [];
              // ignore: avoid_function_literals_in_foreach_calls

              int lastone=0;
              snapshot.docs.forEach((document) {
                var date = DateTime.fromMillisecondsSinceEpoch(
                    document.data()['timestamp']);
                var formattedDate = DateFormat('MM월dd일 HH시mm분').format(date);
                if(lastone==0) {
                  lastone=1;
                  print('장비연결해제');
                  print(snapshot.docs.length);

                  if(_attendeesoffline>0 &&document.data()['timestamp']+60000>DateTime.now().millisecondsSinceEpoch) {
                    _stopSound();
                    _setAsset('assets/audio/alram1.mp3');
                    _setLoopMode(LoopMode.one);
                    _playSound();
                    addNPopupManager(document.data()['name'],formattedDate,'연결해제',300);
                  }
                  _attendeesoffline = snapshot.docs.length;
                  //basicSnackBar(document.data()['text'] +'이 발생했습니, 작업자: '+document.data()['name']));
                }
                _ucnLogMessages.add(
                  GuestBookMessage(
                      name: document.data()['name'],
                      message: document.data()['text'],
                      timestamp: formattedDate,
                      location: document.data()['latitude'].toString() + ', ' +
                          document.data()['longitude'].toString()
                  ),
                );
              }
              );
              notifyListeners();
            });

            _attendeesRecorvline=0;
            listenRCn?.cancel();
            listenRCn = FirebaseFirestore.instance
                .collection('guestbook')
                .where('text', isEqualTo:'연결복귀')  //jay user
                .orderBy("timestamp", descending: true)
                .snapshots()
                .listen((snapshot) {
              /*
                  List<GuestBookMessage> _iaLogMessages = [];
                  List<GuestBookMessage> _ffLogMessages = [];
                  List<GuestBookMessage> _imLogMessages = [];
                  List<GuestBookMessage> _emLogMessages = [];
                  List<GuestBookMessage> _uemLogMessages = [];
                  List<GuestBookMessage> _ucnLogMessages = [];
                  List<GuestBookMessage> _rcnLogMessages = [];
                  List<GuestBookMessage> _beltLogMessages = [];
                  List<GuestBookMessage> _ubeltLogMessages = [];
                  List<GuestBookMessage> _etcLogMessages = [];*/
              _rcnLogMessages = [];
              // ignore: avoid_function_literals_in_foreach_calls

              int lastone=0;
              snapshot.docs.forEach((document) {
                var date = DateTime.fromMillisecondsSinceEpoch(
                    document.data()['timestamp']);
                var formattedDate = DateFormat('MM월dd일 HH시mm분').format(date);
                if(lastone==0) {
                  lastone=1;
                  print('장비연결해제복귀');
                  print(snapshot.docs.length);

                  if(_attendeesRecorvline>0 &&document.data()['timestamp']+60000>DateTime.now().millisecondsSinceEpoch) {
                    _stopSound();
                    _setAsset('assets/audio/relEvent.mp3');
                    _setLoopMode(LoopMode.off);
                    _playSound();
                    addNPopupManager(document.data()['name'],formattedDate,'해제복귀',300);
                    //addNPopupManager('해제복귀',300);
                  }
                  _attendeesRecorvline = snapshot.docs.length;
                  //basicSnackBar(document.data()['text'] +'이 발생했습니, 작업자: '+document.data()['name']));
                }
                _rcnLogMessages.add(
                  GuestBookMessage(
                      name: document.data()['name'],
                      message: document.data()['text'],
                      timestamp: formattedDate,
                      location: document.data()['latitude'].toString() + ', ' +
                          document.data()['longitude'].toString()
                  ),
                );
              }
              );
              notifyListeners();
            });

            _attendeesbelt=0;
            listenBelt?.cancel();
            listenBelt = FirebaseFirestore.instance
                .collection('guestbook')
                .where('text', isEqualTo:'턱끈연결')  //jay user
                .orderBy("timestamp", descending: true)
                .snapshots()
                .listen((snapshot) {

              /*
                  List<GuestBookMessage> _iaLogMessages = [];
                  List<GuestBookMessage> _ffLogMessages = [];
                  List<GuestBookMessage> _imLogMessages = [];
                  List<GuestBookMessage> _emLogMessages = [];
                  List<GuestBookMessage> _uemLogMessages = [];
                  List<GuestBookMessage> _ucnLogMessages = [];
                  List<GuestBookMessage> _rcnLogMessages = [];
                  List<GuestBookMessage> _beltLogMessages = [];
                  List<GuestBookMessage> _ubeltLogMessages = [];
                  List<GuestBookMessage> _etcLogMessages = [];*/
              _beltLogMessages = [];
              // ignore: avoid_function_literals_in_foreach_calls

              int lastone=0;
              snapshot.docs.forEach((document) {
                var date = DateTime.fromMillisecondsSinceEpoch(
                    document.data()['timestamp']);
                var formattedDate = DateFormat('MM월dd일 HH시mm분').format(date);
                if(lastone==0) {
                  lastone=1;
                  print('턱끈연결');
                  print(snapshot.docs.length);
                  /*
              if(_attendeesbelt>0 &&document.data()['timestamp']+60000>DateTime.now().millisecondsSinceEpoch) {
                _stopSound();
                _setAsset('assets/audio/alram1.mp3');
                _setLoopMode(LoopMode.one);
                _playSound();
                    addNPopupManager(document.data()['name'],formattedDate,'턱끈연결',300);
              }*/
                  _attendeesbelt = snapshot.docs.length;
                  //basicSnackBar(document.data()['text'] +'이 발생했습니, 작업자: '+document.data()['name']));
                }
                _beltLogMessages.add(
                  GuestBookMessage(
                      name: document.data()['name'],
                      message: document.data()['text'],
                      timestamp: formattedDate,
                      location: document.data()['latitude'].toString() + ', ' +
                          document.data()['longitude'].toString()
                  ),
                );
              }
              );
              notifyListeners();
            });

            _attendeesDissbelt=0;
            listenUBelt?.cancel();
            listenUBelt = FirebaseFirestore.instance
                .collection('guestbook')
                .where('text', isEqualTo:'턱끈해제')  //jay user
                .orderBy("timestamp", descending: true)
                .snapshots()
                .listen((snapshot) {

              /*
                  List<GuestBookMessage> _iaLogMessages = [];
                  List<GuestBookMessage> _ffLogMessages = [];
                  List<GuestBookMessage> _imLogMessages = [];
                  List<GuestBookMessage> _emLogMessages = [];
                  List<GuestBookMessage> _uemLogMessages = [];
                  List<GuestBookMessage> _ucnLogMessages = [];
                  List<GuestBookMessage> _rcnLogMessages = [];
                  List<GuestBookMessage> _beltLogMessages = [];
                  List<GuestBookMessage> _ubeltLogMessages = [];
                  List<GuestBookMessage> _etcLogMessages = [];*/
              _ubeltLogMessages = [];
              // ignore: avoid_function_literals_in_foreach_calls

              int lastone=0;
              snapshot.docs.forEach((document) {
                var date = DateTime.fromMillisecondsSinceEpoch(
                    document.data()['timestamp']);
                var formattedDate = DateFormat('MM월dd일 HH시mm분').format(date);
                if(lastone==0) {
                  lastone=1;
                  print('턱끈해제');
                  print(snapshot.docs.length);
                  /*
                  if(_attendeesDissbelt>0 &&document.data()['timestamp']+60000>DateTime.now().millisecondsSinceEpoch) {
                    _stopSound();
                    _setAsset('assets/audio/alram1.mp3');
                    _setLoopMode(LoopMode.one);
                    _playSound();
                    addNPopupManager(document.data()['name'],formattedDate,'턱끈해제',300);
              }*/

                  _attendeesDissbelt = snapshot.docs.length;
                  //basicSnackBar(document.data()['text'] +'이 발생했습니, 작업자: '+document.data()['name']));
                }
                _ubeltLogMessages.add(
                  GuestBookMessage(
                      name: document.data()['name'],
                      message: document.data()['text'],
                      timestamp: formattedDate,
                      location: document.data()['latitude'].toString() + ', ' +
                          document.data()['longitude'].toString()
                  ),
                );
              }
              );
              notifyListeners();
            });

            _attendeesetc=0;
            listenEtc?.cancel();
            listenEtc =  FirebaseFirestore.instance
                .collection('guestbook')
              //_attendeesia, _attendeesff, _attendeesim, _attendeesemrels, _attendeesbelt, _attendeesDissbelt, _attendeesoffline, _attendeesRecorvline
              //['무활동반응','추락사고','충격사고','위급상황','상황해제','연결해제','연결복귀','턱끈연결','턱끈해제']) //jay user
                .where('text',whereNotIn: ['무활동반응','추락사고','충격사고','위급상황','상황해제','연결해제','연결복귀','턱끈연결','턱끈해제'])  //jay user
                //.orderBy("timestamp", descending: true)
                .snapshots()
                .listen((snapshot) {
              /*
                  List<GuestBookMessage> _iaLogMessages = [];
                  List<GuestBookMessage> _ffLogMessages = [];
                  List<GuestBookMessage> _imLogMessages = [];
                  List<GuestBookMessage> _emLogMessages = [];
                  List<GuestBookMessage> _uemLogMessages = [];
                  List<GuestBookMessage> _ucnLogMessages = [];
                  List<GuestBookMessage> _rcnLogMessages = [];
                  List<GuestBookMessage> _beltLogMessages = [];
                  List<GuestBookMessage> _ubeltLogMessages = [];
                  List<GuestBookMessage> _etcLogMessages = [];*/
              _etcLogMessages = [];
              // ignore: avoid_function_literals_in_foreach_calls

              int lastone=0;
              snapshot.docs.forEach((document) {

                var date = DateTime.fromMillisecondsSinceEpoch(
                    document.data()['timestamp']);
                var formattedDate = DateFormat('MM월dd일 HH시mm분').format(date);
                if(lastone==0) {
                lastone=1;
                print('기타상황');
                print(snapshot.docs.length);
                if(_attendeesetc>0 &&document.data()['timestamp']+60000>DateTime.now().millisecondsSinceEpoch) {
                  _stopSound();
                  _setAsset('assets/audio/alram1.mp3');
                  _setLoopMode(LoopMode.one);
                  _playSound();
                  addNPopupManager(document.data()['name'],formattedDate,'기타상황',300);
                }
                _attendeesetc = snapshot.docs.length;
                //basicSnackBar(document.data()['text'] +'이 발생했습니, 작업자: '+document.data()['name']));
                }
                _etcLogMessages.add(
                  GuestBookMessage(
                      name: document.data()['name'],
                      message: document.data()['text'],
                      timestamp: formattedDate,
                      location: document.data()['latitude'].toString() + ', ' +
                          document.data()['longitude'].toString()
                  ),
                );
              }
              );
              notifyListeners();
            });
            /*
            _guestBookSubscription = FirebaseFirestore.instance
                .collection('guestbook')
              //.where('userId',isEqualTo:user.uid) //jay user
                .orderBy('timestamp', descending: true)
                .snapshots()
                .listen((snapshot){
              _attendeesall = snapshot.docs.length;
              _stopSound();
              _setAsset('assets/audio/alram1.mp3');
              //_setLoopMode(LoopMode.one);
              _playSound();
              print('페어런츠 모든 얼럿');


              //GetMaterialApp.dialog (SimpleDialog ());
              //_attendeesetc = _attendeesall - _attendeesbelt - _attendeesim -_attendeesff-_attendeesia-_attendeesem;
              _guestBookMessages = [];
              int lastone =0;
              snapshot.docs.forEach((document) {
                if(lastone==0) {
                  print('lastone');
                  lastone=1;
                  scaffoldKey.currentState!.showSnackBar(
                      basicSnackBar(document.data()['text'] +'이 발생했습니, 작업자: '+document.data()['name']));
                }
                 /*if (document.data()['userId'] == user.uid ||logEmail=='jay@tinkerbox.kr') */ {
                  var date = DateTime.fromMillisecondsSinceEpoch(
                      document.data()['timestamp']);
                  var formattedDate = DateFormat('MM월dd일 HH시mm분').format(date);
                  _guestBookMessages.add(
                    GuestBookMessage(
                        name: document.data()['name'],
                        message: document.data()['text'],
                        timestamp: formattedDate,
                        location: document.data()['latitude'].toString() + ', ' +
                            document.data()['longitude'].toString()
                    ),
                  );
                }
              }
              );
              notifyListeners();
            });*/
          }
        else
          {
          _guestBookSubscription = FirebaseFirestore.instance
              .collection('guestbook')
              .where('userId',isEqualTo:user.uid) //jay user
              .orderBy('timestamp', descending: true)
              .snapshots()
              .listen((snapshot){
            _guestBookMessages = [];
            snapshot.docs.forEach((document) {
              if (document.data()['userId'] == user.uid)  {
                var date = DateTime.fromMillisecondsSinceEpoch(
                    document.data()['timestamp']);
                var formattedDate = DateFormat('MM월dd일 HH시mm분').format(date);
                _guestBookMessages.add(
                  GuestBookMessage(
                      name: document.data()['name'],
                      message: document.data()['text'],
                      timestamp: formattedDate,
                      location: document.data()['latitude'].toString() + ', ' +
                          document.data()['longitude'].toString()
                  ),
                );
              }
            }
            );
            notifyListeners();
          });
          notifyListeners();
        }
        // to here.
        // Add from here
        _attendingSubscription = FirebaseFirestore.instance
            .collection('attendees')
            .doc(user.uid)
            .snapshots()
            .listen((snapshot) {
          if (snapshot.data() != null) {
            if (snapshot.data()!['attending']) {
              _attending = Attending.yes;
            } else {
              _attending = Attending.no;
            }
          } else {
            _attending = Attending.unknown;
          }
          notifyListeners();
        });
        // to here
      } else {
        displayPhoneNumber = '사용자 정보없음';
        displayName = '사용자 없음';
        displayEmail = '사용자 정보없음';
        print('logout ');
        bTdevice?.disconnect();
        logState = false;
        logEmail='사용자 정보없음';
        _loginState = ApplicationLoginState.loggedOut;
        // Add from here
        _guestBookMessages = [];
        _guestBookSubscription?.cancel();
        _attendingSubscription?.cancel(); // new
        // to here.
      }
      notifyListeners();
    });
  }

  Attending _attending = Attending.unknown;
  StreamSubscription<DocumentSnapshot>? _attendingSubscription;
  Attending get attending => _attending;
  set attending(Attending attending) {
    final userDoc = FirebaseFirestore.instance
        .collection('attendees')
        .doc(FirebaseAuth.instance.currentUser!.uid);
    if (attending == Attending.yes) {
      userDoc.set({'attending': true});
    } else {
      userDoc.set({'attending': false});
    }
  }



  ApplicationLoginState _loginState = ApplicationLoginState.loggedOut;
  ApplicationLoginState get loginState => _loginState;

  String? _email;
  String? get email => _email;
// Add from here
  StreamSubscription<QuerySnapshot>? _guestBookSubscription;
  List<GuestBookMessage> get guestBookMessages => _guestBookMessages;
  List<GuestBookMessage> _guestBookMessages = [];

  // to here.


  void startLoginFlow() {
    _loginState = ApplicationLoginState.emailAddress;
    notifyListeners();
  }

  void verifyEmail(
      String email,
      void Function(FirebaseAuthException e) errorCallback,
      ) async {
    try {
      var methods =
      await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      if (methods.contains('password')) {
        _loginState = ApplicationLoginState.password;
      } else {
        _loginState = ApplicationLoginState.register;
      }
      _email = email;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
  }

  void signInWithEmailAndPassword(
      String email,
      String password,
      void Function(FirebaseAuthException e) errorCallback,
      ) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
  }

  void cancelRegistration() {
    _loginState = ApplicationLoginState.emailAddress;
    notifyListeners();
  }

  void registerAccount(String email, String displayName, String password,
      void Function(FirebaseAuthException e) errorCallback) async {
    try {
      /*
      var credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      await FirebaseAuth.instance.currentUser.updateProfile();

*/

      var credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await credential.user!.updateProfile(displayName: displayName);
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
  }


  // Add from here
  Future<DocumentReference> addMessageToGuestBook(String message) {

    if (_loginState != ApplicationLoginState.loggedIn) {
      throw Exception('Must be logged in');
    }

    message = message+'(수기입력)';

    return FirebaseFirestore.instance.collection('guestbook').add({
      'text': message,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'name': FirebaseAuth.instance.currentUser!.displayName,
      'userId': FirebaseAuth.instance.currentUser!.uid,
      'latitude': geolatitude,
      'longitude': geolongitude,
    });
  }
// To here
}



class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: scaffoldBgColor,
        body: WillPopScope(
        onWillPop: () async {
      bool backStatus = onWillPop();
      if (backStatus) {
        Future.value(true);//exit(0);
      }
      return false;
    },
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Helmet',
      //title: 'Firebase Meetup',
      theme: ThemeData(
        buttonTheme: Theme.of(context).buttonTheme.copyWith(
              highlightColor: Colors.deepPurple,
            ),
        primarySwatch: Colors.deepPurple,
        textTheme: GoogleFonts.robotoTextTheme(
          Theme.of(context).textTheme,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage()/* FlutterBlueApp()*/,
    ),
      ),
    );
  }

  onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(
        msg: '앱의 최상위 메뉴 입니다',
        backgroundColor: Colors.black,
        textColor: whiteColor,
      );
      return false;
    } else {
      return true;
    }
  }
}

bool isDialogAlive =false;
FlutterBlue flutterBlue=FlutterBlue.instance;
BluetoothDevice? bTdevice;
StreamSubscription? noti;

StreamSubscription? notistate;
StreamSubscription? btstateMachine;

bool isConnected=false;

bool isHelmetDisconnected=false;
double geolatitude=0;
double geolongitude=0;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}
DateTime? currentBackPressTime;

class _HomeState extends State<Home> {

  Widget addNewBeneficiaryButton(){
    return InkWell(
      /*
      onTap: () {
        Navigator.pop(context);
      },*/
      /* onTap: () => Navigator.push(
        context,
        PageTransition(
          duration: Duration(milliseconds: 500),
          type: PageTransitionType.rightToLeft,
          child: AddNewBeneficiary(),
        ),
      ),*/
      child: Container(
        child: Container(
          margin: EdgeInsets.all(fixPadding * 2.0),
          padding: EdgeInsets.symmetric(vertical: fixPadding),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.deepPurple,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child:const Text('종합 사고 상황',
            style:TextStyle(
              fontSize: 18.0,
              color: Colors.white,
              fontWeight: FontWeight.w500 ,
            ),
            //style: white16BoldTextStyle,
          ),
        ),
      ),
    );
  }

  Widget benificiariesText() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: fixPadding * 2.0,
      ),
      child: const Text(
        'Your beneficiaries',
        // style: black16BoldTextStyle,
      ),
    );
  }

  Widget userBeneficiaries() {
    return Container(
      margin: EdgeInsets.only(
        top: fixPadding + 5.0,
        bottom: fixPadding + 5.0,
      ),
      child: GridView.count(
        crossAxisCount: 4,
        childAspectRatio: 0.7,
        padding: const EdgeInsets.all(4.0),
        mainAxisSpacing: 0.0,
        crossAxisSpacing: 0.0,
        shrinkWrap: true,
        primary: true,
        physics: NeverScrollableScrollPhysics(),
        children: beneficiariesList.map(
              (item) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) =>
                                ShowDataLogerScreen(itemname: item['name']!))).then((value) =>
                                  setState(() {})); //_startscan();
                  },
                  /*
                  onTap: () => Navigator.push(
                    context,
                    PageTransition(
                      duration: Duration(milliseconds: 500),
                      type: PageTransitionType.rightToLeft,
                      child: BeneficiaryMoneyTransfer(
                        userPhoto: item['image'],
                        name: item['name'],
                      ),
                    ),
                  ),*/
                  child: Column(
                    children: [
                      Text(
                        item['name']!,
                        style: TextStyle(
                          fontSize: 14.0,
                          color: blackColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      SizedBox(height: 10.0),
                      ////['무활동반응','추락사고','충격사고','위급상황','상황해제','연결해제','연결복귀','턱끈연결','턱끈해제']) //jay user
                      Text(
                        (item['name']=='무활동반응')?
                        _attendeesia.toString():
                        (item['name']=='추락사고')?
                        _attendeesff.toString():
                        (item['name']=='충격사고')?
                        _attendeesim.toString():
                        (item['name']=='위급상황')?
                        _attendeesem.toString():
                        (item['name']=='상황해제')?
                        _attendeesemrels.toString():
                        (item['name']=='연결해제')?
                        _attendeesoffline.toString():
                        (item['name']=='연결복귀')?
                        _attendeesRecorvline.toString():
                        (item['name']=='턱끈해제')?
                        _attendeesDissbelt.toString():
                        (item['name']=='턱끈연결')?
                        _attendeesbelt.toString():
                        (item['name']=='그밖의긴급상황')?
                        _attendeesetc.toString():
                          _attendeesall.toString(),
                        style: const TextStyle(
                          fontSize: 28.0,
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      //SizedBox(height: 10.0),
                      const Icon(
                        Icons.format_list_numbered,
                        color: Colors.black54,
                        //size: 10.0,
                      ),
/*
                      Container(
                        height: 60.0,
                        width: 60.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage(item['image']!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),*/
                    ],
                  ),
                ),
              ],
            );
          },
        ).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body:
      ListView(
        children: <Widget>[
          Image.asset('assets/image/workman.png'),
          //Image.asset('assets/image/caring-nurse-and-the-girl-FPAX4FK.png'),

          const SizedBox(height: 8),

          Consumer<ApplicationState>(
            builder: (context, appState, _) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Add from here
                /*
                if (appState.attendees >= 2)
                  Paragraph('${appState.attendees} 명의 작업자가 공동작업 중에 있습니다')
                  //Paragraph('${appState.attendees} 명이 함께 헬스 시큐리티 관리 중에 있습니다')
                else if (appState.attendees == 1)
                  Paragraph('1 명의 작업자가 작업 중에 있습니다')
                  //Paragraph('1 명이 함께 헬스 시큐리티 관리 중에 있습니다')
                else
                  Paragraph('작업자가 없습니다'),
                  //Paragraph('관리대상 없습니다'),
                 */
                // To here.

                if(logEmail!='jay@tinkerbox.kr') ...[
                  IconAndDetail(Icons.calendar_today, DateFormat('yyyy년 MM월 dd일 HH시mm분').format(DateTime.now()).toString()),
                  IconAndDetail(Icons.location_city, '서울시 구로구 A 작업지'),

                  Consumer<ApplicationState>(
                    builder: (context, appState, _) => Authentication(
                      email: appState.email,
                      loginState: appState.loginState,
                      startLoginFlow: appState.startLoginFlow,
                      verifyEmail: appState.verifyEmail,
                      signInWithEmailAndPassword: appState.signInWithEmailAndPassword,
                      cancelRegistration: appState.cancelRegistration,
                      registerAccount: appState.registerAccount,
                      signOut: appState.signOut,
                    ),
                  ),
                  // to here
                ],


                if (appState.loginState == ApplicationLoginState.loggedIn/*&&btState==BluetoothDeviceState.connected*/) ...[
/*
                  // Add from here
                  YesNoSelection(
                    state: appState.attending,
                    onSelection: (attending) => appState.attending = attending,
                  ),
                  // To here
*/

                  if(logEmail=='jay@tinkerbox.kr') ...[
                      addNewBeneficiaryButton(),
                      //benificiariesText(),
                      userBeneficiaries(),
                    // Add from here
                    Consumer<ApplicationState>(
                      builder: (context, appState, _) => Authentication(
                        email: appState.email,
                        loginState: appState.loginState,
                        startLoginFlow: appState.startLoginFlow,
                        verifyEmail: appState.verifyEmail,
                        signInWithEmailAndPassword: appState.signInWithEmailAndPassword,
                        cancelRegistration: appState.cancelRegistration,
                        registerAccount: appState.registerAccount,
                        signOut: appState.signOut,
                      ),
                    ),
                    // to here

                  ]
                  else ...
                    [
                      const Divider(
                        height: 8,
                        thickness: 1,
                        indent: 8,
                        endIndent: 8,
                        color: Colors.grey,
                      ),

                      heightSpace,
                      heightSpace,
                      const Header('마지막 발생한 안전상황'),
                      GuestBook(
                        messages: appState.guestBookMessages, // new
                        addMessage: (String message) =>
                            appState.addMessageToGuestBook(message),
                        logcount: 1,
                      ),
                    ],
                ],
                if (appState.loginState == ApplicationLoginState.loggedOut/*&&btState==BluetoothDeviceState.connected*/) ...[
                  heightSpace,
                  heightSpace,
                  const Header('오늘의 안전수칙'),
                  const Paragraph('말로하는 안전보다.실천하는 안전점검'),
                ],
              ],
            ),
          ),

          heightSpace,

          // To here.
        ],
      ),
    );
  }
}
class First extends StatefulWidget {
  @override
  _FirstState createState() => _FirstState();
}

class _FirstState extends State<First> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      ListView(
        children: <Widget>[
          Image.asset('assets/image/log.png'),
          //Image.asset('assets/image/caring-nurse-and-the-girl-FPAX4FK.png'),
          Consumer<ApplicationState>(
            builder: (context, appState, _) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (appState.loginState == ApplicationLoginState.loggedIn/*&&btState==BluetoothDeviceState.connected*/) ...[
                  //appState.guestBookMessages,
                  GuestBook(
                    messages: (logEmail=='jay@tinkerbox.kr')? emLogMessages:appState.guestBookMessages, // new
                    addMessage: (String message) =>
                        appState.addMessageToGuestBook(message),
                  ),
                ],
              ],
            ),
          ),
          heightSpace,
          // To here.
        ],
      ),
    );
  }
}


class ATM {
  String? bankname;
  String? address;
  double? rating;
  double? distance;
  LatLng? locationCoords;

  ATM({
    this.bankname,
    this.address,
    this.rating,
    this.distance,
    this.locationCoords,
  });
}

final List<ATM> atms = [
  ATM(
    bankname: 'BankX ATM',
    address: 'G-3, General Point, New York.',
    rating: 4.0,
    distance: 3.5,
    locationCoords: LatLng(40.745803, -73.988213),
  ),
  ATM(
    bankname: 'BankX Yogi Point ATM',
    address: 'G-8, Yogi Point, New York.',
    rating: 4.5,
    distance: 3.0,
    locationCoords: LatLng(40.751908, -73.989804),
  ),
  ATM(
    bankname: 'BankX Varachha Point ATM',
    address: 'B-8, Varachha Point, New York.',
    rating: 5.0,
    distance: 4.5,
    locationCoords: LatLng(40.730148, -73.999639),
  ),
  ATM(
    bankname: 'BankX Sarthana Point ATM',
    address: 'K-9, Sarthana Point, New York.',
    rating: 3.5,
    distance: 3.5,
    locationCoords: LatLng(40.729515, -73.985927),
  ),
];

class Second extends StatefulWidget {
  Second({required this.latitude, required this.longitude});
  double latitude;
  double longitude;
  @override
  _SecondState createState() => _SecondState();
}

class _SecondState extends State<Second> {
  List<LatLng> allMarkers = [];
  late PageController _pageController;

  late int prevPage;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    /*
    atms.forEach((element) {

      allMarkers.add(
        Marker(
          markerId: MarkerId(element.bankname),
          draggable: false,
          infoWindow: InfoWindow(
            title: element.bankname,
            snippet: element.address,
          ),
          position: element.locationCoords,
        ),
      );
   ;
    });
    _pageController = PageController(initialPage: 1, viewportFraction: 0.65)
      ..addListener(_onScroll);
     */
  }

  final controller = MapController(
    location: LatLng(37.4837122, 126.8954294),
    zoom:  18,
  );

  bool _darkMode = false;

  final markers = [
    LatLng(37.3912922, 126.9395068),
    LatLng(37.3912922, 126.9396068),
    LatLng(37.3912922, 126.9397068),
    LatLng(37.3912922, 126.9398068),
    LatLng(37.3912922, 126.9399068),
    LatLng(37.3912922, 126.9394068),
    LatLng(37.3912922, 126.9393068),
  ];

  void _gotoDefault() {
    controller.center = LatLng(geolatitude, geolongitude);
    //controller.zoom += 0.5;
    setState(() {});
  }

  void _gotoTarget() {
    controller.center = LatLng(widget.latitude, widget.longitude);
    //controller.zoom += 0.5;
    setState(() {});
  }

  void _onDoubleTap() {
    controller.zoom += 0.5;
    setState(() {});
  }

  Offset? _dragStart;
  double _scaleStart = 1.0;
  void _onScaleStart(ScaleStartDetails details) {
    _dragStart = details.focalPoint;
    _scaleStart = 1.0;
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    final scaleDiff = details.scale - _scaleStart;
    _scaleStart = details.scale;

    if (scaleDiff > 0) {
      controller.zoom += 0.02;
      setState(() {});
    } else if (scaleDiff < 0) {
      controller.zoom -= 0.02;
      setState(() {});
    } else {
      final now = details.focalPoint;
      final diff = now - _dragStart!;
      _dragStart = now;
      controller.drag(diff.dx, diff.dy);
      setState(() {});
    }
  }

  Widget _buildMarkerWidget(Offset pos, Color color) {
    return Positioned(
      left: pos.dx - 16,
      top: pos.dy - 16,
      width: 38,
      height: 38,
      child: Icon(Icons.location_on, color: color),
    );
  }

/*
  _onScroll() {
    if (_pageController.page!.toInt() != prevPage) {
      prevPage = _pageController.page!.toInt();
      //moveCamera();
    }
  }
*/
  Widget _bankList(index) {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (context, widget) {
        double value = 1.0;
        if (_pageController.position.haveDimensions) {
          value = _pageController.page! - index;
          value = (1 - (value.abs() * 0.35) + 0.06).clamp(0.0, 1.0);
        }
        return Center(
          child: SizedBox(
            height: Curves.easeInOut.transform(value) * 160.0,
            width: Curves.easeInOut.transform(value) * 400.0,
            child: widget,
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: fixPadding,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: fixPadding,
          vertical: fixPadding,
        ),
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(fixPadding),
          boxShadow: [
            BoxShadow(
              spreadRadius: 1.0,
              blurRadius: 4.0,
              color: greyColor.withOpacity(0.5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  atms[index].bankname!,
                 // style: black14BoldTextStyle,
                ),
                //height5Space,
                Text(
                  atms[index].address!,
                 // style: grey12RegularTextStyle,
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  '${atms[index].rating!}',
                  //style: black14RegularTextStyle,
                ),
                SizedBox(width: 3.0),
                const Icon(
                  Icons.star,
                  color: Color(0xffBFDC0F),
                  size: 18.0,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    const Text(
                      'Distance',
                      //style: grey12RegularTextStyle,
                    ),
                   // height5Space,
                    Text(
                      '${atms[index].distance!} km',
                      //style: black14BoldTextStyle,
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: fixPadding * 2.0,
                    vertical: fixPadding - 5.0,
                  ),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: whiteColor,
                    border: Border.all(color: primaryColor),
                    borderRadius: BorderRadius.circular(fixPadding * 2.0),
                  ),
                  child: const Text(
                    'Direction',
                   // style: black12MediumTextStyle,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('사고위치 확인'),
        actions: [
          /*
          IconButton(
            tooltip: '다크모드',
            onPressed: () {
              setState(() {
                _darkMode = !_darkMode;
              });
            },
            icon: Icon(Icons.wb_sunny),
          ),*/
        ],
      ),
      body: Stack(
        children: [
          MapLayoutBuilder(
        controller: controller,
        builder: (context, transformer) {

          //controller.zoom += 3;
         // controller.location =
          final markerPositions =
          markers.map(transformer.fromLatLngToXYCoords).toList();

/*
          final markerWidgets = markerPositions.map(
                (pos) => _buildMarkerWidget(pos, Colors.red),
          );
*/
          final homeLocation =
          transformer.fromLatLngToXYCoords(LatLng(widget.latitude, widget.longitude));

          final homeMarkerWidget =
          _buildMarkerWidget(homeLocation, Colors.deepOrange);

          final centerLocation = Offset(
              transformer.constraints.biggest.width / 2,
              transformer.constraints.biggest.height / 2);

          final centerMarkerWidget =
          _buildMarkerWidget(centerLocation, Colors.deepPurple);

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onDoubleTap: _onDoubleTap,
            onScaleStart: _onScaleStart,
            onScaleUpdate: _onScaleUpdate,
            onTapUp: (details) {
              final location =
              transformer.fromXYCoordsToLatLng(details.localPosition);

              final clicked = transformer.fromLatLngToXYCoords(location);

              print('${location.longitude}, ${location.latitude}');
              print('${clicked.dx}, ${clicked.dy}');
              print('${details.localPosition.dx}, ${details.localPosition.dy}');
            },
            child: Listener(
              behavior: HitTestBehavior.opaque,
              onPointerSignal: (event) {
                if (event is PointerScrollEvent) {
                  final delta = event.scrollDelta;

                  controller.zoom -= delta.dy / 1000.0;
                  setState(() {});
                }
              },
              child: Stack(
                children: [
                  Map(
                    controller: controller,
                    builder: (context, x, y, z) {
                      //Legal notice: This url is only used for demo and educational purposes. You need a license key for production use.

                      //Google Maps
                      final url =
                          'https://www.google.com/maps/vt/pb=!1m4!1m3!1i$z!2i$x!3i$y!2m3!1e0!2sm!3i420120488!3m7!2sen!5e1105!12m4!1e68!2m2!1sset!2sRoadmap!4e0!5m1!1e0!23i4111425';

                      final darkUrl =
                          'https://maps.googleapis.com/maps/vt?pb=!1m5!1m4!1i$z!2i$x!3i$y!4i256!2m3!1e0!2sm!3i556279080!3m17!2sen-US!3sUS!5e18!12m4!1e68!2m2!1sset!2sRoadmap!12m3!1e37!2m1!1ssmartmaps!12m4!1e26!2m2!1sstyles!2zcC52Om9uLHMuZTpsfHAudjpvZmZ8cC5zOi0xMDAscy5lOmwudC5mfHAuczozNnxwLmM6I2ZmMDAwMDAwfHAubDo0MHxwLnY6b2ZmLHMuZTpsLnQuc3xwLnY6b2ZmfHAuYzojZmYwMDAwMDB8cC5sOjE2LHMuZTpsLml8cC52Om9mZixzLnQ6MXxzLmU6Zy5mfHAuYzojZmYwMDAwMDB8cC5sOjIwLHMudDoxfHMuZTpnLnN8cC5jOiNmZjAwMDAwMHxwLmw6MTd8cC53OjEuMixzLnQ6NXxzLmU6Z3xwLmM6I2ZmMDAwMDAwfHAubDoyMCxzLnQ6NXxzLmU6Zy5mfHAuYzojZmY0ZDYwNTkscy50OjV8cy5lOmcuc3xwLmM6I2ZmNGQ2MDU5LHMudDo4MnxzLmU6Zy5mfHAuYzojZmY0ZDYwNTkscy50OjJ8cy5lOmd8cC5sOjIxLHMudDoyfHMuZTpnLmZ8cC5jOiNmZjRkNjA1OSxzLnQ6MnxzLmU6Zy5zfHAuYzojZmY0ZDYwNTkscy50OjN8cy5lOmd8cC52Om9ufHAuYzojZmY3ZjhkODkscy50OjN8cy5lOmcuZnxwLmM6I2ZmN2Y4ZDg5LHMudDo0OXxzLmU6Zy5mfHAuYzojZmY3ZjhkODl8cC5sOjE3LHMudDo0OXxzLmU6Zy5zfHAuYzojZmY3ZjhkODl8cC5sOjI5fHAudzowLjIscy50OjUwfHMuZTpnfHAuYzojZmYwMDAwMDB8cC5sOjE4LHMudDo1MHxzLmU6Zy5mfHAuYzojZmY3ZjhkODkscy50OjUwfHMuZTpnLnN8cC5jOiNmZjdmOGQ4OSxzLnQ6NTF8cy5lOmd8cC5jOiNmZjAwMDAwMHxwLmw6MTYscy50OjUxfHMuZTpnLmZ8cC5jOiNmZjdmOGQ4OSxzLnQ6NTF8cy5lOmcuc3xwLmM6I2ZmN2Y4ZDg5LHMudDo0fHMuZTpnfHAuYzojZmYwMDAwMDB8cC5sOjE5LHMudDo2fHAuYzojZmYyYjM2Mzh8cC52Om9uLHMudDo2fHMuZTpnfHAuYzojZmYyYjM2Mzh8cC5sOjE3LHMudDo2fHMuZTpnLmZ8cC5jOiNmZjI0MjgyYixzLnQ6NnxzLmU6Zy5zfHAuYzojZmYyNDI4MmIscy50OjZ8cy5lOmx8cC52Om9mZixzLnQ6NnxzLmU6bC50fHAudjpvZmYscy50OjZ8cy5lOmwudC5mfHAudjpvZmYscy50OjZ8cy5lOmwudC5zfHAudjpvZmYscy50OjZ8cy5lOmwuaXxwLnY6b2Zm!4e0&key=AIzaSyAOqYYyBbtXQEtcHG7hwAwyCPQSYidG8yU&token=31440';
                      //Mapbox Streets
                      // final url =
                      //     'https://api.mapbox.com/styles/v1/mapbox/streets-v11/tiles/$z/$x/$y?access_token=YOUR_MAPBOX_ACCESS_TOKEN';

                      return CachedNetworkImage(
                        imageUrl: _darkMode ? darkUrl : url,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                  homeMarkerWidget,
                  //...markerWidgets,
                  centerMarkerWidget,
                ],
              ),
            ),
          );
        },
      ),
      /*
      Positioned(
        bottom: 20.0,
        child: Container(
          height: 200.0,
          width: MediaQuery.of(context).size.width,
          child: PageView.builder(
            controller: _pageController,
            itemCount: atms.length,
            itemBuilder: (context, index) {
              return _bankList(index);
            },
          ),
        ),
      ),
          */
      ],
    ),
      floatingActionButton: Stack(
        children: <Widget>[
          Padding(padding: EdgeInsets.only(left:31),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: FloatingActionButton.extended(
                onPressed: _gotoDefault,
                label: Text('내위치 '),
                icon: Icon(Icons.my_location),
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton.extended(
              onPressed: _gotoTarget,
              label: Text('사고위치'),
              icon: Icon(Icons.location_pin),
              backgroundColor: Colors.deepOrange,
            ),
          ),
        ],
      )
      /*
      FloatingActionButton(
        onPressed: _gotoDefault,
        tooltip: '내위치',
        child: Icon(Icons.my_location),
      ),*/
    );
  }
}


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _counter = 0;
  int _counterA = 0;
  StreamController<int>? _events;
  StreamController<int>? _eventsA;
  StreamController<int>? _eventsBattery;

  void initState() {
    super.initState();
    player = AudioPlayer();
    //ble instance 생성
    flutterBlue = FlutterBlue.instance;
    Geolocator.getCurrentPosition().then((value) => {
      geolatitude=value.latitude,
      geolongitude=value.longitude,
      print('geolocation(init) ${geolatitude}, ${geolongitude}'),
    });

    _timer_geo = Timer.periodic(Duration(seconds: 30), (timer) {
      Geolocator.getCurrentPosition().then((value) => {
        geolatitude=value.latitude,
        geolongitude=value.longitude,
        print('tmrGeo_geolocation ${geolatitude}, ${geolongitude}'),
      });
    });
  }

  var writecharacteristic;

  void addNewPopupU(String state, int time)  {

    print('addNewPopup(U) time :'+ time.toString()+', State:'+state);
    if(_eventsA!=null) {
      _eventsA?.close();
    }
    _eventsA = StreamController<int>();
    _eventsA?.add(time);
    alertA(context, state, time);
  }
  // used by FutureBuilder
  Future<int> _calculateSquare(int num) async {
    await Future.delayed(const Duration(seconds: 5));
    return num * num;
  }

  Future<void> connectMyProtocol(BluetoothDevice? device) async {
    if(device == null) { print('connectMyProtocol null return'); return;}
    print('connectMyProtocol ');
    List<int> value2;
    List<BluetoothService> services = await device.discoverServices();
    // CODE DOES NOT
    print('div');
    notistate?.cancel();
    notistate= device.state.listen((bstate) {
      print('device.state: {$bstate}');
      if (bstate == BluetoothDeviceState.connected) {
        device.discoverServices().then((dservice) {
          services = dservice;
          for(BluetoothService service in services) {
            if(service.uuid.toString().contains('6e400001') )
            {
              // Reads all characteristics
              var characteristics = service.characteristics;
              for(BluetoothCharacteristic c in characteristics) {
                if (c.uuid.toString().contains('6e400002'))
                {
                  //print('get characteristic 4 belt status');
                  writecharacteristic = c;
                }

                if(c.descriptors.isNotEmpty) {
                  c.setNotifyValue(true);
                  noti?.cancel();
                  noti= c.value.listen((value) {
                    String state='이상없음';
                    //_stopSound();
                    String btMessage = ascii.decode(value).toString();
                    print('------------- Notify Listen -----------------');
                    print('listenMsg: '+ btMessage.toString());
                    if(btMessage.contains('BAT')){
                      int adcBatt = int.parse(btMessage.substring(btMessage.lastIndexOf(",")+1));
                      setState(() {
                        batteryPercent =(((adcBatt-2700)/(3400-2700))*100);
                      });
                      if(adcBatt>2700) {
                        _timer_bat?.cancel();
                        _timer_bat = Timer.periodic(const Duration(seconds: 60), (timer) {
                          writecharacteristic.write(utf8.encode('req bat'));
                        });
                      }

                    }
                    else if((btMessage.contains('Belt Connected')||btMessage.toString().contains('Belt Alive'))&&beltState==false) {
                      state = '턱끈연결';
                      beltState = true;
                      _setAsset('assets/audio/conBelt.mp3');
                      _setLoopMode(LoopMode.off);
                    }
                    else if(btMessage.contains('Belt Disconnected')) {
                      state = '턱끈해제';
                      beltState = false;
                      _setAsset('assets/audio/belt0.mp3');
                      _setLoopMode(LoopMode.off);
                    }
                    else if(btMessage.contains('EM')) {
                      state = '위급상황';
                      _setAsset('assets/audio/alram1.mp3');
                      _setLoopMode(LoopMode.one);
                    }
                    else if(btMessage.contains('IA')) {
                      state = '무활동반응';
                      _setAsset('assets/audio/alram1.mp3');
                      _setLoopMode(LoopMode.one);
                    }
                    else if(btMessage.contains('FF')) {
                      state = '추락사고';
                      _setAsset('assets/audio/alram1.mp3');
                      _setLoopMode(LoopMode.one);
                    }
                    else if(btMessage.contains('IM')) {
                      state = '충격사고';
                      _setAsset('assets/audio/alram1.mp3');
                      _setLoopMode(LoopMode.one);
                    }

                    if(_counter==0&& state!='이상없음'){
                      //_stopSound();
                      _playSound();
                      addStateToGuestBook(state);

                      if(state!='턱끈연결'&&state!='턱끈해제') {
                        if(_events!=null) {
                          _events?.close();
                        }
                        _events = StreamController<int>();
                        _events?.add(60);
                        alertD(context, state);
                      }
                    }
                    print('------------- End of listenB('+state+') -------------');
                  });
                }
              }
            }
          }
        });
      }
    });
    print('end');
  }

  Timer? _timer;
  Timer? _timer_geo;
  Timer? _timer_bat;
  Timer? _timer_beltinit;


  void alertA(BuildContext context, String State, int time) async {
    print('alertA Context:'+ context.toString()+'State:'+State);
    isDialogAlive = true;
    var alert = await AlertDialog(
      //title: Center(child:Text('${State} 상황 발생', style: TextStyle(fontSize:30,fontWeight: FontWeight.bold, color: Colors.deepOrange),)),
      content:  StreamBuilder<int>(
          stream: _eventsA?.stream,
          builder: (context, snapshot) {
            print(snapshot.data.toString());
            // ignore: sized_box_for_whitespace
            return Container(
              height: 350,
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      color: Colors.white70,
                      child: SizedBox.expand(
                        child: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //SizedBox(height: 80,),
                              Container(
                                color: Colors.white54,
                                child: const Icon(
                                  Icons.health_and_safety, size: 100,
                                  color: Colors.deepPurple,),
                              ),
                              const Text("상황발생",
                                style: TextStyle(
                                  color: Colors.deepPurple,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 23,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 20,),
                              Text(State,
                                style: const TextStyle(
                                  color: Colors.deepOrange,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    (State == '연결해제') ?
                    "알람 소리를 해제하려면 \'해제\'버튼을 눌러주세요"
                        : (State == '상황해제') ?
                    "응급상황이 해제 되었습니다" :
                    "장치연결이 해제 되었습니다",
                    //Text("상황을 해제하려면 \'해제\'버튼을 눌러주세요\n \'해제\'하지 않으면 자동 승인됩니다",
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 13,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20,),
                  Text("- ${snapshot.data} -",
                    style: const TextStyle(
                      color: Colors.deepPurple,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }
          ),
      actions: <Widget>[
        Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children:<Widget>[
              Center(
                child: SizedBox(
                  width : 350,
                  // height: 50,
                  child:Padding(
                    padding: const EdgeInsets.only(left: 20,right: 20),
                    child: (State!='연결해제')?ElevatedButton(
                      child: const Text('확인'),
                      style: ElevatedButton.styleFrom(
                          primary: Colors.deepPurple,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                          textStyle: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                      onPressed:() {
                        _stopSound();
                        _counterA=0;
                        _timer?.cancel();
                        isDialogAlive =false;
                        Navigator.of(context, rootNavigator: true).pop(false);
                      },
                    ):Container(),
                  ),
                ),
              ),

              const SizedBox(height: 15,),
              /*TextButton(
                child: Text('승인',style: TextStyle(fontSize:18,color: Colors.deepPurple /*,fontWeight: FontWeight.bold*/)),
                onPressed: () {
                  double? latitude;
                  double? longitude;
                  player.stop;
                  _counter=0;
                  _timer?.cancel();
                  Navigator.of(context, rootNavigator: true).pop(false);
                },
              ),*/
            ]
        ),
      ],
    );

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (builderContext) {
          _counterA = time;
          _timer?.cancel();
          _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
            if(_counterA > 0) {
              _counterA--;
            }
            else {
              print('alertA TimeExpire:'+State);
              if(State!='상황해제') {
                addStateToGuestBook(State);
              }
              _counterA=0;
              _timer?.cancel();
              _stopSound();
              isDialogAlive =false;

              Navigator.of(context, rootNavigator: true).pop(false);
              //Navigator.of(builderContext).pop(true);
            }
            print(_counterA);
            _eventsA?.add(_counterA);

          });
          return alert;
        }
    );
  }

  void alertD(BuildContext context, String State) async {
    // ignore: avoid_print
    print('alertD Context:'+ context.toString()+'State:'+State);
    var alert = AlertDialog(
      //title: Center(child:Text('${State} 상황 발생', style: TextStyle(fontSize:30,fontWeight: FontWeight.bold, color: Colors.deepOrange),)),
      content:  StreamBuilder<int>(
        stream: _events?.stream,
        builder: (context, snapshot) {
        print(snapshot.data.toString());
        // ignore: sized_box_for_whitespace
        return Container(
          height: 350,
          child: Column(
            children: [
              Expanded(
                child: Container(
                  color: Colors.white70,
                  child: SizedBox.expand(
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //SizedBox(height: 80,),
                          Container(
                              color: Colors.white54,
                                child: const Icon(Icons.health_and_safety, size: 100, color: Colors.deepPurple,),
                              ),
                          const Text("상황발생",
                            style: TextStyle(
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.bold,
                              fontSize: 23,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20,),
                          Text(State,
                            style: const TextStyle(
                              color: Colors.deepOrange,
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              Text(
                (State=='위급상황')?"응급상황이 발생했습니까?"
                :"알람 소리를 해제하려면 \'중단\'버튼을 눌러주세요",
              //Text("상황을 해제하려면 \'해제\'버튼을 눌러주세요\n \'해제\'하지 않으면 자동 승인됩니다",
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 13,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20,),
              if (State=='위급해제') Text("- ${snapshot.data} -",
                  style: const TextStyle(
                    color: Colors.deepPurple,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ) else Container(),
            ],
          ),
        );
      }),

      actions: <Widget>[
        Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children:<Widget>[
              Center(
              child: SizedBox(
                width : 350,
               // height: 50,
                child:Padding(
                  padding: const EdgeInsets.only(left: 20,right: 20),
                  child:  /*(State=='위급상황')? */ElevatedButton(
                    child: (State=='위급상황')?const Text('아니오'):const Text('중단'),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.deepPurple,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                        textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    onPressed:() {
                      _counter=0;
                      _timer?.cancel();
                      _stopSound();
                      Navigator.of(context, rootNavigator: true).pop(false);//true로 앞에 있으면 닫아지고 뒤에 있으면 닫아지지 않음
                      if(State=='위급상황') {
                        addStateToGuestBook('상황해제');
                        addNewPopupU('상황해제', 60);
                      }
                      //Navigator.of(context).pop(true); //이걸로 하면 메인이 닫아짐.
                     },
                  )/*:Container()*/,
                ),
              ),
              ),

              const SizedBox(height: 15,),

              if(State=='위급상황')
              TextButton(
                child: const Text('네. 응급상황입니다',
                    style: TextStyle(
                        fontSize:18,
                        color: Colors.deepPurple,
                      /*fontWeight: FontWeight.bold*/),
                ),
                onPressed: () {
               //   player.stop;
               //   _counter=0;
                  _timer?.cancel();
               //   Navigator.of(context, rootNavigator: true).pop(false);
                },
              ),

            ]
        ),
      ],
    );

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (builderContext) {
          _counter = 60;
          _timer?.cancel();
          _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
            if(_counter > 0) {
              _counter--;
            }
            else {
              print('alertD TimeExpire:'+State);
              _counter=0;
              _timer?.cancel();
              _stopSound();
              Navigator.of(builderContext).pop(true);
            }
            print(_counter);
            _events?.add(_counter);
          });
          return alert;
        }
    );
  }
  //FlutterBlueApp
  double batteryPercent=0;
  bool isDissconnectbyMenu =false;
  int _currentIndex = 0;
  final List<Widget> _bodychildren = [Home(), First(), Profile()];
  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('작업장의 안전을 지키는 스마트 안전헬멧'),
        //title: const Text('안전과 건강을 지키는 \'휴비딕 헬스 시큐리티\''),
        actions: <Widget>[
          StreamBuilder<BluetoothDeviceState>(
            stream: bTdevice?.state,
            initialData: BluetoothDeviceState.disconnected,
            builder: (c, snapshot) {
              VoidCallback? _onPressed;
              String text;
              switch (snapshot.data) {

                case BluetoothDeviceState.connected:
                 /* _onPressed = () async {isDissconnectbyMenu=true; await bTdevice?.disconnect();};

                  //beltState = false;
                  print('beltStateScaffold:'+beltState.toString());
                  text = ' 연결끊기';*/
                  text = ' 연결됨';
                  break;
                case BluetoothDeviceState.disconnected:
                   _onPressed = () =>
                       Navigator.of(context).push(
                           MaterialPageRoute(
                               builder: (context) =>
                                   FindDevicesScreen())).then((value) =>
                           setState(() {})); //_startscan();
                   batteryPercent =0;
                   print(bTdevice?.name);
                   text = ' 연결하기';
                  break;
                default:
                  _onPressed = () =>
                       Navigator.of(context).push(MaterialPageRoute( builder: (context) =>
                           FindDevicesScreen())).then((value) => setState(() {}));
                  text = snapshot.data.toString().substring(21).toUpperCase();
                  break;
              }

              btstateMachine?.cancel();
              btstateMachine = bTdevice?.state.listen((event) async {
                if(event==BluetoothDeviceState.disconnected &&isConnected==true) {
                    print('-------- Bt State Disconnected --------');
                    writecharacteristic=0;
                    isConnected=false;
                    if(beltState) {
                      _stopSound();
                      _setAsset('assets/audio/alram1.mp3');
                      _setLoopMode(LoopMode.one);
                      _playSound();//player.play();
                      isHelmetDisconnected=true;
                      addNewPopupU("연결해제", 15);
                    }
                    else
                      beltState=false;
                  }
                else if(event==BluetoothDeviceState.connected &&isConnected==false){
                  print('-------- Bt State connected ---------');
                  if(isHelmetDisconnected)
                    {
                      _stopSound();
                      if(_counterA==0)
                        addStateToGuestBook('연결복귀');
                      //_counterA=0;
                      _timer?.cancel();
                      if(isDissconnectbyMenu ==false&&isDialogAlive==true) {
                        isDialogAlive=false;
                        Navigator.of(context, rootNavigator: true).pop(false);
                      }
                      isDissconnectbyMenu=false;
                    }
                  isHelmetDisconnected=false;
                  isConnected = true;
                  await connectMyProtocol( bTdevice);

                  _timer_beltinit?.cancel();
                  _timer_beltinit = Timer.periodic(Duration(milliseconds: 100), (timer) {
                  print('req belt => current beltstate:'+ beltState.toString());
                  if (beltState==false){
                      writecharacteristic.write(utf8.encode('belt status'));}
                  else{
                      _timer_beltinit?.cancel();}
                  });

                  _timer_bat?.cancel();
                  _timer_bat = Timer.periodic(Duration(milliseconds: 100), (timer) {
                      print('req batt');
                      writecharacteristic.write(utf8.encode('req bat'));
                  });

                }
                btState=event;
                print('---------- End of appBarState:listen ----------');

              });
              return ElevatedButton(
                  onPressed:_onPressed,
                    /*
                    () {
                     print('--------------');
                     print(bTdevice?.name);
                     _onPressed;
                  },*/
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Icon(Icons.battery_std, color: Colors.white),
                      Text(
                        batteryPercent.round().toString()+'%  ',
                        style: Theme.of(context)
                            .primaryTextTheme
                            .button
                            ?.copyWith(color: Colors.white,fontSize: 18),
                      ),
                        (text == ' 연결끊기')
                          ? Icon(Icons.bluetooth_connected_rounded, color: Colors.white)
                          : Icon(Icons.bluetooth_searching_outlined, color: Colors.white),
                      Text(
                        text,
                        style: Theme.of(context)
                            .primaryTextTheme
                            .button
                            ?.copyWith(color: Colors.white,fontSize: 18),
                      ),
                    ]
                  )
              );
            },
          )
        ],
      ),

      body: _bodychildren[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          onTap: _onTap,
          currentIndex: _currentIndex,
          items: [
            new BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('홈'),
            ),
            new BottomNavigationBarItem(
              icon: Icon(Icons.find_in_page),
              title: Text('기록보기'),
            ),
            new BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text('프로필'),
            )
          ]),

    );
  }
}

/*

      ListView(
        children: <Widget>[
           //Image.asset('assets/image/caring-nurse-and-the-girl-FPAX4FK.png'),

          const SizedBox(height: 8),
          IconAndDetail(Icons.calendar_today, DateFormat('yyyy년 MM월 dd일 HH시mm분').format(DateTime.now()).toString()),
          IconAndDetail(Icons.location_city, '서울시 구로구 A 작업지'),
          //IconAndDetail(Icons.location_city, '안양시 만안구 A병원'),

          // Add from here
          Consumer<ApplicationState>(
            builder: (context, appState, _) => Authentication(
              email: appState.email,
              loginState: appState.loginState,
              startLoginFlow: appState.startLoginFlow,
              verifyEmail: appState.verifyEmail,
              signInWithEmailAndPassword: appState.signInWithEmailAndPassword,
              cancelRegistration: appState.cancelRegistration,
              registerAccount: appState.registerAccount,
              signOut: appState.signOut,
            ),
          ),
          // to here

          Consumer<ApplicationState>(
            builder: (context, appState, _) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*
                // Add from here
                if (appState.attendees >= 2)
                  Paragraph('${appState.attendees} 명의 작업자가 공동작업 중에 있습니다')
                  //Paragraph('${appState.attendees} 명이 함께 헬스 시큐리티 관리 중에 있습니다')
                else if (appState.attendees == 1)지
                  //Paragraph('1 명이 함께 헬스 시큐리티 관리 중에 있습니다')
                else
                  Paragraph('작업자가 없습니다'),
                  //Paragraph('관리대상 없습니다'),
                // To here.

                 */
                const Divider(
                  height: 8,
                  thickness: 1,
                  indent: 8,
                  endIndent: 8,
                  color: Colors.grey,
                ),

                if (appState.loginState == ApplicationLoginState.loggedIn/*&&btState==BluetoothDeviceState.connected*/) ...[
                  /*
                  // Add from here
                  YesNoSelection(
                    state: appState.attending,
                    onSelection: (attending) => appState.attending = attending,
                  ),
                  // To here
                 */

                  heightSpace,
                  heightSpace,
                  Header('마지막 발생한 안전상황'),
                  GuestBook(
                    messages: appState.guestBookMessages, // new
                    addMessage: (String message) =>
                        appState.addMessageToGuestBook(message),
                  ),
                ],
                if (appState.loginState == ApplicationLoginState.loggedOut/*&&btState==BluetoothDeviceState.connected*/) ...[
                  /*
                  // Add from here
                  YesNoSelection(
                    state: appState.attending,
                    onSelection: (attending) => appState.attending = attending,
                  ),
                  // To here
                 */
                  heightSpace,
                  heightSpace,
                  Header('오늘의 안전수칙'),
                  Paragraph('말로하는 안전보다.실천하는 안전점검'),
                ],
              ],
            ),
          ),

          heightSpace,

          // To here.
        ],
      ),
* */

final beneficiariesList = [
  /*{
    'name': '모든사고',
    'image': 'assets/image/helmet.png',
  },*/
  {
    'name': '무활동반응',
    'image': 'assets/image/helmet.png',
  },
  {
    'name': '추락사고',
    'image': 'assets/image/helmet.png',
  },
  {
    'name': '충격사고',
    'image': 'assets/image/helmet.png',
  },
  {
    'name': '위급상황',
    'image': 'assets/image/helmet.png',
  },
  {
    'name': '상황해제',
    'image': 'assets/image/helmet.png',
  },
  {
    'name': '연결해제',
    'image': 'assets/image/helmet.png',
  },
  {
    'name': '연결복귀',
    'image': 'assets/image/helmet.png',
  },
  {
    'name': '턱끈연결',
    'image': 'assets/image/helmet.png',
  },
  {
    'name': '턱끈해제',
    'image': 'assets/image/helmet.png',
  },
  {
    'name': '그밖의긴급상황',
    'image': 'assets/image/helmet.png',
  },
];


class Beneficiaries extends StatefulWidget {
  @override
  _BeneficiariesState createState() => _BeneficiariesState();
}

class _BeneficiariesState extends State<Beneficiaries> {

  final historyBeneficiariesList = [
    {
      'name': 'Beatriz',
      'image': 'assets/user/user_11.jpg',
    },
    {
      'name': 'Shira',
      'image': 'assets/user/user_12.jpg',
    },
    {
      'name': 'Steve',
      'image': 'assets/user/user_8.jpg',
    },
    {
      'name': 'Mike',
      'image': 'assets/user/user_2.jpg',
    },
    {
      'name': 'Linnea',
      'image': 'assets/user/user_3.jpg',
    },
    {
      'name': 'John',
      'image': 'assets/user/user_1.jpg',
    },
  ];
  double? height;
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 1.0,
        centerTitle: true,
        title: const Text(
          'Beneficiaries',
          //style: black18BoldTextStyle,
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: blackColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          addNewBeneficiaryButton(),
          benificiariesText(),
          userBeneficiaries(),
          historyText(),
          historyBeneficiaries(),
        ],
      ),
    );
  }

  Widget historyBeneficiaries() {
    return Container(
      // height: height / 3.7,
      margin: EdgeInsets.only(
        top: fixPadding + 5.0,
        bottom: fixPadding + 5.0,
      ),
      child: GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 1.0,
        padding: const EdgeInsets.all(4.0),
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
        shrinkWrap: true,
        primary: true,
        physics: NeverScrollableScrollPhysics(),
        children: historyBeneficiariesList.map(
              (item) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                onTap: () {
              Navigator.pop(context);
            },/* Navigator.push(
                    context,
                    PageTransition(
                      duration: Duration(milliseconds: 500),
                      type: PageTransitionType.rightToLeft,
                      child: BeneficiaryMoneyTransfer(
                        userPhoto: item['image'],
                        name: item['name'],
                      ),
                    ),
                  ),*/
                  child: Column(
                    children: [
                      Text(
                        item['name']!,
                        //style: black14MediumTextStyle,
                      ),
                      SizedBox(height: 10.0),
                      Container(
                        height: 70.0,
                        width: 70.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage(item['image']!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ).toList(),
      ),
    );
  }

  Widget historyText() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: fixPadding * 2.0,
      ),
      child: Row(
        children: [
          Icon(
            Icons.history,
            size: 20.0,
            color: blackColor,
          ),
          widthSpace,
          const Text(
            'History',
           // style: black16BoldTextStyle,
          ),
        ],
      ),
    );
  }

  Widget addNewBeneficiaryButton() {
    return InkWell(
        onTap: () {
          Navigator.pop(context);
        },
     /* onTap: () => Navigator.push(
        context,
        PageTransition(
          duration: Duration(milliseconds: 500),
          type: PageTransitionType.rightToLeft,
          child: AddNewBeneficiary(),
        ),
      ),*/
      child: Container(
        child: Container(
          margin: EdgeInsets.all(fixPadding * 2.0),
          padding: EdgeInsets.symmetric(vertical: fixPadding),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: const Text(
            'Add new beneficiary',
            //style: white16BoldTextStyle,
          ),
        ),
      ),
    );
  }

  Widget benificiariesText() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: fixPadding * 2.0,
      ),
      child: const Text(
        'Your beneficiaries',
       // style: black16BoldTextStyle,
      ),
    );
  }

  Widget userBeneficiaries() {
    return Container(
      margin: EdgeInsets.only(
        top: fixPadding + 5.0,
        bottom: fixPadding + 5.0,
      ),
      child: GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 1.0,
        padding: const EdgeInsets.all(4.0),
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
        shrinkWrap: true,
        primary: true,
        physics: NeverScrollableScrollPhysics(),
        children: beneficiariesList.map(
              (item) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  /*
                  onTap: () => Navigator.push(
                    context,
                    PageTransition(
                      duration: Duration(milliseconds: 500),
                      type: PageTransitionType.rightToLeft,
                      child: BeneficiaryMoneyTransfer(
                        userPhoto: item['image'],
                        name: item['name'],
                      ),
                    ),
                  ),*/
                  child: Column(
                    children: [
                      Text(
                        item['name']!,
                        //style: black14MediumTextStyle,
                      ),
                      SizedBox(height: 10.0),
                      Container(
                        height: 70.0,
                        width: 70.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage(item['image']!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ).toList(),
      ),
    );
  }
}