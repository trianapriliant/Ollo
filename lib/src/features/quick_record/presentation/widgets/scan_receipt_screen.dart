import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../constants/app_colors.dart';

class ScanReceiptScreen extends StatefulWidget {
  const ScanReceiptScreen({super.key});

  @override
  State<ScanReceiptScreen> createState() => _ScanReceiptScreenState();
}

class _ScanReceiptScreenState extends State<ScanReceiptScreen> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  bool _isTakingPicture = false;
  bool _noCamera = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      if (mounted) setState(() => _noCamera = true);
      return; 
    }

    _controller = CameraController(
      cameras.first, // Back camera usually
      ResolutionPreset.high,
      enableAudio: false,
    );

    _initializeControllerFuture = _controller!.initialize();
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized || _isTakingPicture) {
      return;
    }

    try {
      setState(() => _isTakingPicture = true);
      final image = await _controller!.takePicture();
      
      if (mounted) {
        context.pop(image.path); // Return the path
      }
    } catch (e) {
      print(e);
    } finally {
      if (mounted) setState(() => _isTakingPicture = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_noCamera) {
       return Scaffold(
          appBar: AppBar(backgroundColor: Colors.black, iconTheme: const IconThemeData(color: Colors.white)),
          backgroundColor: Colors.black,
          body: const Center(child: Text("Camera not available", style: TextStyle(color: Colors.white))),
       );
    }

    if (_controller == null || _initializeControllerFuture == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              fit: StackFit.expand,
              children: [
                // Camera Preview
                CameraPreview(_controller!),
                
                // Overlay (Darkened outside, clear rectangle inside)
                CustomPaint(
                  painter: _OverlayPainter(),
                ),

                // Controls
                Positioned(
                  bottom: 50,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: GestureDetector(
                      onTap: _takePicture,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: _isTakingPicture ? Colors.grey : Colors.white, // Flash effect
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.primary, width: 4),
                        ),
                        child: Center(
                          child: Icon(Icons.camera_alt, color: AppColors.primary, size: 40),
                        ),
                      ),
                    ),
                  ),
                ),
                
                // Close button
                Positioned(
                  top: 50,
                  left: 20,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white, size: 30),
                    onPressed: () => context.pop(),
                  ),
                ),

                // Instruction Text
                Positioned(
                    top: 100,
                    left: 0,
                    right: 0,
                    child: Text(
                      'Position receipt within the frame',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        shadows: const [Shadow(color: Colors.black, blurRadius: 4)],
                      ),
                    ),
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class _OverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black54;
    
    // Define the scanning area (rectangle in center)
    // Adjust width/height as needed (e.g. receipt shape)
    final scanRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: size.width * 0.85,
      height: size.height * 0.7, // Taller rectangle for receipts
    );

    // Draw darkened background with a hole (using difference)
    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
        Path()..addRRect(RRect.fromRectAndRadius(scanRect, const Radius.circular(16))),
      ),
      paint,
    );

    // Draw border around the hole
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    
    canvas.drawRRect(
        RRect.fromRectAndRadius(scanRect, const Radius.circular(16)), 
        borderPaint
    );
    
    // Draw corner indicators (L-shapes) for "techy" look
    final cornerLen = 30.0;
    final cornerPaint = Paint()
        ..color = AppColors.primary
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round;

    // Top Left
    canvas.drawLine(scanRect.topLeft, scanRect.topLeft + Offset(0, cornerLen), cornerPaint);
    canvas.drawLine(scanRect.topLeft, scanRect.topLeft + Offset(cornerLen, 0), cornerPaint);

    // Top Right
    canvas.drawLine(scanRect.topRight, scanRect.topRight + Offset(0, cornerLen), cornerPaint);
    canvas.drawLine(scanRect.topRight, scanRect.topRight - Offset(cornerLen, 0), cornerPaint);

    // Bottom Left
    canvas.drawLine(scanRect.bottomLeft, scanRect.bottomLeft - Offset(0, cornerLen), cornerPaint);
    canvas.drawLine(scanRect.bottomLeft, scanRect.bottomLeft + Offset(cornerLen, 0), cornerPaint);

    // Bottom Right
    canvas.drawLine(scanRect.bottomRight, scanRect.bottomRight - Offset(0, cornerLen), cornerPaint);
    canvas.drawLine(scanRect.bottomRight, scanRect.bottomRight - Offset(cornerLen, 0), cornerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
