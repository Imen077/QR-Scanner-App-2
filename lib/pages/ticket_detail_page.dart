// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ikutan/services/auth_services.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TicketDetailPage extends StatelessWidget {
  TicketDetailPage({super.key});

  final _authServices = Get.find<AuthServices>();

  static const _bg = Color(0xFF0D0D0D);
  static const _surface = Color(0xFF1A1A1A);
  static const _border = Color(0xFF2A2A2A);
  static const _accents = Color.fromARGB(255, 76, 255, 210);
  static const _textSecondary = Color(0xFF888888);

  @override
  Widget build(BuildContext context) {
    final dynamic ticket = Get.arguments;

    final String ticketId = ticket?['id']?.toString() ?? 'TKT-001';
    final String eventId = ticket?['event_id']?.toString() ?? 'EVT-001';
    final String eventName = ticket?['event_name'] ?? 'Event Name';
    final String eventDate = ticket?['event_date'] ?? '2025-08-01';
    final String eventLocation =
        ticket?['event_location'] ?? 'Jakarta, Indonesia';
    final String status = ticket?['status'] ?? 'active';
    final String seatNumber = ticket?['seat_number'] ?? 'A-01';
    final String userId = _authServices.user.value?.id?.toString() ?? 'USR-000';
    final String userName = _authServices.user.value?.name ?? 'User';

    // QR data untuk scan masuk event
    final qrData =
        '{"type":"ticket","ticket_id":"$ticketId","event_id":"$eventId","user_id":"$userId","seat":"$seatNumber","status":"$status","issued":"${DateTime.now().toIso8601String()}"}';

    final Color statusColor = _statusColor(status);
    final String statusLabel = _statusLabel(status);

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _border),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              size: 16,
              color: Colors.white,
            ),
          ),
        ),
        title: const Text(
          'Ticket Detail',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Ticket card ────────────────────────────────────
            _buildTicketCard(
              context,
              ticketId: ticketId,
              eventName: eventName,
              eventDate: eventDate,
              eventLocation: eventLocation,
              seatNumber: seatNumber,
              userName: userName,
              statusColor: statusColor,
              statusLabel: statusLabel,
              qrData: qrData,
              status: status,
            ),

            const SizedBox(height: 24),

            // ── Info section ──────────────────────────────────
            _buildInfoSection(ticketId, eventId),

            const SizedBox(height: 24),

            // ── Action buttons ────────────────────────────────
            if (status == 'active') ...[
              _buildActionButton(
                label: 'View Event Details',
                icon: Icons.event_rounded,
                color: _accents,
                onTap: () => Get.toNamed(
                  '/event-detail',
                  arguments: {
                    'id': eventId,
                    'name': eventName,
                    'date': eventDate,
                    'location': eventLocation,
                  },
                ),
              ),
              const SizedBox(height: 12),
              _buildActionButton(
                label: 'Scan QR Event (Masukk)',
                icon: Icons.qr_code_scanner_rounded,
                color: Colors.blueAccent,
                onTap: () => Get.toNamed(
                  '/qr-scanner',
                  arguments: {'ticketId': ticketId, 'mode': 'checkin'},
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTicketCard(
    BuildContext context, {
    required String ticketId,
    required String eventName,
    required String eventDate,
    required String eventLocation,
    required String seatNumber,
    required String userName,
    required Color statusColor,
    required String statusLabel,
    required String qrData,
    required String status,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _border),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: _accents.withOpacity(0.07),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.confirmation_num_rounded,
                  color: _accents,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    eventName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: statusColor.withOpacity(0.4)),
                  ),
                  child: Text(
                    statusLabel,
                    style: TextStyle(
                      fontSize: 11,
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Dashed divider
          _dashedDivider(),

          // QR code section
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                if (status == 'active') ...[
                  const Text(
                    'Scan to Check-in',
                    style: TextStyle(
                      fontSize: 13,
                      color: _textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: _accents.withOpacity(0.2),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: QrImageView(
                      data: qrData,
                      version: QrVersions.auto,
                      size: 200,
                      backgroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Ticket ID: $ticketId',
                    style: const TextStyle(
                      fontSize: 11,
                      color: _textSecondary,
                      fontFamily: 'monospace',
                    ),
                  ),
                ] else ...[
                  Icon(
                    status == 'used'
                        ? Icons.check_circle_rounded
                        : Icons.cancel_rounded,
                    size: 80,
                    color: statusColor.withOpacity(0.6),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    status == 'used'
                        ? 'Ticket already used'
                        : 'Ticket was canceled',
                    style: TextStyle(
                      fontSize: 14,
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Dashed divider
          _dashedDivider(),

          // Details
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _detailRow('Date', eventDate),
                const SizedBox(height: 10),
                _detailRow('Location', eventLocation),
                const SizedBox(height: 10),
                _detailRow('Seat / Code', seatNumber),
                const SizedBox(height: 10),
                _detailRow('Attendee', userName),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String ticketId, String eventId) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _border),
      ),
      child: Column(
        children: [
          _infoTile(Icons.confirmation_num_outlined, 'Ticket ID', ticketId),
          const Divider(height: 20, color: _border),
          _infoTile(Icons.event_rounded, 'Event ID', eventId),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: Icon(icon, color: Colors.black, size: 18),
        label: Text(
          label,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: onTap,
      ),
    );
  }

  Widget _dashedDivider() {
    return CustomPaint(
      size: const Size(double.infinity, 1),
      painter: _DashPainter(),
    );
  }

  Widget _detailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: _textSecondary),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _infoTile(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: _accents),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 11, color: _textSecondary),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'active':
        return _accents;
      case 'used':
        return Colors.blueAccent;
      case 'canceled':
        return Colors.redAccent;
      default:
        return _textSecondary;
    }
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'active':
        return 'ACTIVE';
      case 'used':
        return 'USED';
      case 'canceled':
        return 'CANCELED';
      default:
        return status.toUpperCase();
    }
  }
}

class _DashPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const dashWidth = 8.0;
    const dashSpace = 5.0;
    final paint = Paint()
      ..color = const Color(0xFF2A2A2A)
      ..strokeWidth = 1;
    double x = 0;
    while (x < size.width) {
      canvas.drawLine(Offset(x, 0), Offset(x + dashWidth, 0), paint);
      x += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}
