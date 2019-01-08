import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class GetImage extends StatelessWidget {
  final Function(File) onSave;

  GetImage({
    @required this.onSave
  });

  Future<File> _getImage() async {
    return await ImagePicker.pickImage(source: ImageSource.camera);
  }

  Widget _getImageContainer(FormFieldState<dynamic> imageForm) {
    return Container(
      height: 100,
      width: 100,
      margin: EdgeInsets.fromLTRB(0, 28, 0, 6),
      decoration: BoxDecoration(
        gradient: GreenBlueGradient,
        image: imageForm.value == null ? null : DecorationImage(
          image: FileImage(imageForm.value),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.all(Radius.circular(50)),
      ),
      child: Icon(
        Icons.camera_alt,
        size: 28,
        color: Colors.white,
      )
    );
  }

  Widget _getErrorWidget(bool hasError, String errorText) {
    return hasError ? Text(
      errorText,
      style: TextStyle(
        color: Colors.red,
        fontSize: 12
      )
    ) : Container();
  }

  @override
  Widget build(BuildContext context) {
    return FormField(
      onSaved: (File file) {
        onSave(file);
      },
      validator: (value) {
        return value == null ? 'Image of flower is required' : null;
      },
      builder: (imageForm) {
        return Center(
          child: Column(
            children: <Widget>[
              GestureDetector(
                onTap: () async {
                  File image = await _getImage();
                  imageForm.setValue(image);
                  imageForm.setState((){});
                },
                child: _getImageContainer(imageForm),
              ),
              Text('Take Image',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 16
                )
              ),
              _getErrorWidget(imageForm.hasError, imageForm.errorText)
            ],
          )
        );
      },
    );
  }
}
