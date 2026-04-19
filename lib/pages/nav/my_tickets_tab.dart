import 'package:flutter/material.dart';
import 'package:ikutan/widgets/ticket_tile.dart';

class MyTicketsTab extends StatelessWidget {
  const MyTicketsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {},
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.all(20),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Icon(Icons.confirmation_num),
                    SizedBox(width: 8),
                    Text(
                      'My Tickets!',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Divider(height: 24),
                // Active Tickets
                ExpansionTile(
                  title: Text('Active Tickets'),
                  backgroundColor: Colors.yellow.shade700.withAlpha(50),
                  initiallyExpanded: true,
                  childrenPadding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 16,
                    bottom: 16,
                  ),
                  children: [
                    ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(height: 8);
                      },
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        return TicketTile();
                      },
                    ),
                  ],
                ),
                // Canceled Tickets
                ExpansionTile(
                  title: Text('Canceled Tickets'),
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.errorContainer.withAlpha(50),
                  childrenPadding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 16,
                    bottom: 16,
                  ),
                  children: [
                    ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(height: 8);
                      },
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        return TicketTile();
                      },
                    ),
                  ],
                ),
                // Used Tickets
                ExpansionTile(
                  title: Text('Used Tickets'),
                  backgroundColor: Colors.green.shade700.withAlpha(50),
                  childrenPadding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 16,
                    bottom: 16,
                  ),
                  children: [
                    ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(height: 8);
                      },
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        return TicketTile();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
