import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dormlink/theme.dart';
import 'package:dormlink/services/user_service.dart';
import 'package:dormlink/services/roommate_request_service.dart';
import 'package:dormlink/services/room_service.dart';
import 'package:dormlink/screens/room_types_screen.dart';
import 'package:dormlink/screens/request_detail_screen.dart';
import 'package:dormlink/screens/portal_redirect_screen.dart';
import 'package:dormlink/widgets/request_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final userService = context.watch<UserService>();
    final requestService = context.watch<RoommateRequestService>();
    final currentUser = userService.currentUser;
    final roomTypes = RoomService.getRoomTypes();
    final recentRequests = requestService.requests.take(3).toList();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.paddingMd,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Welcome back,', style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant)),
                        const SizedBox(height: 4),
                        Text(currentUser?.name.split(' ').first ?? 'Student', style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: colorScheme.primaryContainer, borderRadius: BorderRadius.circular(AppRadius.lg)),
                    child: Icon(Icons.notifications_rounded, color: colorScheme.onPrimaryContainer),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Quick Actions
              Container(
                padding: AppSpacing.paddingMd,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [KFUPMColors.green, KFUPMColors.forest],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.school_rounded, color: Colors.white, size: 28),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text('Find Your Perfect Roommate', style: textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text('Connect with KFUPM students who match your lifestyle and preferences.', style: textTheme.bodySmall?.copyWith(color: Colors.white.withValues(alpha: 0.9))),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _QuickActionButton(
                            icon: Icons.open_in_new_rounded,
                            label: 'University Portal',
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PortalRedirectScreen())),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _QuickActionButton(
                            icon: Icons.hotel_rounded,
                            label: 'Room Types',
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RoomTypesScreen())),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Room Types Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Room Types', style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  TextButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RoomTypesScreen())),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('View All', style: TextStyle(color: colorScheme.primary)),
                        const SizedBox(width: 4),
                        Icon(Icons.arrow_forward_rounded, size: 16, color: colorScheme.primary),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 140,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: roomTypes.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final room = roomTypes[index];
                    return _RoomTypeCard(
                      name: room.name,
                      capacity: room.capacity,
                      icon: _getRoomIcon(room.capacity),
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RoomTypesScreen())),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              
              // Recent Requests Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Recent Requests', style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  TextButton(
                    onPressed: () {},
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('View All', style: TextStyle(color: colorScheme.primary)),
                        const SizedBox(width: 4),
                        Icon(Icons.arrow_forward_rounded, size: 16, color: colorScheme.primary),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (recentRequests.isEmpty)
                Container(
                  padding: AppSpacing.paddingLg,
                  decoration: BoxDecoration(color: colorScheme.surface, borderRadius: BorderRadius.circular(AppRadius.lg)),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(Icons.inbox_rounded, size: 48, color: colorScheme.onSurfaceVariant),
                        const SizedBox(height: 12),
                        Text('No requests yet', style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant)),
                      ],
                    ),
                  ),
                )
              else
                ...recentRequests.map((request) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: RequestCard(
                    request: request,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RequestDetailScreen(request: request))),
                  ),
                )),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getRoomIcon(int capacity) {
    switch (capacity) {
      case 1: return Icons.person_rounded;
      case 2: return Icons.people_rounded;
      case 3: return Icons.groups_rounded;
      default: return Icons.apartment_rounded;
    }
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.2),
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Flexible(child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13), overflow: TextOverflow.ellipsis)),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoomTypeCard extends StatelessWidget {
  final String name;
  final int capacity;
  final IconData icon;
  final VoidCallback onTap;

  const _RoomTypeCard({required this.name, required this.capacity, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 130,
        padding: AppSpacing.paddingMd,
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: colorScheme.primaryContainer, borderRadius: BorderRadius.circular(AppRadius.md)),
              child: Icon(icon, color: colorScheme.primary, size: 24),
            ),
            const Spacer(),
            Text(name, style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Text('$capacity ${capacity == 1 ? 'person' : 'people'}', style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }
}
