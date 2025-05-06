import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/Task.dart';
import '../config/ApiConfig.dart'; // Import file chứa baseUrl

class TaskApiService {
  final String _baseUrl = ApiConfig.baseUrl + '/tasks'; // Sử dụng baseUrl từ config

  // Hàm để lấy danh sách tất cả các task
  Future<List<Task>> getTasks() async {
    final response = await http.get(Uri.parse(_baseUrl));
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => Task.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load tasks. Status code: ${response.statusCode}, body: ${response.body}');
    }
  }

  // Hàm để lấy chi tiết một task theo ID
  Future<Task> getTask(String id) async {
    final response = await http.get(Uri.parse('$_baseUrl/$id'));
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final dynamic data = json.decode(response.body);
      return Task.fromJson(data);
    } else {
      throw Exception('Failed to load task. Status code: ${response.statusCode}, body: ${response.body}');
    }
  }

  // Hàm để tạo một task mới
  Future<Task> createTask(Task task) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(task.toJson()),
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final dynamic data = json.decode(response.body);
      return Task.fromJson(data);
    } else {
      throw Exception('Failed to create task. Status code: ${response.statusCode}, body: ${response.body}');
    }
  }

  // Hàm để cập nhật một task
  Future<void> updateTask(String id, Task task) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(task.toJson()),
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return; // Không cần trả về gì khi mã trạng thái là 204 (No Content)
    } else {
      throw Exception('Failed to update task. Status code: ${response.statusCode}, body: ${response.body}');
    }
  }

  // Hàm để xóa một task
  Future<void> deleteTask(String id) async {
    final response = await http.delete(Uri.parse('$_baseUrl/$id'));
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return; // Không cần trả về gì khi mã trạng thái là 204 (No Content)
    } else {
      throw Exception('Failed to delete task. Status code: ${response.statusCode}, body: ${response.body}');
    }
  }
}
