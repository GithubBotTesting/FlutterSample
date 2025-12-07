import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dormlink/theme.dart';
import 'package:dormlink/models/user_model.dart';
import 'package:dormlink/services/user_service.dart';
import 'package:dormlink/services/room_service.dart';
import 'package:dormlink/screens/portal_redirect_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final userService = context.watch<UserService>();
    final currentUser = userService.currentUser;

    if (currentUser == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.paddingMd,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Profile', style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                  IconButton(
                    onPressed: () => _showEditProfileSheet(context, currentUser),
                    icon: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: colorScheme.primaryContainer, borderRadius: BorderRadius.circular(AppRadius.md)),
                      child: Icon(Icons.edit_rounded, color: colorScheme.primary, size: 20),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Profile Card
              Container(
                width: double.infinity,
                padding: AppSpacing.paddingLg,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [KFUPMColors.green, KFUPMColors.forest], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 45,
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      child: Text(currentUser.name.isNotEmpty ? currentUser.name[0].toUpperCase() : 'U', style: textTheme.displaySmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 16),
                    Text(currentUser.name, style: textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(currentUser.email, style: textTheme.bodyMedium?.copyWith(color: Colors.white.withValues(alpha: 0.8))),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(AppRadius.xl)),
                      child: Text('${currentUser.major} • Year ${currentUser.year}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 13)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Bio
              if (currentUser.bio.isNotEmpty) ...[
                _ProfileSection(title: 'About Me', icon: Icons.info_outline_rounded),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: AppSpacing.paddingMd,
                  decoration: BoxDecoration(color: colorScheme.surface, borderRadius: BorderRadius.circular(AppRadius.lg), border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2))),
                  child: Text(currentUser.bio, style: textTheme.bodyMedium?.copyWith(height: 1.5)),
                ),
                const SizedBox(height: 20),
              ],
              
              // Preferences
              _ProfileSection(title: 'My Preferences', icon: Icons.tune_rounded),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _PreferenceTag(icon: Icons.location_city_rounded, label: currentUser.city),
                  _PreferenceTag(icon: Icons.smoke_free_rounded, label: currentUser.smokingPreference),
                  _PreferenceTag(icon: Icons.nightlight_rounded, label: currentUser.sleepSchedule),
                  _PreferenceTag(icon: Icons.menu_book_rounded, label: currentUser.studyHabits),
                ],
              ),
              const SizedBox(height: 24),
              
              // Quick Actions
              _ProfileSection(title: 'Quick Actions', icon: Icons.flash_on_rounded),
              const SizedBox(height: 12),
              _ActionTile(
                icon: Icons.open_in_new_rounded,
                title: 'University Portal',
                subtitle: 'Submit official roommate request',
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PortalRedirectScreen())),
              ),
              const SizedBox(height: 8),
              _ActionTile(
                icon: Icons.help_outline_rounded,
                title: 'Help & Support',
                subtitle: 'Get help with the app',
                onTap: () => _showHelpSheet(context),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditProfileSheet(BuildContext context, AppUser user) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _EditProfileSheet(user: user),
    );
  }

  void _showHelpSheet(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    showModalBottomSheet(
      context: context,
      backgroundColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Padding(
        padding: AppSpacing.paddingLg,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: colorScheme.outline.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 20),
            Text('Help & Support', style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text('DormLink helps KFUPM students find compatible roommates. Browse requests, chat with potential roommates, and submit official requests through the university portal.', style: textTheme.bodyMedium?.copyWith(height: 1.5)),
            const SizedBox(height: 16),
            Text('For technical support, contact: support@kfupm.edu.sa', style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant)),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _ProfileSection extends StatelessWidget {
  final String title;
  final IconData icon;

  const _ProfileSection({required this.title, required this.icon});

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

class _PreferenceTag extends StatelessWidget {
  final IconData icon;
  final String label;

  const _PreferenceTag({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(color: colorScheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(AppRadius.xl)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: colorScheme.onSurfaceVariant),
          const SizedBox(width: 8),
          Text(label, style: TextStyle(fontSize: 13, color: colorScheme.onSurface, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ActionTile({required this.icon, required this.title, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: AppSpacing.paddingMd,
        decoration: BoxDecoration(color: colorScheme.surface, borderRadius: BorderRadius.circular(AppRadius.lg), border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2))),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: colorScheme.primaryContainer, borderRadius: BorderRadius.circular(AppRadius.md)),
              child: Icon(icon, color: colorScheme.primary, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant)),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: colorScheme.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}

class _EditProfileSheet extends StatefulWidget {
  final AppUser user;

  const _EditProfileSheet({required this.user});

  @override
  State<_EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends State<_EditProfileSheet> {
  late TextEditingController _nameController;
  late TextEditingController _bioController;
  late String _selectedCity;
  late String _selectedMajor;
  late String _selectedSmoking;
  late String _selectedSleep;
  late String _selectedStudy;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _bioController = TextEditingController(text: widget.user.bio);
    _selectedCity = widget.user.city;
    _selectedMajor = widget.user.major;
    _selectedSmoking = widget.user.smokingPreference;
    _selectedSleep = widget.user.sleepSchedule;
    _selectedStudy = widget.user.studyHabits;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    final userService = context.read<UserService>();
    await userService.updateUser(widget.user.copyWith(
      name: _nameController.text,
      bio: _bioController.text,
      city: _selectedCity,
      major: _selectedMajor,
      smokingPreference: _selectedSmoking,
      sleepSchedule: _selectedSleep,
      studyHabits: _selectedStudy,
    ));
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Container(
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.85),
      decoration: BoxDecoration(color: colorScheme.surface, borderRadius: const BorderRadius.vertical(top: Radius.circular(24))),
      child: SingleChildScrollView(
        padding: AppSpacing.paddingLg,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: colorScheme.outline.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 20),
            Text('Edit Profile', style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Name')),
            const SizedBox(height: 12),
            TextField(controller: _bioController, decoration: const InputDecoration(labelText: 'Bio'), maxLines: 3),
            const SizedBox(height: 12),
            _buildDropdown('City', _selectedCity, RoomService.getCities().where((c) => c != 'Any').toList(), (v) => setState(() => _selectedCity = v!)),
            const SizedBox(height: 12),
            _buildDropdown('Major', _selectedMajor, RoomService.getMajors().where((m) => m != 'Any').toList(), (v) => setState(() => _selectedMajor = v!)),
            const SizedBox(height: 12),
            _buildDropdown('Smoking Preference', _selectedSmoking, RoomService.getSmokingPreferences(), (v) => setState(() => _selectedSmoking = v!)),
            const SizedBox(height: 12),
            _buildDropdown('Sleep Schedule', _selectedSleep, RoomService.getSleepSchedules(), (v) => setState(() => _selectedSleep = v!)),
            const SizedBox(height: 12),
            _buildDropdown('Study Habits', _selectedStudy, RoomService.getStudyHabits(), (v) => setState(() => _selectedStudy = v!)),
            const SizedBox(height: 24),
            SizedBox(width: double.infinity, child: ElevatedButton(onPressed: _saveProfile, child: const Text('Save Changes', style: TextStyle(color: Colors.white)))),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, String value, List<String> items, Function(String?) onChanged) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(color: colorScheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(AppRadius.md)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          hint: Text(label),
          items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
