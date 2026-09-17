class Operation {
  final int amount;
  final int fee;

  const Operation({required this.amount, required this.fee});

  Map<String, dynamic> toJson() => {'amount': amount, 'fee': fee};

  factory Operation.fromJson(Map<String, dynamic> json) => Operation(
    amount: json['amount'] as int,
    fee: json['fee'] as int,
  );
}
