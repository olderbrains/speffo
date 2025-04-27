enum OTPResponseType { success, error, unknown }

class OTPResponseModel {
  final String? requestID;
  final String? message;
  final OTPResponseType type;

  OTPResponseModel({
    this.requestID,
    this.message,
    required this.type,
  });

  factory OTPResponseModel.fromJson(Map<String, dynamic> json) {
    OTPResponseType parseType(String? type) {
      switch (type) {
        case 'success':
          return OTPResponseType.success;
        case 'error':
          return OTPResponseType.error;
        default:
          return OTPResponseType.unknown;
      }
    }

    return OTPResponseModel(
      requestID: json['request_id'],
      message: json['message'],
      type: parseType(json['type']),
    );
  }
}
