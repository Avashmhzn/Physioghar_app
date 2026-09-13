class TherapistProfile {
  const TherapistProfile({
    required this.name,
    required this.email,
    required this.phone,
    required this.experience,
    required this.specialization,
    required this.address,
    required this.profilePicUrl,
  });

  final String name;
  final String email;
  final String phone;
  final String experience;
  final String specialization;
  final String address;
  final String profilePicUrl;

  TherapistProfile copyWith({
    String? name,
    String? email,
    String? phone,
    String? experience,
    String? specialization,
    String? address,
    String? profilePicUrl,
  }) {
    return TherapistProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      experience: experience ?? this.experience,
      specialization: specialization ?? this.specialization,
      address: address ?? this.address,
      profilePicUrl: profilePicUrl ?? this.profilePicUrl,
    );
  }
}
