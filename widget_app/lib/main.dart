import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      home: DragExample(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

class DragExample extends StatefulWidget {
  const DragExample({super.key});

  @override
  State<DragExample> createState() => _DragExampleState();
}

class _DragExampleState extends State<DragExample> {
  String droppedItem = "Nada";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Drag and Drop Example"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildDraggable(),
          const SizedBox(height: 100),
          buildDragTarget(),
        ],
      ),
    );
  }

  Widget buildDraggable() {
    return Center(
      child: LongPressDraggable<String>(
        data: "Hamburguesa",
        feedback: Material(
          child: Container(
            padding: const EdgeInsets.all(20),
            color: Colors.orange,
            child: const Text(
              "Hamburguesa",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          color: Colors.blue,
          child: const Text(
            "Mantén presionado y arrastra",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget buildDragTarget() {
    return Center(
      child: DragTarget<String>(
        builder: (context, candidateData, rejectedData) {
          return Container(
            height: 150,
            width: 200,
            color: Colors.grey[300],
            child: Center(
              child: Text(
                "Soltado: $droppedItem",
                style: const TextStyle(fontSize: 18),
              ),
            ),
          );
        },
        onAcceptWithDetails: (details) {
          setState(() {
            droppedItem = details.data;
          });
        },
      ),
    );
  }
}