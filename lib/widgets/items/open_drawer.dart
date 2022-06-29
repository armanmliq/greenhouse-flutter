import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:greenhouse/constant/constant.dart';
import 'package:greenhouse/screens/graph_screen.dart';
import 'package:greenhouse/screens/set_point_screen.dart';

import '../../screens/jadwal_penyiraman.dart';
import '../../screens/jadwal_ppm.dart';
import '../../screens/user_uid_info.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: backgroundColor,
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          ListTile(
            leading: const Icon(
              Icons.home,
              color: Colors.white,
            ),
            title: const Text(
              'Home',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.schedule,
              color: Colors.white,
            ),
            title: const Text(
              'Jadwal Nutrisi',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => const JadwalPpmScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.schedule,
              color: Colors.white,
            ),
            title: const Text(
              'Jadwal Penyiraman',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => JadwalPenyiramanScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.note,
              color: Colors.white,
            ),
            title: const Text(
              'Report Harian',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => Graph1(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.settings,
              color: Colors.white,
            ),
            title: const Text(
              'Setting Parameter',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => setPointScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.numbers,
              color: Colors.white,
            ),
            title: const Text(
              'ID',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: ((context) => const UidInfoScreen()),
              ));
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
            title: const Text(
              'Keluar App',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onTap: () {
              SystemNavigator.pop();
            },
          ),
        ],
      ),
    );
  }
}
