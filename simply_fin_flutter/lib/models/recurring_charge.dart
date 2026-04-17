class RecurringCharge {
  const RecurringCharge({
    required this.name,
    required this.amount,
    required this.due,
  });

  final String name;
  final String amount;
  final String due;
}

const recurringCharges = [
  RecurringCharge(name: 'Netflix', amount: '\$15.49', due: 'Apr 18'),
  RecurringCharge(name: 'Spotify', amount: '\$10.99', due: 'Apr 21'),
  RecurringCharge(
    name: 'Adobe Creative Cloud',
    amount: '\$54.99',
    due: 'Apr 24',
  ),
  RecurringCharge(name: 'Gym membership', amount: '\$64.00', due: 'Apr 27'),
];
