import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sizer/sizer.dart';

class CardMovie extends StatelessWidget {
  const CardMovie(
      {super.key,
      required this.imageUrl,
      required this.title,
      this.valoracion,
      required this.width,
      required this.height,
      required this.module,
      this.showTitle = true});

  final String imageUrl;
  final String title;
  final double? valoracion;
  final double width;
  final double height;
  final String module;
  final bool? showTitle;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: title,
      child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: SizedBox(
            width: width,
            height: height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      placeholder: (_, __) =>
                          const SpinKitRipple(color: Colors.white),
                      errorListener: (e) {},
                      imageBuilder:
                          (BuildContext context, ImageProvider image) {
                        return Image(
                          image: image,
                          fit: BoxFit.cover,
                        );
                      }),
                ),
                if (showTitle!) ...[
                  SizedBox(
                    height: 2.h,
                  ),
                  Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 12.sp),
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        (valoracion ?? 0).toStringAsFixed(1),
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 10.sp),
                      ),
                      SizedBox(
                        width: 1.w,
                      ),
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                      )
                    ],
                  )
                ]
              ],
            ),
          )),
    );
  }
}
