import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TicketTile extends StatelessWidget {
  final Map<String, dynamic>? ticket;
  const TicketTile({super.key, this.ticket});

  @override
  Widget build(BuildContext context) {
    final String ticketId = ticket?['id']?.toString() ?? 'TKT-001';
    final String eventId = ticket?['event_id']?.toString() ?? 'EVT-001';
    final String eventName = ticket?['event_name'] ?? 'Event Name';
    final String eventDate = ticket?['event_date'] ?? '2080-80-90';
    final String status = ticket?['status'] ?? 'active';
    final String eventLocation = ticket?['event_location'] ?? 'Jakarta, Indonesia';
    final String seatNumber = ticket?['seat_number'] ?? 'A-01';

    final Color statusColor = _statusColor(status);

    return ListTile(
      onTap: () {
        // Navigasi ke halaman detail tiket
        Get.toNamed(
          '/ticket-detail',
          arguments: {
            'id': ticketId,
            'event_id': eventId,
            'event_name': eventName,
            'event_date': eventDate,
            'event_location': eventLocation,
            'status': status,
            'seat_number': seatNumber,
          },
        );
      },
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: statusColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: statusColor.withOpacity(0.3)),
        ),
        child: Icon(Icons.confirmation_num_outlined, color: statusColor, size: 20),
      ),
      title: Text(eventName),
      titleTextStyle: Theme.of(context).textTheme.titleMedium,
      subtitle: Text(eventDate),
      subtitleTextStyle: Theme.of(context).textTheme.labelMedium,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Status badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              status.toUpperCase(),
              style: TextStyle(
                fontSize: 10,
                color: statusColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right),
        ],
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Theme.of(context).colorScheme.secondary.withAlpha(50),
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'active':
        return const Color(0xFF4ADE80);
      case 'used':
        return Colors.blueAccent;
      case 'canceled':
        return Colors.redAccent;
      default:
        return Colors.grey;
    }
  }
}