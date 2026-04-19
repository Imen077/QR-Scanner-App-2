import 'package:flutter/material.dart';
import 'package:ikutan/widgets/event_tile.dart';

class MainTab extends StatelessWidget {
  const MainTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {},
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Event Around You!',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(height: 24),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(height: 8);
                  },
                  itemCount: 5,
                  itemBuilder: (BuildContext context, int index) {
                    return EventTile();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
