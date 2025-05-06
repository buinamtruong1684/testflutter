import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../Model/NoteApp.dart';

class NoteForm extends StatefulWidget {
  final Note? note; // null nếu tạo mới
  final Function(Note) onSave;

  const NoteForm({super.key, this.note, required this.onSave});

  @override
  State<NoteForm> createState() => _NoteFormState();
}

class _NoteFormState extends State<NoteForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _labelController = TextEditingController();

  int _priority = 1;
  Color _selectedColor = Colors.blue;
  List<String> _labels = [];

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
      _priority = widget.note!.priority;
      _selectedColor = Color(int.parse(widget.note!.color!.replaceFirst('#', ''), radix: 16));
      _labels = List<String>.from(widget.note!.tags ?? []);
    }
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final newNote = Note(
        id: widget.note?.id,
        title: _titleController.text,
        content: _contentController.text,
        priority: _priority,
        color: '#${_selectedColor.value.toRadixString(16).padLeft(8, '0')}',
        tags: _labels,
        createdAt: widget.note?.createdAt ?? DateTime.now(),
        modifiedAt: DateTime.now(),
      );

      print("Đang lưu ghi chú mới...");
      final result = await widget.onSave(newNote);
      if (result == true) {
        print("Lưu xong, thoát về danh sách");
        Navigator.pop(context, true);
      } else {
        print("❌ Lưu ghi chú thất bại");
      }
    }
  }





  void _pickColor() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Chọn màu sắc'),
        content: SingleChildScrollView(
          child: BlockPicker(
            pickerColor: _selectedColor,
            onColorChanged: (color) {
              setState(() {
                _selectedColor = color;
              });
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
    );
  }

  void _addLabel(String label) {
    if (label.isNotEmpty && !_labels.contains(label)) {
      setState(() {
        _labels.add(label);
        _labelController.clear();
      });
    }
  }

  void _removeLabel(String label) {
    setState(() {
      _labels.remove(label);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.note != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Cập nhật Ghi chú' : 'Thêm Ghi chú'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Tiêu đề'),
                validator: (value) =>
                value == null || value.trim().isEmpty ? 'Tiêu đề bắt buộc' : null,

              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _contentController,
                decoration: InputDecoration(labelText: 'Nội dung'),
                maxLines: 4,
                validator: (value) =>
                value == null || value.trim().isEmpty ? 'Nội dung bắt buộc' : null,


              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Text('Ưu tiên:'),
                  SizedBox(width: 10),
                  DropdownButton<int>(
                    value: _priority,
                    items: List.generate(
                      5,
                          (index) => DropdownMenuItem(
                        value: index + 1,
                        child: Text('Mức ${index + 1}'),
                      ),
                    ),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _priority = value;
                        });
                      }
                    },
                  ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Text('Màu:'),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: _pickColor,
                    child: CircleAvatar(backgroundColor: _selectedColor),
                  ),
                ],
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _labelController,
                decoration: InputDecoration(
                  labelText: 'Thêm nhãn',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () => _addLabel(_labelController.text.trim()),
                  ),
                ),
              ),
              Wrap(
                spacing: 8,
                children: _labels
                    .map(
                      (label) => Chip(
                    label: Text(label),
                    onDeleted: () => _removeLabel(label),
                  ),
                )
                    .toList(),
              ),
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  child: Text(isEditing ? 'Cập nhật' : 'Thêm mới'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
