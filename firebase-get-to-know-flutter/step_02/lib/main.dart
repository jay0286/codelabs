
//구글파이어스토어 로그
import 'dart:async';                                    // new
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';  // new

import 'package:firebase_core/firebase_core.dart'; // new
import 'package:firebase_auth/firebase_auth.dart'; // new
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';           // new

import 'src/authentication.dart';                  // new

import 'src/widgets.dart';

import 'dart:math';
import 'package:flutter_blue/flutter_blue.dart';
import 'widgets.dart';
import 'package:just_audio/just_audio.dart';


import 'package:geolocator/geolocator.dart';

StreamSubscription? noti;

Future<void> connectMyProtocol(BluetoothDevice device) async {
  //device = device;
  await device.connect(timeout: Duration(seconds: 5));
  //await device.requestMtu(250);
  List<BluetoothService> services = await device.discoverServices();
  // CODE DOES NOT
  services.forEach((service) {

    if(service.uuid.toString().contains('6e400001') )
      {
        // Reads all characteristics
        var characteristics = service.characteristics;
        for(BluetoothCharacteristic c in characteristics) {
          //List<int> value =  c.read();
          print('characteristic:'+c.uuid.toString());

          //if(n)
          //noti?.cancel();
          if(c.descriptors!=null ) {
            print(c.descriptors);
            /*await*/ c.setNotifyValue(true);

            noti?.cancel();
            noti= c.value.listen((value) {
              //if (value)
              // do something with new value

              print('listenA:');
              print(ascii.decode(value));
              player.setAsset('assets/audio/moo.mp3');
              FirebaseFirestore.instance.collection('guestbook').add({
                'text': 'message',
                'timestamp': DateTime.now().millisecondsSinceEpoch,
                'name': FirebaseAuth.instance.currentUser!.displayName,
                'userId': FirebaseAuth.instance.currentUser!.uid,
              });

            });
            for (BluetoothDescriptor d in c.descriptors) {
              //List<int> value =  c.read();
              print('descriptors:' + d.uuid.toString());
            }
          }
        }

        //characteristic.value.listen((value) {
          //print('gg'+value);
       // });
      //  print('Device Name : ${r.device.name} // Device ID : ${r.device.id} // Device rssi: ${r.rssi}');
      }

    // do something with service
  });


// Subscribe to connection changes



    device.state.listen((s) {

    print("state.listen");
    if (s == BluetoothDeviceState.connected) {

      device.discoverServices().then((s) {

        services = s;


        for(BluetoothService service in services) {
          if(service.uuid.toString().contains('6e400001') )
          {
            // Reads all characteristics
            var characteristics = service.characteristics;
            for(BluetoothCharacteristic c in characteristics) {
              //List<int> value =  c.read();
              print('characteristic:'+c.uuid.toString());


              if(c.descriptors!=null ) {
                print(c.descriptors);

                /*await*/ c.setNotifyValue(true);

                noti?.cancel();
                noti= c.value.listen((value) {
                  //if (value)
                  // do something with new value

                  print('listenB:');
                  print(ascii.decode(value));
                  player.setAsset('assets/audio/moo.mp3');
                  FirebaseFirestore.instance.collection('guestbook').add({
                    'text': 'message2',
                    'timestamp': DateTime.now().millisecondsSinceEpoch,
                    'name': FirebaseAuth.instance.currentUser!.displayName,
                    'userId': FirebaseAuth.instance.currentUser!.uid,
                  });


                });
                for (BluetoothDescriptor d in c.descriptors) {
                  //List<int> value =  c.read();
                  print('descriptors:' + d.uuid.toString());
                }
              }
            }

            //characteristic.value.listen((value) {
            //print('gg'+value);
            // });
            //  print('Device Name : ${r.device.name} // Device ID : ${r.device.id} // Device rssi: ${r.rssi}');
          }

          /*
          for(BluetoothCharacteristic c in service.characteristics) {
            if(c.uuid == new Guid("06d1e5e7-79ad-4a71-8faa-373789f7d93c")) {
           //   _writeCharacteristic(c);
            } else {
              print("Nope");
            }
          }*/
        }

      });
    }
  });
  //myService = services.firstWhere((service) => service.uuid.toString() == '4444');

  //BluetoothCharacteristic endpointCharacteristic = scService.characteristics.firstWhere(
   //       (c) => c.uuid.toString() == SCSEndpointCharacteristic
  //);
  //await endpointCharacteristic.setNotifyValue(true);

  /*
  endpointCharacteristic.value.listen((List<int> value) {
    return;
  }*/
    //  _serverInitialized = true;
  }

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
            Icon(
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

class FindDevicesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Find Devices'),
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            FlutterBlue.instance.startScan(timeout: Duration(seconds: 4)),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              StreamBuilder<List<BluetoothDevice>>(
                stream: Stream.periodic(Duration(seconds: 2))
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
                            child: Text('OPEN'),
                            onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        DeviceScreen(device: d))),
                          );
                        }
                        return Text(snapshot.data.toString());
                      },
                    ),
                  ))
                      .toList(),
                ),
              ),
              StreamBuilder<List<ScanResult>>(
                stream: FlutterBlue.instance.scanResults,
                initialData: [],
                builder: (c, snapshot) => Column(
                  children: snapshot.data!
                      .map(
                        (r) => ScanResultTile(
                      result: r,
                      onTap: () => Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        r.device.connect();
                        return DeviceScreen(device: r.device);
                      })),
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
              child: Icon(Icons.stop),
              onPressed: () => FlutterBlue.instance.stopScan(),
              backgroundColor: Colors.red,
            );
          } else {
            return FloatingActionButton(
                child: Icon(Icons.search),
                onPressed: () => FlutterBlue.instance
                    .startScan(timeout: Duration(seconds: 4)));
          }
        },
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
            initialData: BluetoothDeviceState.connecting,
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
                  text = 'CONNECT';
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
                    ? Icon(Icons.bluetooth_connected)
                    : Icon(Icons.bluetooth_disabled),
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
                      IconButton(
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
                  icon: Icon(Icons.edit),
                  onPressed: () => device.requestMtu(223),
                ),
              ),
            ),
            StreamBuilder<List<BluetoothService>>(
              stream: device.services,
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
late AudioPlayer player;
class _YesNoSelectionState extends State<YesNoSelection> {



  void initState() {
    // TODO: implement initState

    super.initState();

//ble instance 생성

    flutterBlue = FlutterBlue.instance;


    player = AudioPlayer();
  }


  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  void _startscan() {
    // 검색 시작 -> 검색 시간 4초

    flutterBlue.startScan(timeout: Duration(seconds: 4));



// 해당되는 ScanResult 는 Print 합니다.

    var subscription = flutterBlue.scanResults.listen((results) {

      // do something with scan results
      for (ScanResult r in results) {
        print('Device Name : ${r.device.name} // Device ID : ${r.device.id} // Device rssi: ${r.rssi}');
        if(r.device.name.contains('Smart Helmet')){
          flutterBlue.stopScan();
          connectMyProtocol(r.device);
        }
      }

    });

  }

  @override
  Widget build(BuildContext context) {
    switch (widget.state) {
      case Attending.yes:
        return Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(elevation: 0),
                onPressed: () => widget.onSelection(Attending.yes),
                child: Text('YES'),
              ),
              SizedBox(width: 8),
              TextButton(
                onPressed: () {  player.setAsset('assets/audio/moo.mp3');
                player.play();
               // widget.addMessage(_controller.text);
                widget.onSelection(Attending.no);},
                child: Text('NO'),
              ),
            ],
          ),
        );
      case Attending.no:
        return Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: [
              TextButton(
                onPressed: () {_startscan();widget.onSelection(Attending.yes);},
                child: Text('YES'),
              ),
              SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(elevation: 0),
                //widget.addMessage(_controller.text);
                onPressed: ()  {  player.setAsset('assets/audio/moo.mp3');
                player.play();
                widget.onSelection(Attending.no);},
                child: Text('NO'),
              ),
            ],
          ),
        );
      default:
        return Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: [
              StyledButton(
                onPressed: () {_startscan();widget.onSelection(Attending.yes);},
                child: Text('YES'),
              ),
              SizedBox(width: 8),
              StyledButton(
                onPressed: ()  {  player.setAsset('assets/audio/moo.mp3');
                player.play();
                widget.onSelection(Attending.no);},
                child: Text('NO'),
              ),
            ],
          ),
        );
    }
  }
}


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


