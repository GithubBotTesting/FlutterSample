import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dormlink/theme.dart';
import 'package:dormlink/models/roommate_request_model.dart';
import 'package:dormlink/services/user_service.dart';
import 'package:dormlink/services/roommate_request_service.dart';
import 'package:dormlink/services/room_service.dart';

class CreateRequestScreen extends StatefulWidget {
  const CreateRequestScreen({super.key});

  @override
  State<CreateRequestScreen> createState() => _CreateRequestScreenState();
}

class _CreateRequestScreenState extends State<CreateRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  String _selectedRoomType = 'Double Room';
  String _selectedCity = 'Any';
  String _selectedMajor = 'Any';
  String _selectedSmoking = 'No Preference';
  String _selectedSleep = 'Flexible';
  String _selectedStudy = 'Moderate';
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitRequest() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isSubmitting = true);
    
    final userService = context.read<UserService>();
    final requestService = context.read<RoommateRequestService>();
    final currentUser = userService.currentUser;
    
    if (currentUser == null) {
      setState(() => _isSubmitting = false);
      return;
    }
    
    final request = RoommateRequest(
      id: '',
      userId: currentUser.id,
      userName: currentUser.name,
      userAvatar: currentUser.avatarUrl,
      title: _titleController.text,
      description: _descriptionController.text,
      roomType: _selectedRoomType,
      preferredCity: _selectedCity,
      preferredMajor: _selectedMajor,
      smokingPreference: _selectedSmoking,
      sleepSchedule: _selectedSleep,
      studyHabits: _selectedStudy,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    await requestService.addRequest(request);
    
    setState(() => _isSubmitting = false);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Request posted successfully!'),
          backgroundColor: KFUPMColors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
        ),
      );
      _titleController.clear();
      _descriptionController.clear();
      setState(() {
        _selectedRoomType = 'Double Room';
        _selectedCity = 'Any';
        _selectedMajor = 'Any';
        _selectedSmoking = 'No Preference';
        _selectedSleep = 'Flexible';
        _selectedStudy = 'Moderate';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.paddingMd,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text('Post a Request', style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('Find your perfect roommate match', style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant)),
                const SizedBox(height: 24),
                
                _SectionTitle(title: 'Basic Information', icon: Icons.edit_rounded),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(hintText: 'Give your request a catchy title...'),
                  validator: (v) => v == null || v.isEmpty ? 'Please enter a title' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(hintText: 'Describe yourself and what you\'re looking for...'),
                  maxLines: 4,
                  validator: (v) => v == null || v.isEmpty ? 'Please enter a description' : null,
                ),
                const SizedBox(height: 24),
                
                _SectionTitle(title: 'Room Type', icon: Icons.hotel_rounded),
                const SizedBox(height: 12),
                _SelectionGrid(
                  options: RoomService.getRoomTypeNames().where((r) => r != 'Any').toList(),
                  selected: _selectedRoomType,
                  onSelect: (v) => setState(() => _selectedRoomType = v),
                ),
                const SizedBox(height: 24),
                
                _SectionTitle(title: 'Location Preference', icon: Icons.location_on_rounded),
                const SizedBox(height: 12),
                _DropdownField(
                  value: _selectedCity,
                  items: RoomService.getCities(),
                  onChanged: (v) => setState(() => _selectedCity = v!),
                  hint: 'Preferred City',
                ),
                const SizedBox(height: 24),
                
                _SectionTitle(title: 'Academic Preference', icon: Icons.school_rounded),
                const SizedBox(height: 12),
                _DropdownField(
                  value: _selectedMajor,
                  items: RoomService.getMajors(),
                  onChanged: (v) => setState(() => _selectedMajor = v!),
                  hint: 'Preferred Major',
                ),
                const SizedBox(height: 24),
                
                _SectionTitle(title: 'Lifestyle Preferences', icon: Icons.favorite_rounded),
                const SizedBox(height: 12),
                Text('Smoking', style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant)),
                const SizedBox(height: 8),
                _SelectionGrid(
                  options: RoomService.getSmokingPreferences(),
                  selected: _selectedSmoking,
                  onSelect: (v) => setState(() => _selectedSmoking = v),
                ),
                const SizedBox(height: 16),
                Text('Sleep Schedule', style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant)),
                const SizedBox(height: 8),
                _SelectionGrid(
                  options: RoomService.getSleepSchedules(),
                  selected: _selectedSleep,
                  onSelect: (v) => setState(() => _selectedSleep = v),
                ),
                const SizedBox(height: 16),
                Text('Study Habits', style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant)),
                const SizedBox(height: 8),
                _SelectionGrid(
                  options: RoomService.getStudyHabits(),
                  selected: _selectedStudy,
                  onSelect: (v) => setState(() => _selectedStudy = v),
                ),
                const SizedBox(height: 32),
                
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submitRequest,
                    child: _isSubmitting 
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Text('Post Request', style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionTitle({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Row(
      children: [
        Icon(icon, size: 20, color: colorScheme.primary),
        const SizedBox(width: 8),
        Text(title, style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _SelectionGrid extends StatelessWidget {
  final List<String> options;
  final String selected;
  final Function(String) onSelect;

  const _SelectionGrid({required this.options, required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((option) {
        final isSelected = option == selected;
        return GestureDetector(
          onTap: () => onSelect(option),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? colorScheme.primary : colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(AppRadius.xl),
              border: Border.all(color: isSelected ? colorScheme.primary : Colors.transparent, width: 1.5),
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

class _DropdownField extends StatelessWidget {
  final String value;
  final List<String> items;
  final Function(String?) onChanged;
  final String hint;

  const _DropdownField({required this.value, required this.items, required this.onChanged, required this.hint});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          hint: Text(hint),
          icon: Icon(Icons.keyboard_arrow_down_rounded, color: colorScheme.onSurfaceVariant),
          items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
