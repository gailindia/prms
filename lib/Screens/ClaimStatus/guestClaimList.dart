class DummyClaimStatus {
  final String date;
  final String amount;
  final String status;

  DummyClaimStatus({
    required this.date,
    required this.amount,
    required this.status,
  });
}

final List<DummyClaimStatus> dummyClaimStatusList = [
  DummyClaimStatus(date: "2024-09-01", amount: "5000", status: "PROCESSING"),
  DummyClaimStatus(date: "2024-08-15", amount: "12000", status: "PAID"),
  DummyClaimStatus(date: "2024-07-20", amount: "3000", status: "REJECTED"),
];
