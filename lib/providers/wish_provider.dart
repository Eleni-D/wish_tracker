import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/wish_model.dart';

class WishProvider with ChangeNotifier {
  List<Wish> _wishes = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<Wish> get wishes => _wishes;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  final String _url = 'https://jsonplaceholder.typicode.com/todos';

  // READ (Fetch all wishes)
  Future<void> fetchWishes() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await http.get(Uri.parse(_url));
      if (response.statusCode == 200) {
        final List decodedData = json.decode(response.body);
        // Take the first 15 items just so the screen looks clean and elegant
        _wishes = decodedData
            .take(15)
            .map((json) => Wish.fromJson(json))
            .toList();
      } else {
        _errorMessage = 'Failed to load wishes from server.';
      }
    } catch (e) {
      _errorMessage = 'Network Error: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // CREATE (Add new wish)
  Future<void> addWish(String title) async {
    try {
      final response = await http.post(
        Uri.parse(_url),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({'title': title, 'completed': false, 'userId': 1}),
      );

      if (response.statusCode == 201) {
        final newWish = Wish.fromJson(json.decode(response.body));
        _wishes.insert(0, newWish);
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Could not save wish.';
      notifyListeners();
    }
  }

  // UPDATE (Toggle checkbox status)
  Future<void> toggleWishStatus(Wish wish) async {
    final index = _wishes.indexWhere((w) => w.id == wish.id);
    if (index == -1) return;

    try {
      final response = await http.put(
        Uri.parse('$_url/${wish.id}'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({
          'id': wish.id,
          'title': wish.title,
          'completed': !wish.isCompleted,
          'userId': 1,
        }),
      );

      if (response.statusCode == 200) {
        _wishes[index] = Wish(
          id: wish.id,
          title: wish.title,
          isCompleted: !wish.isCompleted,
        );
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Could not sync status update.';
      notifyListeners();
    }
  }

  // DELETE
  Future<void> deleteWish(int id) async {
    try {
      final response = await http.delete(Uri.parse('$_url/$id'));
      if (response.statusCode == 200) {
        _wishes.removeWhere((wish) => wish.id == id);
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Could not delete item.';
      notifyListeners();
    }
  }
}
