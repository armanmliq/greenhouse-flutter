import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenhouse/widgets/title/title_ph.dart';

double borderRadius = 5.0;

const bgColor = Colors.blue;
const backgroundColor = Color.fromARGB(255, 7, 36, 18);
const palleteColor = Color.fromARGB(255, 11, 43, 15);
const titleTextColor = Colors.white;
const secondTitleText = Colors.white;
const titleTextOutside = Colors.white;
const secondTitleOutside = Colors.white;
const lastChangeBackgroundColors = Colors.blue;
const ColorHidup = Colors.blue;
const ColorMati = Colors.blue;
const AppBarColor = Color.fromARGB(255, 28, 49, 28);
const cardColor = backgroundColor;
const cardTitleColor = Colors.black;
const cardTextUnitColor = Colors.grey;
const GridValueTextColor = Colors.white;
const CardLastChangeUpdateTextColor = Colors.white;
const cardButtonColor = Color(0xff243D25);
const BackgroundCardButtonColor = Colors.blue;
const graphPlotAreadColor = Color.fromARGB(255, 50, 92, 51);
const Color shadowColor = Colors.black;
const borderRadiusGlass = 5.0;
const Color outsideTextTitle = Colors.white;
//
const maxPh = 12;
const maxPpm = 1200;
const maxHumidity = 100;
const maxMoisture = 100;
const maxSchedulePpm = 7;
const maxSchedulePenyiraman = 9;
const maxPenyiraman = 300;
const maxIntervalOnPpm = 30000;
const maxIntervalOffPpm = 30000;
const maxIntervalOffPh = 30000;
const maxIntervalOnPh = 3000;

final TextStyleSecondTitleOutside = TextStyle(
  color: Colors.white,
  fontSize: fontSize,
);
final TextStyleTitleOutside = GoogleFonts.anton(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontSize: 20,
  letterSpacing: 2,
);
final TextStyleTitleTitle = GoogleFonts.anton(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontSize: 20,
  letterSpacing: 2,
);
final TextStyleSecondTitle = GoogleFonts.martel();
final TextStyleJadwalValue = GoogleFonts.anton(
  color: Colors.white,
  fontSize: 24,
);
final TextStyleAppbarTitle = GoogleFonts.anton(
  color: Colors.white,
  fontSize: 24,
);

double? height;
double? width;
double? cardWitdh;
double padding = 10;
String uid = '';
bool? SprayerButton;
Map<dynamic, dynamic> grafikData = {};
String initialEmail = '';
String initialPass = '';
String initialUsername = '';
bool isRegister = false;
bool stateButtonPenyiramaan = false;
bool stateButtonPengisian = false;
bool stateButtonPhUp = false;
bool stateButtonPhDown = false;
bool stateButtonPpmUp = false;
