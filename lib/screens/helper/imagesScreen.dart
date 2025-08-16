import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:text_converter/utils/permission_Service.dart';

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
  Set<String> selectedIds = {};
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    _checkPermissionAndLoadImages();
  }

  Future<void> _checkPermissionAndLoadImages() async {
    bool granted = await PermissionsService.requestImagesPermission();

    if (!granted) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      return;
    }

    final albums = await PhotoManager.getAssetPathList(
      type: RequestType.image,
      onlyAll: true,
    );

    if (albums.isEmpty) {
      if (!mounted) return;
      setState(() {
        images = [];
        thumbnails = [];
        isLoading = false;
      });
      return;
    }

    final media = await albums.first.getAssetListPaged(page: 0, size: 100);

    List<Uint8List?> tempThumbs = [];
    for (var asset in media) {
      tempThumbs.add(
        await asset.thumbnailDataWithSize(const ThumbnailSize(200, 200)),
      );
    }

    if (!mounted) return;
    setState(() {
      images = media;
      thumbnails = tempThumbs;
      isLoading = false;
    });

    _preselectPreviouslySelected();
  }

  void _preselectPreviouslySelected() {
    for (var prev in widget.previouslySelected) {
      selectedIds.add(prev.id);
    }
    if (!mounted) return;
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
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }
    if (images.isEmpty) {
      return RefreshIndicator(
        color: Colors.blueAccent,
        onRefresh: _checkPermissionAndLoadImages,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: 300),
            Center(
              child: Text(
                "No images found",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );
    }
    return RefreshIndicator(
      color: Colors.blueAccent,
      onRefresh: _checkPermissionAndLoadImages,
      child: GridView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
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
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox.expand(
                    // 👈 yeh ensure karega ke image pura cell cover kare
                    child: thumbnails[index] != null
                        ? Image.memory(
                            thumbnails[index]!,
                            fit: BoxFit.cover, // 👈 ab image pura fill karegi
                          )
                        : Container(color: Colors.grey),
                  ),
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
      ),
    );
  }
}
