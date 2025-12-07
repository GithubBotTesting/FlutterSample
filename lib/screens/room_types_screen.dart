import 'package:flutter/material.dart';
import 'package:dormlink/theme.dart';
import 'package:dormlink/models/room_type_model.dart';
import 'package:dormlink/services/room_service.dart';

class RoomTypesScreen extends StatelessWidget {
  const RoomTypesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final roomTypes = RoomService.getRoomTypes();

    return Scaffold(
      appBar: AppBar(
        title: Text('Room Types', style: textTheme.titleLarge),
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
            Text('Choose the room that fits your lifestyle', style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant)),
            const SizedBox(height: 20),
            ...roomTypes.map((room) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _RoomTypeDetailCard(room: room),
            )),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}

class _RoomTypeDetailCard extends StatelessWidget {
  final RoomType room;

  const _RoomTypeDetailCard({required this.room});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 140,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _getGradientColors(room.capacity),
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
            ),
            child: Stack(
              children: [
                Positioned(
                  right: 20,
                  bottom: 20,
                  child: Icon(_getRoomIcon(room.capacity), size: 80, color: Colors.white.withValues(alpha: 0.3)),
                ),
                Padding(
                  padding: AppSpacing.paddingMd,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(AppRadius.xl)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.person_rounded, size: 16, color: Colors.white),
                            const SizedBox(width: 4),
                            Text('${room.capacity} ${room.capacity == 1 ? 'Person' : 'People'}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(room.name, style: textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: AppSpacing.paddingMd,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(room.description, style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant, height: 1.5)),
                const SizedBox(height: 16),
                Text('Amenities', style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: room.amenities.map((amenity) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(AppRadius.xl),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(_getAmenityIcon(amenity), size: 14, color: colorScheme.primary),
                        const SizedBox(width: 6),
                        Text(amenity, style: TextStyle(fontSize: 12, color: colorScheme.primary, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  )).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Color> _getGradientColors(int capacity) {
    switch (capacity) {
      case 1: return [KFUPMColors.petrol, const Color(0xFF005566)];
      case 2: return [KFUPMColors.green, KFUPMColors.forest];
      case 3: return [KFUPMColors.stone, const Color(0xFFCC9900)];
      default: return [const Color(0xFF5A5A5A), KFUPMColors.darkGray];
    }
  }

  IconData _getRoomIcon(int capacity) {
    switch (capacity) {
      case 1: return Icons.person_rounded;
      case 2: return Icons.people_rounded;
      case 3: return Icons.groups_rounded;
      default: return Icons.apartment_rounded;
    }
  }

  IconData _getAmenityIcon(String amenity) {
    if (amenity.contains('Bathroom')) return Icons.bathroom_rounded;
    if (amenity.contains('Desk')) return Icons.desk_rounded;
    if (amenity.contains('Wardrobe')) return Icons.door_sliding_rounded;
    if (amenity.contains('AC')) return Icons.ac_unit_rounded;
    if (amenity.contains('Wi-Fi')) return Icons.wifi_rounded;
    if (amenity.contains('Kitchen')) return Icons.kitchen_rounded;
    if (amenity.contains('Living')) return Icons.weekend_rounded;
    if (amenity.contains('Bedroom')) return Icons.bed_rounded;
    return Icons.check_circle_rounded;
  }
}
