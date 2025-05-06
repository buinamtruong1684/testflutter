import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart'; // Đảm bảo đã import Uuid
import '../models/task.dart'; // Import đúng model Task, giả sử nó ở thư mục models

// Hằng số
const String _allStatus = 'Tất cả';
const String _adminUsername = 'admin';
const String _user1Username = 'user1';
const String _user2Username = 'user2';
const String _user3Username = 'user3';
const String _user4Username = 'user4';
const String _workCategory = 'Work';
const String _personalCategory = 'Personal';
const String _adminCategory = 'Admin';
const String _toDoStatus = 'To do';
const String _inProgressStatus = 'In progress';

class TaskProvider extends ChangeNotifier {
  // Danh sách người dùng (thường sẽ lấy từ database)
  final List<User> _users = [
    User(username: _adminUsername, password: '1234'),
    User(username: _user1Username, password: '1234'),
    User(username: _user2Username, password: '1234'),
    User(username: _user3Username, password: '1234'),
    User(username: _user4Username, password: '1234'),
  ];

  // Danh sách công việc
  List<Task> _tasks = [];
  // Tên người dùng hiện tại
  String _currentUsername = '';
  // Biến lưu trữ truy vấn tìm kiếm
  String _searchQuery = '';
  // Biến lưu trữ trạng thái lọc
  String _filterStatus = _allStatus;

  // Getter cho tên người dùng hiện tại
  String get currentUsername => _currentUsername;

  // Getter cho danh sách công việc đã lọc
  List<Task> get tasks {
    return _tasks.where((task) {
      // Kiểm tra xem công việc có khớp với truy vấn tìm kiếm không (không phân biệt hoa thường)
      final matchesQuery = task.title.toLowerCase().contains(_searchQuery.toLowerCase());
      // Kiểm tra xem công việc có khớp với trạng thái lọc không
      final matchesStatus = _filterStatus == _allStatus || task.status == _filterStatus;
      // Kiểm tra xem công việc có được giao cho người dùng hiện tại hoặc admin không
      final isAssignedToCurrentUser = task.assignedTo == _currentUsername || _currentUsername == _adminUsername;
      return matchesQuery && matchesStatus && isAssignedToCurrentUser;
    }).toList();
  }

  // Phương thức đăng nhập
  bool login(String username, String password) {
    final user = _users.firstWhere(
          (user) => user.username == username && user.password == password,
      orElse: () => User(username: '', password: ''), // Trả về User rỗng nếu không tìm thấy
    );
    if (user.username.isNotEmpty) {
      _currentUsername = user.username;
      _loadDummyTasks(); // Tải công việc mẫu sau khi đăng nhập
      notifyListeners();
      return true;
    }
    return false;
  }

  // Phương thức đăng ký
  bool register(String username, String password) {
    final existingUser = _users.firstWhere(
          (user) => user.username == username,
      orElse: () => User(username: '', password: ''), // Trả về User rỗng nếu không tìm thấy
    );
    if (existingUser.username.isEmpty) {
      _users.add(User(username: username, password: password));
      return true;
    }
    return false;
  }

  // Phương thức thêm công việc
  void addTask(Task task) {
    _tasks = [..._tasks, task]; // Tạo list mới với công việc được thêm vào
    notifyListeners();
  }

  // Phương thức cập nhật công việc
  void updateTask(Task task) {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      // Cập nhật công việc bằng cách tạo list mới
      _tasks = _tasks.map((t) => t.id == task.id ? task : t).toList();
      notifyListeners();
    }
  }

  // Phương thức tải công việc mẫu
  void _loadDummyTasks() {
    if (_tasks.isEmpty) {
      _tasks = [
        Task(
          id: '1',
          title: 'Task 1',
          description: 'Description of Task 1',
          dueDate: DateTime.now().add(const Duration(days: 1)),
          priority: 1,
          status: _toDoStatus,
          attachments: [],
          assignedTo: _user1Username,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          category: _workCategory,
          completed: false,
        ),
        Task(
          id: '2',
          title: 'Task 2',
          description: 'Description of Task 2',
          dueDate: DateTime.now().add(const Duration(days: 2)),
          priority: 2,
          status: _inProgressStatus,
          attachments: [],
          assignedTo: _user2Username,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          category: _personalCategory,
          completed: false,
        ),
        Task(
          id: '3',
          title: 'Admin Task',
          description: 'This task belongs to admin',
          dueDate: DateTime.now().add(const Duration(days: 3)),
          priority: 3,
          status: _toDoStatus,
          attachments: [],
          assignedTo: _adminUsername,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          category: _adminCategory,
          completed: false,
        ),
      ];
      notifyListeners();
    }
  }

  // Phương thức tìm kiếm công việc
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // Phương thức lọc trạng thái công việc
  void setFilterStatus(String status) {
    _filterStatus = status;
    notifyListeners();
  }
}

// Lớp User
class User {
  final String username;
  final String password;

  User({required this.username, required this.password});
}

