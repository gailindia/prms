class DummyClaimDetail {
  final String requestDate;
  final String requestType;

  DummyClaimDetail({
    required this.requestDate,
    required this.requestType,
  });
}

final List<DummyClaimDetail> dummyClaimDetailsList = [
  DummyClaimDetail(requestDate: "2024-09-10", requestType: "Medical"),
  DummyClaimDetail(requestDate: "2024-08-20", requestType: "Travel"),
  DummyClaimDetail(requestDate: "2024-07-05", requestType: "Dental"),
];
