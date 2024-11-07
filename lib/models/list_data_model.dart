
class DataModel {
  final String title;
  final String description;
  final String date;

  DataModel({
    required this.title,
    required this.description,
    required this.date,
  });


  factory DataModel.fromMap(Map<String, dynamic> data) {
    return DataModel(
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      date: data['date'] ?? '',
    );
  }

  // Convert model back to map for Firestore saving (if needed)
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'date': date,
    };
  }
}