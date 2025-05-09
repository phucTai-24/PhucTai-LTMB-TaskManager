import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../models/task_model.dart';
import '../../services/task_service.dart';

class TaskFormScreen extends StatefulWidget {
  final TaskModel? task;

  const TaskFormScreen({super.key, this.task});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String title;
  late String description;
  int priority = 2;
  String status = 'To do';
  DateTime? dueDate;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      final task = widget.task!;
      title = task.title;
      description = task.description;
      priority = task.priority;
      status = task.status;
      dueDate = task.dueDate;
    } else {
      title = '';
      description = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.task == null ? 'Thêm công việc' : 'Sửa công việc')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: title,
                decoration: InputDecoration(labelText: 'Tiêu đề'),
                validator: (val) => val!.isEmpty ? 'Không được để trống' : null,
                onSaved: (val) => title = val!,
              ),
              TextFormField(
                initialValue: description,
                decoration: InputDecoration(labelText: 'Mô tả'),
                maxLines: 3,
                onSaved: (val) => description = val!,
              ),
              DropdownButtonFormField<int>(
                value: priority,
                decoration: InputDecoration(labelText: 'Độ ưu tiên'),
                items: [
                  DropdownMenuItem(value: 1, child: Text('Thấp')),
                  DropdownMenuItem(value: 2, child: Text('Trung bình')),
                  DropdownMenuItem(value: 3, child: Text('Cao')),
                ],
                onChanged: (val) => setState(() => priority = val!),
              ),
              DropdownButtonFormField<String>(
                value: status,
                decoration: InputDecoration(labelText: 'Trạng thái'),
                items: ['To do', 'In progress', 'Done', 'Cancelled']
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (val) => setState(() => status = val!),
              ),
              SizedBox(height: 10),
              TextButton.icon(
                icon: Icon(Icons.date_range),
                label: Text(dueDate != null
                    ? 'Hạn: ${dueDate!.toLocal()}'
                    : 'Chọn hạn hoàn thành'),
                onPressed: () async {
                  final picked = await showDatePicker(
                      context: context,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100));
                  if (picked != null) setState(() => dueDate = picked);
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    final task = TaskModel(
                      id: widget.task?.id ?? const Uuid().v4(),
                      title: title,
                      description: description,
                      status: status,
                      priority: priority,
                      dueDate: dueDate,
                      createdAt: widget.task?.createdAt ?? DateTime.now(),
                      updatedAt: DateTime.now(),
                      assignedTo: null,
                      createdBy: 'giahuy2401',
                      category: null,
                      attachments: null,
                      completed: widget.task?.completed ?? false,
                    );

                    if (widget.task == null) {
                      await TaskService.insertTask(task);
                    } else {
                      await TaskService.updateTask(task);
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Đã lưu công việc')),
                    );

                    Navigator.pop(context);
                  }
                },
                child: Text('Lưu công việc'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
