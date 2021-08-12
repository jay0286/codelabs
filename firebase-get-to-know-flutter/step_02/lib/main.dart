
//구글파이어스토어 로그
import 'dart:async';                                    // new
import 'dart:convert';
import 'dart:math';
//import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';  // new
import 'package:firebase_auth/firebase_auth.dart'; // new
import 'package:firebase_core/firebase_core.dart'; // new
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
//DeviceOrientation 관련 서비스
import 'package:flutter/services.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';
import 'package:latlng/latlng.dart';
import 'package:map/map.dart';
import 'package:provider/provider.dart';           // new
import 'package:simple_logger/simple_logger.dart';

import '/constant/constant.dart';
import '/pages/splashScreen.dart';
import 'src/authentication.dart';                  // new
import 'src/widgets.dart';
import 'widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restart_app/restart_app.dart';


final logger = SimpleLogger();


List<AccidentMessage> get iaLogMessages => _iaLogMessages;
List<AccidentMessage> _iaLogMessages = [];
List<AccidentMessage> get ffLogMessages => _ffLogMessages;
List<AccidentMessage> _ffLogMessages = [];
List<AccidentMessage> get imLogMessages => _imLogMessages;
List<AccidentMessage> _imLogMessages = [];
List<AccidentMessage> get emLogMessages => _emLogMessages;
List<AccidentMessage> _emLogMessages = [];
List<AccidentMessage> get uemLogMessages => _uemLogMessages;
List<AccidentMessage> _uemLogMessages = [];
List<AccidentMessage> get ucnLogMessages => _ucnLogMessages;
List<AccidentMessage> _ucnLogMessages = [];
List<AccidentMessage> get rcnLogMessages => _rcnLogMessages;
List<AccidentMessage> _rcnLogMessages = [];
List<AccidentMessage> get beltLogMessages => _beltLogMessages;
List<AccidentMessage> _beltLogMessages = [];
List<AccidentMessage> get ubeltLogMessages => _ubeltLogMessages;
List<AccidentMessage> _ubeltLogMessages = [];
List<AccidentMessage> get etcLogMessages => _etcLogMessages;
List<AccidentMessage> _etcLogMessages = [];

BluetoothDeviceState? btState =BluetoothDeviceState.disconnected;


class Profile extends StatelessWidget {
  @override

  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

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
                          padding: const EdgeInsets.all(10.0),
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
              //jay Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: EditProfile()));
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
                            displayName,
                            style: headingStyle,
                          ),
                          heightSpace,
                          Text(
                            displayEmail,
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
              // ignore: prefer_const_literals_to_create_immutables
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
//jayNavigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: Notifications()));
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
              // ignore: prefer_const_literals_to_create_immutables
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

String displayName = '무명';
String displayEmail = '없음';
String? displayPhoneNumber = '없음';
String workZone = '없음';
String role = '없음';
String iuserId = '없음';

DateTime? timeToWorkStart ;

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
                    .asyncMap((_) async => FlutterBlue.instance.connectedDevices),
                // ignore: prefer_const_literals_to_create_immutables
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
                          // ignore: deprecated_member_use
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
                // ignore: prefer_const_literals_to_create_immutables
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
                  AccidentList(
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
                     weekCount: 0,
                    isName:true,
                    isPosition:true,
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
              // ignore: deprecated_member_use
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
                        icon: const Icon(Icons.refresh),
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
                title: const Text('MTU Size'),
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
                child: const Text('YES'),
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
  logger.warning('_playSound');
  player.play();
}

void _stopSound() {
  // ignore: avoid_print
  logger.warning('_stopSound');
  player.stop();
}
void _setAsset(String str) {
  // ignore: avoid_print
  logger.warning('_setAsset');
  player.setAsset(str);
}

void _setLoopMode(LoopMode mode) {
  // ignore: avoid_print
  logger.warning('_setLoopMode');
  player.setLoopMode(mode);
}



void setMylocation(String uid, GeoPoint location) {

  final userDoc =  FirebaseFirestore.instance
      .collection('user')
      .doc(uid);
  userDoc.update({'geopoint': location});
}





Future<DocumentReference> addStateToGuestBook(String message) {
  message = message;

  // ignore: avoid_print
  logger.warning('addStateToGuestBook $geolatitude, $geolongitude');
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
  initializeDateFormatting('ko_kr', null);
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(MyApp2());
  });
}

class MyApp2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(360, 690),
      builder: () => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Smart Helmet',
        theme: ThemeData(
          primarySwatch: Colors.red,
          primaryColor: primaryColor,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        builder: (context, widget) {
          return MediaQuery(
            ///Setting font does not change with system font size
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: widget!,
          );
        },
        home: SplashScreen(),
        navigatorKey: navigatorKey,
      ),
    );
  }
}



// ^^^&&&&$%&%&%#%$*#$%*


class WorkerBookMessage {
  WorkerBookMessage({required this.name, required this.message, required this.date, required this.time,required this.location, required this.timestamp});
  final String name;
  final String message;
  final String date;
  final String time;
  final String location;
  final DateTime timestamp ;
}

class WorkerList extends StatefulWidget {
  const WorkerList({ required this.messages, required this.weekCount});
  final List<WorkerListMessage> messages; // new
  final int? weekCount;
  @override
  _WorkerListState createState() => _WorkerListState();
}

class _WorkerListState extends State<WorkerList> {

  @override
  Widget build(BuildContext context) {
    return  Container(
      margin:  EdgeInsets.all(fixPadding * 0.5),
      //padding: const EdgeInsets.symmetric(vertical: 10),
      //alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: scaffoldBgColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: widget.messages.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          final WorkerListMessage item = widget.messages[index];
            return Container(
              margin:  EdgeInsets.all(fixPadding * 0.2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ListTile(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) =>
                          WorkerDetailPage(
                              latitude: geolatitude/*37.4836*/,
                              longitude: geolongitude/*126.8954*/,
                              uid: item.uid,
                              state: '상태')));
                },
                leading: CircleAvatar(
                  backgroundColor: Colors.green,
                  radius: 22,
                  child: Text(item.name[0],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24.0,
                      )
                  ),
                ),
                title: Text(item.name,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    )),
                subtitle:Text('01012345678',
                    style: const TextStyle(
                      //color: Colors.black,
                      fontSize: 10,
                    )),
                trailing:SizedBox(
                  width: 120,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(3.0),//or 15.0
                        child: Container(
                          height: 25.0,
                          width: 35.0,
                          color: Colors.deepPurple,
                          alignment: Alignment.center,
                          child: Text('3:32',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10.0,
                              )),
                        ),
                      ),
                      SizedBox(width:5),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(3.0),//or 15.0
                        child: Container(
                          height: 25.0,
                          width: 35.0,
                          color: Colors.deepPurple,
                          alignment: Alignment.center,
                          child: Text('착용중',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 8.0,
                              )),
                        ),
                      ),
                      SizedBox(width:5),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(3.0),//or 15.0
                        child: Container(
                          height: 25.0,
                          width: 35.0,
                          color: Colors.deepPurple,
                          alignment: Alignment.center,
                          child: Text('3회',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 8.0,
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
        },
      ),
    );
  }
}

class WorkerListMessage {
  WorkerListMessage({
    required this.name,
    required this.uid,
    required this.workzone,
    required this.role,
    required this.belt,
    required this.worktime,
    required this.location,
    required this.accident
  });
  final String name;
  final String uid;
  final String workzone;
  final String role;
  final bool belt;
  final DateTime worktime;
  final GeoPoint location;
  final int accident;
}

class AccidentMessage {
  AccidentMessage({required this.uid, required this.name, required this.message, required this.date, required this.time,required this.location, required this.timestamp});
  final String uid;
  final String name;
  final String message;
  final String date;
  final String time;
  final String location;
  final DateTime timestamp ;
}

class AccidentList extends StatefulWidget {
  const AccidentList({ required this.messages, required this.weekCount, required this.isName, required this.isPosition});
  final List<AccidentMessage> messages; // new
  final int? weekCount;
  final bool? isName;
  final bool? isPosition;

  @override
  _AccidentListState createState() => _AccidentListState();
}

