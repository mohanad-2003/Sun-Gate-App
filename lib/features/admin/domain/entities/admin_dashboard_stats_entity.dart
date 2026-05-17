class AdminDashboardStatsEntity {
  final int usersCount;
  final int companiesCount;
  final int productsCount;
  final int pendingRequestsCount;
  final int engineersCount;

  const AdminDashboardStatsEntity({
    required this.usersCount,
    required this.companiesCount,
    required this.productsCount,
    required this.pendingRequestsCount,
    required this.engineersCount,
  });

  static const empty = AdminDashboardStatsEntity(
    usersCount: 0,
    companiesCount: 0,
    productsCount: 0,
    pendingRequestsCount: 0,
    engineersCount: 0,
  );
}
