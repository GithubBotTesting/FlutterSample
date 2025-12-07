import 'package:flutter/material.dart';
import 'package:dormlink/theme.dart';
import 'package:dormlink/services/room_service.dart';

class FilterBottomSheet extends StatefulWidget {
  final String? selectedCity;
  final String? selectedMajor;
  final String? selectedSmoking;
  final String? selectedSleep;
  final String? selectedStudy;
  final String? selectedRoomType;
  final Function(String?, String?, String?, String?, String?, String?) onApply;

  const FilterBottomSheet({
    super.key,
    this.selectedCity,
    this.selectedMajor,
    this.selectedSmoking,
    this.selectedSleep,
    this.selectedStudy,
    this.selectedRoomType,
    required this.onApply,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late String? _city;
  late String? _major;
  late String? _smoking;
  late String? _sleep;
  late String? _study;
  late String? _roomType;

  @override
  void initState() {
    super.initState();
    _city = widget.selectedCity;
    _major = widget.selectedMajor;
    _smoking = widget.selectedSmoking;
    _sleep = widget.selectedSleep;
    _study = widget.selectedStudy;
    _roomType = widget.selectedRoomType;
  }

  void _clearAll() {
    setState(() {
      _city = null;
      _major = null;
      _smoking = null;
      _sleep = null;
      _study = null;
      _roomType = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.85),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(width: 40, height: 4, decoration: BoxDecoration(color: colorScheme.outline.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(2))),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Filter Requests', style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                TextButton(onPressed: _clearAll, child: Text('Clear All', style: TextStyle(color: colorScheme.error))),
              ],
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _FilterSection(
                    title: 'Room Type',
                    icon: Icons.hotel_rounded,
                    child: _ChipGrid(
                      options: RoomService.getRoomTypeNames(),
                      selected: _roomType,
                      onSelect: (v) => setState(() => _roomType = v == 'Any' ? null : v),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _FilterSection(
                    title: 'City',
                    icon: Icons.location_on_rounded,
                    child: _ChipGrid(
                      options: RoomService.getCities(),
                      selected: _city,
                      onSelect: (v) => setState(() => _city = v == 'Any' ? null : v),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _FilterSection(
                    title: 'Major',
                    icon: Icons.school_rounded,
                    child: _ChipGrid(
                      options: RoomService.getMajors(),
                      selected: _major,
                      onSelect: (v) => setState(() => _major = v == 'Any' ? null : v),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _FilterSection(
                    title: 'Smoking Preference',
                    icon: Icons.smoke_free_rounded,
                    child: _ChipGrid(
                      options: RoomService.getSmokingPreferences(),
                      selected: _smoking,
                      onSelect: (v) => setState(() => _smoking = v == 'No Preference' ? null : v),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _FilterSection(
                    title: 'Sleep Schedule',
                    icon: Icons.nightlight_rounded,
                    child: _ChipGrid(
                      options: RoomService.getSleepSchedules(),
                      selected: _sleep,
                      onSelect: (v) => setState(() => _sleep = v == 'Flexible' ? null : v),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _FilterSection(
                    title: 'Study Habits',
                    icon: Icons.menu_book_rounded,
                    child: _ChipGrid(
                      options: RoomService.getStudyHabits(),
                      selected: _study,
                      onSelect: (v) => setState(() => _study = v),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              border: Border(top: BorderSide(color: colorScheme.outline.withValues(alpha: 0.2))),
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    widget.onApply(_city, _major, _smoking, _sleep, _study, _roomType);
                    Navigator.pop(context);
                  },
                  child: const Text('Apply Filters', style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _FilterSection({required this.title, required this.icon, required this.child});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: colorScheme.primary),
            const SizedBox(width: 8),
            Text(title, style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
          ],
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }
}

class _ChipGrid extends StatelessWidget {
  final List<String> options;
  final String? selected;
  final Function(String) onSelect;

  const _ChipGrid({required this.options, required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((option) {
        final isSelected = option == selected || (selected == null && (option == 'Any' || option == 'No Preference' || option == 'Flexible'));
        return GestureDetector(
          onTap: () => onSelect(option),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? colorScheme.primary : colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(AppRadius.xl),
            ),
            child: Text(option, style: TextStyle(
              color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              fontSize: 13,
            )),
          ),
        );
      }).toList(),
    );
  }
}