class _AccidentListState extends State<AccidentList> {
  @override
  Widget build(BuildContext context) {
    return  Container(
      height : 180,
      margin:  EdgeInsets.only(left:fixPadding * 0.5,right:fixPadding * 0.5),
      padding: const EdgeInsets.symmetric(vertical: 0),
      //alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6.0),
        /*boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 0,
                                blurRadius: 5,
                                offset: Offset(0,2),
                              ),
                            ],*/
      ),
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: widget.messages.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          final AccidentMessage item = widget.messages[index];
          //DateTime? today = item.timestamp;
          if( timeToWorkStart!.isAfter(item.timestamp)&&widget.weekCount!>0) {
            return Container(); //jaytodo
          } else {
            return Consumer<ApplicationState>(
              builder: (context, appState, _) {
                if(item.message=='지도노티'||item.message=='턱끈연결'||item.message=='턱끈해제' ||(role!='manager')&&(item.message=='연결해제'||item.message=='연결복귀')) //jay todo 210812: 좀더 최적화 해야 하지 않을까?
                  return Container();
                else
                  return InkWell(
                    child: accidentDetail(
                        item.date, item.time, (widget.isName==true)?item.name:item.message,  (widget.isPosition==true)?item.location :item.message, Colors.black
                    ),
                    onTap: () {
                      List<String> strLocation;
                      strLocation= item.location.split(', ');
                      LatLng positiona;
                      positiona = LatLng(double.parse(strLocation[0]),double.parse(strLocation[1])) ;
                      appState.setpositionA(positiona);

  /*
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) =>
                              WorkerDetailPage(latitude: 37.4219983,
                                  longitude: -122.084,
                                  name: 'tt',
                                  state: '상태')));
   */

                    }
                );
              }
            );
          }
        },
      ),
    );
  }
}



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
                              logger.warning(item.location);
                              logger.warning(double.parse(strLocation[0]));
                              logger.warning(double.parse(strLocation[1]));
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
                                        '  사고위치 ('+item.location+')',

                                        //maxLines: 1,
                                        //overflow: TextOverflow.ellipsis,
                                        //style: buttonBlackTextStyle,
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
            const SizedBox(width: 8),
            StyledButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                    /*await*/ widget.addMessage(_controller.text);
                    _controller.clear();
                }
              },
              child: Row(
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  const Icon(Icons.send),
                  const SizedBox(width: 4),
                  const Text('기록 남기기'),
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



bool _attendeesFirst = false;
bool get  attendeesFirst=> _attendeesFirst;


int _attendees = 0;
int get attendees => _attendees;


int _attendeesim = 0;
int get attendeesim => _attendeesim;


int _attendeesem = 0;
int get attendeesem => _attendeesem;

int _attendeesemrels = 0;
int get attendeesemrels => _attendeesemrels;

int _attendeesmap = 0;
int get attendeesmap => _attendeesmap;


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
int get  attendeesia=> _attendeesia;

int _attendeesetc = 0;
int get attendeesetc => _attendeesetc;


int _attendeesall = 0;
int get attendeesall => _attendeesall;



int _attendeesworker = 0;
int get attendeesworker => _attendeesworker;


class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  Timer? _timer;
  StreamController<int>? _eventsA;
  int _counterA = 0;

  // ignore: avoid_void_async, non_constant_identifier_names
  void alertManager(BuildContext context,String name, var formattedDate, String State, int time) async {
    isDialogAlive = true;
    var alert = AlertDialog(
      //title: Center(child:Text('${State} 상황 발생', style: TextStyle(fontSize:30,fontWeight: FontWeight.bold, color: Colors.deepOrange),)),
      content:  StreamBuilder<int>(
          stream: _eventsA?.stream,
          builder: (context, snapshot) {
            // ignore: avoid_print
            logger.warning(snapshot.data.toString());
            // ignore: sized_box_for_whitespace
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
                    // ignore: unnecessary_string_escapes
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
                    //child: (State!='연결해제'||(logEmail=='jay@tinkerbox.kr'||logEmail=='uzbrainnet@gmail.com'))?ElevatedButton(
                    child: (State!='연결해제'||role=='manager')?ElevatedButton(
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
            // ignore: avoid_print
            logger.warning(_counterA);
            _eventsA?.add(_counterA);
          });
          return alert;
        }
    );
  }

  void addNPopupManager(String name, var formattedDate,String state, int time)  {
    logger.warning('addNewPopup time:'+time.toString()+', State:'+ state);
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
  StreamSubscription<QuerySnapshot>? listenMap;
  StreamSubscription<QuerySnapshot>? listenUCn;
  StreamSubscription<QuerySnapshot>? listenRCn;
  StreamSubscription<QuerySnapshot>? listenBelt;
  StreamSubscription<QuerySnapshot>? listenUBelt;
  StreamSubscription<QuerySnapshot>? listenEtc;
  StreamSubscription<QuerySnapshot>? listenWorker;

  Future<void> init() async {
    await Firebase.initializeApp();

    listenUser?.cancel();
    listenUser= FirebaseAuth.instance.userChanges().distinct((p, n) => p?.uid == n?.uid).listen((user) async {
      logger.warning('FireStore[FirebaseAuth] -------- userChanges()');
      if (user != null) {
        displayPhoneNumber = user.phoneNumber;
        displayName = user.displayName!;
        displayEmail = user.email!;
        iuserId = user.uid;
        logger.warning(user.email);
        logger.warning(user.displayName);
        logger.warning(user.phoneNumber);
        timeToWorkStart = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
        //print(timeToWorkStart);
        logState = true;
        _loginState = ApplicationLoginState.loggedIn;

        await FirebaseFirestore.instance
            .collection('user')
            .where('uid',isEqualTo:user.uid) //jay user
            .get().then((value){
              workZone = (value.docs[0].data()['workZone']!=null)?value.docs[0].data()['workZone']:'기본';
              role = (value.docs[0].data()['role']!=null)?value.docs[0].data()['role']:'worker' ;
            });

        if(role=='manager') {
        //if(logEmail=='jay@tinkerbox.kr'||logEmail=='uzbrainnet@gmail.com') {
/*
            await FirebaseFirestore.instance
                .collection("guestbook")
                .where("text",whereIn: ['위급상황','상황해제','턱끈연결','턱끈해제'])
                .get().then((value){
                  value.docs.forEach((element) async {
                    logger.warning(element.data()['text']);
                     //sleep(Duration(seconds: 1));
                     await FirebaseFirestore.instance.collection("guestbook").doc(element.id).delete().then((value){
                       logger.warning('deleted');
                  });
              });
            });
*/
          listenWorker?.cancel();
          listenWorker = FirebaseFirestore.instance
              .collection('user')
              .snapshots()
              .listen((snapshot) {
            _workerLogMessages = [];
            _attendeesworker = snapshot.docs.length;
            logger.warning('FireStore[read] -------- worker list:' + _attendeesworker.toString());
            snapshot.docs.forEach((document) {

              logger.warning(document.data()['name'].toString());
              _workerLogMessages.add(
                WorkerListMessage(
                    name: document.data()['name'],
                    uid: document.data()['uid'],
                    workzone: (document.data()['workzone']==null)?'none':document.data()['workzone'],
                    role: (document.data()['role']==null)?'none':document.data()['role'],
                    belt: (document.data()['belt']==null)?false:document.data()['belt'],
                    worktime: (document.data()['worktime']==null)?0:document.data()['worktime'],
                    location: (document.data()['location']==null)?'none':document.data()['location'],
                    accident: (document.data()['accident']==null)?'none':document.data()['accident']
                ),
              );
            });
            notifyListeners();
          });

          await FirebaseFirestore.instance
              .collection('guestbook')
              .orderBy('timestamp', descending: true)
              .get().then((value){
                logger.warning('FireStore[read] -------- 모든 데이터');
                _accidentMessages = [];
                value.docs.forEach((document) {
                  DateTime date = DateTime.fromMillisecondsSinceEpoch(document.data()['timestamp']);
                  String formattedDate = DateFormat('MM월dd일').format(date);
                  String formattedTime = DateFormat('HH시mm분').format(date);
                  _accidentMessages.add(
                    AccidentMessage(
                      uid: document.data()['userId'],
                      name: document.data()['name'],
                      time:formattedTime,
                      message: document.data()['text'],
                      date: formattedDate,
                      location: document.data()['latitude'].toString() + ', ' +
                          document.data()['longitude'].toString(),
                      timestamp: date,
                    ),
                  );
                });

                _iaLogMessages =[];
                _iaLogMessages =
                    _accidentMessages.where((element) => element.message.startsWith('무활동반응')).toList();
                _attendeesia = _iaLogMessages.length;
                print('무활동반응 num:'+_attendeesia.toString());

                _ffLogMessages =[];
                _ffLogMessages =
                    _accidentMessages.where((element) => element.message.startsWith('추락사고')).toList();
                _attendeesff = _ffLogMessages.length;
                print('추락사고 num:'+_attendeesff.toString());

                _imLogMessages =[];
                _imLogMessages =
                    _accidentMessages.where((element) => element.message.startsWith('충격사고')).toList();
                _attendeesim = _imLogMessages.length;
                print('충격사고 num:'+_attendeesim.toString());

                _emLogMessages =[];
                _emLogMessages =
                    _accidentMessages.where((element) => element.message.startsWith('위급상황')).toList();
                _attendeesem = _emLogMessages.length;
                print('위급상황 num:'+_attendeesem.toString());

                _uemLogMessages =[];
                _uemLogMessages =
                    _accidentMessages.where((element) => element.message.startsWith('상황해제')).toList();
                _attendeesemrels = _uemLogMessages.length;
                print('상황해제 num:'+_attendeesemrels.toString());

/*
                _uemLogMessages =[];
                _uemLogMessages =
                    _accidentMessages.where((element) => element.message.startsWith('지도노티')).toList();
                _attendeesmap = _uemLogMessages.length;
                print('num:'+_attendeesmap.toString());
*/

              _ucnLogMessages =[];
              _ucnLogMessages =
                  _accidentMessages.where((element) => element.message.startsWith('연결해제')).toList();
              _attendeesoffline = _ucnLogMessages.length;
              print('연결해제 num:'+_attendeesoffline.toString());

              _rcnLogMessages =[];
              _rcnLogMessages =
                  _accidentMessages.where((element) => element.message.startsWith('연결복귀')).toList();
              _attendeesRecorvline = _rcnLogMessages.length;
              print('해제복귀 num:'+_attendeesRecorvline.toString());


              _beltLogMessages =[];
              _beltLogMessages =
                  _accidentMessages.where((element) => element.message.startsWith('턱끈연결')).toList();
              _attendeesbelt = _beltLogMessages.length;
              print('턱끈연결 num:'+_attendeesbelt.toString());


              _ubeltLogMessages =[];
              _ubeltLogMessages =
                  _accidentMessages.where((element) => element.message.startsWith('턱끈해제')).toList();
              _attendeesDissbelt = _ubeltLogMessages.length;
              print('턱끈해제 num:'+_attendeesDissbelt.toString());


              _etcLogMessages =[];
              _etcLogMessages =
                  _accidentMessages.where((element) => element.message.startsWith('김타등등')).toList();
              _attendeesetc = _etcLogMessages.length;
              print('기타등등 num:'+_attendeesetc.toString());

              notifyListeners();
              });

          _guestBookSubscription?.cancel();
          _guestBookSubscription = FirebaseFirestore.instance
              .collection('guestbook')
              .orderBy('timestamp', descending: true)
              .limit(1)
              .snapshots()
              .listen((snapshot) {
                if(attendeesFirst==true) {
                  DateTime date = DateTime.fromMillisecondsSinceEpoch(
                      snapshot.docs[0].data()['timestamp']);
                  String formattedDate = DateFormat('MM월dd일').format(date);
                  String formattedTime = DateFormat('HH시mm분').format(date);
                  String uid = snapshot.docs[0].data()['userId'];
                  String name = snapshot.docs[0].data()['name'];
                  String message = snapshot.docs[0].data()['text'];
                  String location = snapshot.docs[0].data()['latitude'].toString() +
                      ', ' +
                      snapshot.docs[0].data()['longitude'].toString();
                  logger.warning('FireStore[listen all] -------- [' +
                      snapshot.docs.length.toString() + '] ' + name + ': ' + message);

                  AccidentMessage thisTime = AccidentMessage(
                    uid: uid,
                    name: name,
                    time: formattedTime,
                    date: formattedDate,
                    message: message,
                    location: location,
                    timestamp: date,
                  );

                  _accidentMessages.insert(
                    0,
                    thisTime,
                  );
                  logger.warning('acc' + _accidentMessages.length.toString());
                  if (message == '무활동반응') {
                    _iaLogMessages.insert(
                      0,
                      thisTime,
                    );
                    _attendeesia++;
                    if (thisTime.timestamp.add(Duration(minutes: 5)).isAfter(
                        DateTime.now())) {
                      _stopSound();
                      _setAsset('assets/audio/alram1.mp3');
                      _setLoopMode(LoopMode.one);
                      _playSound();
                      addNPopupManager(
                          thisTime.name, formattedDate + formattedTime,
                          '무활동반응', 300);
                    }
                  } else if (message == '추락사고') {
                    _ffLogMessages.insert(
                      0,
                      thisTime,
                    );
                    if (thisTime.timestamp.add(Duration(minutes: 5)).isAfter(
                        DateTime.now())) {
                      _stopSound();
                      _setAsset('assets/audio/alram1.mp3');
                      _setLoopMode(LoopMode.one);
                      _playSound();
                      addNPopupManager(
                          thisTime.name, formattedDate + formattedTime,
                          '추락사고', 300);
                    }
                  } else if (message == '충격사고') {
                    _imLogMessages.insert(
                      0,
                      thisTime,
                    );
                    if (thisTime.timestamp.add(Duration(minutes: 5)).isAfter(
                        DateTime.now())) {
                      _stopSound();
                      _setAsset('assets/audio/alram1.mp3');
                      _setLoopMode(LoopMode.one);
                      _playSound();
                      addNPopupManager(
                          thisTime.name, formattedDate + formattedTime,
                          '충격사고', 300);
                    }
                  } else if (message == '위급상황') {
                    _emLogMessages.insert(
                      0,
                      thisTime,
                    );
                    if (thisTime.timestamp.add(Duration(minutes: 5)).isAfter(
                        DateTime.now())) {
                      _stopSound();
                      _setAsset('assets/audio/alram1.mp3');
                      _setLoopMode(LoopMode.one);
                      _playSound();
                      addNPopupManager(
                          thisTime.name, formattedDate + formattedTime,
                          '위급상황', 300);
                    }
                  } else if (message == '상황해제') {
                    _uemLogMessages.insert(
                      0,
                      thisTime,
                    );
                    if (thisTime.timestamp.add(Duration(minutes: 5)).isAfter(
                        DateTime.now())) {
                      _stopSound();
                      _setAsset('assets/audio/alram1.mp3');
                      _setLoopMode(LoopMode.one);
                      _playSound();
                      addNPopupManager(
                          thisTime.name, formattedDate + formattedTime,
                          '상황해제', 300);
                    }
                  } else if (message == '지도노티') {
                    FirebaseFirestore.instance.collection("guestbook").doc(snapshot.docs[0].id).delete().then((value){
                      logger.warning("지도노티 delete Success!");
                    });
                    List<String> strLocation;
                    strLocation = location.split(', ');
                    Navigator.push(navigatorKey.currentContext!, MaterialPageRoute(
                        builder: (context) =>
                            Second(latitude: double.parse(strLocation[0]), longitude: double.parse(strLocation[1]))));
                  } else if (message == '연결해제') {
                    _ucnLogMessages.insert(
                      0,
                      thisTime,
                    );
                    if (thisTime.timestamp.add(Duration(minutes: 5)).isAfter(
                        DateTime.now())) {
                      _stopSound();
                      _setAsset('assets/audio/alram1.mp3');
                      _setLoopMode(LoopMode.one);
                      _playSound();
                      addNPopupManager(
                          thisTime.name, formattedDate + formattedTime,
                          '연결해제', 300);
                    }
                  } else if (message == '연결복귀') {
                    _rcnLogMessages.insert(
                      0,
                      thisTime,
                    );
                    if (thisTime.timestamp.add(Duration(minutes: 5)).isAfter(
                        DateTime.now())) {
                      _stopSound();
                      _setAsset('assets/audio/alram1.mp3');
                      _setLoopMode(LoopMode.one);
                      _playSound();
                      addNPopupManager(
                          thisTime.name, formattedDate + formattedTime,
                          '연결복귀', 300);
                    }
                  } else if (message == '턱끈연결') {
                    _beltLogMessages.insert(
                      0,
                      thisTime,
                    );
                    _attendeesbelt++;
                  } else if (message == '턱끈해제') {
                    _ubeltLogMessages.insert(
                      0,
                      thisTime,
                    );
                    _attendeesDissbelt++;
                  }
                  notifyListeners();
                } else {
                  _attendeesFirst = true;
                }
              });

/*

          _attendeesia=0;
          listenIa?.cancel();
          listenIa = FirebaseFirestore.instance
              .collection('guestbook')
              .where('text',isEqualTo:'무활동반응') //jay user
              .orderBy("timestamp", descending: true)
              .snapshots()
              .listen((snapshot) {
                _iaLogMessages = [];
                int lastone=0;
                snapshot.docs.forEach((document) {
                  DateTime date = DateTime.fromMillisecondsSinceEpoch(document.data()['timestamp']);
                  String formattedDate = DateFormat('MM월dd일').format(date);
                  String formattedTime = DateFormat('HH시mm분').format(date);
                  if(lastone==0) {
                    lastone=1;
                    logger.warning('FireStore[read] -------- 무활동반응');
                    logger.warning(snapshot.docs.length);
                    if(_attendeesia>0) {
                      logger.warning('stored:'+document.data()['timestamp']);
                      logger.warning('now: $DateTime.now().millisecondsSinceEpoch');
                      _stopSound();
                      _setAsset('assets/audio/alram1.mp3');
                      _setLoopMode(LoopMode.one);
                      _playSound();
                      addNPopupManager(document.data()['name'],formattedDate+formattedTime,'무활동반응',300);
                    }
                    _attendeesia = snapshot.docs.length;
                  }

                  _iaLogMessages.add(
                    AccidentMessage(
                      uid: document.data()['userId'],
                      name: document.data()['name'],
                      time:formattedTime,
                      message: document.data()['text'],
                      date: formattedDate,
                      location: document.data()['latitude'].toString() + ', ' +
                          document.data()['longitude'].toString(),
                      timestamp: date,
                    ),
                  );
                });
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
                  _ffLogMessages = [];
                  int lastone=0;
                  snapshot.docs.forEach((document) {
                    DateTime date = DateTime.fromMillisecondsSinceEpoch(document.data()['timestamp']);
                    String formattedDate = DateFormat('MM월dd일').format(date);
                    String formattedTime = DateFormat('HH시mm분').format(date);
                    if(lastone==0) {
                      lastone=1;
                      logger.warning('FireStore[read] -------- 추락사고');
                      logger.warning(snapshot.docs.length);
                      if(_attendeesff>0 &&document.data()['timestamp']+60000>DateTime.now().millisecondsSinceEpoch) {
                        _stopSound();
                        _setAsset('assets/audio/alram1.mp3');
                        _setLoopMode(LoopMode.one);
                        _playSound();
                        addNPopupManager(document.data()['name'],formattedDate+formattedTime,'추락사고',300);
                      }
                      _attendeesff = snapshot.docs.length;
                    }
                    _ffLogMessages.add(
                      AccidentMessage(
                        uid: document.data()['userId'],
                        name: document.data()['name'],
                        time:formattedTime,
                        message: document.data()['text'],
                        date: formattedDate,
                        location: document.data()['latitude'].toString() + ', ' +
                            document.data()['longitude'].toString(),
                        timestamp: date,
                      ),
                    );
                  });
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
                  _imLogMessages = [];
                  int lastone=0;
                  snapshot.docs.forEach((document) {
                    DateTime date = DateTime.fromMillisecondsSinceEpoch(document.data()['timestamp']);
                    String formattedDate = DateFormat('MM월dd일').format(date);
                    String formattedTime = DateFormat('HH시mm분').format(date);
                    if(lastone==0) {
                      lastone=1;
                      logger.warning('FireStore[read] -------- 충격사고');
                      logger.warning(snapshot.docs.length);
                      if(_attendeesim>0 &&document.data()['timestamp']+60000>DateTime.now().millisecondsSinceEpoch) {
                        _stopSound();
                        _setAsset('assets/audio/alram1.mp3');
                        _setLoopMode(LoopMode.one);
                        _playSound();
                        addNPopupManager(document.data()['name'],formattedDate+formattedTime,'충격사고',300);
                      }
                      _attendeesim = snapshot.docs.length;
                    }
                    _imLogMessages.add(
                      AccidentMessage(
                        uid: document.data()['userId'],
                        name: document.data()['name'],
                        time:formattedTime,
                        message: document.data()['text'],
                        date: formattedDate,
                        location: document.data()['latitude'].toString() + ', ' +
                            document.data()['longitude'].toString(),
                        timestamp: date,
                      ),
                    );
                  });
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
                  logger.warning('FireStore[read] -------- 위급상황');
                  logger.warning(snapshot.docs.length);
                  _emLogMessages = [];
                  int lastone=0;
                  snapshot.docs.forEach((document) {
                    DateTime date = DateTime.fromMillisecondsSinceEpoch(document.data()['timestamp']);
                    String formattedDate = DateFormat('MM월dd일').format(date);
                    String formattedTime = DateFormat('HH시mm분').format(date);
                    if(lastone==0) {
                      lastone=1;
                      if(_attendeesem>0 &&document.data()['timestamp']+60000>DateTime.now().millisecondsSinceEpoch ) {
                        _stopSound();
                        _setAsset('assets/audio/alram1.mp3');
                        _setLoopMode(LoopMode.one);
                        _playSound();
                        addNPopupManager(document.data()['name'],formattedDate+formattedTime,'위급상황',300);
                      }
                      _attendeesem = snapshot.docs.length;
                    }
                    _emLogMessages.add(
                      AccidentMessage(
                        uid: document.data()['userId'],
                        name: document.data()['name'],
                        time:formattedTime,
                        message: document.data()['text'],
                        date: formattedDate,
                        location: document.data()['latitude'].toString() + ', ' +
                            document.data()['longitude'].toString(),
                        timestamp: date,
                      ),
                    );
                  });
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
              logger.warning('FireStore[read] -------- 상황해제');
                  logger.warning(snapshot.docs.length);
                  _uemLogMessages = [];
                  int lastone=0;
                  snapshot.docs.forEach((document) {
                    DateTime date = DateTime.fromMillisecondsSinceEpoch(document.data()['timestamp']);
                    String formattedDate = DateFormat('MM월dd일').format(date);
                    String formattedTime = DateFormat('HH시mm분').format(date);
                    if(lastone==0) {
                      lastone=1;
                      if(_attendeesemrels>0 &&document.data()['timestamp']+60000>DateTime.now().millisecondsSinceEpoch) {
                        _stopSound();
                        _setAsset('assets/audio/relEvent.mp3');
                        _setLoopMode(LoopMode.off);
                        _playSound();
                        addNPopupManager(document.data()['name'],formattedDate+formattedTime,'상황해제',300);
                      }
                      _attendeesemrels = snapshot.docs.length;
                    }
                    _uemLogMessages.add(
                      AccidentMessage(
                        uid: document.data()['userId'],
                        name: document.data()['name'],
                        time:formattedTime,
                        message: document.data()['text'],
                        date: formattedDate,
                        location: document.data()['latitude'].toString() + ', ' +
                            document.data()['longitude'].toString(),
                        timestamp: date,
                      ),
                    );
                  });
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
                  logger.warning('FireStore[read] -------- 위급상황');
                  logger.warning(snapshot.docs.length);
                  _emLogMessages = [];
                  int lastone=0;

                  snapshot.docs.forEach((document) {
                    DateTime date = DateTime.fromMillisecondsSinceEpoch(document.data()['timestamp']);
                    String formattedDate = DateFormat('MM월dd일').format(date);
                    String formattedTime = DateFormat('HH시mm분').format(date);
                    if(lastone==0) {
                      lastone=1;
                      if(_attendeesem>0 &&document.data()['timestamp']+60000>DateTime.now().millisecondsSinceEpoch ) {
                        _stopSound();
                        _setAsset('assets/audio/alram1.mp3');
                        _setLoopMode(LoopMode.one);
                        _playSound();
                        addNPopupManager(document.data()['name'],formattedDate+formattedTime,'위급상황',300);
                      }
                      _attendeesem = snapshot.docs.length;
                    }
                    _emLogMessages.add(
                      AccidentMessage(
                        uid: document.data()['userId'],
                        name: document.data()['name'],
                        time:formattedTime,
                        message: document.data()['text'],
                        date: formattedDate,
                        location: document.data()['latitude'].toString() + ', ' +
                            document.data()['longitude'].toString(),
                        timestamp: date,
                      ),
                    );
                  });
                  notifyListeners();
                });

            _attendeesmap=0;
            listenMap?.cancel();
            listenMap = FirebaseFirestore.instance
                .collection('guestbook')
                .where('text',isEqualTo:'지도노티')  //jay user
                .orderBy("timestamp", descending: true)
                .snapshots()
                .listen((snapshot) {
                  logger.warning('FireStore[read] -------- 지도노티');
                  logger.warning(snapshot.docs.length);
                  _mapNotyMessages = [];
                  int lastone=0;
                  snapshot.docs.forEach((document) {
                    if(lastone==0) {
                      lastone=1;
                      if(_attendeesmap>0 &&document.data()['timestamp']+60000>DateTime.now().millisecondsSinceEpoch) {
                        Navigator.push(navigatorKey.currentContext!, MaterialPageRoute(builder: (context)=>Second(latitude:geolatitude , longitude: geolongitude)));
                        /*
                        _stopSound();
                        _setAsset('assets/audio/relEvent.mp3');
                        _setLoopMode(LoopMode.off);
                        _playSound();
                        addNPopupManager(document.data()['name'],formattedDate,'상황해제',300);*/
                      }
                      _attendeesmap = snapshot.docs.length;
                    }
                    /*
                    _uemLogMessages.add(
                      GuestBookMessage(
                          name: document.data()['name'],
                          message: document.data()['text'],
                          timestamp: formattedDate,
                          location: document.data()['latitude'].toString() + ', ' +
                              document.data()['longitude'].toString()
                      ),
                    );*/
                  });
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
                  _ucnLogMessages = [];
                  int lastone=0;
                  snapshot.docs.forEach((document) {
                    DateTime date = DateTime.fromMillisecondsSinceEpoch(document.data()['timestamp']);
                    String formattedDate = DateFormat('MM월dd일').format(date);
                    String formattedTime = DateFormat('HH시mm분').format(date);
                    if(lastone==0) {
                      lastone=1;
                      logger.warning('FireStore[read] -------- 장비연결해제');
                      logger.warning(snapshot.docs.length);

                      if(_attendeesoffline>0 &&document.data()['timestamp']+60000>DateTime.now().millisecondsSinceEpoch) {
                        _stopSound();
                        _setAsset('assets/audio/alram1.mp3');
                        _setLoopMode(LoopMode.one);
                        _playSound();
                        addNPopupManager(document.data()['name'],formattedDate+formattedTime,'연결해제',300);
                      }
                      _attendeesoffline = snapshot.docs.length;
                      //basicSnackBar(document.data()['text'] +'이 발생했습니, 작업자: '+document.data()['name']));
                    }
                    _ucnLogMessages.add(
                      AccidentMessage(
                        uid: document.data()['userId'],
                        name: document.data()['name'],
                        time:formattedTime,
                        message: document.data()['text'],
                        date: formattedDate,
                        location: document.data()['latitude'].toString() + ', ' +
                            document.data()['longitude'].toString(),
                        timestamp: date,
                      ),
                      /*
                      GuestBookMessage(
                          name: document.data()['name'],
                          message: document.data()['text'],
                          timestamp: formattedDate,
                          location: document.data()['latitude'].toString() + ', ' +
                              document.data()['longitude'].toString()
                      ),*/
                    );
                  });
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
                  _rcnLogMessages = [];
                  int lastone=0;
                  snapshot.docs.forEach((document) {
                    DateTime date = DateTime.fromMillisecondsSinceEpoch(document.data()['timestamp']);
                    String formattedDate = DateFormat('MM월dd일').format(date);
                    String formattedTime = DateFormat('HH시mm분').format(date);
                    if(lastone==0) {
                      lastone=1;
                      logger.warning('FireStore[read] -------- 장비연결해제복귀');
                      logger.warning(snapshot.docs.length);

                      if(_attendeesRecorvline>0 &&document.data()['timestamp']+60000>DateTime.now().millisecondsSinceEpoch) {
                        _stopSound();
                        _setAsset('assets/audio/relEvent.mp3');
                        _setLoopMode(LoopMode.off);
                        _playSound();
                        addNPopupManager(document.data()['name'],formattedDate+formattedTime,'해제복귀',300);
                        //addNPopupManager('해제복귀',300);
                      }
                      _attendeesRecorvline = snapshot.docs.length;
                      //basicSnackBar(document.data()['text'] +'이 발생했습니, 작업자: '+document.data()['name']));
                    }
                    _rcnLogMessages.add(
                      AccidentMessage(
                        uid: document.data()['userId'],
                        name: document.data()['name'],
                        time:formattedTime,
                        message: document.data()['text'],
                        date: formattedDate,
                        location: document.data()['latitude'].toString() + ', ' +
                            document.data()['longitude'].toString(),
                        timestamp: date,
                      ),
                    );
                  });
                  notifyListeners();
                });

 */
/*
            _attendeesbelt=0;
            listenBelt?.cancel();
            listenBelt = FirebaseFirestore.instance
                .collection('guestbook')
                .where('text', isEqualTo:'턱끈연결')  //jay user
                .orderBy("timestamp", descending: true)
                .snapshots()
                .listen((snapshot) {

                  _beltLogMessages = [];
                  int lastone=0;
                  snapshot.docs.forEach((document) {
                    DateTime date = DateTime.fromMillisecondsSinceEpoch(document.data()['timestamp']);
                    String formattedDate = DateFormat('MM월dd일').format(date);
                    String formattedTime = DateFormat('HH시mm분').format(date);
                    if(lastone==0) {
                      lastone=1;
                      logger.warning('FireStore[read] -------- 턱끈연결');
                      logger.warning(snapshot.docs.length);
                      /*
                      if(_attendeesbelt>0 &&document.data()['timestamp']+60000>DateTime.now().millisecondsSinceEpoch) {
                        _stopSound();
                        _setAsset('assets/audio/alram1.mp3');
                        _setLoopMode(LoopMode.one);
                        _playSound();
                            addNPopupManager(document.data()['name'],formattedDate,'턱끈연결',300);
                      }*/
                      _attendeesbelt = snapshot.docs.length;
                    }
                    _beltLogMessages.add(
                      AccidentMessage(
                        uid: document.data()['userId'],
                        name: document.data()['name'],
                        time:formattedTime,
                        message: document.data()['text'],
                        date: formattedDate,
                        location: document.data()['latitude'].toString() + ', ' +
                            document.data()['longitude'].toString(),
                        timestamp: date,
                      ),
                    );
                  });
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
                  _ubeltLogMessages = [];
                  int lastone=0;
                  snapshot.docs.forEach((document) {
                    DateTime date = DateTime.fromMillisecondsSinceEpoch(document.data()['timestamp']);
                    String formattedDate = DateFormat('MM월dd일').format(date);
                    String formattedTime = DateFormat('HH시mm분').format(date);
                    if(lastone==0) {
                      lastone=1;
                      logger.warning('FireStore[read] -------- 턱끈해제');
                      logger.warning(snapshot.docs.length);
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
                      AccidentMessage(
                        uid: document.data()['userId'],
                        name: document.data()['name'],
                        time:formattedTime,
                        message: document.data()['text'],
                        date: formattedDate,
                        location: document.data()['latitude'].toString() + ', ' +
                            document.data()['longitude'].toString(),
                        timestamp: date,
                      ),
                      /*
                      GuestBookMessage(
                          name: document.data()['name'],
                          message: document.data()['text'],
                          timestamp: formattedDate,
                          location: document.data()['latitude'].toString() + ', ' +
                              document.data()['longitude'].toString()
                      ),*/
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
                  _etcLogMessages = [];
                  int lastone=0;
                  snapshot.docs.forEach((document) {
                    DateTime date = DateTime.fromMillisecondsSinceEpoch(document.data()['timestamp']);
                    String formattedDate = DateFormat('MM월dd일').format(date);
                    String formattedTime = DateFormat('HH시mm분').format(date);
                    if(lastone==0) {
                    lastone=1;
                    logger.warning('FireStore[read] -------- 기타상황');
                    logger.warning(snapshot.docs.length);
                    if(_attendeesetc>0 &&document.data()['timestamp']+60000>DateTime.now().millisecondsSinceEpoch) {
                      _stopSound();
                      _setAsset('assets/audio/alram1.mp3');
                      _setLoopMode(LoopMode.one);
                      _playSound();
                      addNPopupManager(document.data()['name'],formattedDate+formattedTime,'기타상황',300);
                    }
                    _attendeesetc = snapshot.docs.length;
                    //basicSnackBar(document.data()['text'] +'이 발생했습니, 작업자: '+document.data()['name']));
                    }
                    _etcLogMessages.add(
                      AccidentMessage(
                        uid: document.data()['userId'],
                        name: document.data()['name'],
                        time:formattedTime,
                        message: document.data()['text'],
                        date: formattedDate,
                        location: document.data()['latitude'].toString() + ', ' +
                            document.data()['longitude'].toString(),
                        timestamp: date,
                      ),
                      /*
                      GuestBookMessage(
                          name: document.data()['name'],
                          message: document.data()['text'],
                          timestamp: formattedDate,
                          location: document.data()['latitude'].toString() + ', ' +
                              document.data()['longitude'].toString()
                      ),*/
                    );
                  }
                  );
                  notifyListeners();
                });

 */

/*
            _guestBookSubscription?.cancel();
            _guestBookSubscription = FirebaseFirestore.instance
                .collection('guestbook')
            //.where('userId',isEqualTo:user.uid) //jay user
                .orderBy('timestamp', descending: true)
                .snapshots()
                .listen((snapshot){
              logger.warning('FireStore[read] -------- 모든 데이터');
              _accidentMessages = [];
              snapshot.docs.forEach((document) {
                DateTime date = DateTime.fromMillisecondsSinceEpoch(document.data()['timestamp']);
                String formattedDate = DateFormat('MM월dd일').format(date);
                String formattedTime = DateFormat('HH시mm분').format(date);
                //_guestBookMessages.add(
                _accidentMessages.add(
                  AccidentMessage(
                      uid: document.data()['userId'],
                    name: document.data()['name'],
                    time:formattedTime,
                    message: document.data()['text'],
                    date: formattedDate,
                    location: document.data()['latitude'].toString() + ', ' +
                        document.data()['longitude'].toString(),
                    timestamp: date,
                  ),
                );
              });
              final List<AccidentMessage> namesStartWithB =
              _accidentMessages.where((element) => element.name.startsWith('김')).toList();
              print(namesStartWithB.map((e) => e.date));

              namesStartWithB.forEach((document) {
                print(document.name);
                print(document.message);
              });

              print(namesStartWithB.length.toString());
              notifyListeners();
            });

            //_attendeesoffline=0;
            listenWorker?.cancel();
            listenWorker = FirebaseFirestore.instance
                .collection('user')
                .snapshots()
                .listen((snapshot) {
              _workerLogMessages = [];
              _attendeesworker = snapshot.docs.length;
              logger.warning('FireStore[read] -------- worker list');
              logger.warning(snapshot.docs.length);
              snapshot.docs.forEach((document) {
                  _workerLogMessages.add(
                   WorkerListMessage(
                     name: document.data()['name'],
                     uid:  document.data()['uid'],
                   ),
                 );
              });
              notifyListeners();
            });

*/
              /*
            _workerBookSubscription?.cancel();
            _workerBookSubscription = FirebaseFirestore.instance
                .collection('guestbook')
            //.where('userId',isEqualTo:user.uid) //jay user
                .orderBy('timestamp', descending: true)
                .snapshots()
                .listen((snapshot){
              _workerBookMessages = [];
              snapshot.docs.forEach((document) {
                DateTime date = DateTime.fromMillisecondsSinceEpoch(document.data()['timestamp']);
                String formattedDate = DateFormat('MM월dd일').format(date);
                String formattedTime = DateFormat('HH시mm분').format(date);
                _workerBookMessages.add(
                  WorkerBookMessage(
                    name: document.data()['name'],
                    time:formattedTime,
                    message: document.data()['text'],
                    date: formattedDate,
                    location: document.data()['latitude'].toString() + ', ' +
                        document.data()['longitude'].toString(),
                    timestamp: date,
                  ),
                );
              });
              notifyListeners();
            });

*/
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
              logger.warning('페어런츠 모든 얼럿');


              //GetMaterialApp.dialog (SimpleDialog ());
              //_attendeesetc = _attendeesall - _attendeesbelt - _attendeesim -_attendeesff-_attendeesia-_attendeesem;
              _guestBookMessages = [];
              int lastone =0;
              snapshot.docs.forEach((document) {
                if(lastone==0) {
                  logger.warning('lastone');
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
        else {
          _guestBookSubscription?.cancel();
          _guestBookSubscription = FirebaseFirestore.instance
            .collection('guestbook')
            .where('userId',isEqualTo:user.uid) //jay user
            .orderBy('timestamp', descending: true)
            .snapshots()
            .listen((snapshot){
              //_guestBookMessages = [];
              _accidentMessages = [];
              // ignore: avoid_function_literals_in_foreach_calls
              snapshot.docs.forEach((document) {
                DateTime date = DateTime.fromMillisecondsSinceEpoch(document.data()['timestamp']);
                String formattedDate = DateFormat('MM월dd일').format(date);
                String formattedTime = DateFormat('HH시mm분').format(date);
                //_guestBookMessages.add(
                _accidentMessages.add(
                  AccidentMessage(
                    uid: document.data()['userId'],
                      name: document.data()['name'],
                      time:formattedTime,
                      message: document.data()['text'],
                      date: formattedDate,
                      location: document.data()['latitude'].toString() + ', ' +
                          document.data()['longitude'].toString(),
                      timestamp: date,
                  ),
                );
              });
              notifyListeners();
            });
        }
      }
      else {
        listenIa?.cancel();
        listenIm?.cancel();
        listenEm?.cancel();
        listenUEm?.cancel();
        listenMap?.cancel();
        listenUCn?.cancel();
        listenRCn?.cancel();
        listenBelt?.cancel();
        listenUBelt?.cancel();
        listenEtc?.cancel();
        listenWorker?.cancel();
        displayPhoneNumber = '사용자 정보없음';
        displayName = '사용자 없음';
        displayEmail = '사용자 정보없음';
        logger.warning('logout ');
        bTdevice?.disconnect();
        logState = false;
        _loginState = ApplicationLoginState.loggedOut;
        _guestBookMessages = [];
        _guestBookSubscription?.cancel();
        notifyListeners();
       // Restart.restartApp();
      }
    });
  }

  LatLng? _positonA  = LatLng(0,0);
  StreamSubscription<DocumentSnapshot>? _positionSubscription;
  LatLng? get positionA => _positonA;

  void setpositionA( LatLng latLng) {
    _positonA =latLng;
    notifyListeners();
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


  List<AccidentMessage> get accidentmessages => _accidentMessages;
  List<AccidentMessage> _accidentMessages = [];


  StreamSubscription<QuerySnapshot>? _workerBookSubscription;
  List<WorkerBookMessage> get workerBookMessages => _workerBookMessages;
  List<WorkerBookMessage> _workerBookMessages = [];


  List<WorkerListMessage> _workerLogMessages = [];
  List<WorkerListMessage> get workerLogMessages => _workerLogMessages;


  String? _message = '';
  String? _verificationId;

  // Example code of how to verify phone number
  Future<void> _verifyPhoneNumber(
    String phoneNumber,
      String Verfycode,
  void Function(FirebaseAuthException e) errorCallback,
  ) async {
/*
    setState(() {
      _message = '';
    });
*/
    PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential phoneAuthCredential) async {
      await FirebaseAuth.instance.signInWithCredential(phoneAuthCredential);
     /* widget._scaffold.showSnackBar(SnackBar(
        content: Text(
            'Phone number automatically verified and user signed in: $phoneAuthCredential'),
      ));*/
    };

    PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
      /*setState(() {
        _message =
        'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}';
      });*/
    };

    PhoneCodeSent codeSent =
        ( String? verificationId, [int? forceResendingToken]) async {
 /*     widget._scaffold.showSnackBar(const SnackBar(
        content: Text('Please check your phone for the verification code.'),
      ));*/
      _verificationId = verificationId;
    };

    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      _verificationId = verificationId;
    };

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          timeout: const Duration(seconds: 5),
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    } catch (e) {
     /* widget._scaffold.showSnackBar(SnackBar(
        content: Text('Failed to Verify Phone Number: $e'),
      ));*/
    }
  }

  void startLoginFlow() {
    _loginState = ApplicationLoginState.emailAddress;
    notifyListeners();
  }

  // ignore: avoid_void_async
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

  // ignore: avoid_void_async
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

  /*

  // Example code of how to sign in with email and password.
  Future<void> _signInWithEmailAndPassword() async {
    try {
      final User user = (await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      ))
          .user;

      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('${user.email} signed in'),
        ),
      );
    } catch (e) {
      Scaffold.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to sign in with Email & Password'),
        ),
      );
    }
  }
}
*/
  void cancelRegistration() {
    _loginState = ApplicationLoginState.emailAddress;
    notifyListeners();
  }

  // ignore: avoid_void_async
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
      // ignore: deprecated_member_use
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
      home: const HomePage()/* FlutterBlueApp()*/,
    ),
      ),
    );
  }

  onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
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


