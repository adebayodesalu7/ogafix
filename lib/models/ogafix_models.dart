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
}

class Quote {
  final String id;
  final String jobId;
  final Professional professional;
  final double amount;
  final String message;
  final String estimatedDuration;
  final String status; // 'pending', 'accepted', 'rejected'

  Quote({
    required this.id,
    required this.jobId,
    required this.professional,
    required this.amount,
    required this.message,
    required this.estimatedDuration,
    required this.status,
  });
}

class Booking {
  final String id;
  final String jobId;
  final Quote quote;
  final DateTime scheduledAt;
  final String
  status; // 'Confirmed', 'On the way', 'Arrived', 'Started', 'Completed'

  Booking({
    required this.id,
    required this.jobId,
    required this.quote,
    required this.scheduledAt,
    required this.status,
  });
}

// Mock Data Repository
class MockData {
  static final List<Category> categories = [
    Category(
      id: 'c1',
      name: 'Plumbing',
      iconName: 'plumbing',
      description: 'Leaking pipes, toilets, water heaters, pumps',
      specificServices: [
        'Leaking Pipe Repair',
        'Blocked Toilet/Drain',
        'Water Heater Installation',
        'Water Pump Fix',
        'Tank Washing',
      ],
    ),
    Category(
      id: 'c2',
      name: 'Electrical',
      iconName: 'electrical_services',
      description: 'Wiring, socket repair, lighting, distribution boards',
      specificServices: [
        'House Wiring',
        'Socket/Switch Replacement',
        'Lighting Installation',
        'Distribution Board Repair',
        'Inverter Setup',
      ],
    ),
    Category(
      id: 'c3',
      name: 'AC & Refrigeration',
      iconName: 'ac_unit',
      description: 'AC servicing, gas refilling, fridge repairs',
      specificServices: [
        'AC Full Servicing',
        'Gas Refilling',
        'AC Installation/Uninstallation',
        'Refrigerator Repair',
        'Chiller Maintenance',
      ],
    ),
    Category(
      id: 'c4',
      name: 'Generator Repair',
      iconName: 'bolt',
      description: 'Generator servicing, coil rewinding, engine fixing',
      specificServices: [
        'Generator Servicing (Oil/Filter)',
        'Coil Rewinding',
        'Starting Motor Fix',
        'Carburetor Cleaning',
        'Diesel Generator Overhaul',
      ],
    ),
    Category(
      id: 'c5',
      name: 'Cleaning',
      iconName: 'cleaning_services',
      description: 'Deep cleaning, post-construction, fumigation',
      specificServices: [
        'Deep House Cleaning',
        'Post-Construction Cleanup',
        'Fumigation & Pest Control',
        'Office Cleaning',
        'Sofa/Carpet Washing',
      ],
    ),
    Category(
      id: 'c6',
      name: 'Carpentry',
      iconName: 'chair',
      description: 'Furniture making, doors, wardrobes, cabinets',
      specificServices: [
        'Custom Wardrobe',
        'Door Repair & Locks',
        'Kitchen Cabinets',
        'Bed Frame Making',
        'Office Desk Assembly',
      ],
    ),
    Category(
      id: 'c7',
      name: 'Painting',
      iconName: 'format_paint',
      description: 'Interior/exterior painting, wall screeding',
      specificServices: [
        'Interior Painting',
        'Exterior Painting',
        'Wall Screeding',
        'POP Ceiling Painting',
        'Wallpaper Installation',
      ],
    ),
    Category(
      id: 'c8',
      name: 'Appliance Repair',
      iconName: 'tv',
      description: 'Washing machines, microwaves, TV mounting',
      specificServices: [
        'TV Wall Mounting',
        'Washing Machine Repair',
        'Microwave Repair',
        'Electric Cooker Fix',
        'Water Dispenser Service',
      ],
    ),
  ];

  static final List<Professional> professionals = [
    Professional(
      id: 'p1',
      name: 'Emeka Okafor',
      profession: 'Master Plumber',
      rating: 4.8,
      completedJobs: 142,
      verificationLevel: 3, // Skill Verified
      state: 'Lagos State',
      lga: 'Eti-Osa (Lekki / Victoria Island / Ikoyi)',
      serviceArea: 'Lekki Phase 1',
      locationStamp: 'Stamped: 6.4474° N, 3.4723° E (Verified GPS)',
      startingPrice: 5000,
      avatarUrl: '',
    ),
    Professional(
      id: 'p2',
      name: 'Aliyu Bello',
      profession: 'Electrical Engineer',
      rating: 4.9,
      completedJobs: 215,
      verificationLevel: 4, // Business Verified
      state: 'Lagos State',
      lga: 'Eti-Osa (Lekki / Victoria Island / Ikoyi)',
      serviceArea: 'Victoria Island',
      locationStamp: 'Stamped: 6.4281° N, 3.4219° E (Verified GPS)',
      startingPrice: 7000,
      avatarUrl: '',
    ),
    Professional(
      id: 'p3',
      name: 'Tunde Adeleke',
      profession: 'AC & Inverter Specialist',
      rating: 4.7,
      completedJobs: 98,
      verificationLevel: 2, // Address Verified
      state: 'Lagos State',
      lga: 'Ibeju-Lekki',
      serviceArea: 'Ajah',
      locationStamp: 'Stamped: 6.4654° N, 3.5653° E (Verified GPS)',
      startingPrice: 6000,
      avatarUrl: '',
    ),
  ];
}
