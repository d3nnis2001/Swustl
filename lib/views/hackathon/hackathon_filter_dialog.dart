import 'package:flutter/material.dart';
import 'package:swustl/models/hackathon_data.dart';
import 'package:swustl/models/hackathon_filter.dart';

class HackathonFilterDialog {
  final HackathonService _hackathonService = HackathonService();
  
  // Lists for filter options
  List<String> get _allLocations {
    final locations = _hackathonService.getAllHackathons()
        .map((h) => h.location)
        .toSet()
        .toList();
    locations.sort();
    return ['Alle', ...locations];
  }
  
  List<String> get _allTechnologies {
    final techSet = <String>{};
    for (var hackathon in _hackathonService.getAllHackathons()) {
      techSet.addAll(hackathon.technologies);
    }
    final technologies = techSet.toList();
    technologies.sort();
    return technologies;
  }
  
  final List<String> _dateRanges = [
    'Alle',
    'Diesen Monat',
    'Nächsten Monat',
    'Nächste 3 Monate',
  ];

  // Show the filter dialog
  Future<HackathonFilter?> showFilterDialog(BuildContext context, HackathonFilter currentFilter) async {
    // Create a temporary copy of the current filter
    final tempFilter = currentFilter.copy();
    
    final result = await showModalBottomSheet<HackathonFilter?>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return DraggableScrollableSheet(
              initialChildSize: 0.7,
              minChildSize: 0.5,
              maxChildSize: 0.95,
              expand: false,
              builder: (context, scrollController) {
                return Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: ListView(
                    controller: scrollController,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Filter',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Event Type
                      const Text(
                        'Veranstaltungstyp',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      CheckboxListTile(
                        title: const Text('Nur virtuelle Events'),
                        value: tempFilter.showOnlyVirtual,
                        activeColor: Colors.blue,
                        onChanged: (value) {
                          setState(() {
                            tempFilter.showOnlyVirtual = value ?? false;
                            if (tempFilter.showOnlyVirtual) {
                              tempFilter.showOnlyInPerson = false;
                            }
                          });
                        },
                        contentPadding: EdgeInsets.zero,
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                      CheckboxListTile(
                        title: const Text('Nur Vor-Ort-Events'),
                        value: tempFilter.showOnlyInPerson,
                        activeColor: Colors.blue,
                        onChanged: (value) {
                          setState(() {
                            tempFilter.showOnlyInPerson = value ?? false;
                            if (tempFilter.showOnlyInPerson) {
                              tempFilter.showOnlyVirtual = false;
                            }
                          });
                        },
                        contentPadding: EdgeInsets.zero,
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                      
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 16),
                      
                      // Location
                      const Text(
                        'Standort',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                        value: tempFilter.selectedLocation,
                        items: _allLocations.map((location) => 
                          DropdownMenuItem(
                            value: location,
                            child: Text(location),
                          )
                        ).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              tempFilter.selectedLocation = value;
                            });
                          }
                        },
                      ),
                      
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 16),
                      
                      // Date Range
                      const Text(
                        'Zeitraum',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _dateRanges.map((range) => 
                          ChoiceChip(
                            label: Text(range),
                            selected: tempFilter.selectedDateRange == range,
                            onSelected: (selected) {
                              if (selected) {
                                setState(() {
                                  tempFilter.selectedDateRange = range;
                                });
                              }
                            },
                            selectedColor: Colors.blue.withOpacity(0.2),
                          ),
                        ).toList(),
                      ),
                      
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 16),
                      
                      // Technologies
                      const Text(
                        'Technologien',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Wähle Technologien, die dich interessieren',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _allTechnologies.map((tech) => 
                          FilterChip(
                            label: Text(tech),
                            selected: tempFilter.selectedTechnologies.contains(tech),
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  tempFilter.selectedTechnologies.add(tech);
                                } else {
                                  tempFilter.selectedTechnologies.remove(tech);
                                }
                              });
                            },
                            selectedColor: Colors.blue.withOpacity(0.2),
                          ),
                        ).toList(),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  tempFilter.reset();
                                });
                              },
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                side: BorderSide(color: Colors.grey.shade300),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text('Zurücksetzen'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context, tempFilter);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Filter anwenden',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
    
    return result; // Returns null if cancelled, or the new filter if applied
  }
}