Widget homeHeaderImage() {
  return Image.asset('assets/image/workman.png',);
}

Widget  workDate(){
  return IconAndDetail(Icons.calendar_today, DateFormat('작업일시 : yyyy년 MM월 dd일').format(DateTime.now()).toString());
}

Widget workTime(){
  return IconAndDetail(Icons.watch_later_outlined, DateFormat('현재시간 : a hh시mm분',"ko_kr" ).format(DateTime.now()).toString());
}

Widget workerZone(){
  return IconAndDetail(Icons.location_city_outlined, '작업지역 : '+'서울시 구로구 A');
}

Widget workerName( String name){
  return IconAndDetail(Icons.person_outline, '작업자명 : '+name);
}
Widget accidentName( String state){
  return IconAndDetail(Icons.warning_amber_outlined, '특이사항 : '+state);
}
class AccidentDetailwithTimeStamp extends StatelessWidget {
  AccidentDetailwithTimeStamp({required this.timestamp, required this.str1, required this.str2, required this.str3, required this.str4, required this.color});
  DateTime timestamp;
  String str1;
  String str2;
  String str3;
  String str4;
  Color color;

  @override
  Widget build(BuildContext context) {

      str1 = DateFormat('MM월dd일').format(timestamp);
      str2 = DateFormat('HH시mm분').format(timestamp);

    return accidentDetail( str1,  str2,  str3,  str4,  color );
  }
}


