import 'package:flutter/material.dart';
import '../Model/NoteApp.dart';
import '../View/NoteItem.dart';
import '../api/NoteAPIService.dart';
import 'NoteForm.dart';
import '../Model/Account.dart';
import '../View/LoginScreen.dart';

class NoteListScreen extends StatefulWidget {
  final Account account;

  const NoteListScreen({super.key, required this.account});
  @override
  _NoteListScreenState createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  late Future<List<Note>> _notesFuture;
  List<Note> _notes = [];
  String _searchQuery = '';
  bool _isGridView = false;
  String _sortType = 'priority'; // or 'date'

  @override
  void initState() {
    super.initState();
    _refreshNotes();
  }

  Future<void> _refreshNotes() async {
    setState(() {
      _notesFuture = NoteAPIService.instance.getAllNotes();
    });
  }

  List<Note> _filterAndSortNotes(List<Note> notes) {
    List<Note> filtered = notes
        .where((note) =>
    note.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        note.content.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    if (_sortType == 'priority') {
      filtered.sort((a, b) => a.priority.compareTo(b.priority));
    } else {
      filtered.sort((a, b) => b.modifiedAt.compareTo(a.modifiedAt));
    }

    return filtered;
  }

  void _onCreateNote() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NoteForm(
          onSave: (newNote) async {
            print("📥 Đang lưu ghi chú mới...");
            await NoteAPIService.instance.createNote(newNote);
            print("✅ Đã lưu xong");
            return true;
          },
        ),
      ),
    );
    if (result == true) {
      print("🔁 Làm mới danh sách ghi chú");
      _refreshNotes();
    }
  }

  void _onEditNote(Note note) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NoteForm(
          note: note,
          onSave: (updatedNote) async {
            await NoteAPIService.instance.updateNote(updatedNote);
          },
        ),
      ),
    );
    if (result == true) _refreshNotes();
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Đăng xuất'),
        content: Text('Bạn có chắc chắn muốn đăng xuất không?'),
        actions: [
          TextButton(
            child: Text('Hủy'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: Text('Đăng xuất'),
            onPressed: () {
              Navigator.of(context).pop(); // Đóng dialog
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => LoginScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách ghi chú'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _refreshNotes,
          ),
          IconButton(
            icon: Icon(_isGridView ? Icons.list : Icons.grid_view),
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                _sortType = value;
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 'priority', child: Text('Sắp xếp theo độ ưu tiên')),
              PopupMenuItem(value: 'date', child: Text('Sắp xếp theo thời gian')),
            ],
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Tìm kiếm ghi chú...',
                fillColor: Colors.white,
                filled: true,
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<Note>>(
        future: _notesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Chưa có ghi chú nào'));
          } else {
            _notes = _filterAndSortNotes(snapshot.data!);
            if (_isGridView) {
              return GridView.builder(
                padding: EdgeInsets.all(8),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: _notes.length,
                itemBuilder: (context, index) {
                  final note = _notes[index];
                  return NoteItem(
                    note: note,
                    onDelete: () async {
                      await NoteAPIService.instance.deleteNote(note.id!);
                      _refreshNotes();
                    },
                    onEdit: () => _onEditNote(note),
                  );
                },
              );
            } else {
              return ListView.builder(
                itemCount: _notes.length,
                itemBuilder: (context, index) {
                  final note = _notes[index];
                  return NoteItem(
                    note: note,
                    onDelete: () async {
                      await NoteAPIService.instance.deleteNote(note.id!);
                      _refreshNotes();
                    },
                    onEdit: () => _onEditNote(note),
                  );
                },
              );
            }
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onCreateNote,
        child: Icon(Icons.add),
      ),
    );
  }
}
