import 'dart:async';
import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

Future<File> compressImageFile(File imageFile) async {
  var dir = await getTemporaryDirectory();
  var targetPath = dir.absolute.path + "/temp.jpg";

  return await FlutterImageCompress.compressAndGetFile(
    imageFile.absolute.path,
    targetPath,
    quality: 50,
    rotate: 90,
    minHeight: 400,
    minWidth: 400
  );
}
