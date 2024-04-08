import 'dart:io';
import 'package:flutter/material.dart';

class AppImagePicker extends StatelessWidget {
  final double? width;
  final double? height;
  final String imagePath;
  final Function() onPickImage;

  const AppImagePicker({
    super.key,
    this.width,
    this.height,
    required this.imagePath,
    required this.onPickImage,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPickImage,
      child: Container(
        width: width ?? double.infinity,
        height: height ?? 200,
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          boxShadow: const [
            BoxShadow(blurRadius: 2, color: Colors.black26),
          ],
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        child: imagePath != ""
            ? ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                child: Image.file(
                  File(imagePath),
                  fit: BoxFit.cover,
                ),
              )
            : const Center(
                child: Icon(
                  Icons.image_search,
                  size: 64,
                ),
              ),
      ),
    );
  }
}
