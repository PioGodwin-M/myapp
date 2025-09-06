import 'package:flutter/material.dart';
import 'package:myapp/app/data/repositories/cart_repository.dart';
import 'package:myapp/app/data/repositories/product_repository.dart';
import 'package:myapp/app/domain/entities/product.dart';
import 'package:myapp/app/presentation/pages/trader/cart_screen.dart';

enum PriceFilter { all, under10, between10and50, over50 }

class TraderDashboard extends StatefulWidget {
  const TraderDashboard({super.key});

  @override
  State<TraderDashboard> createState() => _TraderDashboardState();
}

class _TraderDashboardState extends State<TraderDashboard> {
  final ProductRepository _productRepository = ProductRepository();
  final CartRepository _cartRepository = CartRepository();
  String _searchQuery = '';
  PriceFilter _selectedFilter = PriceFilter.all;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trader Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartScreen(cartRepository: _cartRepository),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'Search',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 10),
                DropdownButton<PriceFilter>(
                  value: _selectedFilter,
                  items: const [
                    DropdownMenuItem(
                      value: PriceFilter.all,
                      child: Text('All Prices'),
                    ),
                    DropdownMenuItem(
                      value: PriceFilter.under10,
                      child: Text('Under \$10'),
                    ),
                    DropdownMenuItem(
                      value: PriceFilter.between10and50,
                      child: Text('\$10 - \$50'),
                    ),
                    DropdownMenuItem(
                      value: PriceFilter.over50,
                      child: Text('Over \$50'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedFilter = value!;
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Product>>(
              stream: _productRepository.getProducts(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Error fetching products'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                var products = snapshot.data
                    ?.where((product) => product.name
                        .toLowerCase()
                        .contains(_searchQuery.toLowerCase()))
                    .toList() ??
                    [];

                products = products.where((product) {
                  switch (_selectedFilter) {
                    case PriceFilter.under10:
                      return product.price < 10;
                    case PriceFilter.between10and50:
                      return product.price >= 10 && product.price <= 50;
                    case PriceFilter.over50:
                      return product.price > 50;
                    case PriceFilter.all:
                      return true;
                  }
                }).toList();

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
                      trailing: ElevatedButton(
                        onPressed: () {
                          _cartRepository.addProductToCart(product);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Product added to cart')),
                          );
                        },
                        child: const Text('Add to Cart'),
                      ),
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
