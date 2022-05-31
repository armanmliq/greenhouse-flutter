import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenhouse/screens/user_uid_info.dart';
import 'package:greenhouse/widgets/items/open_drawer.dart';
import '../widgets/items/clip_shadow_path.dart';
import '../widgets/items/main_content.dart';
import 'package:greenhouse/constant/constant.dart' as constant;

class HomeScreen extends StatefulWidget {
  static const routeName = '/monitor-screen';
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;

    constant.height = size.height;
    constant.width = width;
    constant.cardWitdh = width * 0.8;

    return SafeArea(
      child: Scaffold(
        backgroundColor: constant.backgroundColor,
        key: _key,
        appBar: AppBar(
          shadowColor: constant.shadowColor,
          elevation: 2,
          automaticallyImplyLeading: false,
          backgroundColor: constant.AppBarColor,
          title: Row(
            children: [
              IconButton(
                  onPressed: () {
                    _key.currentState!.openDrawer();
                  },
                  icon: const Icon(Icons.menu)),
              Text(
                'Home',
                style: GoogleFonts.firaSans(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 19,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              color: Colors.white,
              onPressed: () {
                // uid info
                Navigator.of(context).push(
                    MaterialPageRoute(builder: ((context) => UidInfoScreen())));
              },
              icon: const Icon(Icons.person),
            )
          ],
        ),
        drawer: const AppDrawer(),
        body: Stack(
          children: [
            ClipShadowPath(
              clipper: CustomClip(),
              shadow: const BoxShadow(
                color: Colors.black,
                blurRadius: 1,
                spreadRadius: 8,
                offset: Offset(4, 4),
              ),
              child: Container(
                height: size.height * 0.22,
                color: constant.palleteColor,
              ),
            ),
            const MainContent(),
          ],
        ),
      ),
    );
  }
}

class InformasiControlTempHumidity extends StatelessWidget {
  const InformasiControlTempHumidity({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(10),
    );
  }
}

class CustomClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();
    path.lineTo(
        0, size.height); //start path with this if you are making at bottom

    var firstStart = Offset(size.width / 5, size.height);
    //fist point of quadratic bezier curve
    var firstEnd = Offset(size.width / 2.25, size.height - 50.0);
    //second point of quadratic bezier curve
    path.quadraticBezierTo(
        firstStart.dx, firstStart.dy, firstEnd.dx, firstEnd.dy);

    var secondStart =
        Offset(size.width - (size.width / 3.24), size.height - 105);
    //third point of quadratic bezier curve
    var secondEnd = Offset(size.width, size.height - 10);
    //fourth point of quadratic bezier curve
    path.quadraticBezierTo(
        secondStart.dx, secondStart.dy, secondEnd.dx, secondEnd.dy);

    path.lineTo(
        size.width, 0); //end with this path if you are making wave at bottom
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

class SecondClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();
    path.lineTo(
        0, size.height); //start path with this if you are making at bottom

    var firstStart = Offset(size.width / 5, size.height);
    //fist point of quadratic bezier curve
    var firstEnd = Offset(size.width / 2.25, size.height - 50.0);
    //second point of quadratic bezier curve
    path.quadraticBezierTo(
        firstStart.dx, firstStart.dy, firstEnd.dx, firstEnd.dy);

    var secondStart =
        Offset(size.width - (size.width / 3.24), size.height - 105);
    //third point of quadratic bezier curve
    var secondEnd = Offset(size.width, size.height - 10);
    //fourth point of quadratic bezier curve
    path.quadraticBezierTo(
        secondStart.dx, secondStart.dy, secondEnd.dx, secondEnd.dy);

    path.lineTo(
        size.width, 0); //end with this path if you are making wave at bottom
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
