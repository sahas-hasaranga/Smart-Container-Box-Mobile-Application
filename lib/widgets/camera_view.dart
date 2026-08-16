import 'package:flutter/material.dart';
import 'camera_view_mobile.dart' if (dart.library.html) 'camera_view_web.dart';

Widget buildCameraView(String url) {
  return buildPlatformCameraView(url);
}
