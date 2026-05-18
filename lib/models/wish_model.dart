class Wish {
  final int? id;
  final String title;
  final bool isCompleted;

  Wish({this.id, required this.title, this.isCompleted = false});

  factory Wish.fromJson(Map<String, dynamic> json) {
    return Wish(
      id: json['id'],
      title: json['title'] ?? '',
      isCompleted: json['completed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {if (id != null) 'id': id, 'title': title, 'completed': isCompleted};
  }
}
