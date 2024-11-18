import 'package:flutter/material.dart';
import 'package:hasd/services/service.dart';
import 'package:hasd/shared/utils_more.dart';

class FilePreview extends StatelessWidget {
  final String mimeType;
  final String url;

  const FilePreview(this.url, {super.key, required this.mimeType});

  @override
  Widget build(BuildContext context) {
    if (mimeType.startsWith('image')) {
      return ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 256.0),
        child: GestureDetector(
          onTap: () async => showDialog(
            context: context,
            builder: (context) => Dialog(
              child: Image.network(url, headers: Service.instance.authorizationHeaders),
            ),
          ),
          child: Image.network(url, headers: Service.instance.authorizationHeaders),
        ),
      );
    }

    return InkWell(
      onTap: () async => launchFileWebView(context, mimeType, url),
      child: const AspectRatio(
        aspectRatio: 16 / 9,
        child: Icon(Icons.file_present),
      ),
    );
  }
}
