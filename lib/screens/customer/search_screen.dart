import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, String>> _categories = [
    {
      'title': 'Graphics & Design',
      'subtitle': 'Web & App Design, Art & Illustration',
      'icon': 'brush',
    },
    {
      'title': 'Programming & Tech',
      'subtitle': 'Website Development, Website Platforms',
      'icon': 'code',
    },
    {
      'title': 'AI Services',
      'subtitle': 'AI Mobile Development, Data',
      'icon': 'smart_toy',
    },
    {
      'title': 'Digital Marketing',
      'subtitle': 'Search, Social',
      'icon': 'trending_up',
    },
    {
      'title': 'Video & Animation',
      'subtitle': 'Editing & Post-Production, Social & Marketing Videos',
      'icon': 'movie',
    },
    {
      'title': 'Writing & Translation',
      'subtitle': 'Content Writing, Editing & Critique',
      'icon': 'edit_note',
    },
    {
      'title': 'Music & Audio',
      'subtitle': 'Music Production & Writing, Voice Over & Narration',
      'icon': 'music_note',
    },
    {
      'title': 'Business',
      'subtitle': 'Business Formation & Consulting, Operations & Management',
      'icon': 'business_center',
    },
    {
      'title': 'Finance',
      'subtitle': 'Accounting Services, Corporate Finance',
      'icon': 'account_balance',
    },
    {
      'title': 'Personal Growth',
      'subtitle': 'Self Improvement, Fashion & Style',
      'icon': 'self_improvement',
    },
  ];

  final List<Map<String, String>> _interests = [
    {
      'title': 'Create social media content',
      'subtitle': 'Create authentic UGC videos, Social Media Copywriting',
    },
    {
      'title': 'Develop a brand identity',
      'subtitle': 'Logo Design, Business Cards & Stationery',
    },
    {
      'title': 'Edit photos and images',
      'subtitle': 'Product Image Editing, Photo Manipulation',
    },
    {
      'title': 'Create print-ready designs',
      'subtitle': 'T-Shirts & Merchandise, Illustration',
    },
    {
      'title': 'Get professional photos taken',
      'subtitle': 'Product Photographers, Lifestyle & Fashion Photographers',
    },
    {'title': 'Improve gaming skills', 'subtitle': 'Game Coaching, Gaming'},
    {
      'title': 'Create streaming assets',
      'subtitle': 'Graphics for Streamers, Animation for Streamers',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text(
          'Categories',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1E1E1E),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF008751),
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: 'Categories'),
            Tab(text: 'Interests'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Categories Tab
          ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final cat = _categories[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1E1E),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade800),
                      ),
                      child: const Icon(
                        Icons.handyman,
                        color: Color(0xFF008751),
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cat['title']!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            cat['subtitle']!,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
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
          // Interests Tab
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your interests',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Choose your interests for a better discovery experience.',
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Choose Interests',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'You may also like',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _interests.length,
                  itemBuilder: (context, index) {
                    final item = _interests[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E1E1E),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade800),
                            ),
                            child: const Icon(
                              Icons.star_outline,
                              color: Color(0xFF008751),
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['title']!,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  item['subtitle']!,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
