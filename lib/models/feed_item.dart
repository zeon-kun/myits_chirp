
class StoryItem {
  final String id;
  final String imagePath;
  final String title;
  final String image;

  StoryItem({
    required this.id,
    required this.imagePath,
    required this.title,
    required this.image
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imagePath': imagePath,
      'title': title,
      'getImage': image,
    };
  }

  factory StoryItem.fromJson(Map<String, dynamic> json) {
    return StoryItem(
      id: json['id'],
      imagePath: json['imagePath'],
      title: json['title'],
      image: json['getImage']
    );
  }
}
