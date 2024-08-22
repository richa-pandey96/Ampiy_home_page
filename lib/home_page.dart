import 'dart:convert';
import 'package:ampiiiy/coins_screen.dart';
import 'package:flutter/material.dart';
import 'web_socket_service.dart';
import 'package:provider/provider.dart';
import 'crypto_model.dart';
import 'crypto_detailpage.dart';

class CryptoScreen extends StatefulWidget {


  
  @override
  _CryptoScreenState createState() => _CryptoScreenState();
}


class _CryptoScreenState extends State<CryptoScreen> with TickerProviderStateMixin {
  late final AnimationController _backgroundController;
  late AnimationController _buttonController;
  late WebSocketService _webSocketService;
  late Stream<List<Crypto>> _cryptoStream;
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  late Animation<double> _buyScaleAnimation;
  late Animation<double> _sellRotationAnimation;
  late Animation<double> _referralScaleAnimation;
  late Animation<double> _tutorialRippleAnimation;

  
  

  @override
  void initState() {
    super.initState();
    _webSocketService = WebSocketService();
    _cryptoStream = _webSocketService.stream.asBroadcastStream().map((data) {
      //final parsedData = jsonDecode(data);
      //final List<dynamic> dataList = parsedData['data'];
      //return dataList.map((e) => Crypto.fromJson(e)).toList();
      try {
      // Parse the incoming JSON data
      print('Received data: $data'); 
      //final parsedData = jsonDecode(data as String);
       if (data is List<Crypto>) {
        return data;
       }
       else{
        // Handle unexpected data format
        throw FormatException('Unexpected data format');
       }
      
      } catch (e) {
      // Handle any errors in parsing or mapping
      print('Error processing data: $e');
      return <Crypto>[]; // Return an empty list on error
    }
    }).asBroadcastStream();

    _initializeAnimations();
  }
   void _initializeAnimations() {
    // Background animation controller
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat(reverse: true);

    // Button animations controller
    _buttonController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _buyScaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeInOut),
    );

    _sellRotationAnimation = Tween<double>(begin: 0.0, end: 0.1).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.elasticIn),
    );

    _referralScaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.bounceInOut),
    );

    _tutorialRippleAnimation = Tween<double>(begin: 1.0, end: 1.0).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _webSocketService.dispose();
    _searchController.dispose();
    _backgroundController.dispose();
    _buttonController.dispose();
    super.dispose();
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromARGB(255, 6, 56, 107), Color.fromARGB(255, 84, 93, 100)],
            ),
          ),
          child: Text(
            'WELCOME TO AMIPY',
            style: TextStyle(color: Colors.white),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
         actions: [
    IconButton(
      icon: Icon(Icons.notifications),
      onPressed: () {
        // Handle the notification icon tap
      },
    ),
  ],
      ),
    
      body: Stack(
        children: [
          // Background Image with Animation
          AnimatedBuilder(
            animation: _backgroundController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, 50 * (1 - _backgroundController.value)),
                child: Transform.scale(
                  scale: 1.05 - (_backgroundController.value * 0.1),
                  child: Opacity(
                    opacity: _backgroundController.value,
                    child: child,
                  ),
                ),
              );
            },
        
            child: Container(
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage('https://images.unsplash.com/photo-1645516484419-35a747c99474?w=1000&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8N3x8Y3J5cHRvJTIwYXBwJTIwaG9tZXBhZ2V8ZW58MHx8MHx8fDA%3D'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Content on top of the background
          Positioned.fill(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Account Actions Section
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        BlinkingButton(),
                        SizedBox(height: 50),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildBuyButton(),
                            _buildSellButton(),
                            _buildReferralButton(),
                            _buildTutorialButton(),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // SIP Section - Separate Widget
                  AnimatedSipSection(),
                  // Search Bar Section
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        labelText: 'Search by Symbol',
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (query) {
                        setState(() {
                          _searchQuery = query.toUpperCase();
                        });
                      },
                    ),
                  ),
                  // Crypto List Section
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Coins', style: TextStyle(fontSize: 20,color: Colors.amber)),
                  ),
                  StreamBuilder<List<Crypto>>(
                    stream: _cryptoStream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text('No data available'));
                      }

                      final filteredList = snapshot.data!
                          .where((crypto) => crypto.symbol.contains(_searchQuery))
                          // .toList();
                        .take(5) // Show only the first 5 items
                          .toList();
                      print('Filtered list: $filteredList');    
                      return Column(
                        children:[
                        ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: filteredList.length,
                        itemBuilder: (context, index) {
                          final crypto = filteredList[index];
                          return ListTile(
                            title: Text(crypto.symbol),
                            subtitle: Text('Price: ${crypto.currentPrice}'),
                            trailing: Text(
                              '${crypto.priceChange}%',
                              style: TextStyle(
                                color: double.parse(crypto.priceChange) >= 0
                                    ? Colors.green
                                    : Colors.red,
                                    fontSize: 15,
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      CryptoDetailPage(crypto: crypto),
                                ),
                              );
                            },
                          );
                        },
                      ),
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CoinsScreen(cryptoList: snapshot.data!),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white, padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16), backgroundColor: Color.fromARGB(255, 50, 51, 52), // Text color
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10), // Rounded corners
                                  side: BorderSide.none, // Border color and width
                                ),
                                shadowColor: Colors.black.withOpacity(0.5), // Shadow color
                                elevation: 10, 
                                minimumSize: Size(double.infinity, 60)// Shadow elevation
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    'View All',
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(Icons.arrow_forward, size: 20),
                                ],
                              ),
                            ),
                          ),
                     

                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}


  Widget _buildBuyButton() {
    return ScaleTransition(
      scale: _buyScaleAnimation,
      child: GestureDetector(
        onTap: () {},
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildSellButton() {
    return RotationTransition(
      turns: _sellRotationAnimation,
      child: GestureDetector(
        onTap: () {},
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.remove, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildReferralButton() {
    return ScaleTransition(
      scale: _referralScaleAnimation,
      child: GestureDetector(
        onTap: () {},
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.orange,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.person_add, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildTutorialButton() {
    return ScaleTransition(
      scale: _tutorialRippleAnimation,
      child: GestureDetector(
        onTap: () {},
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.help_outline, color: Colors.white),
        ),
      ),
    );
  }
}

// Separate SIP Section Widget



class AnimatedSipSection extends StatefulWidget {
  @override
  _AnimatedSipSectionState createState() => _AnimatedSipSectionState();
}

class _AnimatedSipSectionState extends State<AnimatedSipSection> with TickerProviderStateMixin {
  late AnimationController _iconController;
  late AnimationController _buttonController;

  late Animation<double> _iconScaleAnimation;
  late Animation<double> _buttonScaleAnimation;

  @override
  void initState() {
    super.initState();

    _iconController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _buttonController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _iconScaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _iconController, curve: Curves.easeInOut),
    );

    _buttonScaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _iconController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // First Curved Section with Icon and Color
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blueAccent, Colors.deepPurpleAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black45,
                  blurRadius: 10,
                  offset: Offset(2, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                ScaleTransition(
                  scale: _iconScaleAnimation,
                  child: ListTile(
                    leading: Icon(Icons.savings, color: Colors.white, size: 40),
                    title: Text(
                      'Create Wealth with SIP',
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      'Invest. Grow. Repeat. Grow your money with SIP now.',
                      style: TextStyle(color: Colors.white70),
                    ),
                    trailing: ScaleTransition(
                      scale: _buttonScaleAnimation,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.deepPurple,
                          shadowColor: Colors.purpleAccent,
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text('Start a SIP'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16), // Space between sections

          // Second Curved Section with Icon and Color
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.greenAccent, Colors.teal],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black45,
                  blurRadius: 10,
                  offset: Offset(2, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                ScaleTransition(
                  scale: _iconScaleAnimation,
                  child: ListTile(
                    leading: Icon(Icons.calculate, color: Color.fromARGB(255, 255, 255, 255), size: 40),
                    title: Text(
                      'SIP Calculator',
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      'Calculate Interests and Returns',
                      style: TextStyle(color: Colors.white70),
                    ),
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16), // Space between sections

          // Third Curved Section with Icon and Color
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orangeAccent, Colors.deepOrange],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black45,
                  blurRadius: 10,
                  offset: Offset(2, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                ScaleTransition(
                  scale: _iconScaleAnimation,
                  child: ListTile(
                    leading: Icon(Icons.account_balance_wallet, color: Colors.white, size: 40),
                    title: Text(
                      'Deposit INR',
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      'Use UPI or Bank Account to trade or buy SIP',
                      style: TextStyle(color: Colors.white70),
                    ),
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
class BlinkingButton extends StatefulWidget {
  @override
  _BlinkingButtonState createState() => _BlinkingButtonState();
}

class _BlinkingButtonState extends State<BlinkingButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1), // Blink speed
      vsync: this,
    )..repeat(reverse: true); // Loop the animation and reverse it each time

    _animation = Tween<double>(begin: 1.0, end: 0.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Color.fromARGB(255, 61, 92, 207), // Button color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              elevation: 5,
            ),
            child: Text('Verify Account'),
          ),
        );
      },
    );
  }
}


// 

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  Stream<List<Crypto>> _cryptoStream = fetchCryptoDataStream();
  List<Crypto> _cryptoList = [];
  @override
  void initState() {
    super.initState();
    _cryptoStream.listen((cryptoList) {
      setState(() {
        _cryptoList = cryptoList;
      });
    });
  }


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Crypto>>.value(
      value: fetchCryptoDataStream(),
      initialData: [],
      child: Scaffold(
        body: _widgetOptions.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.attach_money), label: 'Coins'),
            BottomNavigationBarItem(icon: Icon(Icons.swap_vert), label: 'Exchange'),
            BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: 'Wallet'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'You'),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blueAccent,
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  List<Widget> get _widgetOptions => <Widget>[
        CryptoScreen(), // Home
        CoinsScreen(cryptoList: _cryptoList,), // Coins, StreamProvider will provide the stream
        Center(child: Text('Exchange Section')), // Exchange (Placeholder)
        Center(child: Text('Wallet Section')), // Wallet (Placeholder)
        Center(child: Text('You Section')), // You (Placeholder)
      ];
}
