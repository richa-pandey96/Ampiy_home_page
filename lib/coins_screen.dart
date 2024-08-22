import 'package:flutter/material.dart';
import 'crypto_model.dart'; // Import your Crypto model file
import 'package:provider/provider.dart';
import 'crypto_detailpage.dart';

class CoinsScreen extends StatefulWidget {
  final List<Crypto> cryptoList;
  CoinsScreen({required this.cryptoList});

  @override
  _CoinsScreenState createState() => _CoinsScreenState();
}

class _CoinsScreenState extends State<CoinsScreen> {
  List<Crypto> _filteredCryptoList = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredCryptoList = widget.cryptoList;
    _searchController.addListener(_filterCryptoList);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterCryptoList);
    _searchController.dispose();
    super.dispose();
  }

  void _filterCryptoList() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredCryptoList = widget.cryptoList
          .where((crypto) =>
              crypto.symbol.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search Coins...',
            hintStyle: TextStyle(color: Colors.amber),
            border: InputBorder.none,
          ),
          style: TextStyle(color: Colors.amber, fontSize: 20),
          cursorColor: Colors.amber,
        ),
        backgroundColor: Color.fromARGB(255, 41, 41, 41),
      ),
      body: _filteredCryptoList.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _filteredCryptoList.length,
              itemBuilder: (context, index) {
                final crypto = _filteredCryptoList[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CryptoDetailPage(crypto: crypto),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 33, 33, 33),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.currency_bitcoin,
                                  color: Colors.amber,
                                  size: 24,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  crypto.symbol,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '${crypto.priceChange}%',
                              style: TextStyle(
                                color: double.parse(crypto.priceChange) >= 0
                                    ? Colors.greenAccent
                                    : Colors.redAccent,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Price: ₹${crypto.currentPrice}',
                          style: TextStyle(
                            color: Color.fromARGB(255, 37, 243, 236),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