Widget accidentDetail( String str1, String str2, String str3, String str4, Color color){
  return SizedBox(
    width:double.infinity,
    child: Row(
      children: [
        Expanded(
          flex: 3,
            child: Container(
              alignment: Alignment.center,
              child: Text(str1,
                style:TextStyle(
                  fontSize: ScreenUtil().setSp(16),
                  color: color,
                  //fontWeight: FontWeight.w700 ,
                ),
              ),
            ),
        ),
        Expanded(
            flex: 3,
            child: Container(
              alignment: Alignment.center,
                child: Text(str2,
                  style:TextStyle(
                    fontSize: ScreenUtil().setSp(16),
                    color: color,
                    //fontWeight: FontWeight.w700 ,
                  ),
                ),
            )
        ),
        Expanded(
          flex: 3,
            child: Container(
                alignment: Alignment.center,
                child: Text(str3,
                  style:TextStyle(
                    fontSize: ScreenUtil().setSp(16),
                    color: color,
                    //fontWeight: FontWeight.w700 ,
                  ),
                ),
            ),
        ),
        Expanded(
          flex: 4,
          child: Container(
            alignment: Alignment.center,
            //child: Text('위도:'+str4.replaceAll(', ', '\n경도:') ,
            child: Text(str4,
              style:TextStyle(
                fontSize: ScreenUtil().setSp(16),
                color: color,
                //fontWeight: FontWeight.w700 ,
              ),
            ),
          ),
        ),
      ],
    ),
  );
    //IconAndDetail(Icons.warning_amber_outlined, workerName+' / '+accidentTime+' / ' +state);
}

