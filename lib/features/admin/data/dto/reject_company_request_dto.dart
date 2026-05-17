class RejectCompanyRequestDto {
  final String? reason;

  const RejectCompanyRequestDto({this.reason});

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    final trimmed = reason?.trim();
    if (trimmed != null && trimmed.isNotEmpty) {
      map['reason'] = trimmed;
    }
    return map;
  }
}
