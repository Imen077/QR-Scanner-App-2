// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ikutan/services/auth_services.dart';
import 'package:qr_flutter/qr_flutter.dart';

class EventDetailPage extends StatelessWidget {
  EventDetailPage({super.key});

  final _authServices = Get.find<AuthServices>();

  static const _bg = Color(0xFF0D0D0D);
  static const _surface = Color(0xFF1A1A1A);
  static const _border = Color(0xFF2A2A2A);
  static const _accents = Color.fromARGB(255, 76, 255, 210);
  static const _accentDim = Color(0x224ADE80);
  static const _textPrimary = Color(0xFFFFFFFF);
  static const _textSecondary = Color(0xFF888888);

  @override
  Widget build(BuildContext context) {
    final dynamic event = Get.arguments;
    final String eventId = event?['id']?.toString() ?? 'EVT-001';
    final String eventName = event?['name'] ?? 'Sample Event';
    final String eventDate = event?['date'] ?? '2025-08-01';
    final String eventLocation = event?['location'] ?? 'Jakarta, Indonesia';
    final String eventDescription =
        event?['description'] ??
        'Join us for an amazing event filled with great speakers, workshops, and networking opportunities. This is a placeholder description for demonstration purposes.';
    final String eventImage =
        event?['image'] ??
        'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?q=80&w=1742&auto=format&fit=crop';
    final bool isAttendee = _authServices.user.value?.role == 'attendee';
    final int totalSeats = event?['total_seats'] ?? 100;
    final int bookedSeats = event?['booked_seats'] ?? 45;
    final double price = (event?['price'] ?? 0).toDouble();

    return Scaffold(
      backgroundColor: _bg,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: _bg,
            leading: GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    eventImage,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Container(
                      color: const Color(0xFF1A2A1A),
                      child: const Icon(Icons.event, size: 64, color: _accents),
                    ),
                  ),
                  // Gradient overlay
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Color(0xFF0D0D0D)],
                      ),
                    ),
                  ),
                  // QR corner brackets overlay
                  ..._buildQrCorners(),
                  // QR Event badge
                  Positioned(
                    top: 60,
                    left: 56,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _accents.withOpacity(0.2),
                        border: Border.all(color: _accents.withOpacity(0.5)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'QR Event',
                        style: TextStyle(
                          fontSize: 11,
                          color: _accents,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    eventName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: _textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),

                  _infoRow(Icons.calendar_today_rounded, eventDate),
                  const SizedBox(height: 8),
                  _infoRow(Icons.location_on_rounded, eventLocation),
                  const SizedBox(height: 8),
                  _infoRow(
                    Icons.people_rounded,
                    '$bookedSeats / $totalSeats seats booked',
                  ),
                  if (price > 0) ...[
                    const SizedBox(height: 8),
                    _infoRow(
                      Icons.sell_rounded,
                      'Rp ${price.toStringAsFixed(0)}',
                      color: _accents,
                    ),
                  ],

                  const SizedBox(height: 20),

                  // Seat progress bar
                  _buildSeatProgress(bookedSeats, totalSeats),

                  const SizedBox(height: 24),

                  // Description
                  const Text(
                    'About Event',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: _textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    eventDescription,
                    style: const TextStyle(
                      fontSize: 14,
                      color: _textSecondary,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 32),
                  if (isAttendee)
                    _buildRegisterButton(context, eventId, eventName, eventDate)
                  else
                    _buildScanButton(context, eventId),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterButton(
    BuildContext context,
    String eventId,
    String eventName,
    String eventDate,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.qr_code_rounded, color: Colors.black),
        label: const Text(
          'Get Ticket (Generate QR)',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: _accents,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: () =>
            _showTicketQrDialog(context, eventId, eventName, eventDate),
      ),
    );
  }

  // ── Scan QR button (for organizer/admin) ─────────────────────
  Widget _buildScanButton(BuildContext context, String eventId) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.qr_code_scanner_rounded, color: Colors.black),
        label: const Text(
          'Scan Attendee QR',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: _accents,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: () =>
            Get.toNamed('/qr-scanner', arguments: {'eventId': eventId}),
      ),
    );
  }

  void _showTicketQrDialog(
    BuildContext context,
    String eventId,
    String eventName,
    String eventDate,
  ) {
    final userId = _authServices.user.value?.id?.toString() ?? 'USR-000';
    // QR data: JSON-like string yang bisa di-decode saat scan
    final qrData =
        '{"type":"ticket","event_id":"$eventId","user_id":"$userId","event":"$eventName","date":"$eventDate","issued":"${DateTime.now().toIso8601String()}"}';

    showModalBottomSheet(
      context: context,
      backgroundColor: _surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: _border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Your Ticket QR',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: _textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              eventName,
              style: const TextStyle(fontSize: 13, color: _textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: QrImageView(
                data: qrData,
                version: QrVersions.auto,
                size: 220,
                backgroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Show this QR to the event organizer',
              style: const TextStyle(fontSize: 12, color: _textSecondary),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: _accentDim,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: _accents.withOpacity(0.3)),
              ),
              child: Text(
                eventDate,
                style: const TextStyle(
                  fontSize: 13,
                  color: _accents,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _accents,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Close',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text, {Color? color}) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color ?? _accents),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 13, color: color ?? _textSecondary),
          ),
        ),
      ],
    );
  }

  Widget _buildSeatProgress(int booked, int total) {
    final ratio = total > 0 ? booked / total : 0.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Seats Available',
              style: TextStyle(fontSize: 12, color: _textSecondary),
            ),
            Text(
              '${total - booked} left',
              style: const TextStyle(
                fontSize: 12,
                color: _accents,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: ratio,
            backgroundColor: _border,
            valueColor: const AlwaysStoppedAnimation<Color>(_accents),
            minHeight: 6,
          ),
        ),
      ],
    );
  }

  List<Widget> _buildQrCorners() {
    const c = _accents;
    const sz = 22.0;
    const stroke = 3.0;

    Widget corner(double t, double l, double r, double b, int rot) =>
        Positioned(
          top: t == -1 ? null : t,
          left: l == -1 ? null : l,
          right: r == -1 ? null : r,
          bottom: b == -1 ? null : b,
          child: SizedBox(
            width: sz,
            height: sz,
            child: CustomPaint(
              painter: _CornerPainter(color: c, rotate: rot, strokeW: stroke),
            ),
          ),
        );

    return [
      corner(48, 16, -1, -1, 0),
      corner(48, -1, 16, -1, 1),
      corner(-1, 16, -1, 16, 3),
      corner(-1, -1, 16, 16, 2),
    ];
  }
}

class _CornerPainter extends CustomPainter {
  final Color color;
  final int rotate;
  final double strokeW;
  const _CornerPainter({
    required this.color,
    required this.rotate,
    this.strokeW = 2.5,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeW
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
  bool shouldRepaint(covariant _CornerPainter old) =>
      old.color != color || old.rotate != rotate;
}
