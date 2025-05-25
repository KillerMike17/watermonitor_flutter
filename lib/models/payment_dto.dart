class PaymentDto {
  final String returnUrl;
  final String email;
  final String first_name;
  final String last_name;
  final String userId;
  final String description;
  final String title;
  final String uuid;
  final String currency;

  PaymentDto({
    required this.returnUrl,
    required this.email,
    required this.first_name,
    required this.last_name,
    required this.userId,
    required this.description,
    required this.title,
    required this.uuid,
    required this.currency,
  });

  Map<String, dynamic> toJson() => {
        'returnUrl': returnUrl,
        'email': email,
        'first_name': first_name,
        'last_name': last_name,
        'userId': userId,
        'description': description,
        'title': title,
        'uuid': uuid,
        'currency': currency,
      };
}
