// ignore: file_names

// ignore_for_file: file_names
// new
import 'dart:convert';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gtk_flutter/main.dart';
import 'package:provider/provider.dart';

import '/constant/constant.dart';
import '../main.dart';

import './splashScreen.dart';


StreamSubscription? subEventConnecting;
/*
StreamController<int>? event4Connect;

ValueNotifier<double>? batteryPercent;

Timer? _timer_bat;
Timer? _timer_beltinit;

Timer? _timer; //new alertD

int _counter = 0;
int counterA = 0; //new alertA
StreamController<int>? _events;
StreamController<int>? _eventsA;



var writecharacteristic;


Future<void> connectMyProtocol(BluetoothDevice? device) async {
  //Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  //final SharedPreferences prefs = await _prefs;

  if(device == null) { logger.warning('connectMyProtocol null return'); return;}
  logger.warning('connectMyProtocol ');
  //List<BluetoothService> services = await device.discoverServices();
  // CODE DOES NOT
  logger.warning('div');
  notistate?.cancel();
  notistate= device.state.listen((bstate) {
    logger.warning('device.state: {$bstate}');
    if (bstate == BluetoothDeviceState.connected)  {

      //prefs.setString('lasthelmet', device.name);
      //logger.shout(prefs.getInt('lasthelmet'));

      device.discoverServices().then((dservice) {
        //services = dservice;
        for(BluetoothService service in dservice) {

          logger.severe('discoverServices  : ${service.uuid.toString()}');
          if(service.uuid.toString().contains('6e400001') )
          {
            // Reads all characteristics
            var characteristics = service.characteristics;
            for(BluetoothCharacteristic c in characteristics) {
              logger.warning('characteristics  : ${c.uuid.toString()}');
              if (c.uuid.toString().contains('6e400002'))
              {
                logger.severe('keep writecharacteristic');
                writecharacteristic = c;
              }

              if(c.descriptors.isNotEmpty) {
                c.setNotifyValue(true);
                noti?.cancel();
                noti= c.value.listen((value) {
                  String state='이상없음';
                  //stopSound();
                  String btMessage = ascii.decode(value).toString();
                  logger.warning('------------- Notify Listen -----------------');
                  logger.warning('listenMsg: '+ btMessage.toString());
                  if(btMessage.contains('BAT')){
                    int adcBatt = int.parse(btMessage.substring(btMessage.lastIndexOf(",")+1));

                    if(adcBatt>2100) {
                      _timer_bat?.cancel();
                      _timer_bat = Timer.periodic(const Duration(seconds: 60), (timer) {
                        if(writecharacteristic!=null) {
                          writecharacteristic.write(utf8.encode('req bat'));
                        }
                      });
                    }

                    if(adcBatt>3006)
                      adcBatt = 3006;
                    else if(adcBatt<2300)
                      adcBatt = 2300;
                    //setState(() {
                   //   batteryPercent =(((adcBatt-2300)/(3006-2300))*100);
                    //});

                  }
                  else if((btMessage.contains('Belt Connected')||btMessage.toString().contains('Belt Alive'))&&beltState==false) {
                    state = '턱끈연결';
                    beltState = true;
                    setAsset('assets/audio/conBelt.mp3');
                    setLoopMode(LoopMode.off);

                    logger.warning('Notify beltstate T: ${iuserId}, ${attendees}');
                    setMyBeltState(iuserId,3, ++attendees);
                    // setAccidentIncrease(iuserId, attendees); //jay set my bel state 함수 안으로 이동
                  }
                  else if(btMessage.contains('Belt Disconnected')&&beltState==true) {
                    state = '턱끈해제';
                    beltState = false;
                    setAsset('assets/audio/belt0.mp3');
                    setLoopMode(LoopMode.off);

                    logger.warning('Notify beltstate F: ${iuserId}, ${attendees}');
                    setMyBeltState(iuserId, 1 , 0);
                  }
                  else if(btMessage.contains('EM')) {
                    state = '위급상황';
                    setAsset('assets/audio/alram1.mp3');
                    setLoopMode(LoopMode.one);
                  }
                  else if(btMessage.contains('IA')) {
                    state = '무활동반응';
                    setAsset('assets/audio/alram1.mp3');
                    setLoopMode(LoopMode.one);
                  }
                  else if(btMessage.contains('FF')) {
                    state = '추락사고';
                    setAsset('assets/audio/alram1.mp3');
                    setLoopMode(LoopMode.one);
                  }
                  else if(btMessage.contains('IM')) {
                    state = '충격사고';
                    setAsset('assets/audio/alram1.mp3');
                    setLoopMode(LoopMode.one);
                  }


                  if(_counter==0&& state!='이상없음'){
                    //stopSound();
                    playSound();
                    addStateToGuestBook(state);

                    if(state!='턱끈연결'&&state!='턱끈해제') {
                      if(_events!=null) {
                        _events?.close();
                      }
                      _events = StreamController<int>();
                      _events?.add(60);
                     // alertD(context, state);

                      /*  if(state=='위급상황') {
                          alertD(context, state);
                        }
                        else {
                          newAlertD(context, displayName,  geolatitude.toString()+ ', ' +geolongitude.toString(), state);
                        }*/
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
*/
/*

Future<void> connectMyProtocol(BluetoothDevice? device) async {

  batteryPercent = ValueNotifier<double>(0);

  //Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  //final SharedPreferences prefs = await _prefs;

  if(device == null) { logger.warning('connectMyProtocol null return'); return;}

  logger.warning('connectMyProtocol go on');
  List<BluetoothService> services = await device.discoverServices();
  // CODE DOES NOT
  notistate?.cancel();
  notistate= device.state.listen((bstate) {
    logger.warning('-- Bt State Change : bTdevice.state' +bstate.toString()+ ', isConnected:'+isConnected.toString()+ ', isBluetoothDisconnectOnBeltConnected:'+isBluetoothDisconnectOnBeltConnected.toString()+', beltState:'+beltState.toString()+', isDissconnectbyMenu:'+isDissconnectbyMenu.toString() );

    btState = bstate;

    if (bstate == BluetoothDeviceState.connected)  {
      //prefs.setString('lasthelmet', device.name);
      //logger.shout(prefs.getInt('lasthelmet'));
      device.discoverServices().then((services) {
        logger.warning('--- BT discoverServices -- ');
        for(BluetoothService service in services) {
          logger.warning('---- BT Service : ${service.uuid.toString()} ');

          if(service.uuid.toString().contains('6e400001') )
          {
            // Reads all characteristics
            var characteristics = service.characteristics;
            for(BluetoothCharacteristic c in characteristics) {

              logger.warning('----- BT characteristics : ${c.uuid.toString()} ');
              if (c.uuid.toString().contains('6e400002'))
              {
                logger.warning('------ keep writecharacteristic');
                writecharacteristic = c;
                event4Connect!.add(1); //todo jay 확인하자 여기가 적절할지
              }

              if(c.descriptors.isNotEmpty) {
                c.setNotifyValue(true);
                logger.warning('------ Set Notify');
                noti?.cancel();
                noti= c.value.listen((value) {

                  logger.warning('------- BT characteristics.listen');
                  String state='이상없음';
                  //stopSound();
                  String btMessage = ascii.decode(value).toString();
                  logger.warning('-------- listen Msg: '+ btMessage.toString());

                  if(btMessage.contains('BAT')){
                    int adcBatt = int.parse(btMessage.substring(btMessage.lastIndexOf(",")+1));

                    if(adcBatt>2100) {
                      _timer_bat?.cancel();
                      _timer_bat = Timer.periodic(const Duration(seconds: 60), (timer) {
                        if(writecharacteristic!=null &&beltState==false) {
                          writecharacteristic.write(utf8.encode('req bat'));
                        }
                      });
                    }

                    if(adcBatt>3006)
                      adcBatt = 3006;
                    else if(adcBatt<2300)
                      adcBatt = 2300;

                    batteryPercent!.value =(((adcBatt-2300)/(3006-2300))*100);
                  }
                  else if((btMessage.contains('Belt Connected')||btMessage.toString().contains('Belt Alive'))&&beltState==false) {
                    state = '턱끈연결';
                    beltState = true;
                    setAsset('assets/audio/conBelt.mp3');
                    setLoopMode(LoopMode.off);

                    logger.warning('Notify beltstate T: ${iuserId}, ${attendees}');
                    setMyBeltState(iuserId,3, ++attendees);
                    // setAccidentIncrease(iuserId, attendees); //jay set my bel state 함수 안으로 이동
                  }
                  else if(btMessage.contains('Belt Disconnected')&&beltState==true) {
                    state = '턱끈해제';
                    beltState = false;
                    setAsset('assets/audio/belt0.mp3');
                    setLoopMode(LoopMode.off);

                    logger.warning('Notify beltstate F: ${iuserId}, ${attendees}');
                    setMyBeltState(iuserId, 1 , 0);
                  }
                  else if(btMessage.contains('EM')) {
                    state = '위급상황';
                    setAsset('assets/audio/alram1.mp3');
                    setLoopMode(LoopMode.one);
                  }
                  else if(btMessage.contains('IA')) {
                    state = '무활동반응';
                    setAsset('assets/audio/alram1.mp3');
                    setLoopMode(LoopMode.one);
                  }
                  else if(btMessage.contains('FF')) {
                    state = '추락사고';
                    setAsset('assets/audio/alram1.mp3');
                    setLoopMode(LoopMode.one);
                  }
                  else if(btMessage.contains('IM')) {
                    state = '충격사고';
                    setAsset('assets/audio/alram1.mp3');
                    setLoopMode(LoopMode.one);
                  }


                  if(_counter ==0&& state!='이상없음'){//todo jay 여기 카운터 원래는 homepae class안에 있던거임
                    //stopSound();
                    playSound();
                    addStateToGuestBook(state);

                    if(state!='턱끈연결'&&state!='턱끈해제') {
                      if(_events!=null) {
                        _events?.close();
                      }
                      _events = StreamController<int>();
                      _events?.add(60);
                      //todo jay alertD(context, state);
                      //alertD(navigatorKey.currentContext!, state);

                      /*  if(state=='위급상황') {
                          alertD(context, state);
                        }
                        else {
                          newAlertD(context, displayName,  geolatitude.toString()+ ', ' +geolongitude.toString(), state);
                        }*/
                    }
                  }
                  logger.warning('------------- End of listenB('+state+') -------------');
                });
              }
            }
          }
        }
      });
      if(isConnected==false){
        logger.warning('-------- Bt Paringg connected ---------');
        if(isBluetoothDisconnectOnBeltConnected) {
          stopSound();
          if(counterA==0) { //todo 커넥트가 들어올 때 0인경우가 거진 없으니..
            addStateToGuestBook('연결복귀');
            // todo 1029 살펴보자 원래 막혀있 1019 jay BT Noti에서 어짜피 붙여주니까. 그대로 두면 턱끈없이 BT연결되도 BT set 됨. setMyBeltState(iuserId,3, attendees); //전원이랑 턱끈이랑 연결되엉있어 BT가 연결되면 턲끈이 있다 봐도 무방함
          }
          //_counterA=0;
          _timer?.cancel();
          if(isDissconnectbyMenu ==false&&isDialogAlive==true) {
            isDialogAlive=false;
            // todo jay 1028 Navigator.of(context, rootNavigator: true).pop(false);
          }
          isDissconnectbyMenu=false;
        }

        // setMyHelmetBtState(iuserId, true);
        isBluetoothDisconnectOnBeltConnected=false;
        isConnected = true;
        //jay await connectMyProtocol( bTdevice);

        _timer_beltinit?.cancel();
        _timer_beltinit = Timer.periodic(const Duration(milliseconds: 250), (timer) {
          logger.warning('req belt => current beltstate:'+ beltState.toString());
          if(writecharacteristic!=null &&beltState==false) {
            writecharacteristic.write(utf8.encode('belt status'));
          }

          else{
            _timer_beltinit?.cancel();
          }
        });

        _timer_bat?.cancel();
        _timer_bat = Timer.periodic(const Duration(milliseconds: 250), (timer) {
          logger.warning('req batt => current beltstate:'+ beltState.toString());
          if(writecharacteristic!=null && beltState ==true) {
            writecharacteristic.write(utf8.encode('req bat'));
          }
        });
      }
    } else if(bstate==BluetoothDeviceState.disconnected &&isConnected==true) {
      logger.warning('-------- Bt Paring Disconnected --------');
      writecharacteristic=null;
      isConnected=false;
      if(beltState == true) {
        if(isDissconnectbyMenu==true) {
          stopSound();
          //todo jay addNewPopupU("연결끊기"/*유저의 의도적 (메뉴)연결해제*/, 3);
          //addNewPopupU("연결끊기"/*유저의 의도적 (메뉴)연결해제*/, 3);
        }
        else {
          stopSound();
          /*
            setAsset('assets/audio/alram beeps.mp3');
            setLoopMode(LoopMode.one);
            playSound();
          */
          //todo jay addNewPopupU("연결해제", 15);
          //addNewPopupU("연결해제", 15);
          //setMyBeltState(iuserId,2, 0);
        }
        beltState = false; //1019: add by jay bt noty가 안오므로 여기서 false해줘야함
        //setMyHelmetBtState(iuserId, false);
        isBluetoothDisconnectOnBeltConnected=true;
        isDissconnectbyMenu=false;
      }
      _timer_bat?.cancel();
      _timer_beltinit?.cancel();
    }
  });
  logger.warning('---- BT End ----');
}
*/
class ParingScreen extends StatefulWidget {
  BluetoothDevice? bTdevice;
  int? scanevent;

