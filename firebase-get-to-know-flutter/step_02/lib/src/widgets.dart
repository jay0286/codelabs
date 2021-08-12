import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '/constant/constant.dart';

class Header extends StatelessWidget {
  const Header(this.heading);
  final String heading;

  @override
  Widget build(BuildContext context) =>
      /*Container(
        margin:  EdgeInsets.all(fixPadding * 0.5),
        padding: const EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        //alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: Colors.deepPurple,
          //color: Colors.white,
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
        child: Text(heading,
          style:TextStyle(
            fontSize: ScreenUtil().setSp(18),
            color: Colors.white,
            fontWeight: FontWeight.w700 ,
          ),
          //style: white16BoldTextStyle,
        ),
      );*/

      Padding(
        padding: const EdgeInsets.only(left: 15.0,top: 0, bottom: 0),
        child:
        Text(
          heading,
          style:  TextStyle(fontSize: ScreenUtil().setWidth(15),fontWeight: FontWeight.bold),
        ),
      );
}

class Paragraph extends StatelessWidget {
  const Paragraph(this.content);
  final String content;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          content,
          style: const TextStyle(fontSize: 18),
        ),
      );
}

class IconAndDetail extends StatelessWidget {
  const IconAndDetail(this.icon, this.detail);
  final IconData icon;
  final String detail;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(left: 10.0,top: 2),
        child: Row(
          children: [
            Icon(icon,size: ScreenUtil().setWidth(16),),
            const SizedBox(width: 8), //ScreenUtil().setWidth(8)
            Text(
              detail,
              style:  TextStyle(fontSize: ScreenUtil().setSp(15)),
            )
          ],
        ),
      );
}

class StyledButton extends StatelessWidget {
  const StyledButton({required this.child, required this.onPressed});
  final Widget child;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) => OutlinedButton(
        style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.deepPurple)),
        onPressed: onPressed,
        child: child,
      );
}
