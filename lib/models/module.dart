class Module {
  String alias;
  String topic;
  String state;
  String type;

  Module({this.alias, this.topic, this.type});

  Module.fromJson(Map<String, dynamic> json) {
    alias = json['alias'];
    topic = json['topic'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['alias'] = this.alias;
    data['topic'] = this.topic;
    data['type'] = this.type;
    return data;
  }
}
