import 'package:flutter/material.dart';

import '../../constant/constant.dart';

class TitleControl extends StatelessWidget {
  const TitleControl({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Status Pompa',
              style: TextStyleTitleTitle,
            ),
            const Text(
              'menampilkan status pompa secara realtime',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