Widget workerBeltState(){
  if(beltState==true) {
    return const IconAndDetail(Icons.sync_outlined, '안전모 착용상태 : 착용');
  } else {
    return const IconAndDetail(Icons.sync_disabled, '안전모 착용상태 : 미착용');
  }
}


class HomePersonalInfo extends StatefulWidget {
  @override
  _HomePersonalInfoState createState() => _HomePersonalInfoState();
}

class _HomePersonalInfoState extends State<HomePersonalInfo> {

  Widget userBeneficiaries() {
    return Container(
      margin:  EdgeInsets.all(fixPadding * 0.2),
      padding: EdgeInsets.only(left:4,right:4, top:10), //const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
      alignment: Alignment.center,
      //alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.0),
        /*boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 0,
                                blurRadius: 5,
                                offset: Offset(0,2),
                              ),
                            ],*/
      ),
      child: GridView.count(
        crossAxisCount: 5,
        childAspectRatio: 1.1,
        padding: const EdgeInsets.all(0.2),
        mainAxisSpacing: 5.0,
        crossAxisSpacing: 1,
        shrinkWrap: true,
        //primary: true,
        physics: const NeverScrollableScrollPhysics(),
        children: beneficiariesList.map(
              (item) {
            return InkWell(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) =>
                        AccidentCaseDetailPage(itemname: item['name']!))).then((value) => // ShowDataLogerScreen
                    setState(() {})); //_startscan();
              },
              child: Container(
                //color:Colors.blue,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(3.8),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(3.0),
                        /*boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 0,
                                blurRadius: 5,
                                offset: Offset(0,2),
                              ),
                            ],*/
                      ),
                      //color:Colors.deepPurple,
                      width: double.infinity,
                      child: Text(
                        item['name']!,
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(14.4),
                          color: Colors.white,
                          //fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    //const SizedBox(height: 5.0),
                    ////['무활동반응','추락사고','충격사고','위급상황','상황해제','연결해제','연결복귀','턱끈연결','턱끈해제']) //jay user
                    Expanded(
                      child: Container(
                        //color:Colors.yellow,
                        width: double.infinity,
                        alignment: Alignment.center,
                        //height:double.infinity,
                        child: Text(
                          (item['name']=='무활동반응')?
                            attendeesia.toString():
                          (item['name']=='추락사고')?
                            attendeesff.toString():
                          (item['name']=='충격사고')?
                            attendeesim.toString():
                          (item['name']=='위급상황')?
                            attendeesem.toString():
                          (item['name']=='상황해제')?
                            attendeesemrels.toString():
                          (item['name']=='연결해제')?
                            attendeesoffline.toString():
                          (item['name']=='연결복귀')?
                            attendeesRecorvline.toString():
                          (item['name']=='턱끈해제')?
                            attendeesDissbelt.toString():
                          (item['name']=='턱끈연결')?
                            attendeesbelt.toString():
                          (item['name']=='그밖의상황')?
                            attendeesetc.toString():
                            attendeesall.toString(),
                          style:  TextStyle(
                            fontSize: ScreenUtil().setSp(20),
                            //color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return  Consumer<ApplicationState>(
          builder: (context, appState, _) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (appState.loginState == ApplicationLoginState.loggedOut/*&&btState==BluetoothDeviceState.connected*/) ...[
                homeHeaderImage(),
                heightSpace,
                const Header('오늘의 안전수칙'),
                const Paragraph('말로하는 안전보다.실천하는 안전점검'),
                heightSpace,
                heightSpace,
              ],

              if (appState.loginState == ApplicationLoginState.loggedIn/*&&btState==BluetoothDeviceState.connected*/) ...[
                if(role=='manager') ...[
                //if(logEmail=='jay@tinkerbox.kr'||logEmail=='uzbrainnet@gmail.com') ...[
                  const SizedBox(height:4,),
                  Container (
                    margin:  EdgeInsets.only(left:fixPadding * 0.5,right:fixPadding * 0.5),
                    padding: EdgeInsets.symmetric(vertical: fixPadding),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6.0),
                      /*boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 0,
                          blurRadius: 5,
                          offset: Offset(0,2),
                        ),
                      ],*/
                    ),
                    child: Column(
                      children: [
                        workDate(),
                        workTime(),
                        workerZone(),
                      ],
                    ),
                  ),
                  const SizedBox(height:5,),
                  //addNewBeneficiaryButton(),
                  const Header('종합 사고상황'),
                  //benificiariesText(),
                  userBeneficiaries(),
                  const SizedBox(height:5,),
                  const Header('최근 특이사항'),
                  Container(
                    //height: ,
                      margin:  EdgeInsets.all(fixPadding * 0.5),
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      //alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(6.0),
                        /*boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 0,
                                blurRadius: 5,
                                offset: Offset(0,2),
                              ),
                            ],*/
                      ),
                      child: accidentDetail( '발생일자', '발생시각', '작업자','특이사항' ,Colors.white)
                  ),
                  AccidentList(
                    messages: appState.accidentmessages, // new
                    weekCount: 1,
                    isName: true,
                    isPosition:false,
                  ),
                ]
                else ...
                [
                  homeHeaderImage(),
                  const SizedBox(height:7,),
                  Container (
                    margin:  EdgeInsets.only(left:fixPadding * 0.5,right:fixPadding * 0.5),
                    padding: EdgeInsets.symmetric(vertical: fixPadding),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      children: [
                        workDate(),
                        workTime(),
                        workerZone(),
                        workerName(displayName),
                        workerBeltState(),
                      ],
                    ),
                  ),
                  const SizedBox(height:5,),
                  const Header('최근 특이사항'),
                  //const Header('마지막 발생한 안전상황'),
                  Container(
                      margin:  EdgeInsets.all(fixPadding * 0.3),
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      //alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(6.0),
                        /*boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 0,
                                blurRadius: 5,
                                offset: Offset(0,2),
                              ),
                            ],*/
                      ),
                      child: accidentDetail( '발생일자', '발생시각', '작업자','특이사항' ,Colors.white)
                  ),
                  AccidentList(
                    messages: appState.accidentmessages, // new
                    weekCount: 1,
                    isName: true,
                    isPosition:false,
                  ),
                  /*GuestBook(
                    messages: appState.guestBookMessages, // new
                    addMessage: (message) =>
                        appState.addMessageToGuestBook(message),
                    logcount: 0,
                  ),*/
                ],
              ],
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
            ],
          ),
        );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}
