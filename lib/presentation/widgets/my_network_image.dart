import 'package:allin1/presentation/widgets/loading_image_container.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MyNetworkImage extends StatelessWidget {
  final String image;
  final double? width;
  final double? height;
  final bool repeat;
  final BoxFit fit;
  const MyNetworkImage({
    Key? key,
    required this.image,
    this.width,
    this.height,
    this.repeat = true,
    this.fit = BoxFit.cover,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: image,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) => LoadingImageContainer(
        width: width,
        height: height,
      ),
      errorWidget: (context, url, error) => LoadingImageContainer(
        width: width,
        height: height,
        repeat: repeat,
      ),
    );
  }
}
