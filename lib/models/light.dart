class Light {
  String alias;
  String topic;

  Light({this.alias, this.topic});

  Light.fromJson(Map<String, dynamic> json) {
    alias = json['alias'];
    topic = json['topic'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['alias'] = this.alias;
    data['topic'] = this.topic;
    return data;
  }
}
