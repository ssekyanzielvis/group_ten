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

class FoodDetailPage extends StatelessWidget {
  final String foodName;

  const FoodDetailPage({super.key, required this.foodName});

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    return Scaffold(
      appBar: AppBar(
        title: Text('Choose $foodName according to your budget.'),
        backgroundColor: Colors.deepOrange,
      ),
      body: StreamBuilder(
        stream: firestore
            .collection('foods')
            .where('name', isEqualTo: foodName)
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
                onTap: () => _navigateToPaymentScreen(context, foodItem),
                child: Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      foodItem.data() != null &&
                              (foodItem.data() as Map<String, dynamic>)
                                  .containsKey('imageUrl') &&
                              foodItem['imageUrl'] != null &&
                              foodItem['imageUrl'] is String
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
                            ),
                      const SizedBox(height: 8.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          foodItem.data() != null &&
                                  (foodItem.data() as Map<String, dynamic>)
                                      .containsKey('name') &&
                                  foodItem['name'] is String
                              ? foodItem['name']
                              : 'Unknown food name',
                          style: const TextStyle(fontSize: 16.0),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          foodItem.data() != null &&
                                  (foodItem.data() as Map<String, dynamic>)
                                      .containsKey('price') &&
                                  foodItem['price'] is int
                              ? 'Price: ${foodItem['price']}'
                              : 'Price not available',
                          style: const TextStyle(fontSize: 14.0),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      ElevatedButton(
                        onPressed: () =>
                            _navigateToPaymentScreen(context, foodItem),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange,
                        ),
                        child: const Text('Make Order'),
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

  void _navigateToPaymentScreen(
      BuildContext context, QueryDocumentSnapshot foodSnapshot) {
    Food food = Food.fromDocument(foodSnapshot);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentScreen(food: food),
      ),
    );
  }
}

class PaymentScreen extends StatelessWidget {
  final Food food;
  PaymentScreen({super.key, required this.food});

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
