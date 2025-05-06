import 'package:flutter/material.dart';
import '../models/Task.dart';

class TaskDetailScreen extends StatelessWidget {
  final Task task;

  const TaskDetailScreen({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(task.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Mô tả: ${task.description}'),
            Text('Trạng thái: ${task.status}'),
            Text('Ưu tiên: ${task.priority}'),
            Text('Ngày hết hạn: ${task.dueDate}'),
            Text('Gán cho: ${task.assignedTo}'),
            Text('Danh mục: ${task.category}'),
            // Hiển thị các tệp đính kèm nếu có
            if (task.attachments.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Tệp đính kèm:'),
                  ...task.attachments.map((attachment) => Text(attachment)).toList(),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
