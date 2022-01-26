class Item {
  int id;
  String title;
  String videoUrl;
  String coverImgUrl;
  bool isPlaying;

  Item(this.id, this.title, this.videoUrl, this.coverImgUrl, this.isPlaying);

  Item.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        videoUrl = json['videoUrl'],
        coverImgUrl = json['coverPicture'],
        isPlaying = json['isPlaying'];
}
