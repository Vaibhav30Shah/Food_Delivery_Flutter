class LoyaltyPoints {
  int orderCount;
  int points;

  LoyaltyPoints({this.orderCount = 0, this.points = 0});

  factory LoyaltyPoints.fromJson(Map<String, dynamic> json) {
    return LoyaltyPoints(
      orderCount: json['orderCount'] ?? 0,
      points: json['points'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderCount': orderCount,
      'points': points,
    };
  }
}