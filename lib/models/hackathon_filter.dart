import 'package:swustl/models/hackathon_data.dart';

class HackathonFilter {
  bool showOnlyVirtual = false;
  bool showOnlyInPerson = false;
  String selectedLocation = 'Alle';
  String selectedDateRange = 'Alle';
  List<String> selectedTechnologies = [];

  HackathonFilter();

  // Reset all filters to their default values
  void reset() {
    showOnlyVirtual = false;
    showOnlyInPerson = false;
    selectedLocation = 'Alle';
    selectedDateRange = 'Alle';
    selectedTechnologies = [];
  }

  // Check if any filter is active
  bool get isActive => 
      showOnlyVirtual || 
      showOnlyInPerson || 
      selectedLocation != 'Alle' || 
      selectedDateRange != 'Alle' || 
      selectedTechnologies.isNotEmpty;

  // Apply filters to a list of hackathons
  List<HackathonEvent> applyFilters(List<HackathonEvent> hackathons, String searchQuery) {
    List<HackathonEvent> result = List.from(hackathons);
    
    // Filter by event type (virtual/in-person)
    if (showOnlyVirtual) {
      result = result.where((h) => h.isVirtual).toList();
    } else if (showOnlyInPerson) {
      result = result.where((h) => !h.isVirtual).toList();
    }
    
    // Filter by location
    if (selectedLocation != 'Alle') {
      result = result.where((h) => h.location == selectedLocation).toList();
    }
    
    // Filter by date range
    if (selectedDateRange != 'Alle') {
      final now = DateTime.now();
      switch (selectedDateRange) {
        case 'Diesen Monat':
          result = result.where((h) {
            final date = _parseHackathonDate(h.date);
            return date.year == now.year && date.month == now.month;
          }).toList();
          break;
        case 'Nächsten Monat':
          final nextMonth = DateTime(now.year, now.month + 1);
          result = result.where((h) {
            final date = _parseHackathonDate(h.date);
            return date.year == nextMonth.year && date.month == nextMonth.month;
          }).toList();
          break;
        case 'Nächste 3 Monate':
          final threeMonthsLater = DateTime(now.year, now.month + 3);
          result = result.where((h) {
            final date = _parseHackathonDate(h.date);
            return date.isAfter(now) && date.isBefore(threeMonthsLater);
          }).toList();
          break;
      }
    }
    
    // Filter by technologies
    if (selectedTechnologies.isNotEmpty) {
      result = result.where((h) {
        return selectedTechnologies.every((tech) => h.technologies.contains(tech));
      }).toList();
    }
    
    // Filter by search query
    if (searchQuery.isNotEmpty) {
      final searchLower = searchQuery.toLowerCase();
      result = result.where((hackathon) =>
        hackathon.title.toLowerCase().contains(searchLower) ||
        hackathon.description.toLowerCase().contains(searchLower) ||
        hackathon.location.toLowerCase().contains(searchLower) ||
        hackathon.technologies.any((tech) => 
            tech.toLowerCase().contains(searchLower))
      ).toList();
    }
    
    return result;
  }

  // Helper method to parse date from string
  DateTime _parseHackathonDate(String dateStr) {
    // Example: "24.-26. Mai 2025" -> Takes the first date (24. Mai 2025)
    final parts = dateStr.split('.');
    if (parts.length >= 2) {
      final day = int.tryParse(parts[0].replaceAll(RegExp(r'[^0-9]'), '')) ?? 1;
      String monthStr = parts[1].trim();
      if (monthStr.contains(' ')) {
        monthStr = monthStr.split(' ')[1];
      }
      
      int month;
      switch (monthStr.toLowerCase()) {
        case 'januar': month = 1; break;
        case 'februar': month = 2; break;
        case 'märz': month = 3; break;
        case 'april': month = 4; break;
        case 'mai': month = 5; break;
        case 'juni': month = 6; break;
        case 'juli': month = 7; break;
        case 'august': month = 8; break;
        case 'september': month = 9; break;
        case 'oktober': month = 10; break;
        case 'november': month = 11; break;
        case 'dezember': month = 12; break;
        default: month = 1;
      }
      
      int year = 2025; // Default value
      if (parts.length > 2) {
        year = int.tryParse(parts[2].trim()) ?? 2025;
      } else if (dateStr.contains('20')) {
        // Try to extract the year from the string
        final yearMatch = RegExp(r'20\d{2}').firstMatch(dateStr);
        if (yearMatch != null) {
          year = int.tryParse(yearMatch.group(0) ?? '') ?? 2025;
        }
      }
      
      return DateTime(year, month, day);
    }
    
    return DateTime.now(); // Fallback
  }
  
  // Create a copy of this filter
  HackathonFilter copy() {
    final filter = HackathonFilter();
    filter.showOnlyVirtual = showOnlyVirtual;
    filter.showOnlyInPerson = showOnlyInPerson;
    filter.selectedLocation = selectedLocation;
    filter.selectedDateRange = selectedDateRange;
    filter.selectedTechnologies = List.from(selectedTechnologies);
    return filter;
  }
}