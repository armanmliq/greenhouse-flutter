import 'package:flutter/material.dart';

import '../../constant/constant.dart';

class TitlePompaStatus extends StatelessWidget {
  const TitlePompaStatus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Status Pompa',
                style: TextStyleTitleTitle,
              ),
              const Text(
                'menampilkan status pompa realtime',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
