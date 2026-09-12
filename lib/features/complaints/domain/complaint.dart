class Complaint {
  const Complaint({
    required this.id,
    required this.category,
    required this.subject,
    required this.description,
    required this.createdAt,
  });

  final String id;
  final String category;
  final String subject;
  final String description;
  final DateTime createdAt;
}
