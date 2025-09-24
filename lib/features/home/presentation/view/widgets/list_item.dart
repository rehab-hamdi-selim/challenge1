import 'package:flutter/material.dart';

/*import '../../../data/models/task_model.dart';

class ListItem extends StatelessWidget {
  const ListItem({super.key, required this.task, required this.onChanged});

  final Task task;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.drag_handle),
      title: Text(
        task.title,
        style: TextStyle(
          decoration: task.isDone
              ? TextDecoration.lineThrough
              : TextDecoration.none,
          color: task.isDone ? Colors.grey : Colors.black,
        ),
      ),
      trailing: Checkbox(value: task.isDone, onChanged: onChanged),
    );
  }
}*/

import '../../../data/models/task_model.dart';

class ListItem extends StatelessWidget {
  const ListItem({super.key, required this.task, required this.onChanged});

  final Task task;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.drag_handle),
      title: Text(
        task.title,
        style: TextStyle(
          decoration: task.isDone
              ? TextDecoration.lineThrough
              : TextDecoration.none,
          color: Colors.black,
        ),
      ),
      trailing: Checkbox.adaptive(
        value: task.isDone,
        onChanged: (v) => onChanged(v ?? false),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      visualDensity: const VisualDensity(vertical: -1),
    );
  }
}
