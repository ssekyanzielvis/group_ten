import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/favourite_item.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = TextEditingController();

    return ChangeNotifierProvider(
      create: (_) => FavoritesState(FavoritesRepositoryImpl())..loadFavorites(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Favorites"),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: FavoritesSearchDelegate(),
                );
              },
            ),
          ],
        ),
        body: Consumer<FavoritesState>(
          builder: (context, state, child) {
            if (state.filteredItems.isEmpty) {
              return const Center(child: Text("No favorites yet. Add some!"));
            }
            return GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 3 / 4,
              ),
              itemCount: state.filteredItems.length,
              itemBuilder: (context, index) {
                final item = state.filteredItems[index];
                return Card(
                  elevation: 4.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Image.network(
                          item.imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              style: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              item.description,
                              style: const TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    item.isFavorite
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    if (item.isFavorite) {
                                      state.removeFavorite(item.id);
                                    } else {
                                      state.addFavorite(item);
                                    }
                                  },
                                ),
                                Text("\$${item.price.toStringAsFixed(2)}"),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class FavoritesSearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Consumer<FavoritesState>(
      builder: (context, state, child) {
        state.filterFavorites(query);
        if (state.filteredItems.isEmpty) {
          return const Center(child: Text("No results found."));
        }
        return GridView.builder(
          padding: const EdgeInsets.all(8.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            childAspectRatio: 3 / 4,
          ),
          itemCount: state.filteredItems.length,
          itemBuilder: (context, index) {
            final item = state.filteredItems[index];
            return Card(
              elevation: 4.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Image.network(
                      item.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          item.description,
                          style: const TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: Icon(
                                item.isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                if (item.isFavorite) {
                                  state.removeFavorite(item.id);
                                } else {
                                  state.addFavorite(item);
                                }
                              },
                            ),
                            Text("\$${item.price.toStringAsFixed(2)}"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Consumer<FavoritesState>(
      builder: (context, state, child) {
        state.filterFavorites(query);
        if (state.filteredItems.isEmpty) {
          return const Center(child: Text("No suggestions found."));
        }
        return ListView.builder(
          itemCount: state.filteredItems.length,
          itemBuilder: (context, index) {
            final item = state.filteredItems[index];
            return ListTile(
              title: Text(item.name),
              subtitle: Text(item.description),
              onTap: () {
                query = item.name;
                showResults(context);
              },
            );
          },
        );
      },
    );
  }
}

class FavoritesState extends ChangeNotifier {
  final FavoritesRepository favoritesRepository;
  List<FavoriteItem> favoriteItems = [];
  List<FavoriteItem> filteredItems = [];

  FavoritesState(this.favoritesRepository);

  Future<void> loadFavorites() async {
    favoriteItems = await favoritesRepository.getFavoriteItems();
    filteredItems = favoriteItems;
    notifyListeners();
  }

  void filterFavorites(String query) {
    if (query.isEmpty) {
      filteredItems = favoriteItems;
    } else {
      filteredItems = favoriteItems
          .where(
              (item) => item.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  Future<void> addFavorite(FavoriteItem item) async {
    await favoritesRepository.addFavoriteItem(item);
    loadFavorites();
  }

  Future<void> removeFavorite(String id) async {
    await favoritesRepository.removeFavoriteItem(id);
    loadFavorites();
  }
}
