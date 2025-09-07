class Crypto {
  final String id;
  final String name;
  final String symbol;
  final String image;
  final double currentPrice;
  final double priceChangePercentage24h;
  final double marketCap;
  final int marketCapRank;

  Crypto({
    required this.id,
    required this.name,
    required this.symbol,
    required this.image,
    required this.currentPrice,
    required this.priceChangePercentage24h,
    required this.marketCap,
    required this.marketCapRank,
  });

  factory Crypto.fromJson(Map<String, dynamic> json) {
    return Crypto(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Unknown',
      symbol: json['symbol'] ?? '',
      image: json['image'] ?? '',
      currentPrice: (json['current_price'] ?? 0.0).toDouble(),
      priceChangePercentage24h:
          (json['price_change_percentage_24h'] ?? 0.0).toDouble(),
      marketCap: (json['market_cap'] ?? 0.0).toDouble(),
      marketCapRank: json['market_cap_rank'] ?? 0,
    );
  }
}
