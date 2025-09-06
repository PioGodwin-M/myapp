import 'dart:io';

import 'package:flutter/material.dart';
import 'package:myapp/app/data/datasources/remote/storage_service.dart';
import 'package:myapp/app/data/repositories/product_repository.dart';
import 'package:myapp/app/domain/entities/product.dart';
import 'package:uuid/uuid.dart';

import '../../../data/datasources/remote/auth_service.dart';

class FarmerDashboard extends StatefulWidget {
  const FarmerDashboard({super.key});

  @override
  State<FarmerDashboard> createState() => _FarmerDashboardState();
}

class _FarmerDashboardState extends State<FarmerDashboard> {
  final ProductRepository _productRepository = ProductRepository();
  final AuthService _authService = AuthService();
  final StorageService _storageService = StorageService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Farmer Dashboard'),
      ),
      body: StreamBuilder<List<Product>>(
        stream: _productRepository.getProducts(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching products'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final products = snapshot.data ?? [];

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ListTile(
                leading: product.imageUrl != null
                    ? Image.network(product.imageUrl!)
                    : null,
                title: Text(product.name),
                subtitle: Text(product.description),
                trailing: Text('\$${product.price.toStringAsFixed(2)}'),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddProductDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddProductDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    String name = '';
    String description = '';
    double price = 0.0;
    File? image0;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Product'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Name'),
                  onSaved: (value) => name = value!,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a name' : null,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Description'),
                  onSaved: (value) => description = value!,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a description' : null,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                  onSaved: (value) => price = double.parse(value!),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a price' : null,
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    final image = await _storageService.pickImage();
                    setState(() {
                      image0 = image;
                    });
                  },
                  child: const Text('Add Image'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final navigator = Navigator.of(context);
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  String? imageUrl;
                  if (image0 != null) {
                    imageUrl = await _storageService.uploadImage(image0!);
                  }
                  final newProduct = Product(
                    id: const Uuid().v4(),
                    name: name,
                    description: description,
                    price: price,
                    farmerId: _authService.currentUser!.uid,
                    imageUrl: imageUrl,
                  );
                  await _productRepository.addProduct(newProduct);
                  navigator.pop();
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
