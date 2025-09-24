import 'package:flutter/material.dart';
import 'package:challenge1/features/home/presentation/view/widgets/list_item.dart';
import '../../data/models/task_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Task> tasks = [
    Task(id: 't1', title: 'Review Clean Architecture', isDone: false),
    Task(id: 't2', title: 'Complete flutter assignments', isDone: false),
    Task(id: 't3', title: 'Practice widget Catalog', isDone: false),
  ];

  void _toggleTask(int index, bool value) {
    final task = tasks[index];
    setState(() {
      tasks[index] = task.copyWith(isDone: value);
    });
  }

  void _showSnackBar(int index) {
    final removedTask = tasks[index];
    setState(() {
      tasks.removeAt(index);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Deleted: ${removedTask.title}'),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () {
            setState(() {
              final insertIndex = index.clamp(0, tasks.length);
              tasks.insert(insertIndex, removedTask);
            });
          },
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Manager'),
        centerTitle: true,
        leading: const Icon(Icons.arrow_back_ios),
      ),

      // ✅ ReorderableListView.builder لأداء أفضل
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ReorderableListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: tasks.length,

          itemBuilder: (context, index) {
            final task = tasks[index];

            // ✅ Dismissible
            return Dismissible(
              key: ValueKey(task.id),
              direction: DismissDirection.endToStart,
              background: Container(
                decoration: BoxDecoration(
                  color: Colors.red.shade600,
                  borderRadius: BorderRadius.circular(8),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Delete',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.delete, color: Colors.white),
                  ],
                ),
              ),
              confirmDismiss: (_) async {
                final result = await showDialog<bool>(
                  context: context,
                  builder: (c) => AlertDialog(
                    title: const Text('Confirm Delete'),
                    content: Text('Delete "${tasks[index].title}" ?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(c, false), // Cancel
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.green),
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(c, true), // Delete
                        child: const Text(
                          'Delete',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );
                if (result == true) {
                  _showSnackBar(index);
                  return true;
                }
                return false;
              },
              child: Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListItem(
                  key: ValueKey('${task.id}_tile'),
                  task: task,
                  onChanged: (v) => _toggleTask(index, v),
                ),
              ),
            );
          },
          onReorder: (oldIndex, newIndex) {
            setState(() {
              if (newIndex > oldIndex) newIndex -= 1;
              final moved = tasks.removeAt(oldIndex);
              tasks.insert(newIndex, moved);
            });
          },
        ),
      ),
    );
  }
}
