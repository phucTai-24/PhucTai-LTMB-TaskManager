import 'package:flutter/material.dart';
import '../../models/task_model.dart';
import '../../services/task_service.dart';

class TaskDetailScreen extends StatelessWidget {
  final TaskModel task;

  const TaskDetailScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(task.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Trạng thái: ${task.status}'),
            Text('Mô tả: ${task.description}'),
            Text('Ngày tạo: ${task.createdAt.toLocal()}'),
            if (task.attachments != null)
              ...task.attachments!.map((file) => Text('📎 $file')).toList(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/task-form', arguments: task);
              },
              child: Text('Sửa công việc'),
            ),
            ElevatedButton(
              onPressed: () async {
                final updatedTask = task.copyWith(
                  completed: !task.completed,
                  status: task.completed ? 'To do' : 'Done',
                  updatedAt: DateTime.now(),
                );
                await TaskService.updateTask(updatedTask);
                Navigator.pop(context);
              },
              child: Text(task.completed
                  ? 'Đánh dấu là chưa hoàn thành'
                  : 'Đánh dấu là đã hoàn thành'),
            ),
          ],
        ),
      ),
    );
  }
}
