import 'package:flutter/material.dart';

import '../../models/ogafix_models.dart';
import '../../models/user_profile_model.dart';
import '../profile/user_profile_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedFilter = 'All';

  final List<String> _filters = [
    'All',
    'Plumbing',
    'Electrical',
    'Web Designer',
    'App Developer',
    'AC Repair',
  ];

  @override
  Widget build(BuildContext context) {
    // Combine mock professionals with new trades
    final allPros = [
      ...MockData.professionals,
      Professional(
        id: 'p_web',
        name: 'Oluwaseun Adebayo',
        profession: 'Web Designer',
        rating: 4.9,
        completedJobs: 84,
        verificationLevel: 3,
        state: 'Lagos State',
        lga: 'Ikeja',
        serviceArea: 'Ikeja, Lagos',
        locationStamp: 'Stamped: Ikeja, Lagos',
        startingPrice: 25000,
        avatarUrl: '',
      ),
      Professional(
        id: 'p_app',
        name: 'Chidi Okoro',
        profession: 'App Developer',
        rating: 5.0,
        completedJobs: 62,
        verificationLevel: 4,
        state: 'Lagos State',
        lga: 'Lekki Phase 1',
        serviceArea: 'Lekki, Lagos',
        locationStamp: 'Stamped: Lekki, Lagos',
        startingPrice: 50000,
        avatarUrl: '',
      ),
    ];

    final filteredPros = allPros.where((pro) {
      final matchesQuery =
          pro.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          pro.profession.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          pro.serviceArea.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesFilter =
          _selectedFilter == 'All' ||
          pro.profession.toLowerCase().contains(_selectedFilter.toLowerCase());
      return matchesQuery && matchesFilter;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Handymen & Services'),
        backgroundColor: const Color(0xFF008751),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: InputDecoration(
                hintText:
                    'Search plumber, web designer, app developer, Ikeja...',
                prefixIcon: const Icon(Icons.search, color: Color(0xFF008751)),
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
                  borderRadius: BorderRadius.circular(16),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _filters.length,
                itemBuilder: (context, index) {
                  final filter = _filters[index];
                  final isSelected = _selectedFilter == filter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(filter),
                      selected: isSelected,
                      selectedColor: const Color(0xFF008751),
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                      onSelected: (val) =>
                          setState(() => _selectedFilter = filter),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: filteredPros.isEmpty
                  ? const Center(
                      child: Text(
                        'No professionals found matching your search.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredPros.length,
                      itemBuilder: (context, index) {
                        final pro = filteredPros[index];
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
                              yearsOfExperience: 5,
                              profession: pro.profession,
                              ninNumber: '12345678901',
                              description:
                                  'Verified professional specializing in ${pro.profession}.',
                              profileImageUrl: '',
                              jobStatuses: [],
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
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8F5E9),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.green.shade200),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 26,
                                  backgroundColor: const Color(0xFF008751),
                                  child: Text(
                                    pro.name.substring(0, 1),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
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
                                          color: Color(0xFF008751),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${pro.serviceArea} • ₦${pro.startingPrice.toStringAsFixed(0)} starting',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                  color: Color(0xFF008751),
                                ),
                              ],
                            ),
                          ),
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
