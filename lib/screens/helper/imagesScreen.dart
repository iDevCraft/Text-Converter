import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:device_info_plus/device_info_plus.dart';

class Imagesscreen extends StatefulWidget {
  final Function(List<AssetEntity>) onImagesSelected;
  final List<AssetEntity> previouslySelected;

  const Imagesscreen({
    super.key,
    required this.onImagesSelected,
    required this.previouslySelected,
  });

  @override
  State<Imagesscreen> createState() => _ImagesscreenState();
}

class _ImagesscreenState extends State<Imagesscreen> {
  List<AssetEntity> images = [];
  List<Uint8List?> thumbnails = [];

  Set<String> selectedIds = {}; // 👈 ab IDs track karenge
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkPermissionAndLoadImages();
  }

  Future<void> _checkPermissionAndLoadImages() async {
    final albums = await PhotoManager.getAssetPathList(
      type: RequestType.image,
      onlyAll: true,
    );
    final media = await albums.first.getAssetListPaged(page: 0, size: 100);

    List<Uint8List?> tempThumbs = [];
    for (var asset in media) {
      tempThumbs.add(
        await asset.thumbnailDataWithSize(const ThumbnailSize(200, 200)),
      );
    }

    setState(() {
      images = media;
      thumbnails = tempThumbs;
      isLoading = false;
    });

    _preselectPreviouslySelected();
  }

  void _preselectPreviouslySelected() {
    for (var prev in widget.previouslySelected) {
      selectedIds.add(prev.id); // ✅ direct ID match
    }
    setState(() {});
    _updateSelectedImages();
  }

  void _updateSelectedImages() {
    final selected = images
        .where((img) => selectedIds.contains(img.id))
        .toList();
    widget.onImagesSelected(selected);
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator(color: Colors.white))
        : GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: images.length,
            itemBuilder: (context, index) {
              final asset = images[index];
              final isSelected = selectedIds.contains(asset.id);

              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      selectedIds.remove(asset.id);
                    } else {
                      selectedIds.add(asset.id);
                    }
                  });
                  _updateSelectedImages();
                },
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: thumbnails[index] != null
                          ? Image.memory(thumbnails[index]!, fit: BoxFit.cover)
                          : Container(color: Colors.grey),
                    ),
                    if (isSelected)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blueAccent,
                          ),
                          padding: const EdgeInsets.all(5),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          );
  }
}
