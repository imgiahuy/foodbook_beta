import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  final String? imageUrl;
  final VoidCallback? onTap;

  const Avatar({this.imageUrl, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 40,
        backgroundImage: imageUrl != null
            ? NetworkImage(imageUrl!)
            : const AssetImage('assets/images/avatar-1.jpgr')
                as ImageProvider,
      ),
    );
  }
}

