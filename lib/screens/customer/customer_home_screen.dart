import 'package:flutter/material.dart';
import 'package:ogafix/screens/customer/map_search_screen.dart';
import 'package:ogafix/screens/customer/post_job_screen.dart';

import '../../models/ogafix_models.dart';

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  String selectedLocation = 'Lekki Phase 1, Lagos';
  final List<String> lagosLocations = [
    'Lekki Phase 1, Lagos',
    'Victoria Island, Lagos',
    'Ikoyi, Lagos',
    'Ajah, Lagos',
    'Ikeja, Lagos',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.location_on, color: Color(0xFF008751), size: 20),
            const SizedBox(width: 4),
            DropdownButton<String>(
              value: selectedLocation,
              underline: const SizedBox(),
              items: lagosLocations.map((loc) {
                return DropdownMenuItem(
                  value: loc,
                  child: Text(
                    loc,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) setState(() => selectedLocation = val);
              },
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.map, color: Color(0xFF008751)),
            tooltip: 'Map & Distance Search',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MapSearchScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search / Tell OgaFix Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF008751).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF008751).withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'What needs fixing today?',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1D1D1D),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Describe problem, take photo or record voice note.',
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PostJobScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF008751),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Post Job'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Categories Header
            const Text(
              'Service Categories',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),
              itemCount: MockData.categories.length,
              itemBuilder: (context, index) {
                final cat = MockData.categories[index];
                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.handyman,
                        color: Color(0xFF008751),
                        size: 28,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      cat.name,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),
            // Recommended Professionals
            const Text(
              'Verified Professionals Near You',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: MockData.professionals.length,
              itemBuilder: (context, index) {
                final pro = MockData.professionals[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey.shade200),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: const Color(0xFF008751)
                              .withOpacity(0.2),
                          child: Text(
                            pro.name.substring(0, 1),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF008751),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    pro.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  const Icon(
                                    Icons.verified,
                                    color: Color(0xFF008751),
                                    size: 16,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                pro.profession,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${pro.rating} (${pro.completedJobs} jobs)',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    '₦${pro.startingPrice.toStringAsFixed(0)} starting',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF008751),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
