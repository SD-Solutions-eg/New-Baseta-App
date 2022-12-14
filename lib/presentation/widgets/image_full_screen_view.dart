import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImageFullScreenView extends StatefulWidget {
  final String image;

  const ImageFullScreenView({
    Key? key,
    required this.image,
  }) : super(key: key);

  @override
  _ImageFullScreenViewState createState() => _ImageFullScreenViewState();
}

class _ImageFullScreenViewState extends State<ImageFullScreenView> {
  late final String image;
  final _photoController = PhotoViewController();

  @override
  void initState() {
    super.initState();
    image = widget.image;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  key: const Key('closeButton'),
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: Colors.white),
                ),
                const Spacer(),
              ],
            ),
            Expanded(
              child: PhotoViewGallery.builder(
                key: const Key('imageView'),
                scrollPhysics: const BouncingScrollPhysics(),
                builder: (BuildContext context, int index) {
                  return PhotoViewGalleryPageOptions(
                    imageProvider: NetworkImage(image),
                    initialScale: PhotoViewComputedScale.contained,
                    heroAttributes: PhotoViewHeroAttributes(tag: image),
                    minScale: 0.1,
                    maxScale: 1.5,
                    controller: _photoController,
                  );
                },
                itemCount: 1,
                loadingBuilder: (context, event) => Center(
                  child: SizedBox(
                    width: 20.0.w,
                    height: 20.0.w,
                    child: CircularProgressIndicator(
                      value: event == null
                          ? 0
                          : event.cumulativeBytesLoaded /
                              (event.expectedTotalBytes ?? 1),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
