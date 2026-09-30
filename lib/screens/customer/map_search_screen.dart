import 'package:flutter/material.dart';

import '../../models/ogafix_models.dart';

class MapSearchScreen extends StatefulWidget {
  const MapSearchScreen({super.key});

  @override
  State<MapSearchScreen> createState() => _MapSearchScreenState();
}

class _MapSearchScreenState extends State<MapSearchScreen> {
  double _selectedRadiusKm = 5.0; // Default 5km radius in Lagos
  String _searchQuery = '';
  String _selectedCategory = 'All';

  final List<Map<String, dynamic>> _mockProsWithCoords = [
    {
      'pro': MockData.professionals[0],
      'lat': 6.4474,
      'lng': 3.4723,
      'distance': 1.2, // km
    },
    {
      'pro': MockData.professionals[1],
      'lat': 6.4281,
      'lng': 3.4219,
      'distance': 3.5, // km
    },
    {
      'pro': MockData.professionals[2],
      'lat': 6.4654,
      'lng': 3.5653,
      'distance': 8.0, // km
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredPros = _mockProsWithCoords.where((item) {
      final Professional pro = item['pro'];
      final double distance = item['distance'];
      final matchesRadius = distance <= _selectedRadiusKm;
      final matchesQuery =
          pro.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          pro.profession.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesRadius && matchesQuery;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Nearby Pros on Map'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Open advanced filter
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar & Radius Filter Header
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  onChanged: (val) => setState(() => _searchQuery = val),
                  decoration: InputDecoration(
                    hintText: 'Search plumber, electrician, AC repair...',
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Color(0xFF008751),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Distance Radius: ${_selectedRadiusKm.toStringAsFixed(1)} km',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      '${filteredPros.length} pros found',
                      style: const TextStyle(
                        color: Color(0xFF008751),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Slider(
                  value: _selectedRadiusKm,
                  min: 1.0,
                  max: 20.0,
                  divisions: 19,
                  activeColor: const Color(0xFF008751),
                  label: '${_selectedRadiusKm.toStringAsFixed(1)} km',
                  onChanged: (val) => setState(() => _selectedRadiusKm = val),
                ),
              ],
            ),
          ),
          // Interactive Map Simulation View
          Expanded(
            flex: 3,
            child: Container(
              color: const Color(0xFFE8F5E9),
              child: Stack(
                children: [
                  // Map grid lines background simulation
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.map_rounded,
                          size: 64,
                          color: Color(0xFF008751),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Lagos Service Map (Radius: ${_selectedRadiusKm.toStringAsFixed(1)}km)',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF008751),
                          ),
                        ),
                        const Text(
                          'Showing verified professionals within range',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  // Simulated Map Pins
                  ...filteredPros.map((item) {
                    final Professional pro = item['pro'];
                    final double distance = item['distance'];
                    // Randomize position slightly for simulation
                    return Positioned(
                      top: 50.0 + (pro.name.hashCode % 150),
                      left: 50.0 + (pro.profession.hashCode % 200),
                      child: InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) => Container(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: const Color(0xFF008751)
                                            .withOpacity(0.2),
                                        child: Text(
                                          pro.name.substring(0, 1),
                                          style: const TextStyle(
                                            color: Color(0xFF008751),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            pro.name,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          Text(
                                            pro.profession,
                                            style: const TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      Chip(
                                        label: Text(
                                          '$distance km away',
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: Colors.white,
                                          ),
                                        ),
                                        backgroundColor: const Color(
                                          0xFF008751,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${pro.rating} (${pro.completedJobs} completed jobs)',
                                      ),
                                      const Spacer(),
                                      Text(
                                        '₦${pro.startingPrice.toStringAsFixed(0)} starting',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF008751),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Requesting quote from ${pro.name}...',
                                          ),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF008751),
                                      foregroundColor: Colors.white,
                                      minimumSize: const Size(
                                        double.infinity,
                                        48,
                                      ),
                                    ),
                                    child: const Text(
                                      'Request Quote / Book Now',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                            border: Border.all(
                              color: const Color(0xFF008751),
                              width: 2,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.person_pin_circle,
                                color: Color(0xFF008751),
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${distance}km',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          // Pros List within Radius
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.white,
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: filteredPros.length,
                itemBuilder: (context, index) {
                  final item = filteredPros[index];
                  final Professional pro = item['pro'];
                  final double distance = item['distance'];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFF008751).withOpacity(0.2),
                      child: Text(
                        pro.name.substring(0, 1),
                        style: const TextStyle(
                          color: Color(0xFF008751),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      pro.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('${pro.profession} • $distance km away'),
                    trailing: Text(
                      '₦${pro.startingPrice.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF008751),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
