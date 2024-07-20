
// ignore_for_file: use_super_parameters

import 'dart:io';

import 'package:flutter/material.dart';

class PhotoWidget extends StatelessWidget {
  final VoidCallback onImageSelected;
  final String? imageUrl;

  const PhotoWidget({Key? key, required this.onImageSelected, this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onImageSelected,
      child: Container(
        height: 150,
        width: 150,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
          image: imageUrl != null
              ? DecorationImage(
                  image: imageUrl!.startsWith('http')
                      ? NetworkImage(imageUrl!)
                      : FileImage(File(imageUrl!)) as ImageProvider,
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: imageUrl == null
            ? Center(
                child: Icon(
                  Icons.camera_alt,
                  color: Colors.grey,
                  size: 50,
                ),
              )
            : null,
      ),
    );
  }
}
