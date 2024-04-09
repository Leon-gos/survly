import 'dart:io';
import 'package:flutter/material.dart';

class AppImagePicker extends StatelessWidget {
  final double? width;
  final double? height;
  final String imagePath;
  final Function() onPickImage;
  final String? defaultImageUrl;

  const AppImagePicker({
    super.key,
    this.width,
    this.height,
    required this.imagePath,
    required this.onPickImage,
    this.defaultImageUrl,
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
        child: _buildImage(),
      ),
    );
  }

  Widget _buildImage() {
    if (imagePath != "") {
      return ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        child: Image.file(
          File(imagePath),
          fit: BoxFit.cover,
        ),
      );
    } else if (defaultImageUrl != null && defaultImageUrl != "") {
      return ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        child: Image.network(
          defaultImageUrl!,
          fit: BoxFit.cover,
        ),
      );
    }
    return const Center(
      child: Icon(
        Icons.image_search,
        size: 64,
      ),
    );
  }
}
