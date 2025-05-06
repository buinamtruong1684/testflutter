import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/Task.dart';
import '../providers/Task_Provider.dart';

class AddEditTaskScreen extends StatefulWidget {
  final Task? task;

  const AddEditTaskScreen({Key? key, this.task}) : super(key: key);

  @override
  _AddEditTaskScreenState createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends State<AddEditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;
  late int _priority;
  late String _status;
  late DateTime _dueDate;
  late String _assignedTo;

  @override
  void initState() {
    super.initState();
    final task = widget.task;
    _title = task?.title ?? '';
    _description = task?.description ?? '';
    _priority = task?.priority ?? 2;
    _status = task?.status ?? 'To do';
    _dueDate = task?.dueDate ?? DateTime.now().add(Duration(days: 1));
    _assignedTo = task?.assignedTo ?? '';
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);

      final task = Task(
        id: widget.task?.id ?? '',
        title: _title,
        description: _description,
        priority: _priority,
        status: _status,
        dueDate: _dueDate,
        assignedTo: _assignedTo,
        completed: _status == 'Done',
        createdAt: widget.task?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(), attachments: [], category: '',
      );

      if (widget.task == null) {
        taskProvider.addTask(task);
      } else {
        taskProvider.updateTask(task);
      }

      Navigator.pop(context);
    }
  }

  Future<void> _pickDueDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _dueDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Thêm công việc' : 'Chỉnh sửa công việc'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _title,
                decoration: InputDecoration(labelText: 'Tiêu đề'),
                validator: (value) => value == null || value.isEmpty ? 'Vui lòng nhập tiêu đề' : null,
                onChanged: (value) => _title = value,
              ),
              TextFormField(
                initialValue: _description,
                decoration: InputDecoration(labelText: 'Mô tả'),
                onChanged: (value) => _description = value,
              ),
              DropdownButtonFormField<int>(
                value: _priority,
                items: const [
                  DropdownMenuItem(value: 1, child: Text('Thấp')),
                  DropdownMenuItem(value: 2, child: Text('Trung bình')),
                  DropdownMenuItem(value: 3, child: Text('Cao')),
                ],
                decoration: InputDecoration(labelText: 'Mức độ ưu tiên'),
                onChanged: (value) {
                  if (value != null) setState(() => _priority = value);
                },
              ),
              DropdownButtonFormField<String>(
                value: _status,
                items: const [
                  DropdownMenuItem(value: 'To do', child: Text('To do')),
                  DropdownMenuItem(value: 'In progress', child: Text('In progress')),
                  DropdownMenuItem(value: 'Done', child: Text('Done')),
                  DropdownMenuItem(value: 'Cancelled', child: Text('Cancelled')),
                ],
                decoration: InputDecoration(labelText: 'Trạng thái'),
                onChanged: (value) {
                  if (value != null) setState(() => _status = value);
                },
              ),
              TextFormField(
                initialValue: _assignedTo,
                decoration: InputDecoration(labelText: 'Giao cho (username)'),
                validator: (value) => value == null || value.isEmpty ? 'Vui lòng nhập tên người nhận' : null,
                onChanged: (value) => _assignedTo = value,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Hạn hoàn thành: ${_dueDate.day}/${_dueDate.month}/${_dueDate.year}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  TextButton(
                    onPressed: _pickDueDate,
                    child: Text('Chọn ngày'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                child: Text(widget.task == null ? 'Thêm' : 'Cập nhật'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