DateTime? currentBackPressTime;

class _HomeState extends State<Home> {

  Widget addNewBeneficiaryButton(){
    return InkWell(
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
        physics: const NeverScrollableScrollPhysics(),
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

                      const SizedBox(height: 10.0),
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
                        (item['name']=='그밖의상황')?
                        _attendeesetc.toString():
                        _attendeesall.toString(),
                        style: const TextStyle(
                          fontSize: 28.0,
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Icon(
                        Icons.format_list_numbered,
                        color: Colors.black54,
                        //size: 10.0,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBgColor,
      key: scaffoldKey,
      body:
      ListView(
        children: <Widget>[
          HomePersonalInfo(),
          heightSpace,
        ],
      ),
    );
  }
}

class First2 extends StatefulWidget {
  @override
  _First2State createState() => _First2State();
}

class _First2State extends State<First2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBgColor,
      body: ListView(
        children: <Widget>[
          Image.asset('assets/image/log.png'),
          //Image.asset('assets/image/caring-nurse-and-the-girl-FPAX4FK.png'),
          Consumer<ApplicationState>(
            builder: (context, appState, _) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (appState.loginState == ApplicationLoginState.loggedIn/*&&btState==BluetoothDeviceState.connected*/) ...[
                  //appState.guestBookMessages,
                  const SizedBox(height:7,),
                  Container (
                    margin:  EdgeInsets.only(left:fixPadding * 0.5,right:fixPadding * 0.5),
                    padding: EdgeInsets.symmetric(vertical: fixPadding),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      /*boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 0,
                          blurRadius: 5,
                          offset: Offset(0,2),
                        ),
                      ],*/
                    ),
                    child: Column(
                      children: [
                        workDate(),
                        workTime(),
                        workerZone(),
                      ],
                    ),
                  ),
                  WorkerList(
                    messages: appState.workerLogMessages, // new
                    weekCount:0,
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
                    messages: appState.guestBookMessages, // new
                    addMessage: (message) =>
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

// ignore: must_be_immutable
class MapArea extends StatefulWidget {
  MapArea({required this.latitude, required this.longitude, required this.pos1, required this.pos2, required this.refresh});
  double latitude;
  double longitude;
  bool pos1;
  bool pos2;
  bool refresh;

  @override
  _MapAreaState createState() => _MapAreaState();
}

class _MapAreaState extends State<MapArea> {
  late PageController _pageController;
  late int prevPage;


  final controller = MapController(
    location: LatLng(37.4837122, 126.8954294),
    zoom:  18,
  );

  final _darkMode = false;

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
    setState(() {});
  }

  void _gotoTarget() {
    controller.center = LatLng(widget.latitude, widget.longitude);
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
      child:
      const Icon(Icons.location_pin, color: Colors.deepPurple),
    );
  }

  Widget _buildWorkerMarkerWidget(Offset pos, Color color) {
    return Positioned(
      left: pos.dx - 16,
      top: pos.dy - 16,
      width: 64,
      height: 64,
      child:
      const Icon(Icons.my_location, color:Colors.red),
    );
  }

  double _oldUserLatitude =0;
  double _oldUserLongitude =0;

  @override
  void initState() {
    // TODO: implement initState
    controller.center=LatLng(widget.latitude, widget.longitude);
    super.initState();

  }

  @override
  Widget build(BuildContext context) {

    if(_oldUserLatitude!=widget.latitude &&_oldUserLongitude!=widget.longitude) {
      _gotoTarget();
      _oldUserLatitude=widget.latitude;
      _oldUserLongitude=widget.longitude;
    }

    return Scaffold(
      body: Stack(
        children: [
          MapLayoutBuilder(
            controller: controller,
            builder: (context, transformer) {
              final homeLocation =
              transformer.fromLatLngToXYCoords(LatLng(widget.latitude, widget.longitude));

              final myLocation =
              transformer.fromLatLngToXYCoords(LatLng(geolatitude, geolongitude));

              final homeMarkerWidget =
              _buildWorkerMarkerWidget(homeLocation, Colors.deepOrange);

              final centerLocation = Offset(
                  transformer.constraints.biggest.width / 2,
                  transformer.constraints.biggest.height / 2);

              final centerMarkerWidget =
              _buildMarkerWidget(myLocation, Colors.deepPurple);

              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onDoubleTap: _onDoubleTap,
                onScaleStart: _onScaleStart,
                onScaleUpdate: _onScaleUpdate,
                onTapUp: (details) {
                  final location =
                  transformer.fromXYCoordsToLatLng(details.localPosition);

                  final clicked = transformer.fromLatLngToXYCoords(location);

                  logger.warning('${location.longitude}, ${location.latitude}');
                  logger.warning('${clicked.dx}, ${clicked.dy}');
                  logger.warning('${details.localPosition.dx}, ${details.localPosition.dy}');
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
                        builder: (context, x, y2, z) {
                          //Legal notice: This url is only used for demo and educational purposes. You need a license key for production use.
                          //Google Maps
                          final url =
                              'https://www.google.com/maps/vt/pb=!1m4!1m3!1i$z!2i$x!3i$y2!2m3!1e0!2sm!3i420120488!3m7!2sen!5e1105!12m4!1e68!2m2!1sset!2sRoadmap!4e0!5m1!1e0!23i4111425';

                          final darkUrl =
                              'https://maps.googleapis.com/maps/vt?pb=!1m5!1m4!1i$z!2i$x!3i$y2!4i256!2m3!1e0!2sm!3i556279080!3m17!2sen-US!3sUS!5e18!12m4!1e68!2m2!1sset!2sRoadmap!12m3!1e37!2m1!1ssmartmaps!12m4!1e26!2m2!1sstyles!2zcC52Om9uLHMuZTpsfHAudjpvZmZ8cC5zOi0xMDAscy5lOmwudC5mfHAuczozNnxwLmM6I2ZmMDAwMDAwfHAubDo0MHxwLnY6b2ZmLHMuZTpsLnQuc3xwLnY6b2ZmfHAuYzojZmYwMDAwMDB8cC5sOjE2LHMuZTpsLml8cC52Om9mZixzLnQ6MXxzLmU6Zy5mfHAuYzojZmYwMDAwMDB8cC5sOjIwLHMudDoxfHMuZTpnLnN8cC5jOiNmZjAwMDAwMHxwLmw6MTd8cC53OjEuMixzLnQ6NXxzLmU6Z3xwLmM6I2ZmMDAwMDAwfHAubDoyMCxzLnQ6NXxzLmU6Zy5mfHAuYzojZmY0ZDYwNTkscy50OjV8cy5lOmcuc3xwLmM6I2ZmNGQ2MDU5LHMudDo4MnxzLmU6Zy5mfHAuYzojZmY0ZDYwNTkscy50OjJ8cy5lOmd8cC5sOjIxLHMudDoyfHMuZTpnLmZ8cC5jOiNmZjRkNjA1OSxzLnQ6MnxzLmU6Zy5zfHAuYzojZmY0ZDYwNTkscy50OjN8cy5lOmd8cC52Om9ufHAuYzojZmY3ZjhkODkscy50OjN8cy5lOmcuZnxwLmM6I2ZmN2Y4ZDg5LHMudDo0OXxzLmU6Zy5mfHAuYzojZmY3ZjhkODl8cC5sOjE3LHMudDo0OXxzLmU6Zy5zfHAuYzojZmY3ZjhkODl8cC5sOjI5fHAudzowLjIscy50OjUwfHMuZTpnfHAuYzojZmYwMDAwMDB8cC5sOjE4LHMudDo1MHxzLmU6Zy5mfHAuYzojZmY3ZjhkODkscy50OjUwfHMuZTpnLnN8cC5jOiNmZjdmOGQ4OSxzLnQ6NTF8cy5lOmd8cC5jOiNmZjAwMDAwMHxwLmw6MTYscy50OjUxfHMuZTpnLmZ8cC5jOiNmZjdmOGQ4OSxzLnQ6NTF8cy5lOmcuc3xwLmM6I2ZmN2Y4ZDg5LHMudDo0fHMuZTpnfHAuYzojZmYwMDAwMDB8cC5sOjE5LHMudDo2fHAuYzojZmYyYjM2Mzh8cC52Om9uLHMudDo2fHMuZTpnfHAuYzojZmYyYjM2Mzh8cC5sOjE3LHMudDo2fHMuZTpnLmZ8cC5jOiNmZjI0MjgyYixzLnQ6NnxzLmU6Zy5zfHAuYzojZmYyNDI4MmIscy50OjZ8cy5lOmx8cC52Om9mZixzLnQ6NnxzLmU6bC50fHAudjpvZmYscy50OjZ8cy5lOmwudC5mfHAudjpvZmYscy50OjZ8cy5lOmwudC5zfHAudjpvZmYscy50OjZ8cy5lOmwuaXxwLnY6b2Zm!4e0&key=AIzaSyAOqYYyBbtXQEtcHG7hwAwyCPQSYidG8yU&token=31440';
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
                      ///...markerWidgets,
                      centerMarkerWidget,
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
     floatingActionButton: Stack(
        children: <Widget>[
          (widget.pos1==true)?
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.only(left:30.0),
                child: Container(
                  width:  ScreenUtil().setWidth(100),
                  height:ScreenUtil().setHeight(40),
                  child: FloatingActionButton.extended(
                    heroTag: "my",
                    onPressed: _gotoDefault,
                    label: const Text('내위치'),
                    icon: const Icon(Icons.location_pin),
                  ),
                ),
              ),
            ):Container(),

          (widget.pos2==true)?
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              width:  ScreenUtil().setWidth(130),
              height:ScreenUtil().setHeight(50),
              child: FloatingActionButton.extended(
                heroTag: "wk",
                onPressed: _gotoTarget,
                label: const Text('사고위치'),
                icon: const Icon(Icons.my_location),
                backgroundColor: Colors.red,
              ),
            ),
          ):Container(),
        ],
      )
    );
  }
}




// ignore: must_be_immutable
class AccidentCaseDetailPage extends StatefulWidget {
  const AccidentCaseDetailPage({Key? key,required this.itemname}): super(key: key);
  final String itemname;
  @override
  _AccidentCaseDetailPageState createState() => _AccidentCaseDetailPageState();
}

class _AccidentCaseDetailPageState extends State<AccidentCaseDetailPage> {


  List<AccidentMessage> get iaLogMessages => _iaLogMessages;
  List<AccidentMessage> get ffLogMessages => _ffLogMessages;
  List<AccidentMessage> get imLogMessages => _imLogMessages;


  final ScrollController _scrollController = ScrollController();
/*
  AppBar appBar =AppBar(
    title:  appBarTitleText,
  );
*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: AppBar(
        title:  Text(widget.itemname+' 현황'),
      ),
      body:  Consumer<ApplicationState>(
        builder: (context, appState, _) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //const SizedBox(height:5),
            Container(
                margin:  EdgeInsets.all(fixPadding * 0.5),
                padding: const EdgeInsets.symmetric(vertical: 10),
                //alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(10.0),
                  /*boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 0,
                                blurRadius: 5,
                                offset: Offset(0,2),
                              ),
                            ],*/
                ),
                child: accidentDetail( '발생일자', '발생시각', '작업자','발생 위치' ,Colors.white)
            ),
            Expanded(
              child: AccidentList(
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
                weekCount: 0,
                isName: true,
                isPosition:true,
              ),
            ),
            const SizedBox(height:5),
          ],
        ),
      ),

    );
  }
}





