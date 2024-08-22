// // import 'dart:convert';
// // import 'package:ampiiiy/coins_screen.dart';
// // import 'package:flutter/material.dart';
// // import 'web_socket_service.dart';
// // import 'crypto_model.dart';
// // import 'crypto_detailpage.dart';



// // class MainScreen extends StatefulWidget {
// //   @override
// //   _MainScreenState createState() => _MainScreenState();
// // }

// // class _MainScreenState extends State<MainScreen> {
// //   int _selectedIndex = 0;
// //   late Stream<List<Crypto>> _cryptoStream;

// //    @override
// //   void initState() {
// //     super.initState();
// //     _cryptoStream = WebSocketService().stream.map((data) {
// //       final parsedData = jsonDecode(data);
// //       final List<dynamic> dataList = parsedData['data'];
// //       return dataList.map((e) => Crypto.fromJson(e)).toList();
// //     });
// //   }

// //   void _onItemTapped(int index) {
// //     setState(() {
// //       _selectedIndex = index;
// //     });
// //   }


  
// //    @override
// //   Widget build(BuildContext context) {
// //   List<Widget> _widgetOptions = <Widget>[
// //     CryptoScreen(), // Home
// //     CoinsScreen(cryptoStream: _cryptoStream), // Coins
// //     Center(child: Text('Exchange Section')), // Exchange (Placeholder)
// //     Center(child: Text('Wallet Section')), // Wallet (Placeholder)
// //     Center(child: Text('You Section')), // You (Placeholder)
// //   ];

// //   void _onItemTapped(int index) {
// //     setState(() {
// //       _selectedIndex = index;
// //     });
// //   }


// //     return Scaffold(
// //       body: _widgetOptions.elementAt(_selectedIndex),
// //       bottomNavigationBar: BottomNavigationBar(
// //         items: const <BottomNavigationBarItem>[
// //           BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
// //           BottomNavigationBarItem(icon: Icon(Icons.attach_money), label: 'Coins'),
// //           BottomNavigationBarItem(icon: Icon(Icons.swap_vert), label: 'Exchange'),
// //           BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: 'Wallet'),
// //           BottomNavigationBarItem(icon: Icon(Icons.person), label: 'You'),
// //         ],
// //         currentIndex: _selectedIndex,
// //         selectedItemColor: Colors.blueAccent,
// //         onTap: _onItemTapped,
// //       ),
// //     );
// //   }
// // }


// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'web_socket_service.dart';
// import 'crypto_model.dart';
// import 'crypto_detailpage.dart';
// import 'coins_screen.dart';

// class CryptoScreen extends StatefulWidget {
//   @override
//   _CryptoScreenState createState() => _CryptoScreenState();
// }

// class _CryptoScreenState extends State<CryptoScreen> with TickerProviderStateMixin {
//   late AnimationController _backgroundController;
//   late AnimationController _buttonController;
//   late WebSocketService _webSocketService;
//   late Stream<List<Crypto>> _cryptoStream;
//   TextEditingController _searchController = TextEditingController();
//   String _searchQuery = '';

//   late Animation<double> _buyScaleAnimation;
//   late Animation<double> _sellRotationAnimation;
//   late Animation<double> _referralScaleAnimation;
//   late Animation<double> _tutorialRippleAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _webSocketService = WebSocketService();
//     _cryptoStream = _webSocketService.stream.map((data) {
//       final parsedData = jsonDecode(data);
//       final List<dynamic> dataList = parsedData['data'];
//       return dataList.map((e) => Crypto.fromJson(e)).toList();
//     });

//     _backgroundController = AnimationController(
//       duration: const Duration(seconds: 20),
//       vsync: this,
//     )..repeat(reverse: true);

//     _buttonController = AnimationController(
//       duration: const Duration(seconds: 2),
//       vsync: this,
//     )..repeat(reverse: true);

//     _buyScaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
//       CurvedAnimation(parent: _buttonController, curve: Curves.easeInOut),
//     );

//     _sellRotationAnimation = Tween<double>(begin: 0.0, end: 0.1).animate(
//       CurvedAnimation(parent: _buttonController, curve: Curves.elasticIn),
//     );

//     _referralScaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
//       CurvedAnimation(parent: _buttonController, curve: Curves.bounceInOut),
//     );

//     _tutorialRippleAnimation = Tween<double>(begin: 1.0, end: 1.0).animate(
//       CurvedAnimation(parent: _buttonController, curve: Curves.easeInOut),
//     );
//   }

