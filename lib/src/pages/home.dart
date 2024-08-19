import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'bugdet.dart';
import '../models/food.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/login_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: const Text('Deliver Your Best Foods With Fooddash'),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () async {
              try {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  // ignore: use_build_context_synchronously
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              } catch (e) {
                if (kDebugMode) {
                  print('Error signing out: $e');
                }
              }
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.logout,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: _firestore.collection('foods').snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No foods available'));
                  }

                  final foodItems = snapshot.data!.docs;
                  final uniqueFoodItems = _removeDuplicateFoods(foodItems);

                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                    ),
                    itemCount: uniqueFoodItems.length,
                    itemBuilder: (context, index) {
                      var foodItem = uniqueFoodItems[index];
                      final data = foodItem.data() as Map<String, dynamic>?;
                      return GestureDetector(
                        onTap: () => _navigateToFoodDetailPage(
                            context, data?['name'] ?? 'Unknown food name'),
                        child: Card(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              data != null &&
                                      data.containsKey('imageUrl') &&
                                      data['imageUrl'] != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: SizedBox(
                                          height: 420,
                                          width: double.infinity,
                                          child: Image.network(
                                            data['imageUrl'] ?? '',
                                            height: 420,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                            errorBuilder: (BuildContext context,
                                                Object exception,
                                                StackTrace? stackTrace) {
                                              if (kDebugMode) {
                                                print(
                                                    'Image failed to load: $exception');
                                              } // Debug print
                                              return Container(
                                                height: 420,
                                                width: double.infinity,
                                                color: Colors.grey,
                                                child: const Icon(
                                                  Icons.error,
                                                  color: Colors.white,
                                                ),
                                              );
                                            },
                                          )),
                                    )
                                  : Container(
                                      height: 150,
                                      width: double.infinity,
                                      color: Colors.grey,
                                      child: const Icon(
                                        Icons.fastfood,
                                        color: Colors.white,
                                      ),
                                    ),
                              const SizedBox(height: 8.0),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Container(
                                  color: Colors.white,
                                  child: Text(
                                    data?['name'] ?? 'Unknown food name',
                                    style: const TextStyle(fontSize: 18.0),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const Icon(Icons.search),
              const SizedBox(width: 8.0),
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search your favourite food!',
                    border: InputBorder.none,
                  ),
                  onSubmitted: (value) {
                    _navigateToSearchResultsPage(context, value);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<QueryDocumentSnapshot<Object?>> _removeDuplicateFoods(
      List<QueryDocumentSnapshot<Object?>> foodItems) {
    final uniqueNames = <String>{};
    final uniqueFoodItems = <QueryDocumentSnapshot<Object?>>[];

    for (var item in foodItems) {
      final data = item.data() as Map<String, dynamic>?;
      final name = data?['name'] ?? '';
      if (uniqueNames.add(name)) {
        uniqueFoodItems.add(item);
      }
    }

    return uniqueFoodItems;
  }

  void _navigateToFoodDetailPage(BuildContext context, String foodName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FoodDetailPage(foodName: foodName),
      ),
    );
  }

  void _navigateToSearchResultsPage(BuildContext context, String query) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchResultsPage(query: query),
      ),
    );
  }
}

class FoodDetailPage extends StatefulWidget {
  final String foodName;

  const FoodDetailPage({super.key, required this.foodName});

  @override
  // ignore: library_private_types_in_public_api
  _FoodDetailPageState createState() => _FoodDetailPageState();
}

