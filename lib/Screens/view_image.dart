import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

import '../Widget/customAppBar.dart';

class ViewImage extends StatelessWidget {
  String imageUrl;
  String type;
  ViewImage({super.key, required this.imageUrl, required this.type});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: CustomAppBar(title: "",),
        body:   Column(
            children: [
              type=="PDF" || type=="pdf"?Expanded(
                child: PDF().fromUrl(
                  imageUrl,
                  placeholder: (progress) => Center(child: Text('$progress %')),
                  errorWidget: (error) => Center(child: Text(error.toString())),
                ),
              ) :Expanded(child: Image.network(imageUrl))
            ],
        )
    );
  }

}

