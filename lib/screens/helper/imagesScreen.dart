import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class Imagesscreen extends StatefulWidget {
  final Function(List<Uint8List>) onImagesSelected;

  const Imagesscreen({super.key, required this.onImagesSelected});

  @override
  State<Imagesscreen> createState() => _ImagesscreenState();
}

class _ImagesscreenState extends State<Imagesscreen> {
  List<AssetEntity> images = [];
  Set<int> selectedIndexes = {};
  bool isLoading = true;
  bool permissionDenied = false;

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    final ps = await PhotoManager.requestPermissionExtend(
      requestOption: const PermissionRequestOption(
        iosAccessLevel: IosAccessLevel.readWrite,
      ),
    );

    if (!ps.hasAccess) {
      setState(() {
        isLoading = false;
        permissionDenied = true;
      });
      return;
    }

    final albums = await PhotoManager.getAssetPathList(
      type: RequestType.image,
      onlyAll: true,
    );

    if (albums.isEmpty) {
      setState(() {
        images = [];
        isLoading = false;
      });
      return;
    }

    final media = await albums.first.getAssetListPaged(page: 0, size: 100);

    setState(() {
      images = media;
      isLoading = false;
      permissionDenied = false;
    });
  }

  Future<void> _updateSelectedImages() async {
    List<Uint8List> selectedImagesBytes = [];
    for (int index in selectedIndexes) {
      final bytes = await images[index].thumbnailDataWithSize(
        const ThumbnailSize(500, 500),
      );
      if (bytes != null) {
        selectedImagesBytes.add(bytes);
      }
    }
    widget.onImagesSelected(selectedImagesBytes);
  }

  @override
  Widget build(BuildContext context) {
    if (permissionDenied) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showPermissionDialog();
      });
    }

    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : images.isEmpty
        ? const Center(child: Text("No images found or permission denied"))
        : Padding(
            padding: EdgeInsets.all(2.w),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 2.w,
                mainAxisSpacing: 2.w,
              ),
              itemCount: images.length,
              itemBuilder: (context, index) {
                final isSelected = selectedIndexes.contains(index);

                return InkWell(
                  onTap: () async {
                    setState(() {
                      if (isSelected) {
                        selectedIndexes.remove(index);
                      } else {
                        selectedIndexes.add(index);
                      }
                    });
                    await _updateSelectedImages();
                  },
                  child: Stack(
                    children: [
                      FutureBuilder<Uint8List?>(
                        future: images[index].thumbnailDataWithSize(
                          const ThumbnailSize(200, 200),
                        ),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Container(color: Colors.grey[300]);
                          }
                          if (snapshot.hasData) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.memory(
                                snapshot.data!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            );
                          } else {
                            return Container(color: Colors.grey[300]);
                          }
                        },
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

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permission Required'),
        content: const Text(
          'Please grant gallery access permission in your device settings to continue.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              PhotoManager.openSetting();
            },
            child: const Text('Open Settings'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
