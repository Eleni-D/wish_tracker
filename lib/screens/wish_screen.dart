import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/wish_provider.dart';

class WishScreen extends StatelessWidget {
  const WishScreen({super.key});

  void _showAddWishDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add New Wish'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'What is your wish?'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                Provider.of<WishProvider>(
                  context,
                  listen: false,
                ).addWish(controller.text);
              }
              Navigator.pop(ctx);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WishProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('✨ Wish Tracker'),
        backgroundColor: Colors.teal.shade100,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddWishDialog(context),
        backgroundColor: Colors.teal,
        child: const Icon(Icons.star, color: Colors.white),
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.errorMessage.isNotEmpty
          ? Center(
              child: Text(
                provider.errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            )
          : ListView.builder(
              itemCount: provider.wishes.length,
              itemBuilder: (context, index) {
                final wish = provider.wishes[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    leading: IconButton(
                      icon: Icon(
                        wish.isCompleted
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        color: wish.isCompleted ? Colors.green : Colors.grey,
                      ),
                      onPressed: () => provider.toggleWishStatus(wish),
                    ),
                    title: Text(
                      wish.title,
                      style: TextStyle(
                        decoration: wish.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.redAccent,
                      ),
                      onPressed: () => provider.deleteWish(wish.id ?? 0),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
