class Account {
  String? uid;
  Account(this.uid);
  double? temp;
  Account.fromSnapshot(snapshot, uid) {
    uid = uid;
    try {
      print('========== ${snapshot.data['temp']}');
      temp = snapshot.data['temp'] ?? '';
    } catch (err) {
      print(err);
    }
  }
}