class _FoodDetailPageState extends State<FoodDetailPage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final Map<QueryDocumentSnapshot, int> selectedItems =
      {}; // Map to store selected food items and their quantities

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose ${widget.foodName} according to your budget.'),
        backgroundColor: Colors.deepOrange,
      ),
      body: StreamBuilder(
        stream: firestore
            .collection('foods')
            .where('name', isEqualTo: widget.foodName)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
                child: Text('No details available for this food'));
          }

          final foodItems = snapshot.data!.docs;

          return Column(
            children: [
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemCount: foodItems.length,
                  itemBuilder: (context, index) {
                    var foodItem = foodItems[index];
                    return GestureDetector(
                      onTap: () => _selectItem(foodItem),
                      child: Card(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildFoodImage(foodItem),
                            const SizedBox(height: 8.0),
                            _buildFoodName(foodItem),
                            const SizedBox(height: 4.0),
                            _buildFoodPrice(foodItem),
                            const SizedBox(height: 8.0),
                            ElevatedButton(
                              onPressed: () => _selectItem(foodItem),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepOrange,
                              ),
                              child: const Text('Add to Order'),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              _buildOrderSummary(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFoodImage(QueryDocumentSnapshot foodItem) {
    return foodItem['imageUrl'] != null && foodItem['imageUrl'] is String
        ? ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              foodItem['imageUrl'],
              height: 420,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          )
        : Container(
            height: 420,
            width: double.infinity,
            color: Colors.grey,
            child: const Icon(
              Icons.fastfood,
              color: Colors.white,
            ),
          );
  }

  Widget _buildFoodName(QueryDocumentSnapshot foodItem) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Text(
        foodItem['name'] ?? 'Unknown food name',
        style: const TextStyle(fontSize: 16.0),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildFoodPrice(QueryDocumentSnapshot foodItem) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Text(
        foodItem['price'] != null && foodItem['price'] is int
            ? 'Price: ${foodItem['price']}'
            : 'Price not available',
        style: const TextStyle(fontSize: 14.0),
        textAlign: TextAlign.center,
      ),
    );
  }

  void _selectItem(QueryDocumentSnapshot foodItem) {
    setState(() {
      if (selectedItems.containsKey(foodItem)) {
        selectedItems[foodItem] = selectedItems[foodItem]! + 1;
      } else {
        selectedItems[foodItem] = 1;
      }
    });
  }

  Widget _buildOrderSummary() {
    int totalCost = selectedItems.entries.fold<int>(
      0,
      // ignore: avoid_types_as_parameter_names
      (sum, entry) {
        final price =
            (entry.key['price'] as num).toInt(); // Cast 'price' to int
        return sum + (price * entry.value);
      },
    );

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          if (selectedItems.isNotEmpty) ...[
            const Text(
              'Order Summary',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...selectedItems.entries.map((entry) {
              final foodName = entry.key['name'];
              final foodQuantity = entry.value;
              final foodPrice = entry.key['price'];
              final itemTotal = foodPrice * foodQuantity;

              return Text(
                '$foodName x$foodQuantity = $itemTotal',
              );
            }),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () =>
                  _navigateToPaymentScreen(context, selectedItems, totalCost),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
              ),
              child: const Text('Proceed to Payment'),
            ),
          ],
        ],
      ),
    );
  }

  void _navigateToPaymentScreen(BuildContext context,
      Map<QueryDocumentSnapshot, int> selectedItems, int totalCost) {
    // Assuming you take the first selected item as the `Food` object
    var firstItem = selectedItems.entries.first.key;

    // Get the data from the document snapshot
    var data = firstItem.data() as Map<String, dynamic>?;

    // Check if the data is not null and all required fields exist
    if (data != null &&
        data.containsKey('restaurantName') &&
        data.containsKey('restaurantPhoneNumber') &&
        data.containsKey('pricePerKg') &&
        data.containsKey('values') &&
        data.containsKey('bestTimeToEat')) {
      Food food = Food(
        id: firstItem.id, // Assuming the document ID is the food ID
        name: data['name'] as String,
        values: data['values'] as String,
        bestTimeToEat: data['bestTimeToEat'] as String,
        pricePerKg: (data['pricePerKg'] as num).toDouble(),
        imageUrl: data['imageUrl'] as String,
        price: (data['price'] as num).toDouble(),
        restaurantName: data['restaurantName'] as String,
        restaurantPhoneNumber:
            (data['restaurantPhoneNumber'] as num).toDouble(),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentScreen(
            food: food, // Pass the `food` object
            totalCost: totalCost,
          ),
        ),
      );
    } else {
      // Handle the case where one or more fields are missing or data is null
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Some required fields are missing for the selected food item.'),
        ),
      );
    }
  }
}

