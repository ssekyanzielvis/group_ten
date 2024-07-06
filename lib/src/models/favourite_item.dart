import 'package:flutter/material.dart';

class FavoriteItem {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final double price;
  final String category;
  final double rating;
  final List<String> reviews;
  final bool isFavorite;
  final List<String> tags;

  FavoriteItem({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.category,
    required this.rating,
    required this.reviews,
    required this.isFavorite,
    required this.tags,
  });
}

abstract class FavoritesRepository {
  Future<List<FavoriteItem>> getFavoriteItems();
  Future<void> addFavoriteItem(FavoriteItem item);
  Future<void> removeFavoriteItem(String id);
}

class FavoritesRepositoryImpl implements FavoritesRepository {
  final List<FavoriteItem> _favorites = [];

  @override
  Future<List<FavoriteItem>> getFavoriteItems() async {
    return _favorites;
  }

  @override
  Future<void> addFavoriteItem(FavoriteItem item) async {
    _favorites.add(item);
  }

  @override
  Future<void> removeFavoriteItem(String id) async {
    _favorites.removeWhere((item) => item.id == id);
  }
}

class FavoritesState extends ChangeNotifier {
  final FavoritesRepository favoritesRepository;
  List<FavoriteItem> favoriteItems = [];

  FavoritesState(this.favoritesRepository);

  Future<void> loadFavorites() async {
    favoriteItems = await favoritesRepository.getFavoriteItems();
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
