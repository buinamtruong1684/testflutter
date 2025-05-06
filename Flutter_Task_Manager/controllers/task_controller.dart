import 'package:flutter/material.dart';
import '../models/Task.dart';
import '../api/task_api_service.dart';

class TaskController extends ChangeNotifier {
  List<Task> _tasks = [];
  List<Task> get tasks => _tasks;

  final TaskApiService taskApiService;

  TaskController({required this.taskApiService}) {
    fetchTasks();
  }

  // Hàm lấy danh sách task
  Future<void> fetchTasks() async {
    try {
      _tasks = await taskApiService.getTasks();
      notifyListeners();
    } catch (e) {
      print('Error fetching tasks: $e');
      // Cần xử lý lỗi cho người dùng (có thể show thông báo lỗi hoặc trạng thái)
    }
  }

  // Hàm thêm một task mới
  Future<Task?> addTask(Task task) async {
    try {
      final newTask = await taskApiService.createTask(task);
      _tasks.add(newTask);
      notifyListeners();
      return newTask;
    } catch (e) {
      print('Error creating task: $e');
      return null;
    }
  }

  // Hàm lấy task theo ID
  Future<Task?> getTaskById(String id) async {
    try {
      final task = await taskApiService.getTask(id);
      return task;
    } catch (e) {
      print('Error fetching task by ID: $e');
      return null; // Có thể thêm thông báo lỗi cho người dùng
    }
  }

  // Hàm cập nhật task
  Future<void> updateTask(Task task) async {
    try {
      await taskApiService.updateTask(task.id, task); // Sửa để truyền task.id vào
      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _tasks[index] = task;
        notifyListeners();
      }
    } catch (e) {
      print('Error updating task: $e');
      // Có thể thêm thông báo lỗi cho người dùng
    }
  }

  // Hàm xóa task
  Future<void> deleteTask(String id) async {
    try {
      await taskApiService.deleteTask(id);
      _tasks.removeWhere((task) => task.id == id);
      notifyListeners();
    } catch (e) {
      print('Error deleting task: $e');
      // Xử lý lỗi (thông báo cho người dùng)
    }
  }
}
