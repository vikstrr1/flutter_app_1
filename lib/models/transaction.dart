class Transaction {
  final String id;
  final String title;
  final double amount;
  final String category;

  Transaction({
    required this.id, 
    required this.title, 
    required this.amount, 
    required this.category
  });
  
    Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'amount': amount,
    'category': category,
  };

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
    id: json['id'] as String,
    title: json['title'] as String,
    amount: json['amount'] as double,
    category: json['category'] as String,
  );
}