//   @override
//   void dispose() {
//     _webSocketService.dispose();
//     _searchController.dispose();
//     _backgroundController.dispose();
//     _buttonController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Container(
//           padding: EdgeInsets.all(16.0),
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Color.fromARGB(255, 6, 56, 107), Color.fromARGB(255, 84, 93, 100)],
//             ),
//           ),
//           child: Text(
//             'WELCOME TO AMIPY',
//             style: TextStyle(color: Colors.white),
//           ),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//       ),
//       body: Stack(
//         children: [
//           AnimatedBuilder(
//             animation: _backgroundController,
//             builder: (context, child) {
//               return Transform.translate(
//                 offset: Offset(0, 50 * (1 - _backgroundController.value)),
//                 child: Transform.scale(
//                   scale: 1.05 - (_backgroundController.value * 0.1),
//                   child: Opacity(
//                     opacity: _backgroundController.value,
//                     child: child,
//                   ),
//                 ),
//               );
//             },
//             child: Container(
//               height: MediaQuery.of(context).size.height,
//               decoration: const BoxDecoration(
//                 image: DecorationImage(
//                   image: NetworkImage('https://images.unsplash.com/photo-1645516484419-35a747c99474?w=1000&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8N3x8Y3J5cHRvJTIwYXBwJTIwaG9tZXBhZ2V8ZW58MHx8MHx8fDA%3D'),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//           ),
//           Positioned.fill(
//             child: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       children: [
//                         BlinkingButton(),
//                         SizedBox(height: 50),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             _buildBuyButton(),
//                             _buildSellButton(),
//                             _buildReferralButton(),
//                             _buildTutorialButton(),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   AnimatedSipSection(),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: TextField(
//                       controller: _searchController,
//                       decoration: InputDecoration(
//                         labelText: 'Search by Symbol',
//                         prefixIcon: Icon(Icons.search),
//                       ),
//                       onChanged: (query) {
//                         setState(() {
//                           _searchQuery = query.toUpperCase();
//                         });
//                       },
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Text('Coins', style: TextStyle(fontSize: 20, color: Colors.amber)),
//                   ),
//                   StreamBuilder<List<Crypto>>(
//                     stream: _cryptoStream,
//                     builder: (context, snapshot) {
//                       if (snapshot.connectionState == ConnectionState.waiting) {
//                         return Center(child: CircularProgressIndicator());
//                       } else if (snapshot.hasError) {
//                         return Center(child: Text('Error: ${snapshot.error}'));
//                       } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                         return Center(child: Text('No data available'));
//                       }

//                       final filteredList = snapshot.data!
//                           .where((crypto) => crypto.symbol.contains(_searchQuery))
//                           .take(5)
//                           .toList();
//                       return Column(
//                         children: [
//                           ListView.builder(
//                             shrinkWrap: true,
//                             physics: NeverScrollableScrollPhysics(),
//                             itemCount: filteredList.length,
//                             itemBuilder: (context, index) {
//                               final crypto = filteredList[index];
//                               return ListTile(
//                                 title: Text(crypto.symbol),
//                                 subtitle: Text('Price: ${crypto.currentPrice}'),
//                                 trailing: Text(
//                                   '${crypto.priceChange}%',
//                                   style: TextStyle(
//                                     color: double.parse(crypto.priceChange) >= 0
//                                         ? Colors.green
//                                         : Colors.red,
//                                     fontSize: 15,
//                                   ),
//                                 ),
//                                 onTap: () {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) => CryptoDetailPage(crypto: crypto),
//                                     ),
//                                   );
//                                 },
//                               );
//                             },
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: ElevatedButton(
//                               onPressed: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => CoinsScreen(cryptoStream: _cryptoStream),
//                                   ),
//                                 );
//                               },
//                               child: Text('View All'),
//                             ),
//                           ),
//                         ],
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildBuyButton() {
//     return ScaleTransition(
//       scale: _buyScaleAnimation,
//       child: GestureDetector(
//         onTap: () {},
//         child: Container(
//           padding: EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: Colors.green,
//             shape: BoxShape.circle,
//           ),
//           child: Icon(Icons.add, color: Colors.white),
//         ),
//       ),
//     );
//   }

//   Widget _buildSellButton() {
//     return RotationTransition(
//       turns: _sellRotationAnimation,
//       child: GestureDetector(
//         onTap: () {},
//         child: Container(
//           padding: EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: Colors.red,
//             shape: BoxShape.circle,
//           ),
//           child: Icon(Icons.remove, color: Colors.white),
//         ),
//       ),
//     );
//   }

//   Widget _buildReferralButton() {
//     return ScaleTransition(
//       scale: _referralScaleAnimation,
//       child: GestureDetector(
//         onTap: () {},
//         child: Container(
//           padding: EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: Colors.blue,
//             shape: BoxShape.circle,
//           ),
//           child: Icon(Icons.redeem, color: Colors.white),
//         ),
//       ),
//     );
//   }

//   Widget _buildTutorialButton() {
//     return ScaleTransition(
//       scale: _tutorialRippleAnimation,
//       child: GestureDetector(
//         onTap: () {},
//         child: Container(
//           padding: EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: Colors.orange,
//             shape: BoxShape.circle,
//           ),
//           child: Icon(Icons.info, color: Colors.white),
//         ),
//       ),
//     );
//   }
// }

// class BlinkingButton extends StatefulWidget {
//   @override
//   _BlinkingButtonState createState() => _BlinkingButtonState();
// }

// class _BlinkingButtonState extends State<BlinkingButton> with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;
//   late Animation<double> _opacityAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       duration: const Duration(seconds: 1),
//       vsync: this,
//     )..repeat(reverse: true);

//     _opacityAnimation = Tween<double>(begin: 1.0, end: 0.5).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
//     );
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FadeTransition(
//       opacity: _opacityAnimation,
//       child: Container(
//         padding: EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Colors.purple,
//           shape: BoxShape.circle,
//         ),
//         child: Icon(Icons.flash_on, color: Colors.white),
//       ),
//     );
//   }
// }

// class AnimatedSipSection extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.all(16),
//       padding: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.black54,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Invest Smartly',
//             style: TextStyle(color: Colors.white, fontSize: 18),
//           ),
//           SizedBox(height: 10),
//           Text(
//             'Start your SIP with our exclusive offers!',
//             style: TextStyle(color: Colors.grey[400], fontSize: 14),
//           ),
//         ],
//       ),
//     );
//   }
// }

