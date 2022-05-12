import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenhouse/widgets/items/grid_live_data.dart';
import 'package:greenhouse/widgets/items/homescreen_graph.dart';
import 'package:greenhouse/widgets/items/set_paramater.dart';
import 'package:greenhouse/widgets/title/title_setting.dart';
import '../widgets/items/status_pompa.dart';
import 'package:greenhouse/widgets/title/title_status_pump.dart';
import 'package:greenhouse/widgets/title/title_history.dart';
import 'package:greenhouse/widgets/title/title_live_data.dart';
import '../widgets/items/app_drawer.dart';
import '../constant/constant.dart' as constant;
import '../widgets/items/set_paramater.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/monitor-screen';
  HomeScreen();

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    constant.height = size.height;
    constant.width = size.width;
    constant.cardWitdh = constant.width! * 0.8;

    print('====HomeScreen====width=== ${size.width}');
    print('====HomeScreen====height=== ${size.height}');
    print('====HomeScreen====cardWitdh=== ${constant.cardWitdh}');

    return SafeArea(
      child: Scaffold(
        key: _key,
        backgroundColor: constant.backgroundColor,
        drawer: AppDrawer(),
        appBar: AppBar(
          shadowColor: constant.shadowColor,
          elevation: 2,
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0x0ff64663),
          title: Text(
            constant.uid!,
            style: GoogleFonts.firaSans(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 10,
              letterSpacing: 2,
            ),
          ),
          leading: GestureDetector(
            onTap: () {
              _key.currentState!.openDrawer(); //<-- SEE HERE
            },
            child: const Icon(
              Icons.menu,
            ),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  /////////////////////////
                },
                icon: const Icon(Icons.person))
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            _refreshData();
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(constant.padding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  SizedBox(height: 10),
                  TitleControl(),
                  ControlInformation(),
                  SizedBox(height: 10),

                  TitleSet(),
                  SetParameter(),
                  SizedBox(height: 10),

                  TitleChart(),
                  GraphSensor(),
                  SizedBox(height: 10),

                  TitleRealtimeSensor(),
                  GridLiveData(),
                  //ImageGreenhouse(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future _refreshData() async {
    return;
  }
}

class ImageGreenhouse extends StatelessWidget {
  const ImageGreenhouse({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(constant.borderRadius),
          child: Image.asset(
            'assets/images/greenhouse.png',
            width: double.infinity,
            height: 160,
            fit: BoxFit.cover,
          ),
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