// ignore: must_be_immutable
class WorkerDetailPage extends StatefulWidget {
  WorkerDetailPage({required this.latitude, required this.longitude, required this.uid, required this.state});
  double latitude;
  double longitude;
  String uid;
  String state;
  @override
  _WorkerDetailPageState createState() => _WorkerDetailPageState();
}

class _WorkerDetailPageState extends State<WorkerDetailPage> {

  AppBar appBar =AppBar(
    title: const Text('작업자 이력확인'),
  );

  int _selectedIndex = 0;

  _onSelected(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: appBar,
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height:5),
            Container(
                height: ScreenUtil().setHeight(190),
                width: ScreenUtil().setWidth(350),
                margin:  EdgeInsets.only(left:fixPadding * 1.0,right:fixPadding * 1.0),
                //padding: EdgeInsets.symmetric(vertical: fixPadding),
                alignment: Alignment.bottomCenter,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 0,
                      blurRadius: 5,
                      offset: Offset(0,2), // changes position of shadow
                    ),
                  ],
                ),
                child: Consumer<ApplicationState>(
                    builder: (context, appState, _) => MapArea(latitude: (appState.positionA!.latitude==0)?widget.latitude:appState.positionA!.latitude, longitude: (appState.positionA!.longitude==0)?widget.longitude:appState.positionA!.longitude, pos1: false, pos2:false, refresh: true )
                ),
            ),
            Container(
                margin:  EdgeInsets.all(fixPadding * 0.5),
                padding: const EdgeInsets.symmetric(vertical: 10),
                //alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: accidentDetail( '발생일자', '발생시간', '발생상황', '위치 정보',Colors.white)
            ),
            Expanded(
                child: Container(
                  margin:  EdgeInsets.all(fixPadding * 0.5),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color:Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),

                  child: Consumer<ApplicationState>(
                    builder: (context, appState, _)  {
                      List<AccidentMessage>   userLogMessages =
                          appState.accidentmessages.where((element) => element.uid.startsWith(widget.uid)).toList();

                      return ListView.builder(
                      itemCount: userLogMessages.length,
                      itemBuilder: (ctx, index){
                        if(userLogMessages[index].message=='지도노티') { //jay todo 210812: 좀더 최적화 해야 하지 않을까?
                          return Container();
                        }
                        else {
                          return InkWell(
                            onTap: () {
                              List<String> strLocation;
                              _onSelected(index);
                              strLocation =
                                  userLogMessages[index].location.split(', ');
                              LatLng? posA = LatLng(
                                  double.parse(strLocation[0]),
                                  double.parse(strLocation[1]));
                              appState.setpositionA(posA);
                            },
                            child: AccidentDetailwithTimeStamp(
                                timestamp: userLogMessages[index].timestamp,
                                str1: 'none',
                                str2: 'none',
                                str3: userLogMessages[index].message,
                                str4: userLogMessages[index].location,
                                color: _selectedIndex != null &&
                                    _selectedIndex == index
                                    ? Colors.deepPurple
                                    : Colors.black
                            ),
                          );
                        }
                      });
                    }),
                ),
            ),
            const SizedBox(height:5),
          ],
        ),
      );
  }
}




// ignore: must_be_immutable
class WorkerMap extends StatefulWidget {
  WorkerMap({required this.latitude, required this.longitude, required this.name, required this.state});
  double latitude;
  double longitude;
  String name;
  String state;
  @override
  _WorkerMapState createState() => _WorkerMapState();
}

class _WorkerMapState extends State<WorkerMap> {
  AppBar appBar =AppBar(
    title: const Text('사고위치 확인'),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar,
        body:  SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height:5),
              Container (
                height: ScreenUtil().setHeight(101),
                width: ScreenUtil().setWidth(350),
                margin:  EdgeInsets.only(left:fixPadding * 1.0,right:fixPadding * 1.0),
                padding: EdgeInsets.symmetric(vertical: fixPadding),
                alignment: Alignment.bottomCenter,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 0,
                      blurRadius: 5,
                      offset: Offset(0,2), // changes position of shadow
                    ),
                  ],
                ),

                child: Column(
                  children: [
                    //workDate(),

                    //workerZone(),
                    workerName(widget.name),
                    accidentName(widget.state),
                    workTime(),
                  ],
                ),
              ),
              const SizedBox(height:5),
              Container(
                  height: ScreenUtil().setHeight(550)-appBar.preferredSize.height,
                  width: ScreenUtil().setWidth(350),
                  margin:  EdgeInsets.only(left:fixPadding * 1.0,right:fixPadding * 1.0),
                  padding: EdgeInsets.symmetric(vertical: fixPadding),
                  alignment: Alignment.bottomCenter,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 0,
                        blurRadius: 5,
                        offset: Offset(0,2), // changes position of shadow
                      ),
                    ],
                  ),
                  child: MapArea(latitude: widget.latitude, longitude:widget.longitude, pos1:false, pos2:true, refresh:true)),
            ],
          ),
        ),
    );
  }
}


