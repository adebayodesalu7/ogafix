import 'package:flutter/material.dart';

import '../../models/ogafix_models.dart';
import '../../models/user_profile_model.dart';
import '../profile/user_profile_screen.dart';
import 'map_search_screen.dart';
import 'post_job_screen.dart';

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  String selectedLocation = 'Lekki Phase 1, Lagos';
  int _bottomNavIndex = 0;

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
          // 3-Line Settings & Profile Menu Icon
          PopupMenuButton<String>(
            icon: const Icon(Icons.menu, color: Color(0xFF008751)),
            onSelected: (val) {
              if (val == 'profile') {
                final demoProfile = UserProfile(
                  uid: 'cust1',
                  email: 'customer@ogafix.ng',
                  phone: '+2348011905411',
                  role: 'customer',
                  fullName: 'Adebayo Desalu',
                  state: 'Lagos State',
                  lga: 'Eti-Osa',
                  stateOfOrigin: 'Lagos',
                  age: 28,
                  yearsOfExperience: 0,
                  profession: 'Customer',
                  ninNumber: '12345678901',
                  description: 'OgaFix Valued Customer Account in Lagos.',
                  profileImageUrl: '',
                  verificationLevel: 2,
                  emailVerified: true,
                  phoneVerified: true,
                  ninVerified: true,
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        UserProfileScreen(profile: demoProfile),
                  ),
                );
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'profile', child: Text('My Profile')),
              const PopupMenuItem(
                value: 'settings',
                child: Text('Account Settings'),
              ),
              const PopupMenuItem(
                value: 'support',
                child: Text('OgaFix Support'),
              ),
            ],
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
                color: const Color(0xFF008751).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFF008751).withValues(alpha: 0.3),
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
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
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
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
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
            // Recommended Professionals (Greenish Design Boxes - Screenshot 3 Style)
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
                return InkWell(
                  onTap: () {
                    final userProfile = UserProfile(
                      uid: pro.id,
                      email:
                          '${pro.name.toLowerCase().replaceAll(' ', '')}@ogafix.ng',
                      phone: '+2348000000000',
                      role: 'professional',
                      fullName: pro.name,
                      state: pro.state,
                      lga: pro.lga,
                      stateOfOrigin: 'Lagos State',
                      age: 32,
                      yearsOfExperience: 6,
                      profession: pro.profession,
                      ninNumber: '29384756102',
                      description: 'Certified master artisan with over 6 years of professional experience handling residential and commercial repairs across Lagos State.',
                      profileImageUrl: '',
                      verificationLevel: pro.verificationLevel,
                      emailVerified: true,
                      phoneVerified: true,
                      ninVerified: true,
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            UserProfileScreen(profile: userProfile),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9), // Greenish design box
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.green.shade200,
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withValues(alpha: 0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: const Color(0xFF008751),
                          child: Text(
                            pro.name.substring(0, 1),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
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
                                      color: Color(0xFF00331A),
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
                                  color: Color(0xFF006633),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
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
                                  const Spacer(),
                                  Text(
                                    '₦${pro.startingPrice.toStringAsFixed(0)} starting',
                                    style: const TextStyle(
                                      fontSize: 13,
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomNavIndex,
        selectedItemColor: const Color(0xFF008751),
        unselectedItemColor: Colors.grey,
        onTap: (val) => setState(() => _bottomNavIndex = val),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
