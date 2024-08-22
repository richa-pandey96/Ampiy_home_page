class Crypto {
  final String symbol;
  final String priceChange;
  final String percentChange;
  final String currentPrice;

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
