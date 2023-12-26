class ApiResponse {
  bool isSuccess;
  String? errorMessage;
  var data;

  ApiResponse({
    this.isSuccess = true,
    this.errorMessage,
    this.data,
  });

  factory ApiResponse.fromMap(Map<String, dynamic> json) => ApiResponse(
        isSuccess: json["status"] == "success",
        errorMessage: json["error"],
        data: json["data"],
      );
}
