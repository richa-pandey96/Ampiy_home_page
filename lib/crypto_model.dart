class Crypto {
  final String symbol;
  late final String priceChange;
  late final String percentChange;
  late final String currentPrice;

  Crypto({
    required this.symbol,
    required this.priceChange,
    required this.percentChange,
    required this.currentPrice,
  });

  factory Crypto.fromJson(Map<String, dynamic> json) {
    return Crypto(
      symbol: json['s'],
      priceChange: json['p'],
      percentChange: json['P'],
      currentPrice: json['c'],
    );
  }
}