  ParingScreen({Key? key, @required this.bTdevice, this.scanevent }) : super(key: key);

  @override
  _ParingScreenState createState() => _ParingScreenState();
}


class _ParingScreenState extends State<ParingScreen> {


  @override
  void initState() {
    super.initState();
    event4Connect= StreamController<int>();
    logger.shout('ParingScreen Init');

    subEventConnecting = event4Connect!.stream.listen((eventconnect) {
      logger.shout('_event4event4Connect: ${eventconnect}');
      if(eventconnect==1) {
        subEventConnecting!.cancel();
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>
                ChangeNotifierProvider(
                  create: (context) => ApplicationState(),
                  builder: (context, _) => HomePage(),//App2(), //
                ),
            ));
      }
    });

    if(widget.scanevent ==1) {
      connectMyProtocol(widget.bTdevice);
    }
  }

  @override
  Widget build(BuildContext context) {
    logger.shout('ParingScreen build');
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(fixPadding),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              (widget.scanevent ==1)?
              Column(
                children: [
                  Image.asset(
                    'assets/image/helmet.png',
                    width: 100.0,
                    fit: BoxFit.fitWidth,
                  ),
                  heightSpace,
                  heightSpace,
                  Text('등록된 ${widget.bTdevice!.name}를 찾았습니다',
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 18.0,
                      )
                    //listItemTitleStyle,
                  ),
                   const Text('연결을 시도합니다',
                      style: TextStyle(
                        color: Colors.deepPurple,
                        fontSize: 16.0,
                      )
                    //listItemTitleStyle,
                  ),
                  heightSpace,
                  const SpinKitPulse(
                    color: Colors.deepPurple,//primaryColor,
                    size: 50.0,
                  ),
                ],
              )
              :(widget.scanevent ==2)?Column(
                children: [
                  heightSpace,
                  const Text('등록된 스마트안전모를 찾을 수 없습니다',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                  ),
                  const Text('안전모의 상태를 확인해 주세요',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      )
                  ),
                  heightSpace,
                  heightSpace,
                  heightSpace,
                  Row(
                    mainAxisAlignment:MainAxisAlignment.spaceEvenly ,
                    children: [
                      FloatingActionButton.extended(
                        heroTag: "btn1",
                        onPressed: () =>Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) =>
                                SplashScreen(),
                            )),
                        /*icon: const Icon(Icons.search,
                            //color: Colors.deepPurple,
                        ),*/
                        label: const Text("내안전모 다시찾기",
                            style: TextStyle(
                              //color: Colors.deepPurple,
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            )
                        ),
                        backgroundColor: Colors.deepPurple,
                        hoverColor: Colors.black54,
                        splashColor: Colors.black54,

                      ),
                      FloatingActionButton.extended(
                        heroTag: "btn2",
                        onPressed: () {
                          subEventScanning!.cancel();
                          subIsScanning!.cancel();
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) =>
                                FindDevicesScreen(),
                            ));},
                        //icon: const Icon(Icons.add_link),
                        label: const Text("새안전모 등록하기"),
                      ),
                    ],
                  ),
                ],
              ):Column(
                children: const [
                  Text('장치찾기 상태오류 발생',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 18.0,
                      )
                    //listItemTitleStyle,
                  ),
                ],
              ),
              /*
              StreamBuilder<bool>(
                stream: FlutterBlue.instance.isScanning,
                initialData: false,
                builder: (c, snapshot) {
                  if (snapshot.data!) {
                    return  Column(
                      children:  [
                        Text(' 등록된 장치를 찾았습니다',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 18.0,
                            )
                          //listItemTitleStyle,

                        ),
                        heightSpace,
                        SpinKitPulse(
                          color: Colors.deepPurple,//primaryColor,
                          size: 50.0,
                        ),
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        (deviceName=='null')?
                        Text(
                          '등록된 장치 없음',
                          style: listItemTitleStyle,
                        ):Text(
                          '장치를 찾았습니다: ${deviceName}\n자동연결을 시작합니다.',
                          style: listItemTitleStyle,
                        ),
                        heightSpace,
                      ],
                    );
                    /*FloatingActionButton(
                        child: Icon(Icons.search),
                        onPressed: () => FlutterBlue.instance
                            .startScan(timeout: Duration(seconds: 4)));*/
                  }
                },
              ),
      */
            ],
          ),
        ),
      ),
    );
  }
}
