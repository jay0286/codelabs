import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:gtk_flutter/main.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'widgets.dart';

enum ApplicationLoginState {
  loggedOut,
  emailAddress,
  register,
  password,
  loggedIn,
}

class Authentication extends StatelessWidget {
  const Authentication({
    required this.loginState,
    required this.email,
    required this.startLoginFlow,
    required this.verifyEmail,
    required this.signInWithEmailAndPassword,
    required this.cancelRegistration,
    required this.registerAccount,
    required this.signOut,
  });

  final ApplicationLoginState loginState;
  final String? email;
  final void Function() startLoginFlow;
  final void Function(
    String email,
    void Function(Exception e) error,
  ) verifyEmail;
  final void Function(
    String email,
    String password,
    void Function(Exception e) error,
  ) signInWithEmailAndPassword;
  final void Function() cancelRegistration;
  final void Function(
      String email,
      String displayName,
      String phone,
      String password,
      String role,
      String workzone,
    void Function(Exception e) error,
  ) registerAccount;
  final void Function() signOut;

  @override
  Widget build(BuildContext context) {
    switch (loginState) {
      case ApplicationLoginState.loggedOut:
        return Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 24, bottom: 8),
              child: StyledButton(
                onPressed: () {
                  startLoginFlow();
                },
                child: const Text('작업 시작 하기'),
                //child: const Text('관리 시작 하기'),
              ),
            ),
          ],
        );
      case ApplicationLoginState.emailAddress:
        return EmailForm(
            callback: (email) => verifyEmail(
                email, (e) => _showErrorDialog(context, '메일 형식을 확인하세요', e)));
      case ApplicationLoginState.password:
        return PasswordForm(
          email: email!,
          login: (email, password) {
            signInWithEmailAndPassword(email, password,
                (e) => _showErrorDialog(context, '로그인 실패', e));
          },
        );
      case ApplicationLoginState.register:
        return RegisterForm(
          email: email!,
          cancel: () {
            cancelRegistration();
          },
          registerAccount: (
            email,
            displayName,
            phone,
            password,
              role,
              workzone,
          ) {
            registerAccount(
                email,
                displayName,
                phone,
                password,
                role,
                workzone,
                (e) =>
                    _showErrorDialog(context, '메일 계정 생성 실패', e));
          },
        );
      case ApplicationLoginState.loggedIn:
        return Row(
          children: [
            /*
            Padding(
              padding: const EdgeInsets.only(left: 24, bottom: 8),
              child: StyledButton(
                onPressed: () {
                  //signOut();
                  if(btState==BluetoothDeviceState.disconnected) {
                    signOut();
                  }
                  else {
                    // ignore: deprecated_member_use
                    Fluttertoast.showToast(
                      msg: '먼저 스마트헬멧 연결을 종료해 주세요',
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                    );
                  }
                },
                child: const Text('로그아웃'),
              ),
            ),

             */
          ],
        );
      default:
        return Row(
          children: const [
            Text("에러가 발생했습니다, this shouldn't happen..."),
          ],
        );
    }
  }

  void _showErrorDialog(BuildContext context, String title, Exception e) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            title,
            style: const TextStyle(fontSize: 24),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  '${(e as dynamic).message}',
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            StyledButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.deepPurple),
              ),
            ),
          ],
        );
      },
    );
  }
}

class EmailForm extends StatefulWidget {
  const EmailForm({required this.callback});
  final void Function(String email) callback;
  @override
  _EmailFormState createState() => _EmailFormState();
}

