class Provider {
  final String uid;
  final String category;
  final String city;
  final String email;
  final String firstName;
  final String lastName;
  final String profileImageUrl;
  final String phoneNumber;
  final int yearsOfExperience;
  final double latitude;
  final double longitude;
  final double numberOfReviews;
  final double totalReviews;

  Provider({
    required this.uid,
    required this.category,
    required this.city,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.profileImageUrl,
    required this.phoneNumber,
    required this.yearsOfExperience,
    required this.latitude,
    required this.longitude,
    required this.numberOfReviews,
    required this.totalReviews,
  });

  factory Provider.fromMap(Map<dynamic, dynamic> map, String uid) {
    print("Mapping Provider Data: $map"); // Debug print

    return Provider(
      uid: uid,
      category: map['category'] ?? '',
      city: map['city'] ?? '',
      email: map['email'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      profileImageUrl: map['profileImageUrl'] ?? '',
      phoneNumber: map['phoneNumber'].toString(), // Ensure phone number is a string
      yearsOfExperience: int.tryParse(map['yearsOfExperience'].toString()) ?? 0, // Convert String to int
      latitude: double.tryParse(map['latitude'].toString()) ?? 0.0, // Convert String to double
      longitude: double.tryParse(map['longitude'].toString()) ?? 0.0, // Convert String to double
      numberOfReviews: double.tryParse(map['numberOfReviews'].toString()) ?? 0.0, // Convert String to double
      totalReviews: double.tryParse(map['totalReviews'].toString()) ?? 0.0, // Convert String to double
    );
  }
}
