class PositionModel {
  final int positionId;
  final String jobName;

  PositionModel({
    required this.positionId,
    required this.jobName,
  });

  factory PositionModel.fromJson(Map<String, dynamic> jsonData) {
    return PositionModel(
      positionId: jsonData['position_id'] ?? '',
      jobName: jsonData['position'] ?? '',
    );
  }
}
