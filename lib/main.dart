import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const InteractivePhysics(),
    );
  }
}

class InteractivePhysics extends StatefulWidget {
  const InteractivePhysics({super.key});

  @override
  State<InteractivePhysics> createState() => _InteractivePhysicsState();
}

class DragData {
  final String name;
  final Color color;
  final IconData icon;

  DragData({required this.name, required this.color, required this.icon});
}

class _InteractivePhysicsState extends State<InteractivePhysics> {
  List<String> dropHistory = [];
  String? currentHover;

  final List<Color> dragItemsColor = [Colors.blue, Colors.green, Colors.red];
  final List<bool> targetstate = [false, false, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Interactive Physics')),
      body: Column(
        children: [
          const SizedBox(height: 150),

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: dragItemsColor
                .map((color) => _buildDraggableItem(color))
                .toList(),
          ),

          const SizedBox(height: 200),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: targetstate
                .asMap()
                .entries
                .map(
                  (targetstate) => _buildDropTarget(
                    dragItemsColor[targetstate.key],
                    targetstate.key,
                  ),
                )
                .toList(),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                targetstate.setAll(0, [false, false, false]);
              });
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  Widget _buildDraggableItem(Color item) {
    return Draggable<Color>(
      data: item,
      feedback: CircleAvatar(backgroundColor: item, radius: 25),
      childWhenDragging: CircleAvatar(
        backgroundColor: item.withValues(alpha: 0.5),
        radius: 25,
      ),
      child: CircleAvatar(backgroundColor: item, radius: 25),
    );
  }

  Widget _buildDropTarget(Color targetColor, int index) {
    return DragTarget<Color>(
      builder: (context, candidateData, rejectedData) => Container(
        width: 90,
        height: 90,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: targetstate[index]
              ? targetColor
              : targetColor.withValues(alpha: .2),
          border: Border.all(color: targetColor, width: 3),
        ),
        child: targetstate[index]
            ? Icon(Icons.check, color: Colors.white, size: 40)
            : candidateData.isEmpty
            ? const SizedBox()
            : Icon(Icons.arrow_downward, color: Colors.white, size: 30),
      ),

      onAcceptWithDetails: (details) {
        if (targetColor == details.data) {
          targetstate[index] = true;
          setState(() {});
        }
      },
    );
  }
}
