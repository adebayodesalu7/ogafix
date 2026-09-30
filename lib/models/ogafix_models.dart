import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  final String id;
  final String name;
  final String iconName;
  final String description;
  final List<String> specificServices;

  Category({
    required this.id,
    required this.name,
    required this.iconName,
    required this.description,
    required this.specificServices,
  });
}

class Professional {
  final String id;
  final String name;
  final String profession;
  final double rating;
  final int completedJobs;
  final int verificationLevel; // 0 to 4
  final String state;
  final String lga;
  final String serviceArea;
  final String locationStamp;
  final double startingPrice;
  final String avatarUrl;

  Professional({
    required this.id,
    required this.name,
    required this.profession,
    required this.rating,
    required this.completedJobs,
    required this.verificationLevel,
    required this.state,
    required this.lga,
    required this.serviceArea,
    required this.locationStamp,
    required this.startingPrice,
    required this.avatarUrl,
  });
}

class JobPost {
  final String id;
  final String categoryId;
  final String specificService;
  final String description;
  final String state;
  final String lga;
  final String locationStamp;
  final double budgetMin;
  final double budgetMax;
  final String status; // 'open', 'quoted', 'booked', 'completed'
  final DateTime createdAt;

  JobPost({
    required this.id,
    required this.categoryId,
    required this.specificService,
    required this.description,
    required this.state,
    required this.lga,
    required this.locationStamp,
    required this.budgetMin,
    required this.budgetMax,
    required this.status,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'categoryId': categoryId,
      'specificService': specificService,
      'description': description,
      'state': state,
      'lga': lga,
      'locationStamp': locationStamp,
      'budgetMin': budgetMin,
      'budgetMax': budgetMax,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory JobPost.fromMap(Map<String, dynamic> map) {
    DateTime parsedDate = DateTime.now();
    if (map['createdAt'] != null) {
      if (map['createdAt'] is Timestamp) {
        parsedDate = (map['createdAt'] as Timestamp).toDate();
      } else if (map['createdAt'] is String) {
        parsedDate = DateTime.tryParse(map['createdAt']) ?? DateTime.now();
      }
    }

    return JobPost(
      id: map['id'] ?? '',
      categoryId: map['categoryId'] ?? '',
      specificService: map['specificService'] ?? '',
      description: map['description'] ?? '',
      state: map['state'] ?? 'Lagos State',
      lga: map['lga'] ?? '',
      locationStamp: map['locationStamp'] ?? '',
      budgetMin: (map['budgetMin'] ?? 0.0).toDouble(),
      budgetMax: (map['budgetMax'] ?? 0.0).toDouble(),
      status: map['status'] ?? 'open',
      createdAt: parsedDate,
    );
  }
}

class Quote {
  final String id;
  final String jobId;
  final Professional professional;
  final double amount;
  final String message;

  Quote({
    required this.id,
    required this.jobId,
    required this.professional,
    required this.amount,
    required this.message,
  });
}

class MockData {
  static final List<Category> categories = [
    Category(
      id: 'c1',
      name: 'Plumbing',
      iconName: 'plumbing',
      description: 'Pipe repairs, leaky faucets, sanitary ware installation',
      specificServices: [
        'Leaking Pipe Repair',
        'Toilet & Sink Installation',
        'Water Heater Repair',
        'Drainage Unclogging',
      ],
    ),
    Category(
      id: 'c2',
      name: 'Electrical',
      iconName: 'electrical',
      description: 'Wiring, generator setup, light fixtures, inverter repairs',
      specificServices: [
        'Wiring & Rewiring',
        'Generator Installation & Repair',
        'Inverter & Solar Setup',
        'Switch & Socket Replacement',
      ],
    ),
    Category(
      id: 'c3',
      name: 'AC & Refrigeration',
      iconName: 'ac',
      description: 'AC servicing, gas refill, refrigerator repairs',
      specificServices: [
        'AC Full Servicing',
        'Gas Top-Up',
        'AC Installation & Relocation',
        'Refrigerator Repair',
      ],
    ),
    Category(
      id: 'c4',
      name: 'Web Designer',
      iconName: 'web',
      description: 'UI/UX design, WordPress websites, e-commerce stores',
      specificServices: [
        'Business Website Design',
        'E-Commerce Store Setup',
        'Landing Page UI/UX',
        'Website Maintenance',
      ],
    ),
    Category(
      id: 'c5',
      name: 'App Developer',
      iconName: 'app',
      description: 'Mobile app development for Android & iOS',
      specificServices: [
        'Flutter Mobile App',
        'Android Native App',
        'iOS App Development',
        'API Integration & Backend',
      ],
    ),
    Category(
      id: 'c6',
      name: 'Cleaning Services',
      iconName: 'cleaning',
      description: 'Deep cleaning, fumigation, laundry, and house chores',
      specificServices: [
        'Deep House Cleaning',
        'Fumigation & Pest Control',
        'Laundry & Ironing',
        'Office Cleaning',
      ],
    ),
    Category(
      id: 'c7',
      name: 'Tailoring & Fashion',
      iconName: 'tailoring',
      description: 'Custom native wear, alterations, and corporate tailoring',
      specificServices: [
        'Native Senator Wear',
        'Suit & Blazer Tailoring',
        'Cloth Alterations',
        'Bridal & Event Dresses',
      ],
    ),
    Category(
      id: 'c8',
      name: 'Security & CCTV',
      iconName: 'security',
      description: 'CCTV camera installation, electric fencing, and intercoms',
      specificServices: [
        'CCTV Camera Setup',
        'Electric Fence Installation',
        'Intercom & Access Control',
        'Smart Alarm Systems',
      ],
    ),
  ];

  static final List<Professional> professionals = [];
}
