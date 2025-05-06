import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

// Đảm bảo import đúng đường dẫn theo cấu trúc của dự án của bạn
import 'Flutter_Task_Manager/models/Task.dart';
import 'Flutter_Task_Manager/views/add_edit_task_screen.dart';
import 'Flutter_Task_Manager/views/task_item.dart';
import 'models/Task.dart';  // Đảm bảo rằng bạn có thư mục models trong dự án của mình
import 'views/task_item.dart';  // Đảm bảo rằng bạn có thư mục views trong dự án của mình
import 'views/add_edit_task_screen.dart';  // Đảm bảo rằng bạn có thư mục views trong dự án của mình

// ---------------------------- Provider ----------------------------
class TaskProvider extends ChangeNotifier {
  final List<Task> _tasks = [];
  String _searchQuery = '';
  String _filterStatus = 'Tất cả';
  String _currentUsername = ''; // Username của người dùng đang đăng nhập

  List<Task> get tasks {
    return _tasks.where((task) {
      final matchesQuery = task.title.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesStatus = _filterStatus == 'Tất cả' || task.status == _filterStatus;
      return matchesQuery && matchesStatus;
    }).toList();
  }

  String get filterStatus => _filterStatus;

  String get currentUsername => _currentUsername;

  bool get isAdmin => _currentUsername == 'admin';

  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners();
  }

  void updateTask(Task task) {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
      notifyListeners();
    }
  }

  void deleteTask(String id) {
    _tasks.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  void toggleComplete(Task task) {
    final updatedTask = Task(
      id: task.id,
      title: task.title,
      description: task.description,
      status: task.completed ? 'To do' : 'Done',
      priority: task.priority,
      dueDate: task.dueDate,
      createdAt: task.createdAt,
      updatedAt: DateTime.now(),
      assignedTo: task.assignedTo,
      attachments: task.attachments,
      category: task.category,
      completed: !task.completed,
    );
    updateTask(updatedTask);
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setFilterStatus(String status) {
    _filterStatus = status;
    notifyListeners();
  }

  // Thêm phương thức login và logout
  bool login(String username, String password) {
    if (username == 'admin' && password == '1234') {
      _currentUsername = 'admin';
      notifyListeners();
      return true;
    } else if (username == 'user' && password == '1234') {
      _currentUsername = 'user';
      notifyListeners();
      return true;
    }
    return false;
  }

  void logout() {
    _currentUsername = '';
    notifyListeners();
  }
}

// ---------------------------- App ----------------------------
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TaskProvider>(
      create: (_) => TaskProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Task Manager',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          useMaterial3: true,
        ),
        home: LoginScreen(),
      ),
    );
  }
}

// ---------------------------- Login Screen ----------------------------
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() {
    final provider = Provider.of<TaskProvider>(context, listen: false);

    if (provider.login(_usernameController.text, _passwordController.text)) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => TaskListScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sai tài khoản hoặc mật khẩu')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đăng nhập')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(controller: _usernameController, decoration: const InputDecoration(labelText: 'Tài khoản')),
            TextField(controller: _passwordController, decoration: const InputDecoration(labelText: 'Mật khẩu'), obscureText: true),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _login, child: const Text('Đăng nhập')),
          ],
        ),
      ),
    );
  }
}

// ---------------------------- Task List Screen ----------------------------
class TaskListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý công việc'),
        actions: [
          // Nút thêm công việc
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddEditTaskScreen(),
                ),
              );
            },
          ),
          // Nút đăng xuất
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              provider.logout(); // Đảm bảo đăng xuất
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => LoginScreen()), // Quay lại màn hình đăng nhập
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(labelText: 'Tìm kiếm...'),
              onChanged: provider.setSearchQuery,
            ),
          ),
          DropdownButton<String>(
            value: provider.filterStatus,
            onChanged: (value) => provider.setFilterStatus(value ?? 'Tất cả'),
            items: ['Tất cả', 'To do', 'In progress', 'Done']
                .map((status) => DropdownMenuItem(value: status, child: Text(status)))
                .toList(),
          ),
          Expanded(
            child: provider.tasks.isEmpty
                ? const Center(child: Text('Không có công việc nào.'))
                : ListView.builder(
              itemCount: provider.tasks.length,
              itemBuilder: (context, index) {
                final task = provider.tasks[index];
                return TaskItem(
                  task: task,
                  onEdit: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddEditTaskScreen(task: task),
                      ),
                    );
                  },
                  onDelete: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Xác nhận xóa'),
                        content: Text('Bạn có chắc muốn xóa "${task.title}"?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(),
                            child: const Text('Hủy'),
                          ),
                          TextButton(
                            onPressed: () {
                              provider.deleteTask(task.id);
                              Navigator.of(ctx).pop();
                            },
                            child: const Text('Xóa'),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
