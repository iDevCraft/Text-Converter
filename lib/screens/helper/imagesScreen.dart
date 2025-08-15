import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:device_info_plus/device_info_plus.dart';

class Imagesscreen extends StatefulWidget {
  final Function(List<Uint8List>) onImagesSelected;

  const Imagesscreen({super.key, required this.onImagesSelected});

  @override
  State<Imagesscreen> createState() => _ImagesscreenState();
}

class _ImagesscreenState extends State<Imagesscreen> {
  static List<AssetEntity> _cachedImages = [];
  static List<Uint8List?> _cachedThumbnails = [];
  static bool _isAlreadyLoaded = false;

  List<AssetEntity> images = [];
  List<Uint8List?> thumbnails = [];
  Set<int> selectedIndexes = {};
  bool isLoading = true;
  bool permissionDenied = false;

  @override
  void initState() {
    super.initState();
    if (_isAlreadyLoaded) {
      images = _cachedImages;
      thumbnails = _cachedThumbnails;
      isLoading = false;
    } else {
      _checkPermissionAndLoadImages();
    }
  }

  Future<void> _checkPermissionAndLoadImages() async {
    setState(() {
      isLoading = true;
      permissionDenied = false;
    });

    bool granted = false;

    if (Platform.isAndroid) {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;

      if (androidInfo.version.sdkInt < 33) {
        granted = (await Permission.storage.request()).isGranted;
      } else {
        granted = (await Permission.photos.request()).isGranted;
      }
    } else {
      granted = (await PhotoManager.requestPermissionExtend()).isAuth;
    }

    if (granted) {
      await _loadImages();
    } else {
      setState(() {
        permissionDenied = true;
        isLoading = false;
      });
    }
  }

  Future<void> _loadImages() async {
    try {
      final albums = await PhotoManager.getAssetPathList(
        type: RequestType.image,
        onlyAll: true,
      );

      if (albums.isEmpty) {
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

      setState(() {
        images = media;
        thumbnails = tempThumbs;
        isLoading = false;
        permissionDenied = false;

        _cachedImages = media;
        _cachedThumbnails = tempThumbs;
        _isAlreadyLoaded = true;
      });
    } catch (e) {
      debugPrint("Error loading images: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _updateSelectedImages() async {
    final currentSelection = List<int>.from(selectedIndexes);
    List<Uint8List> selectedImagesBytes = [];

    for (int index in currentSelection) {
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
    return Scaffold(
      backgroundColor: const Color(0xFF2b2b2b),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : permissionDenied
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Gallery permission is required to load images",
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _checkPermissionAndLoadImages,
                    child: const Text("Grant Permission"),
                  ),
                ],
              ),
            )
          : images.isEmpty
          ? const Center(
              child: Text(
                "No images found",
                style: TextStyle(color: Colors.white),
              ),
            )
          : Padding(
              padding: EdgeInsets.all(2.w),
              child: RefreshIndicator(
                color: Colors.blueAccent,
                onRefresh: () async {
                  await _loadImages();
                },
                child: GridView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 2.w,
                    mainAxisSpacing: 2.w,
                  ),
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    final isSelected = selectedIndexes.contains(index);

                    return GestureDetector(
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
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: thumbnails[index] != null
                                ? Image.memory(
                                    thumbnails[index]!,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  )
                                : Container(color: Colors.grey[300]),
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
              ),
            ),
    );
  }
}
