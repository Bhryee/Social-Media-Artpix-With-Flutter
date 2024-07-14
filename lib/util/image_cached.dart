import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImageCached extends StatelessWidget {
  String? imageURL;
  ImageCached(this.imageURL, {super.key});


  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      fit: BoxFit.cover,
      imageUrl: imageURL!,
      progressIndicatorBuilder: (context, url, progress){
        return Container(
          child: Padding(
            padding: const EdgeInsets.all(130.0),
            child: CircularProgressIndicator(
              value: progress.progress,
              color: Color(0xFF1C869E),
            ),
          ),

        );
      },
      errorWidget: (context, url, error) => Container(
        color: Colors.amber,
      ),
    );
  }
}
