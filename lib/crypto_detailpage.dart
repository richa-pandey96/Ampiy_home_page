import 'package:flutter/material.dart';
import 'crypto_model.dart';
import 'package:fl_chart/fl_chart.dart';

class CryptoDetailPage extends StatefulWidget {
  final Crypto crypto;

  const CryptoDetailPage({Key? key, required this.crypto}) : super(key: key);

  @override
  _CryptoDetailPageState createState() => _CryptoDetailPageState();
}

class _CryptoDetailPageState extends State<CryptoDetailPage>
    with SingleTickerProviderStateMixin {
  TextEditingController _alertController = TextEditingController();
  double? _priceAlert;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _alertController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _setAlert() {
    final enteredPrice = double.tryParse(_alertController.text);
    if (enteredPrice != null) {
      setState(() {
        _priceAlert = enteredPrice;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Alert set at $enteredPrice')),
      );
    }
  }

  List<FlSpot> _getChartSpots() {
    // Replace this with your actual data points for the chart
    return List.generate(7,
        (index) => FlSpot(index.toDouble(), double.parse(widget.crypto.currentPrice)));
  }

  void _animateButton() {
    _controller.forward().then((_) {
      _controller.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.crypto.symbol} Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Symbol: ${widget.crypto.symbol}', style: TextStyle(fontSize: 20)),
              SizedBox(height: 10),
              Text('Current Price: ${widget.crypto.currentPrice}', style: TextStyle(fontSize: 20)),
              SizedBox(height: 10),
              Text('Price Change: ${widget.crypto.priceChange}', style: TextStyle(fontSize: 20)),
              SizedBox(height: 10),
              Text('Price Change Percent: ${widget.crypto.percentChange}%', style: TextStyle(fontSize: 20)),
              SizedBox(height: 20),
              TextField(
                controller: _alertController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Set Price Alert',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  _setAlert();
                  _animateButton();  // Trigger animation on button press
                },
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Text('Set Alert'),
                ),
              ),
              if (_priceAlert != null)
                Text(
                  'Alert set at: $_priceAlert',
                  style: TextStyle(color: Colors.red, fontSize: 18),
                ),
              SizedBox(height: 20),
              Text('Price Chart', style: TextStyle(fontSize: 20)),
              SizedBox(height: 10),
              SizedBox(
                height: 200,
                child: LineChart(
                  LineChartData(
                    lineBarsData: [
                      LineChartBarData(
                        spots: _getChartSpots(),
                        isCurved: true,
                        color: Colors.blue, // Single color instead of list
                        dotData: FlDotData(show: false),
                      ),
                    ],
                    titlesData: FlTitlesData(show: true),
                    borderData: FlBorderData(show: true),
                    gridData: FlGridData(show: true),
                  ),
                ),
              ),
              SizedBox(height: 20),
              AnimatedButtons(), // Adding animated buttons above coins section
            ],
          ),
        ),
      ),
    );
  }
}

class AnimatedButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildAnimatedButton(context, Icons.add, "Buy", Colors.green),
        _buildAnimatedButton(context, Icons.remove, "Sell", Colors.red),
        _buildAnimatedButton(context, Icons.people, "Referral", Colors.blue),
        _buildAnimatedButton(context, Icons.help_outline, "Tutorial", Colors.orange),
      ],
    );
  }

  Widget _buildAnimatedButton(BuildContext context, IconData icon, String label, Color color) {
    return GestureDetector(
      onTap: () {
        // Handle button tap
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$label Clicked')),
        );
      },
      child: Column(
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.2),
            ),
            child: Icon(icon, color: color, size: 30),
          ),
          SizedBox(height: 5),
          Text(label, style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
