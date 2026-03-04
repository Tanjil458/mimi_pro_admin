import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/area.dart';

class AreaListPage extends StatefulWidget {
  const AreaListPage({Key? key}) : super(key: key);

  @override
  State<AreaListPage> createState() => _AreaListPageState();
}

class _AreaListPageState extends State<AreaListPage> {
  List<Area> _areas = [];
  bool _loading = true;
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  int? _editingId;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final list = await DBHelper.getAreas();
    if (mounted)
      setState(() {
        _areas = list;
        _loading = false;
      });
  }

  Future<void> _showForm([Area? area]) async {
    _editingId = area?.id;
    _controller.text = area?.name ?? '';

    // Wait for dialog to finish opening before showing the keyboard
    Future.delayed(const Duration(milliseconds: 300), () {
      _focusNode.requestFocus();
    });

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(_editingId == null ? 'Add Area' : 'Edit Area'),
        content: TextField(
          controller: _controller,
          focusNode: _focusNode,
          autofocus: false,
          decoration: const InputDecoration(
            labelText: 'Area name',
            border: OutlineInputBorder(),
          ),
          textCapitalization: TextCapitalization.words,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => _save(ctx),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _save(BuildContext ctx) async {
    final name = _controller.text.trim();
    if (name.isEmpty) return;
    if (_editingId == null) {
      await DBHelper.insertArea(Area(name: name));
    } else {
      await DBHelper.updateArea(Area(id: _editingId, name: name));
    }
    if (ctx.mounted) Navigator.pop(ctx);
    _load();
  }

  Future<void> _confirmDelete(Area area) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete area?'),
        content: Text('Delete "${area.name}"? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (ok == true) {
      await DBHelper.deleteArea(area.id!);
      _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _areas.isEmpty
          ? const Center(child: Text('No areas yet. Tap + to add one.'))
          : ListView.separated(
              itemCount: _areas.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (ctx, i) {
                final area = _areas[i];
                return Dismissible(
                  key: ValueKey(area.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  confirmDismiss: (_) async {
                    await _confirmDelete(area);
                    return false;
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 14,
                      child: Text(
                        '${i + 1}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    title: Text(area.name),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      onPressed: () => _showForm(area),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
