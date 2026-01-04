import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DashboardPage extends StatefulWidget {
  final int userId;
  final String username;

  const DashboardPage({Key? key, required this.userId, required this.username})
      : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final String apiUrl = "https://campus-backend-1-jxul.onrender.com";

  // 1. Predefined list of laptops
  final List<Map<String, String>> laptopCatalog = [
    {
      "name": "MacBook Pro M3",
      "price": "PKR 550,000",
      "image": "https://cdn-icons-png.flaticon.com/512/428/428001.png"
    },
    {
      "name": "Dell XPS 15",
      "price": "PKR 420,000",
      "image": "https://cdn-icons-png.flaticon.com/512/428/428001.png"
    },
    {
      "name": "HP Spectre x360",
      "price": "PKR 380,000",
      "image": "https://cdn-icons-png.flaticon.com/512/428/428001.png"
    },
    {
      "name": "Lenovo ThinkPad",
      "price": "PKR 310,000",
      "image": "https://cdn-icons-png.flaticon.com/512/428/428001.png"
    },
    {
      "name": "Asus ROG Strix",
      "price": "PKR 480,000",
      "image": "https://cdn-icons-png.flaticon.com/512/428/428001.png"
    },
  ];

  // 2. Function to place an order
  Future<void> placeOrder(String laptopName) async {
    try {
      final response = await http.post(
        Uri.parse("$apiUrl/add-order"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "userId": widget.userId,
          "item_name": laptopName,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Successfully ordered $laptopName!")),
        );
        // Refresh the UI to show the new order in history
        setState(() {});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to place order")),
        );
      }
    } catch (e) {
      print("Error placing order: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome, ${widget.username}"),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section 1: Laptop Catalog Title
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Select a Laptop to Order",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),

          // Section 2: Horizontal Scrollable List of Laptops
          SizedBox(
            height: 220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemCount: laptopCatalog.length,
              itemBuilder: (context, index) {
                final laptop = laptopCatalog[index];
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: Container(
                    width: 170,
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(laptop['image']!, height: 60),
                        const SizedBox(height: 10),
                        Text(
                          laptop['name']!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(
                          laptop['price']!,
                          style: const TextStyle(color: Colors.green, fontSize: 14),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () => placeOrder(laptop['name']!),
                          child: const Text("Order Now"),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const Divider(height: 40, thickness: 1, indent: 20, endIndent: 20),

          // Section 3: History Title
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Your Order History",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),

          // Section 4: Vertical List of Past Orders (using FutureBuilder)
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: http
                  .get(Uri.parse("$apiUrl/orders/${widget.userId}"))
                  .then((r) => json.decode(r.body)),
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snap.hasData || (snap.data as List).isEmpty) {
                  return const Center(child: Text("No orders found."));
                }

                final orders = snap.data!;
                return ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, i) {
                    return ListTile(
                      leading: const CircleAvatar(child: Icon(Icons.laptop)),
                      title: Text(orders[i]['item_name']),
                      subtitle: Text("Date: ${orders[i]['order_date']}"),
                      trailing: const Icon(Icons.check_circle, color: Colors.green),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}