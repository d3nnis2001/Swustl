import 'package:flutter/material.dart';
import 'package:swustl/views/shared/report_dialog.dart';
import 'package:swustl/models/hackathon_data.dart';
import 'package:swustl/models/hackathon_filter.dart';
import 'package:swustl/views/hackathon/hackathon_filter_dialog.dart';
import 'package:share_plus/share_plus.dart';

class HackathonScreen extends StatefulWidget {
  const HackathonScreen({super.key});

  @override
  HackathonScreenState createState() => HackathonScreenState();
}

class HackathonScreenState extends State<HackathonScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final HackathonService _hackathonService = HackathonService();
  final HackathonFilter _filter = HackathonFilter();
  final HackathonFilterDialog _filterDialog = HackathonFilterDialog();
  
  List<HackathonEvent> get filteredHackathons {
    return _filter.applyFilters(
      _hackathonService.getAllHackathons(),
      _searchQuery
    );
  }
  
  void _showReportHackathonDialog(BuildContext context, HackathonEvent hackathon) {
    showDialog(
      context: context,
      builder: (context) => ReportDialog(
        itemId: hackathon.id,
        itemName: hackathon.title,
        reportType: ReportType.project, // Wir verwenden hier project als Typ
      ),
    );
  }
  
  void _openFilterDialog() async {
    final result = await _filterDialog.showFilterDialog(context, _filter);
    if (result != null) {
      setState(() {
        // Apply the new filter
        _filter.showOnlyVirtual = result.showOnlyVirtual;
        _filter.showOnlyInPerson = result.showOnlyInPerson;
        _filter.selectedLocation = result.selectedLocation;
        _filter.selectedDateRange = result.selectedDateRange;
        _filter.selectedTechnologies = result.selectedTechnologies;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Hackathons',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: _openFilterDialog,
              ),
              // Show indicator if filters are active
              if (_filter.isActive)
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Suchfeld
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Suche nach Hackathons, Orten, Technologien...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          
          // Aktive Filter anzeigen
          if (_filter.isActive)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    if (_filter.showOnlyVirtual)
                      _buildFilterChip('Virtuell', () {
                        setState(() {
                          _filter.showOnlyVirtual = false;
                        });
                      }),
                    if (_filter.showOnlyInPerson)
                      _buildFilterChip('Vor Ort', () {
                        setState(() {
                          _filter.showOnlyInPerson = false;
                        });
                      }),
                    if (_filter.selectedLocation != 'Alle')
                      _buildFilterChip(_filter.selectedLocation, () {
                        setState(() {
                          _filter.selectedLocation = 'Alle';
                        });
                      }),
                    if (_filter.selectedDateRange != 'Alle')
                      _buildFilterChip(_filter.selectedDateRange, () {
                        setState(() {
                          _filter.selectedDateRange = 'Alle';
                        });
                      }),
                    ..._filter.selectedTechnologies.map((tech) => 
                      _buildFilterChip(tech, () {
                        setState(() {
                          _filter.selectedTechnologies.remove(tech);
                        });
                      }),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _filter.reset();
                        });
                      },
                      child: const Text('Alle zurücksetzen'),
                    ),
                  ],
                ),
              ),
            ),
          
          // Liste der Hackathons
          Expanded(
            child: filteredHackathons.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          'Keine Hackathons gefunden',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredHackathons.length,
                    padding: const EdgeInsets.only(bottom: 16),
                    itemBuilder: (context, index) {
                      final hackathon = filteredHackathons[index];
                      return HackathonCard(
                        hackathon: hackathon,
                        onReport: () => _showReportHackathonDialog(context, hackathon),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildFilterChip(String label, VoidCallback onRemove) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Chip(
        label: Text(label),
        deleteIcon: const Icon(Icons.close, size: 16),
        onDeleted: onRemove,
        backgroundColor: Colors.blue.withOpacity(0.1),
        labelStyle: const TextStyle(fontSize: 12),
        visualDensity: VisualDensity.compact,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}

class HackathonCard extends StatelessWidget {
  final HackathonEvent hackathon;
  final VoidCallback onReport;
  
  const HackathonCard({
    super.key,
    required this.hackathon,
    required this.onReport,
  });

  void _shareHackathon(BuildContext context, HackathonEvent hackathon) {
    final String shareText = '''
    ${hackathon.title}
📅   ${hackathon.date}
📍   ${hackathon.location}
🔧   ${hackathon.technologies.join(', ')}
    ${hackathon.description}

    Veranstalter: ${hackathon.organizerName}

    Entdeckt auf Swustl - Deine Projektfinder-App!
    ''';

    Share.share(shareText, subject: 'Spannender Hackathon: ${hackathon.title}');
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hackathon-Bild mit Badge für virtuell/vor Ort
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.asset(
                    hackathon.image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                      Container(
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(Icons.image, size: 50, color: Colors.white),
                        ),
                      ),
                  ),
                ),
              ),
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: hackathon.isVirtual ? Colors.purple : Colors.green,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        hackathon.isVirtual ? Icons.computer : Icons.location_on,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        hackathon.isVirtual ? 'Virtuell' : 'Vor Ort',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: const Icon(Icons.more_vert),
                  color: Colors.white,
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      builder: (context) => Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: const Icon(Icons.flag, color: Colors.red),
                            title: const Text('Hackathon melden'),
                            onTap: () {
                              Navigator.pop(context);
                              onReport();
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.share, color: Colors.blue),
                            title: const Text('Teilen'),
                            onTap: () {
                              Navigator.pop(context);
                              _shareHackathon(context, hackathon);
                            },
                          ),  
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          
          // Hackathon Informationen
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hackathon.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 6),
                    Text(
                      hackathon.date,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 6),
                    Text(
                      hackathon.location,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  hackathon.description,
                  style: const TextStyle(fontSize: 14),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                // Technologien
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: hackathon.technologies.map((tech) =>
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue.withOpacity(0.2)),
                      ),
                      child: Text(
                        tech,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ).toList(),
                ),
                const SizedBox(height: 16),
                // Veranstalter und Anmeldebutton
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          const Icon(Icons.group, size: 16),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              'Veranstalter: ${hackathon.organizerName}',
                              style: const TextStyle(fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Navigiere zur Detailseite oder öffne Anmeldeformular
                        _showHackathonDetailsDialog(context, hackathon);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                      child: const Text('Details'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  void _showHackathonDetailsDialog(BuildContext context, HackathonEvent hackathon) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle-Leiste
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 16),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                
                // Hackathon-Bild
                SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: Image.asset(
                    hackathon.image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => 
                      Container(
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(Icons.image, size: 50, color: Colors.white),
                        ),
                      ),
                  ),
                ),
                
                // Hackathon-Informationen
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: hackathon.isVirtual ? Colors.purple : Colors.green,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              hackathon.isVirtual ? 'Virtuell' : 'Vor Ort',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            hackathon.date,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        hackathon.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            hackathon.location,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Beschreibung',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        hackathon.description,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Technologien',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: hackathon.technologies.map((tech) =>
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.blue.withOpacity(0.2)),
                            ),
                            child: Text(
                              tech,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ).toList(),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Veranstalter',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            hackathon.organizerName,
                            style: const TextStyle(fontSize: 16),
                          ),
                          IconButton(
                            icon: const Icon(Icons.share, color: Colors.blue),
                            onPressed: () => _shareHackathon(context, hackathon),
                            tooltip: 'Teilen',
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // Anmeldelogik hier implementieren
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Anmeldung für ${hackathon.title} erfolgreich!'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Jetzt anmelden',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: BorderSide(color: Colors.grey.shade300),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Zurück',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}