// entities
class MealType {
  final String id;
  final String name;

  MealType({this.id, this.name});
}

class Meal {
  final String id;
  final String name;
  final MealType mealType;

  Meal({this.id, this.name, this.mealType});
}

class Restaurant {
  final String id;
  final String name;
  final List<Meal> meals;

  Restaurant({this.id, this.name, this.meals});
}

class Order {
  final String id;
  final Meal meal;
  final Restaurant restaurant;
  final int quantity;

  Order({this.id, this.meal, this.restaurant, this.quantity});
}

// repositories
class MealTypeRepository {
  Future<List<MealType>> getMealTypes() async {
    // return list of meal types from database or API
  }
}

class MealRepository {
  Future<List<Meal>> getMeals() async {
    // return list of meals from database or API
  }
}

class RestaurantRepository {
  Future<List<Restaurant>> getRestaurants() async {
    // return list of restaurants from database or API
  }
}

class OrderRepository {
  Future<void> placeOrder(Order order) async {
    // place order in database or API
  }
}

// use cases
class SelectMealType with UseCase {
  final MealTypeRepository _repository;

  SelectMealType(this._repository);

  @override
  Future<void> execute() async {
    final mealTypes = await _repository.getMealTypes();
    // update MealTypeSelector with mealTypes
  }
}

class SelectMeal with UseCase {
  final MealRepository _repository;

  SelectMeal(this._repository);

  @override
  Future<void> execute() async {
    final meals = await _repository.getMeals();
    // update MealSelector with meals
  }
}

class InputBudget with UseCase {
  final BudgetRepository _repository;

  InputBudget(this._repository);

  @override
  Future<void> execute() async {
    final budget = await _repository.getBudget();
    // update BudgetInput with budget
  }
}

class GetDietRecommendation with UseCase {
  final DietRecommendationRepository _repository;

  GetDietRecommendation(this._repository);

  @override
  Future<void> execute() async {
    final dietRecommendation = await _repository.getDietRecommendation();
    // update DietRecommendation with dietRecommendation
  }
}

class GetNearbyRestaurants with UseCase {
  final RestaurantRepository _repository;

  GetNearbyRestaurants(this._repository);

  @override
  Future<void> execute() async {
    final restaurants = await _repository.getRestaurants();
    // update NearbyRestaurants with restaurants
  }
}

class PlaceOrder with UseCase {
  final OrderRepository _repository;

  PlaceOrder(this._repository);

  @override
  Future<void> execute() async {
    final order = await _repository.placeOrder();
    // update OrderPlacer with order
  }
}

// adapters
class MealTypeSelectorAdapter with Adapter<MealType> {
  @override
  Widget build(BuildContext context, MealType mealType) {
    return DropdownMenuItem<MealType>(
      value: mealType,
      child: Text(mealType.name),
    );
  }
}

class MealSelectorAdapter with Adapter<Meal> {
  @override
  Widget build(BuildContext context, Meal meal) {
    return DropdownMenuItem<Meal>(
      value: meal,
      child: Text(meal.name),
    );
  }
}

class BudgetInputAdapter with Adapter<int> {
  @override
  Widget build(BuildContext context, int budget) {
    return TextField(
      controller: TextEditingController(text: budget.toString()),
      decoration: InputDecoration(
        labelText: 'Budget',
      ),
    );
  }
}

class DietRecommendationAdapter with Adapter<String> {
  @override
  Widget build(BuildContext context, String dietRecommendation) {
    return Text(dietRecommendation);
  }
}

class NearbyRestaurantsAdapter with Adapter<Restaurant> {
  @override
  Widget build(BuildContext context, Restaurant restaurant) {
    return ListTile(
      title: Text(restaurant.name),
    );
  }
}

class OrderPlacerAdapter with Adapter<Order> {
  @override
  Widget build(BuildContext context, Order order) {
    return ElevatedButton(
      onPressed: () {
        // place order logic here
      },
      child: Text('Place Order'),
    );
  }
}

// widgets
class MealTypeSelector extends StatefulWidget {
  @override
  _MealTypeSelectorState createState() => _MealTypeSelectorState();
}

class _MealTypeSelectorState extends State<MealTypeSelector> {
  List<MealType> _mealTypes = [];
  MealType _selectedMealType;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<MealType>(