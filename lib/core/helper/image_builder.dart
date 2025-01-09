// ignore_for_file: sized_box_for_whitespace, must_be_immutable, non_constant_identifier_names, prefer_if_null_operators

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImageBuilder extends StatelessWidget {
  String? image, type;
  bool isFull;
  BorderRadius radius;
  double? hight, width, new_hight;
  BoxFit? fit = BoxFit.fill;
  Widget? placeHolder, errorImage;
  Widget Function(BuildContext, ImageProvider<Object>)? imageBuilder;
  ImageBuilder({
    super.key,
    this.image,
    this.type = 'image',
    this.placeHolder,
    this.errorImage,
    this.imageBuilder,
    this.width,
    this.hight,
    this.radius = BorderRadius.zero,
    this.fit,
    this.isFull = false,
  });

  @override
  Widget build(BuildContext context) {
    String x = image!.substring(image!.lastIndexOf('/') + 1);
    return type != 'image'
        ? SizedBox(
            height: hight ?? 170,
            child: const Icon(
              Icons.video_camera_back,
              size: 40,
            ),
          )
        : ClipRRect(
            borderRadius: radius,
            child: x.length > 4
                ? CachedNetworkImage(
                    imageUrl: image!,
                    height: hight,
                    width: width,
                    fit: fit,
                    imageBuilder: imageBuilder,
                    placeholder: (context, string) => placeHolder != null
                        ? placeHolder!
                        : Container(
                            height: hight ?? 150,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Theme.of(context).primaryColor,
                                strokeWidth: 1,
                              ),
                            ),
                          ),
                    errorWidget: (context, url, error) => errorImage != null
                        ? errorImage!
                        : Image.asset(
                            'assets/images/noImage.jpeg',
                            height: hight,
                          ),
                  )
                : errorImage != null
                    ? errorImage
                    : Image.asset(
                        'assets/images/noImage.jpeg',
                        height: hight,
                      ),
          );
  }
}
