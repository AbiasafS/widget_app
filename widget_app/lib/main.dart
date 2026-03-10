import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      home: ExampleDragAndDrop(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

const _urlPrefix =
    'https://docs.flutter.dev/assets/images/exercise/effects/split-check';

const List<Item> _items = [
  Item(
    name: 'Spinach Pizza',
    totalPriceCents: 1299,
    uid: '1',
    imageProvider: NetworkImage('$_urlPrefix/Food1.jpg'),
  ),
  Item(
    name: 'Veggie Delight',
    totalPriceCents: 799,
    uid: '2',
    imageProvider: NetworkImage('$_urlPrefix/Food2.jpg'),
  ),
  Item(
    name: 'Chicken Parmesan',
    totalPriceCents: 1499,
    uid: '3',
    imageProvider: NetworkImage('$_urlPrefix/Food3.jpg'),
  ),
];

class ExampleDragAndDrop extends StatefulWidget {
  const ExampleDragAndDrop({super.key});

  @override
  State<ExampleDragAndDrop> createState() => _ExampleDragAndDropState();
}

class _ExampleDragAndDropState extends State<ExampleDragAndDrop> {
  final List<Customer> _people = [
    Customer(
      name: 'Makayla',
      imageProvider: const NetworkImage('$_urlPrefix/Avatar1.jpg'),
    ),
    Customer(
      name: 'Nathan',
      imageProvider: const NetworkImage('$_urlPrefix/Avatar2.jpg'),
    ),
    Customer(
      name: 'Emilio',
      imageProvider: const NetworkImage('$_urlPrefix/Avatar3.jpg'),
    ),
  ];

  void _itemDroppedOnCustomerCart({
    required Item item,
    required Customer customer,
  }) {
    setState(() {
      customer.items.add(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order Food')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];

                return LongPressDraggable<Item>(
                  data: item,
                  feedback: Image(
                    image: item.imageProvider,
                    width: 120,
                  ),
                  child: ListTile(
                    leading: Image(image: item.imageProvider, width: 50),
                    title: Text(item.name),
                    subtitle: Text(item.formattedTotalItemPrice),
                  ),
                );
              },
            ),
          ),
          Row(
            children: _people.map((customer) {
              return Expanded(
                child: DragTarget<Item>(
                  builder: (context, candidateData, rejectedData) {
                    return Container(
                      height: 120,
                      margin: const EdgeInsets.all(8),
                      color: candidateData.isNotEmpty
                          ? Colors.red
                          : Colors.grey[300],
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(
                            image: customer.imageProvider,
                            width: 50,
                          ),
                          Text(customer.name),
                          Text(customer.formattedTotalItemPrice),
                        ],
                      ),
                    );
                  },
                  onAcceptWithDetails: (details) {
                    _itemDroppedOnCustomerCart(
                      item: details.data,
                      customer: customer,
                    );
                  },
                ),
              );
            }).toList(),
          )
        ],
      ),
    );
  }
}

class Customer {
  Customer({
    required this.name,
    required this.imageProvider,
    List<Item>? items,
  }) : items = items ?? [];

  final String name;
  final ImageProvider imageProvider;
  final List<Item> items;

  String get formattedTotalItemPrice {
    final totalPriceCents =
        items.fold<int>(0, (prev, item) => prev + item.totalPriceCents);
    return '\$${(totalPriceCents / 100.0).toStringAsFixed(2)}';
  }
}

class Item {
  const Item({
    required this.totalPriceCents,
    required this.name,
    required this.uid,
    required this.imageProvider,
  });

  final int totalPriceCents;
  final String name;
  final String uid;
  final ImageProvider imageProvider;

  String get formattedTotalItemPrice =>
      '\$${(totalPriceCents / 100.0).toStringAsFixed(2)}';
}