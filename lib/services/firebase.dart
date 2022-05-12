import 'package:firebase_database/firebase_database.dart';
import 'package:greenhouse/constant/constant.dart' as constant;

class FirebaseService {
  var recentJobsRef = FirebaseDatabase.instance
      .ref()
      .child('users')
      .child(constant.uid!) //order by creation time.
      .child('sensor_status');
}
