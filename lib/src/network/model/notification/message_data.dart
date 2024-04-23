import 'dart:convert';

class MessageData {
  String? type;
  dynamic data;
  MessageData({
    this.type,
    this.data,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'type': type,
      'data': data,
    };
  }

  factory MessageData.fromMap(Map<String, dynamic> map) {
    return MessageData(
      type: map['type'] != null ? map['type'] as String : null,
      data: map['data'] as dynamic,
    );
  }

  String toJson() => json.encode(toMap());

  factory MessageData.fromJson(String source) =>
      MessageData.fromMap(json.decode(source) as Map<String, dynamic>);
}
