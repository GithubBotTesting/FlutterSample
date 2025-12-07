import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dormlink/theme.dart';
import 'package:dormlink/models/roommate_request_model.dart';
import 'package:dormlink/services/roommate_request_service.dart';
import 'package:dormlink/services/room_service.dart';
import 'package:dormlink/screens/request_detail_screen.dart';
import 'package:dormlink/widgets/request_card.dart';
import 'package:dormlink/widgets/filter_bottom_sheet.dart';

class RequestsScreen extends StatefulWidget {
  const RequestsScreen({super.key});

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  String? _selectedCity;
  String? _selectedMajor;
  String? _selectedSmoking;
  String? _selectedSleep;
  String? _selectedStudy;
  String? _selectedRoomType;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _clearFilters() {
    setState(() {
      _selectedCity = null;
      _selectedMajor = null;
      _selectedSmoking = null;
      _selectedSleep = null;
      _selectedStudy = null;
      _selectedRoomType = null;
    });
  }

  bool get _hasFilters => _selectedCity != null || _selectedMajor != null || _selectedSmoking != null || 
                          _selectedSleep != null || _selectedStudy != null || _selectedRoomType != null;

  List<RoommateRequest> _filterAndSearchRequests(List<RoommateRequest> requests) {
    var filtered = requests.where((r) => r.isActive).toList();
    
    if (_selectedCity != null && _selectedCity != 'Any') {
      filtered = filtered.where((r) => r.preferredCity == 'Any' || r.preferredCity == _selectedCity).toList();
    }
    if (_selectedMajor != null && _selectedMajor != 'Any') {
      filtered = filtered.where((r) => r.preferredMajor == 'Any' || r.preferredMajor == _selectedMajor).toList();
    }
    if (_selectedSmoking != null && _selectedSmoking != 'No Preference') {
      filtered = filtered.where((r) => r.smokingPreference == 'No Preference' || r.smokingPreference == _selectedSmoking).toList();
    }
    if (_selectedSleep != null && _selectedSleep != 'Flexible') {
      filtered = filtered.where((r) => r.sleepSchedule == 'Flexible' || r.sleepSchedule == _selectedSleep).toList();
    }
    if (_selectedStudy != null) {
      filtered = filtered.where((r) => r.studyHabits == _selectedStudy).toList();
    }
    if (_selectedRoomType != null && _selectedRoomType != 'Any') {
      filtered = filtered.where((r) => r.roomType == _selectedRoomType).toList();
    }
    
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((r) => 
        r.title.toLowerCase().contains(query) || 
        r.description.toLowerCase().contains(query) ||
        r.userName.toLowerCase().contains(query)
      ).toList();
    }
    
    return filtered;
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheet(
        selectedCity: _selectedCity,
        selectedMajor: _selectedMajor,
        selectedSmoking: _selectedSmoking,
        selectedSleep: _selectedSleep,
        selectedStudy: _selectedStudy,
        selectedRoomType: _selectedRoomType,
        onApply: (city, major, smoking, sleep, study, roomType) {
          setState(() {
            _selectedCity = city;
            _selectedMajor = major;
            _selectedSmoking = smoking;
            _selectedSleep = sleep;
            _selectedStudy = study;
            _selectedRoomType = roomType;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final requestService = context.watch<RoommateRequestService>();
    final filteredRequests = _filterAndSearchRequests(requestService.requests);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text('Find Roommates', style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('Browse through roommate requests', style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          onChanged: (value) => setState(() => _searchQuery = value),
                          decoration: InputDecoration(
                            hintText: 'Search requests...',
                            prefixIcon: Icon(Icons.search_rounded, color: colorScheme.onSurfaceVariant),
                            suffixIcon: _searchQuery.isNotEmpty 
                              ? IconButton(
                                  icon: Icon(Icons.clear_rounded, color: colorScheme.onSurfaceVariant),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() => _searchQuery = '');
                                  },
                                )
                              : null,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: _showFilterSheet,
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: _hasFilters ? colorScheme.primary : colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(AppRadius.md),
                          ),
                          child: Icon(Icons.tune_rounded, color: _hasFilters ? colorScheme.onPrimary : colorScheme.onSurfaceVariant),
                        ),
                      ),
                    ],
                  ),
                  if (_hasFilters) ...[
                    const SizedBox(height: 12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          if (_selectedCity != null) _FilterChip(label: _selectedCity!, onRemove: () => setState(() => _selectedCity = null)),
                          if (_selectedMajor != null) _FilterChip(label: _selectedMajor!, onRemove: () => setState(() => _selectedMajor = null)),
                          if (_selectedSmoking != null) _FilterChip(label: _selectedSmoking!, onRemove: () => setState(() => _selectedSmoking = null)),
                          if (_selectedSleep != null) _FilterChip(label: _selectedSleep!, onRemove: () => setState(() => _selectedSleep = null)),
                          if (_selectedStudy != null) _FilterChip(label: _selectedStudy!, onRemove: () => setState(() => _selectedStudy = null)),
                          if (_selectedRoomType != null) _FilterChip(label: _selectedRoomType!, onRemove: () => setState(() => _selectedRoomType = null)),
                          TextButton(onPressed: _clearFilters, child: Text('Clear all', style: TextStyle(color: colorScheme.error))),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text('${filteredRequests.length} requests found', style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant)),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: requestService.isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredRequests.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off_rounded, size: 64, color: colorScheme.onSurfaceVariant),
                          const SizedBox(height: 16),
                          Text('No requests found', style: textTheme.titleMedium?.copyWith(color: colorScheme.onSurfaceVariant)),
                          const SizedBox(height: 8),
                          Text('Try adjusting your filters', style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant)),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                      itemCount: filteredRequests.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final request = filteredRequests[index];
                        return RequestCard(
                          request: request,
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RequestDetailScreen(request: request))),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;

  const _FilterChip({required this.label, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: colorScheme.onPrimaryContainer, fontWeight: FontWeight.w500)),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: Icon(Icons.close_rounded, size: 16, color: colorScheme.onPrimaryContainer),
          ),
        ],
      ),
    );
  }
}
