import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../widgets/camera_view.dart';

class CameraTab extends StatefulWidget {
  const CameraTab({super.key});

  @override
  State<CameraTab> createState() => _CameraTabState();
}

class _CameraTabState extends State<CameraTab> {
  final TextEditingController _urlController = TextEditingController(text: 'http://172.20.10.5/');
  
  String _currentUrl = 'http://172.20.10.5/';

  @override
  void initState() {
    super.initState();
  }

  void _loadUrl() {
    FocusScope.of(context).unfocus();
    final url = _urlController.text.trim();
    if (url.isNotEmpty && url != _currentUrl) {
      setState(() {
        _currentUrl = url;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Live Camera', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // 1. Top UI (Badges and URL Bar)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              children: [
                // Top Status Badge
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.redAccent.withOpacity(0.8)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8, height: 8,
                            decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle),
                          ).animate(onPlay: (controller) => controller.repeat(reverse: true)).fade(duration: 800.ms, begin: 0.3, end: 1.0),
                          const SizedBox(width: 8),
                          const Text('LIVE STREAM', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text('ESP32-CAM', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ).animate().fade().slideY(begin: -0.2),
                
                const SizedBox(height: 16),
                
                // Connection Settings
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.black.withOpacity(0.7) : Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 15),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _urlController,
                          style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                          decoration: InputDecoration(
                            hintText: 'Enter Camera URL',
                            hintStyle: TextStyle(color: isDarkMode ? Colors.grey[400] : Colors.grey[600]),
                            prefixIcon: Icon(Icons.link, color: isDarkMode ? Colors.grey[300] : Colors.grey[700]),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          ),
                          onSubmitted: (_) => _loadUrl(),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1877F2),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.refresh, color: Colors.white),
                          onPressed: _loadUrl,
                        ),
                      ),
                    ],
                  ),
                ).animate().fade(delay: 200.ms).slideY(begin: 0.2),
              ],
            ),
          ),
          
          // 2. Camera WebView takes the rest of the screen
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              child: Container(
                color: Colors.black, // Dark background for webview
                child: buildCameraView(_currentUrl),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