class _EmailFormState extends State<EmailForm> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_EmailFormState');
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Header('메일 어드레스 가입/로그인'),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: TextFormField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: '메일 주소를 입력하세요',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return '메일 주소를 입력하고 다음 버튼을 누르세요';
                      }
                      return null;
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 30),
                      child: StyledButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            widget.callback(_controller.text);
                          }
                        },
                        child: const Text('다음'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({
    required this.registerAccount,
    required this.cancel,
    required this.email,
  });
  final String email;
  final void Function(String email, String displayName,String phone, String password,String role, String workzone)
      registerAccount;
  final void Function() cancel;
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

int _valueworkzone = 1;
int _valuerole = 1;

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_RegisterFormState');
  final _emailController = TextEditingController();
  final _displayNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.email;
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        const SizedBox(height:25),
        const Header('계정 생성하기'),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      hintText: '메일 주소를 입력해 주세요',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return '메일 주소를 입력하고, 다음을 눌러주세요';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: TextFormField(
                    controller: _displayNameController,
                    decoration: const InputDecoration(
                      hintText: '성명을 넣어주세요',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return '성명을 입력해 주세요';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: TextFormField(
                    controller: _phoneNumberController,
                    decoration: const InputDecoration(
                      hintText: '휴대폰 번호를 입력해 주세요',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return '휴대폰 번호를 입력해 주세요';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      hintText: '암호',
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return '암호를 입력해 주세요';
                      }
                      return null;
                    },
                  ),
                ),

                const SizedBox(height:25),
                const Center(child: Header('추가 정보')),

                const SizedBox(height:10),
                Row(
                  children: [
                    const Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text('작업 현장명:',
                        style:TextStyle(
                          //fontSize: 18,
                          //color: color,
                          //fontWeight: FontWeight.w700 ,
                        ),
                      ),
                    ),
                    DropdownButton(
                        icon: const Icon(Icons.keyboard_arrow_down_rounded),
                        iconSize: 24,
                        elevation: 16,
                        style: const TextStyle(
                            color: Colors.deepPurple
                        ),
                        underline: Container(
                          height: 2,
                          color: Colors.deepPurpleAccent,
                        ),
                        value: _valueworkzone,
                        items: const [
                          DropdownMenuItem(
                            child: Text("부산 A지구"),
                            value: 1,
                          ),
                          DropdownMenuItem(
                            child: Text("부산 B지구"),
                            value: 2,
                          ),
                          DropdownMenuItem(
                            child: Text("서울 가산지구"),
                            value: 3,
                          ),
                          DropdownMenuItem(
                            child: Text("수원 고등지구"),
                            value: 4,
                          ),
                          DropdownMenuItem(
                            child: Text("서울 사학연금"),
                            value: 5,
                          ),
                          DropdownMenuItem(
                            child: Text("대전 메가허브"),
                            value: 6,
                          )
                        ],
                        onChanged: ( int? value) {
                          setState(() {
                            logger.warning('value ${value}');
                            _valueworkzone = value!;
                          });
                        },
                        hint:const Text("Select item")
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Text('관리/작업 직무 :',
                        style:TextStyle(
                          //fontSize: 18,
                          //color: color,
                          //fontWeight: FontWeight.w700 ,
                        ),
                      ),
                    ),
                    DropdownButton(
                        icon: const Icon(Icons.keyboard_arrow_down_rounded),
                        iconSize: 24,
                        elevation: 16,
                        style: const TextStyle(
                            color: Colors.deepPurple
                        ),
                        underline: Container(
                          height: 2,
                          color: Colors.deepPurpleAccent,
                        ),
                        value: _valuerole,
                        items: const [
                          DropdownMenuItem(
                            child: Text("작업자"),
                            value: 1,
                          ),
                          DropdownMenuItem(
                            child: Text("관리자"),
                            value: 2,
                          )
                        ],
                        onChanged: ( int? value) {
                          setState(() {
                            logger.warning('value ${value}');
                            _valuerole = value!;
                          });
                        },
                        hint:const Text("Select item")
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: widget.cancel,
                        child: const Text('취소'),
                      ),
                      const SizedBox(width: 16),
                      StyledButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                             widget.registerAccount(
                               _emailController.text,
                               _displayNameController.text,
                               _phoneNumberController.text,
                               _passwordController.text,
                               (_valuerole==1)?'worker':'manager',
                               (_valueworkzone==1)?'부산 A지구':(_valueworkzone==2)?'부산 B지구':(_valueworkzone==3)?'서울 가산지구':(_valueworkzone==4)?'수원 고등지구':(_valueworkzone==5)?'서울 사학연금':'대전 메가허브',
                            );
                          }
                        },
                        child: const Text('저장'),
                      ),
                      const SizedBox(width: 30),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class PasswordForm extends StatefulWidget {
  const PasswordForm({
    required this.login,
    required this.email,
  });
  final String email;
  final void Function(String email, String password) login;
  @override
  _PasswordFormState createState() => _PasswordFormState();
}

class _PasswordFormState extends State<PasswordForm> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_PasswordFormState');
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.email;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Header('로그인'),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      hintText: '메일 주소를 입력해 주세요',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return '메일 주소를 입력하고, 다음을 눌러 계속해 주세요';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      hintText: '암호',
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return '암호를 입력해 주세요';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const SizedBox(width: 16),
                      StyledButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            widget.login(
                              _emailController.text,
                              _passwordController.text,
                            );
                          }
                        },
                        child: const Text('로그인'),
                      ),
                      const SizedBox(width: 30),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
