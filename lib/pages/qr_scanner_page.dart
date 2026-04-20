// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'dart:convert';

class QrScannerPage extends StatefulWidget {
  const QrScannerPage({super.key});

  @override
  State<QrScannerPage> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<QrScannerPage> {
  MobileScannerController cameraController = MobileScannerController();
  bool _scanned = false;

  static const _accents = Color.fromARGB(255, 76, 255, 210);
  static const _bg = Color(0xFF0D0D0D);

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_scanned) return;
    final barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final rawValue = barcodes.first.rawValue;
    if (rawValue == null) return;

    setState(() => _scanned = true);

    try {
      final data = jsonDecode(rawValue) as Map<String, dynamic>;
      _showResultDialog(data, rawValue);
    } catch (e) {
      // Bukan JSON — tampilkan raw value
      _showResultDialog({'raw': rawValue}, rawValue);
    }
  }

  void _showResultDialog(Map<String, dynamic> data, String raw) {
    final type = data['type'] ?? 'unknown';
    final isTicket = type == 'ticket';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(
              isTicket ? Icons.check_circle_rounded : Icons.qr_code_rounded,
              color: isTicket ? _accents : Colors.orangeAccent,
            ),
            const SizedBox(width: 10),
            Text(
              isTicket ? 'Ticket Scanned!' : 'QR Scanned',
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isTicket) ...[
              _resultRow('Event', data['event'] ?? data['event_id'] ?? '-'),
              _resultRow('Ticket ID', data['ticket_id'] ?? '-'),
              _resultRow('User ID', data['user_id'] ?? '-'),
              _resultRow('Seat', data['seat'] ?? '-'),
              _resultRow('Date', data['date'] ?? '-'),
              _resultRow('Status', data['status'] ?? 'active'),
            ] else ...[
              _resultRow('Data', raw.length > 100 ? '${raw.substring(0, 100)}...' : raw),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => _scanned = false);
            },
            child: const Text(
              'Scan Again',
              style: TextStyle(color: Colors.white54),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _accents,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.pop(context);
              Get.back(result: data);
            },
            child: const Text(
              'Done',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  Widget _resultRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(fontSize: 12, color: Color(0xFF888888)),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF2A2A2A)),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              size: 16,
              color: Colors.white,
            ),
          ),
        ),
        title: const Text(
          'Scan QR Code',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => cameraController.toggleTorch(),
            icon: const Icon(Icons.flashlight_on_rounded, color: Colors.white),
          ),
          IconButton(
            onPressed: () => cameraController.switchCamera(),
            icon: const Icon(Icons.flip_camera_ios_rounded, color: Colors.white),
          ),
        ],
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Camera preview
          MobileScanner(
            controller: cameraController,
            onDetect: _onDetect,
          ),

          // QR frame overlay
          Center(
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.transparent),
              ),
              child: Stack(
                children: [
                  // Corner brackets
                  _corner(0, 0, 0),
                  _corner(0, null, 1),
                  _corner(null, 0, 3),
                  _corner(null, null, 2),

                  // Center scanner line animation
                  if (!_scanned)
                    Center(
                      child: Container(
                        height: 2,
                        width: 220,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              _accents.withOpacity(0),
                              _accents,
                              _accents.withOpacity(0),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Bottom instruction
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Point camera at QR code to scan',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                if (_scanned) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: _accents.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: _accents.withOpacity(0.4)),
                    ),
                    child: const Text(
                      '✓ QR Detected!',
                      style: TextStyle(
                        color: _accents,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _corner(double? top, double? left, int rotate) {
    final isRight = left == null;
    final isBottom = top == null;
    return Positioned(
      top: isBottom ? null : 0,
      bottom: isBottom ? 0 : null,
      left: isRight ? null : 0,
      right: isRight ? 0 : null,
      child: SizedBox(
        width: 32,
        height: 32,
        child: CustomPaint(
          painter: _CornerPainter(color: _accents, rotate: rotate),
        ),
      ),
    );
  }
}

class _CornerPainter extends CustomPainter {
  final Color color;
  final int rotate;
  const _CornerPainter({required this.color, required this.rotate});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square;

    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(rotate * 3.14159265 / 2);
    canvas.translate(-size.width / 2, -size.height / 2);

    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, 0)
      ..lineTo(size.width, 0);
    canvas.drawPath(path, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _CornerPainter old) => old.color != color;
}