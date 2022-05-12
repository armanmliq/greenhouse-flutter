import 'package:flutter/material.dart';
import 'package:greenhouse/screens/login_screen.dart';
import 'package:greenhouse/screens/home_screen.dart';
import 'package:greenhouse/services/auth.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:greenhouse/constant/constant.dart' as constant;

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: constant.backgroundColor,
      child: Column(
        children: [
          AppBar(
            backgroundColor: constant.bgColor,
            title: const Text('Menu'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(
              Icons.home_filled,
              color: constant.bgColor,
            ),
            title: const Text(
              'Home',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.water_drop,
              color: constant.bgColor,
            ),
            title: const Text(
              'Water Usage',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onTap: () {
              // Navigator.of(context).push(
              //   PageTransition(
              //     child: OrderScreen(),
              //     type: PageTransitionType.leftToRight,
              //   ),
              // );
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.error_outline,
              color: constant.bgColor,
            ),
            title: const Text(
              'About',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(
              Icons.logout,
              color: constant.bgColor,
            ),
            title: const Text(
              'Sign Out',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onTap: () {
              print('exit');
              Provider.of<AuthService>(context, listen: false).logout();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginScreen()));
            },
          ),
        ],
      ),
    );
  }
}
