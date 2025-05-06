import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Model/NoteApp.dart';

class NoteDetailScreen extends StatelessWidget {
  final Note note;

  const NoteDetailScreen({Key? key, required this.note}) : super(key: key);

  String _getPriorityLabel(int priority) {
    switch (priority) {
      case 1:
        return 'Thấp';
      case 2:
        return 'Trung bình';
      case 3:
        return 'Cao';
      default:
        return 'Không xác định';
    }
  }

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('dd/MM/yyyy HH:mm');

    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết ghi chú'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Card(
          elevation: 2,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow('Tiêu đề', note.title),
                Divider(),
                _buildDetailRow('Nội dung', note.content),
                Divider(),
                _buildDetailRow('Mức độ ưu tiên', _getPriorityLabel(note.priority)),
                Divider(),
                _buildDetailRow('Ngày tạo', formatter.format(note.createdAt)),
                Divider(),
                _buildDetailRow('Ngày chỉnh sửa', formatter.format(note.modifiedAt)),
                if (note.tags != null && note.tags!.isNotEmpty) ...[
                  Divider(),
                  _buildDetailRow('Tags', note.tags!.join(', ')),
                ],
                if (note.color != null) ...[
                  Divider(),
                  _buildDetailRow('Màu', note.color!),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
              fontSize: 12,
            ),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