class PaymentScreen extends StatelessWidget {
  final Food food;
  PaymentScreen({super.key, required this.food, required int totalCost});

  final AirtelPaymentService _paymentService = AirtelPaymentService();

  void _processCashPayment(BuildContext context, Food food) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LocationScreen(
          name: food.name, // Use the actual food name
          restaurantName: food.restaurantName, // Use the actual restaurant name
        ),
      ),
    );
  }

  void _processMobilePayment(BuildContext context, bool isCashIn) async {
    if (isCashIn) {
      await _paymentService.cashIn(food.price.toString() as double,
          food.restaurantPhoneNumber as String);
    } else {
      await _paymentService.cashOut(food.price.toString() as double,
          food.restaurantPhoneNumber as String);
    }

    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${isCashIn ? 'Cash In' : 'Cash Out'} processed')),
    );

    Navigator.push(
      // ignore: use_build_context_synchronously
      context,
      MaterialPageRoute(
        builder: (context) => PaymentConfirmationScreen(food: food),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Payment for ${food.name}',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.deepOrange,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Choose payment method for ${food.name}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _processCashPayment(context, food),
              style: ElevatedButton.styleFrom(
                iconColor: Colors.green,
                disabledIconColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.money),
                  SizedBox(width: 10),
                  Text('Pay by Cash'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _processMobilePayment(context, true),
              style: ElevatedButton.styleFrom(
                disabledIconColor: Colors.blue,
                iconColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.phone_android),
                  SizedBox(width: 10),
                  Text('Cash In with Mobile Money'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _processMobilePayment(context, false),
              style: ElevatedButton.styleFrom(
                disabledIconColor: Colors.blue,
                iconColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.phone_android),
                  SizedBox(width: 10),
                  Text('Cash Out with Mobile Money'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchResultsPage extends StatefulWidget {
  final String query;

  const SearchResultsPage({super.key, required this.query});

  @override
  // ignore: library_private_types_in_public_api
  _SearchResultsPageState createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Future<List<QueryDocumentSnapshot>> _searchResults;

  @override
  void initState() {
    super.initState();
    _searchResults = _searchFoods(widget.query);
  }

  Future<List<QueryDocumentSnapshot>> _searchFoods(String query) async {
    try {
      final result = await _firestore
          .collection('foods')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: '$query\uf8ff')
          .get();
      return result.docs;
    } catch (e) {
      if (kDebugMode) {
        print('Error searching foods: $e');
      }
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: const Text('Search Results '),
      ),
      body: FutureBuilder<List<QueryDocumentSnapshot>>(
        future: _searchResults,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No results found'));
          }

          final foodItems = snapshot.data!;

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            itemCount: foodItems.length,
            itemBuilder: (context, index) {
              var foodItem = foodItems[index];
              return GestureDetector(
                onTap: () =>
                    _navigateToFoodDetailPage(context, foodItem['name']),
                child: Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      foodItem.data() is Map<String, dynamic> &&
                              (foodItem.data() as Map<String, dynamic>)
                                  .containsKey('imageUrl') &&
                              foodItem['imageUrl'] != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: SizedBox(
                                height: 420,
                                width: double.infinity,
                                child: Image.network(
                                  foodItem['imageUrl'],
                                  fit: BoxFit.cover,
                                  errorBuilder: (BuildContext context,
                                      Object exception,
                                      StackTrace? stackTrace) {
                                    return Container(
                                      height: 420,
                                      width: double.infinity,
                                      color: Colors.grey,
                                      child: const Icon(
                                        Icons.error,
                                        color: Colors.white,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            )
                          : Container(
                              height: 100,
                              width: double.infinity,
                              color: Colors.grey,
                              child: const Icon(
                                Icons.fastfood,
                                color: Colors.white,
                              ),
                            ),
                      const SizedBox(height: 8.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          foodItem['name'],
                          style: const TextStyle(fontSize: 16.0),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _navigateToFoodDetailPage(BuildContext context, String foodName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FoodDetailPage(foodName: foodName),
      ),
    );
  }
}
