// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:posts/utils/kTextStyle.dart';

class PostTile extends StatelessWidget {
  Widget? avatar;
  String? displayName;
  String? title;
  String? content;
  PostTile({
    super.key,
    this.avatar,
    this.displayName,
    this.title,
    this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Container(
        padding: EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 245, 245, 245),
          borderRadius: BorderRadius.circular(4),
        ),
        height: 100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: const Color.fromARGB(255, 221, 221, 221),
                  radius: 10,
                  child: Center(child: avatar),
                ),
                const SizedBox(width: 3),
                Text(displayName!),
              ],
            ),
            Text(title!, style: kTextStyle(size: 25)),
            Text(content!),
          ],
        ),
      ),
    );
  }
}