class MyApp extends StatelessWidget {

  @override

  Widget build(BuildContext context) {

    return MaterialApp(

      title: 'Flutter Demo',

      theme: ThemeData(

        primarySwatch: Colors.blue,

        visualDensity: VisualDensity.adaptivePlatformDensity,

      ),

      home: MyHomePage(title: 'Flutter Demo Home Page'),

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

FlutterBlue flutterBlue=FlutterBlue.instance;


class _MyHomePageState extends State<MyHomePage> {

  @override

  void initState() {
    // TODO: implement initState

    super.initState();

//ble instance 생성

    flutterBlue = FlutterBlue.instance;
  }
  void _startscan() {
    // 검색 시작 -> 검색 시간 4초

    flutterBlue.startScan(timeout: Duration(seconds: 4));



// 해당되는 ScanResult 는 Print 합니다.

    var subscription = flutterBlue.scanResults.listen((results) {

      // do something with scan results
      for (ScanResult r in results) {
        print('Device Name : ${r.device.name} // Device ID : ${r.device.id} // Device rssi: ${r.rssi}');
        if(r.device.name.contains('Smart Helmet')){
          flutterBlue.stopScan();
          connectMyProtocol(r.device);
        }
      }

    });

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

        child: Icon(Icons.bluetooth),

      ), // This trailing comma makes auto-formatting nicer for build methods.

    );

  }

}

// ^^^&&&&$%&%&%#%$*#$%*

class GuestBookMessage {
  GuestBookMessage({required this.name, required this.message});
  final String name;
  final String message;
}


class GuestBook extends StatefulWidget {
  // Modify the following line
  GuestBook({required this.addMessage, required this.messages});
  final FutureOr<void> Function(String message) addMessage;
  final List<GuestBookMessage> messages; // new

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
                  hintText: 'Leave a message',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter your message to continue';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(width: 8),
            StyledButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  await widget.addMessage(_controller.text);
                  _controller.clear();
                }
              },
              child: Row(
                children: [
                  Icon(Icons.send),
                  SizedBox(width: 4),
                  Text('SEND'),
                ],
              ),
            ),
          ],
        ),
      ),
        ),
          // Modify from here
          SizedBox(height: 8),
          for (var message in widget.messages)
            Paragraph('${message.name}: ${message.message}'),
          SizedBox(height: 8),
          // to here.
        ],
    );
  }
}


