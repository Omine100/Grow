import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';

class TestScreen extends StatefulWidget {
  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  PermissionStatus _status;

  @override
  void initState() {
    super.initState();
    PermissionHandler()
      .checkPermissionStatus(PermissionGroup.camera)
      .then(_updateStatus);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green.shade300,
      child: Column(
        children: <Widget>[
          RaisedButton(
            color: Colors.blue,
            onPressed: () {
              _displayOptionsDialog();
            },
          ),
          Text("Click Me"),
        ],
      ),
    );
  }

  void _displayOptionsDialog() async {
    await _optionsDialogBox();
  }

  Future<void> _optionsDialogBox() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: new SingleChildScrollView(
              child: new ListBody(
                children: <Widget>[
                  GestureDetector(
                    onTap: _askPermission,
                    child: Text("Take Photo"),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  GestureDetector(
                    onTap: imageSelectorGallery,
                    child: Text("Select Image From Gallery"),
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

  void _askPermission() {
    PermissionHandler()
        .requestPermissions([PermissionGroup.camera]).then(_onStatusRequested);
  }

  void _onStatusRequested(Map<PermissionGroup, PermissionStatus> value) {
    final status = value[PermissionGroup.camera];
    if (status == PermissionStatus.granted) {
      imageSelectorCamera();
    } else {
      _updateStatus(status);
    }
  }

  _updateStatus(PermissionStatus value) {
    if (value != _status) {
      setState(() {
        _status = value;
      });
    }
  }

  void imageSelectorCamera() async {
    Navigator.pop(context);
    var imageFile = await ImagePicker.pickImage(
      source: ImageSource.camera,
    );
  }

  void imageSelectorGallery() async {
    Navigator.pop(context);
    var imageFile1 = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
  }
}