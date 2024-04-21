class Restaurant {
  final int id;
  final String name;
  final String city;
  final double rating;
  final int ratingCount;
  final String cost;
  final String cuisine;
  final String licenseNumber;
  final String link;
  final String address;
  final String menu;

  Restaurant({
    required this.id,
    required this.name,
    required this.city,
    required this.rating,
    required this.ratingCount,
    required this.cost,
    required this.cuisine,
    required this.licenseNumber,
    required this.link,
    required this.address,
    required this.menu,
  });

  // Factory constructor to create Restaurant objects from a map
  factory Restaurant.fromMap(Map<String, dynamic> map) {
    return Restaurant(
      id: map['id'],
      name: map['name'],
      city: map['city'],
      rating: map['rating'],
      ratingCount: map['rating_count'],
      cost: map['cost'],
      cuisine: map['cuisine'],
      licenseNumber: map['lic_no'],
      link: map['link'],
      address: map['address'],
      menu: map['menu'],
    );
  }
}