class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

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

    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _loginState = ApplicationLoginState.loggedIn;
        // Add from here
        _guestBookSubscription = FirebaseFirestore.instance
            .collection('guestbook')
            .orderBy('timestamp', descending: true)
            .snapshots()
            .listen((snapshot) {
          _guestBookMessages = [];
          snapshot.docs.forEach((document) {
            _guestBookMessages.add(
              GuestBookMessage(
                name: document.data()['name'],
                message: document.data()['text'],
              ),
            );
          });
          notifyListeners();
        });
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

  int _attendees = 0;
  int get attendees => _attendees;

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
  List<GuestBookMessage> _guestBookMessages = [];
  List<GuestBookMessage> get guestBookMessages => _guestBookMessages;
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

    return FirebaseFirestore.instance.collection('guestbook').add({
      'text': message,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'name': FirebaseAuth.instance.currentUser!.displayName,
      'userId': FirebaseAuth.instance.currentUser!.uid,
    });
  }
// To here
}



class App extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Meetup',
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
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Meetup'),
      ),
      body: ListView(
        children: <Widget>[
          Image.asset('assets/codelab.png'),
          const SizedBox(height: 8),
          const IconAndDetail(Icons.calendar_today, 'October 30'),
          const IconAndDetail(Icons.location_city, 'San Francisco'),
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
          const Divider(
            height: 8,
            thickness: 1,
            indent: 8,
            endIndent: 8,
            color: Colors.grey,
          ),
          const Header("What we'll be doing"),
          const Paragraph(
            'Join us for a day full of Firebase Workshops and Pizza!',
          ),

          Consumer<ApplicationState>(
            builder: (context, appState, _) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Add from here
                if (appState.attendees >= 2)
                  Paragraph('${appState.attendees} people going')
                else if (appState.attendees == 1)
                  Paragraph('1 person going')
                else
                  Paragraph('No one going'),
                // To here.
                if (appState.loginState == ApplicationLoginState.loggedIn) ...[
                  // Add from here
                  YesNoSelection(
                    state: appState.attending,
                    onSelection: (attending) => appState.attending = attending,
                  ),
                  // To here.
                  Header('Discussion'),
                  GuestBook(
                    addMessage: (String message) =>
                        appState.addMessageToGuestBook(message),
                    messages: appState.guestBookMessages, // new

                  ),
                ],
              ],
            ),
          ),
          // To here.
        ],
      ),
    );
  }
}
