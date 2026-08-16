// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;
import 'package:flutter/material.dart';

Widget buildPlatformCameraView(String url) {
  final String viewId = 'iframe-${url.hashCode}';
  
  // Register the iframe view for web
  ui_web.platformViewRegistry.registerViewFactory(
    viewId,
    (int viewId) => html.IFrameElement()
      ..style.width = '100%'
      ..style.height = '100%'
      ..src = url
      ..style.border = 'none'
      ..allowFullscreen = true,
  );

  return HtmlElementView(viewType: viewId);
}