// ignore: must_be_immutable
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

    controller.center=LatLng(widget.latitude, widget.longitude);
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

  final _darkMode = false;

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
      child:
      const Icon(Icons.location_pin, color: Colors.deepPurple),
      /*Column(
        children: [
          const Text("내위치",
            style: TextStyle(
              color: Colors.deepPurple,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      )*/
    );
  }

  Widget _buildWorkerMarkerWidget(Offset pos, Color color) {
    return Positioned(
      left: pos.dx - 16,
      top: pos.dy - 16,
      width: 64,
      height: 64,
      child:
        const Icon(Icons.my_location, color:Colors.red),
        /*Column(
        children: [
          const Text("사고위치",
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const Icon(Icons.location_pin, color:Colors.red),
        ],
      )*/
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
                const SizedBox(width: 3.0),
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
              //controller.zoom += 3
             // controller =
              /*
          final markerPositions = markers.map(transformer.fromLatLngToXYCoords).toList();


          final markerWidgets = markerPositions.map(
                (pos) => _buildMarkerWidget(pos, Colors.red),
          );
          */
          final homeLocation =
          transformer.fromLatLngToXYCoords(LatLng(widget.latitude, widget.longitude));

          final myLocation =
          transformer.fromLatLngToXYCoords(LatLng(geolatitude, geolongitude));

          final homeMarkerWidget =
          _buildWorkerMarkerWidget(homeLocation, Colors.deepOrange);

          final centerLocation = Offset(
              transformer.constraints.biggest.width / 2,
              transformer.constraints.biggest.height / 2);

          final centerMarkerWidget =
          _buildMarkerWidget(myLocation, Colors.deepPurple);

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onDoubleTap: _onDoubleTap,
            onScaleStart: _onScaleStart,
            onScaleUpdate: _onScaleUpdate,
            onTapUp: (details) {
              final location =
              transformer.fromXYCoordsToLatLng(details.localPosition);

              final clicked = transformer.fromLatLngToXYCoords(location);

              logger.warning('${location.longitude}, ${location.latitude}');
              logger.warning('${clicked.dx}, ${clicked.dy}');
              logger.warning('${details.localPosition.dx}, ${details.localPosition.dy}');
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
                  ///...markerWidgets,
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
          Padding(padding: const EdgeInsets.only(left:31),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: FloatingActionButton.extended(
                heroTag: "my",
                onPressed: _gotoDefault,
                label: const Text('내위치확인'),
                icon: const Icon(Icons.location_pin),
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton.extended(
              heroTag: "wk",
              onPressed: _gotoTarget,
              label: const Text('사고위치확인'),
              icon: const Icon(Icons.my_location),
              backgroundColor: Colors.red,
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

  @override
  void initState() {
    super.initState();
    player = AudioPlayer();
    //ble instance 생성
    flutterBlue = FlutterBlue.instance;
    Geolocator.getCurrentPosition().then((value) => {
      geolatitude=value.latitude,
      geolongitude=value.longitude,
      logger.warning('geolocation(init) $geolatitude, $geolongitude'),
    });

    _timer_geo = Timer.periodic(const Duration(seconds: 30), (timer) {
      Geolocator.getCurrentPosition().then((value) => {
        geolatitude=value.latitude,
        geolongitude=value.longitude,
        logger.warning('tmrGeo_geolocation $geolatitude, $geolongitude'),

        setMylocation(iuserId, GeoPoint(geolatitude,geolongitude)),
      });
    });
  }

  var writecharacteristic;

  void addNewPopupU(String state, int time)  {

    logger.warning('addNewPopup(U) time :'+ time.toString()+', State:'+state);
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
    if(device == null) { logger.warning('connectMyProtocol null return'); return;}
    logger.warning('connectMyProtocol ');
    List<BluetoothService> services = await device.discoverServices();
    // CODE DOES NOT
    logger.warning('div');
    notistate?.cancel();
    notistate= device.state.listen((bstate) {
      logger.warning('device.state: {$bstate}');
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
                  //logger.warning('get characteristic 4 belt status');
                  writecharacteristic = c;
                }

                if(c.descriptors.isNotEmpty) {
                  c.setNotifyValue(true);
                    noti?.cancel();
                    noti= c.value.listen((value) {
                      String state='이상없음';
                    //_stopSound();
                    String btMessage = ascii.decode(value).toString();
                    logger.warning('------------- Notify Listen -----------------');
                    logger.warning('listenMsg: '+ btMessage.toString());
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
                        //alertD(context, state);
                        if(state=='위급상황') {
                          alertD(context, state);
                        }
                        else {
                          newAlertD(context, displayName, state);
                        }
                      }
                    }
                    logger.warning('------------- End of listenB('+state+') -------------');
                  });
                }
              }
            }
          }
        });
      }
    });
    logger.warning('end');
  }

  Timer? _timer;
  Timer? _timer_geo;
  Timer? _timer_bat;
  Timer? _timer_beltinit;


  // ignore: avoid_void_async
  void alertA(BuildContext context, String State, int time) async {
    logger.warning('alertA Context:'+ context.toString()+'State:'+State);
    isDialogAlive = true;
    var alert = AlertDialog(
      //title: Center(child:Text('${State} 상황 발생', style: TextStyle(fontSize:30,fontWeight: FontWeight.bold, color: Colors.deepOrange),)),
      content:  StreamBuilder<int>(
          stream: _eventsA?.stream,
          builder: (context, snapshot) {
            logger.warning(snapshot.data.toString());
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
                    // ignore: unnecessary_string_escapes
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
              logger.warning('alertA TimeExpire:'+State);
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
            logger.warning(_counterA);
            _eventsA?.add(_counterA);

          });
          return alert;
        }
    );
  }

  // basic Accident Popup
  // ignore: non_constant_identifier_names, avoid_void_async
  void alertD(BuildContext context, String State) async {
    // ignore: avoid_print
    logger.warning('alertD Context:'+ context.toString()+'State:'+State);
    var alert = AlertDialog(
      //title: Center(child:Text('${State} 상황 발생', style: TextStyle(fontSize:30,fontWeight: FontWeight.bold, color: Colors.deepOrange),)),
      content:  StreamBuilder<int>(
        stream: _events?.stream,
        builder: (context, snapshot) {
        logger.warning(snapshot.data.toString());
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
                // ignore: unnecessary_string_escapes
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

                  addStateToGuestBook('지도노티');
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
              logger.warning('alertD TimeExpire:'+State);
              _counter=0;
              _timer?.cancel();
              _stopSound();
              Navigator.of(builderContext).pop(true);
            }
            logger.warning(_counter);
            _events?.add(_counter);
          });
          return alert;
        }
    );
  }

  void newAlertD(BuildContext context, String name, String state) async {
    logger.warning('newAlertD Context:'+ context.toString()+'State:'+state);
    var alert = AlertDialog(
    /*  insetPadding: EdgeInsets.symmetric(
        horizontal: ScreenUtil().setWidth(20),
        vertical: ScreenUtil().setHeight(240),
      ),*/ //jay AlertDialog 에서 Column등이 들어가면 박스 세로사이즈가 무조건 max로 잡혀서 외부에서 강제로 패딩을 주려고 했었음.장치마다 사이즈 잡기가 쉽지않았는데.. mainAxisSize: MainAxisSize.min으로 해결되어 주석 막아
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      contentPadding :  EdgeInsets.fromLTRB(10, 22, 10, 5), //jay 컨텐츠 패딩 설정안하면 기본 컨텐츠 패딩이 너무 넓음.
      content: Container(
        //color:Colors.blue,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(name,
                  style:  TextStyle(
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold,
                    fontSize: ScreenUtil().setSp(18),
                  ),
                ),
                Text(' 근무자',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.normal,
                    fontSize: ScreenUtil().setSp(18),
                  ),
                ),
              ],
            ),
            //SizedBox(height: ScreenUtil().setHeight(5),),
            SizedBox(
              //width: double.maxFinite,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state,
                    style:  TextStyle(
                      color: Colors.deepOrange,
                      fontWeight: FontWeight.bold,
                      fontSize: ScreenUtil().setSp(18),
                    ),
                  ),
                  Text(' 사고가 발생했습니다.',
                    style:  TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.normal,
                      fontSize: ScreenUtil().setSp(18),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actionsPadding :  EdgeInsets.fromLTRB(0, 0, 0, 8),
      actions: <Widget>[
        Container(
          //color: Colors.blue,
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children:<Widget>[
                SizedBox(
                    width : ScreenUtil().setWidth(100),
                    height : ScreenUtil().setHeight(45),
                    child:ElevatedButton(
                      child: const Text('확인'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.deepPurple,
                        //padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                        textStyle: TextStyle(
                            fontSize: ScreenUtil().setSp(16),
                            fontWeight: FontWeight.bold)
                    ),
                    onPressed:() {
                      _counter=0;
                      _timer?.cancel();
                      _stopSound();
                      Navigator.of(context, rootNavigator: true).pop(false);
                    },
                  )
              ),
              //SizedBox(width: ScreenUtil().setWidth(10),),
              SizedBox(
                  width : ScreenUtil().setWidth(100),
                  height : ScreenUtil().setHeight(45),
                  child: ElevatedButton(
                    child: const Text('위치확인'),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.deepPurple,
                        //padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                        textStyle: TextStyle(
                            fontSize: ScreenUtil().setSp(16),
                            fontWeight: FontWeight.bold)
                    ),
                    onPressed:() {
                      _counter=0;
                      _timer?.cancel();
                      _stopSound();
                      Navigator.of(context, rootNavigator: true).pop(false);//true로 앞에 있으면 닫아지고 뒤에 있으면 닫아지지 않음
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>
                          WorkerMap(latitude: geolatitude , longitude: geolongitude, name: name, state: state)));
                    },
                  )
              ),
            ]
          ),
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
              logger.warning('newAlertD TimeExpire:'+state);
              _counter=0;
              _timer?.cancel();
              _stopSound();
              Navigator.of(builderContext).pop(true);
            }
            logger.warning(_counter);
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
  final List<Widget> _bodyManager = [Home(),First2(), Profile()];
  final List<Widget> _bodyWorker = [Home(), Profile()];
  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBgColor,
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
                  logger.warning('beltStateScaffold:'+beltState.toString());
                  text = ' 연결끊기';*/
                  text = ' 연결됨';
                  break;
                case BluetoothDeviceState.disconnected:
                   _onPressed = () =>// newAlertD(context, displayName!, '응급상황');
                       Navigator.of(context).push(
                           MaterialPageRoute(
                               builder: (context) =>
                                   FindDevicesScreen())).then((value) =>
                           setState(() {})); //_startscan();*/
                   batteryPercent =0;
                   logger.warning(bTdevice?.name);
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
                    logger.warning('-------- Bt State Disconnected --------');
                    writecharacteristic=0;
                    isConnected=false;
                    if(!beltState) {
                      beltState=false;
                    } else
                      {
                      _stopSound();
                      _setAsset('assets/audio/alram1.mp3');
                      _setLoopMode(LoopMode.one);
                      _playSound();//player.play();
                      isHelmetDisconnected=true;
                      addNewPopupU("연결해제", 15);
                    }
                  }
                else if(event==BluetoothDeviceState.connected &&isConnected==false){
                  logger.warning('-------- Bt State connected ---------');
                  if(isHelmetDisconnected)
                    {
                      _stopSound();
                      if(_counterA==0) {
                        addStateToGuestBook('연결복귀');
                      }
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
                  _timer_beltinit = Timer.periodic(const Duration(milliseconds: 100), (timer) {
                  logger.warning('req belt => current beltstate:'+ beltState.toString());
                  if (beltState==false){
                      writecharacteristic.write(utf8.encode('belt status'));}
                  else{
                      _timer_beltinit?.cancel();}
                  });

                  _timer_bat?.cancel();
                  _timer_bat = Timer.periodic(const Duration(milliseconds: 100), (timer) {
                      logger.warning('req batt');
                      writecharacteristic.write(utf8.encode('req bat'));
                  });

                }
                btState=event;
                logger.warning('---------- End of appBarState:listen ----------');

              });
              return ElevatedButton(
                  onPressed:_onPressed,
                    /*
                    () {
                     logger.warning('--------------');
                     logger.warning(bTdevice?.name);
                     _onPressed;
                  },*/
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Icon(Icons.battery_std, color: Colors.white),
                      Text(
                        batteryPercent.round().toString()+'%  ',
                        style: Theme.of(context)
                            .primaryTextTheme
                            .button
                            ?.copyWith(color: Colors.white,fontSize: 18),
                      ),
                        (text == ' 연결끊기')
                          ? const Icon(Icons.bluetooth_connected_rounded, color: Colors.white)
                          : const Icon(Icons.bluetooth_searching_outlined, color: Colors.white),
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


      //body: (logEmail=='jay@tinkerbox.kr'||logEmail=='uzbrainnet@gmail.com') ? _bodyManager[_currentIndex]:_bodyWorker[_currentIndex],
      body: (role=='manager') ? _bodyManager[_currentIndex]:_bodyWorker[_currentIndex],
       //bottomNavigationBar: (logEmail=='jay@tinkerbox.kr'||logEmail=='uzbrainnet@gmail.com') ? BottomNavigationBar(
      bottomNavigationBar: (role=='manager') ? BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          onTap: _onTap,
          currentIndex: _currentIndex,
          // ignore: prefer_const_literals_to_create_immutables
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('홈'),
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.find_in_page),
              title: Text('작업자현황'),
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text('프로필'),
            ),
          ]):BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          onTap: _onTap,
          currentIndex: _currentIndex,
          // ignore: prefer_const_literals_to_create_immutables
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('홈'),
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text('프로필'),
            ),
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
    'name': '그밖의상황',
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
        physics: const BouncingScrollPhysics(),
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
        physics: const NeverScrollableScrollPhysics(),
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
                      const SizedBox(height: 10.0),
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
      // ignore: avoid_unnecessary_containers
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
        physics: const NeverScrollableScrollPhysics(),
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
                      const SizedBox(height: 10.0),
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