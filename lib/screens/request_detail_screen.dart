import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dormlink/theme.dart';
import 'package:dormlink/models/roommate_request_model.dart';
import 'package:dormlink/services/user_service.dart';
import 'package:dormlink/services/chat_service.dart';
import 'package:dormlink/screens/chat_detail_screen.dart';
import 'package:dormlink/screens/portal_redirect_screen.dart';
import 'package:intl/intl.dart';

class RequestDetailScreen extends StatelessWidget {
  final RoommateRequest request;

  const RequestDetailScreen({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final userService = context.read<UserService>();
    final chatService = context.read<ChatService>();
    final currentUser = userService.currentUser;
    final isOwnRequest = currentUser?.id == request.userId;

    return Scaffold(
      appBar: AppBar(
        title: Text('Request Details', style: textTheme.titleLarge),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.paddingMd,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Info
            Container(
              padding: AppSpacing.paddingMd,
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: colorScheme.primaryContainer,
                    child: Text(
                      request.userName.isNotEmpty ? request.userName[0].toUpperCase() : 'U',
                      style: textTheme.headlineSmall?.copyWith(color: colorScheme.primary, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(request.userName, style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text('Posted ${_formatDate(request.createdAt)}', style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant)),
                      ],
                    ),
                  ),
                  if (!isOwnRequest)
                    IconButton(
                      onPressed: () async {
                        final conversation = await chatService.getOrCreateConversation(
                          currentUser!.id,
                          currentUser.name,
                          request.userId,
                          request.userName,
                        );
                        if (context.mounted) {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => ChatDetailScreen(conversation: conversation)));
                        }
                      },
                      icon: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: colorScheme.primary, borderRadius: BorderRadius.circular(AppRadius.md)),
                        child: Icon(Icons.chat_bubble_rounded, color: colorScheme.onPrimary, size: 20),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            // Title
            Text(request.title, style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            
            // Description
            Text(request.description, style: textTheme.bodyLarge?.copyWith(height: 1.6, color: colorScheme.onSurfaceVariant)),
            const SizedBox(height: 24),
            
            // Room Type
            _DetailSection(
              title: 'Room Type',
              icon: Icons.hotel_rounded,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [KFUPMColors.green, KFUPMColors.forest]),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Text(request.roomType, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
              ),
            ),
            const SizedBox(height: 20),
            
            // Preferences
            _DetailSection(
              title: 'Preferences',
              icon: Icons.tune_rounded,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _PreferenceChip(icon: Icons.location_city_rounded, label: request.preferredCity),
                  _PreferenceChip(icon: Icons.school_rounded, label: request.preferredMajor),
                  _PreferenceChip(icon: Icons.smoke_free_rounded, label: request.smokingPreference),
                  _PreferenceChip(icon: Icons.nightlight_rounded, label: request.sleepSchedule),
                  _PreferenceChip(icon: Icons.menu_book_rounded, label: request.studyHabits),
                ],
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: !isOwnRequest ? Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          border: Border(top: BorderSide(color: colorScheme.outline.withValues(alpha: 0.2))),
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final conversation = await chatService.getOrCreateConversation(
                      currentUser!.id,
                      currentUser.name,
                      request.userId,
                      request.userName,
                    );
                    if (context.mounted) {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => ChatDetailScreen(conversation: conversation)));
                    }
                  },
                  icon: Icon(Icons.chat_bubble_outline_rounded, color: colorScheme.primary),
                  label: Text('Message', style: TextStyle(color: colorScheme.primary)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PortalRedirectScreen())),
                  icon: const Icon(Icons.open_in_new_rounded, color: Colors.white),
                  label: const Text('Go to Portal', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ) : null,
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays == 0) return 'today';
    if (diff.inDays == 1) return 'yesterday';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    return DateFormat('MMM d, y').format(date);
  }
}

class _DetailSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _DetailSection({required this.title, required this.icon, required this.child});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: colorScheme.primary),
            const SizedBox(width: 8),
            Text(title, style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600, color: colorScheme.onSurfaceVariant)),
          ],
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }
}

class _PreferenceChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _PreferenceChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: colorScheme.onSurfaceVariant),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(fontSize: 13, color: colorScheme.onSurface, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
