import 'dart:convert';

class NotiRequest {
  String notiRequestId;
  String requestId;
  String notiId;

  NotiRequest({
    required this.notiRequestId,
    required this.requestId,
    required this.notiId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'notiRequestId': notiRequestId,
      'requestId': requestId,
      'notiId': notiId,
    };
  }

  factory NotiRequest.fromMap(Map<String, dynamic> map) {
    return NotiRequest(
      notiRequestId: map['notiRequestId']?.toString() ?? "",
      requestId: map['requestId']?.toString() ?? "",
      notiId: map['notiId']?.toString() ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory NotiRequest.fromJson(String source) =>
      NotiRequest.fromMap(json.decode(source) as Map<String, dynamic>);
}
