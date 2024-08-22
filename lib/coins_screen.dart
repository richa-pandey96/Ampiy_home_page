// 
import 'package:flutter/material.dart';
import 'crypto_model.dart'; // Import your Crypto model file
import 'package:provider/provider.dart';
import 'crypto_detailpage.dart';

class CoinsScreen extends StatelessWidget {

  final List<Crypto> cryptoList ;
   CoinsScreen({required this.cryptoList});


  @override
  Widget build(BuildContext context) {
    // Access the List<Crypto> provided by StreamProvider
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'All Coins',
          style: TextStyle(
            color: Colors.amber,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 41, 41, 41),
      ),
      body: cryptoList.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: cryptoList.length,
              itemBuilder: (context, index) {
                final crypto = cryptoList[index];
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
                                // You can replace the Icon with an image of the cryptocurrency logo
                                Icon(
                                  Icons.currency_bitcoin, // Example icon
                                  color: Colors.amber, // Change this icon color if needed
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
