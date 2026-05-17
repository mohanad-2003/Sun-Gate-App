import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sun_gate_app/features/marketplace/presentation/provider/market_place_provider.dart';

class EngineersScreen extends ConsumerStatefulWidget {
  final String? companyId;

  const EngineersScreen({super.key, this.companyId});

  @override
  ConsumerState<EngineersScreen> createState() => _EngineersScreenState();
}

class _EngineersScreenState extends ConsumerState<EngineersScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref
          .read(marketPlaceControllerProvider.notifier)
          .getEngineers(companyId: widget.companyId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(marketPlaceControllerProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Engineers'), centerTitle: true),
<<<<<<< Updated upstream
      body: RefreshIndicator(
        onRefresh: () => ref
            .read(marketPlaceControllerProvider.notifier)
            .getEngineers(companyId: widget.companyId),
        child: Builder(
          builder: (context) {
            if (state.isLoading) {
              return ListView(
                children: [
                  SizedBox(
                    height: 280,
                    child: Center(child: CircularProgressIndicator()),
=======
      body: Builder(
        builder: (context) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.errorMessage != null) {
            return Center(
              child: Text(
                state.errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (state.engineers.isEmpty) {
            return const Center(child: Text('No engineers found'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: state.engineers.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final engineer = state.engineers[index];

              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.15),
>>>>>>> Stashed changes
                  ),
                ],
              );
            }

            if (state.errorMessage != null) {
              return ListView(
                children: [
                  SizedBox(
                    height: 280,
                    child: Center(
                      child: Text(
                        state.errorMessage!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                ],
              );
            }

            if (state.engineers.isEmpty) {
              return ListView(
                children: [
                  SizedBox(
                    height: 280,
                    child: Center(child: Text('No engineers found')),
                  ),
                ],
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.engineers.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final engineer = state.engineers[index];

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: theme.colorScheme.outline.withValues(alpha: 0.15),
                    ),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: theme.colorScheme.primary.withValues(
                          alpha: 0.12,
                        ),
                        child: Icon(
                          Icons.engineering,
                          color: theme.colorScheme.primary,
                        ),
                      ),

                      const SizedBox(width: 14),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Engineer',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 6),

                            Text(
                              '${engineer.yearsOfExperience} years experience',
                              style: theme.textTheme.bodyMedium,
                            ),

                            const SizedBox(height: 4),

                            Text(
                              engineer.certificate.isEmpty
                                  ? 'No certificate'
                                  : engineer.certificate,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.textTheme.bodySmall?.color
                                    ?.withValues(alpha: 0.7),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 18,
                          ),
                          const SizedBox(width: 4),
                          Text(engineer.rating.toStringAsFixed(1)),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
