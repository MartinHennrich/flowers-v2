import 'dart:async';
import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

Future<File> compressImageFile(File imageFile, {bool rotate = true}) async {
  var dir = await getTemporaryDirectory();
  var targetPath = dir.absolute.path + "/temp.jpg";

  return await FlutterImageCompress.compressAndGetFile(
    imageFile.absolute.path,
    targetPath,
    quality: 50,
    rotate: rotate ? 90 : 0,
    minHeight: 400,
    minWidth: 400
  );
}
