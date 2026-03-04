import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../database/db_helper.dart';
import '../models/employee.dart';

class EmployeeListPage extends StatefulWidget {
  const EmployeeListPage({Key? key}) : super(key: key);

  @override
  State<EmployeeListPage> createState() => _EmployeeListPageState();
}

class _EmployeeListPageState extends State<EmployeeListPage> {
  List<Employee> _employees = [];
  bool _loading = true;

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _salaryController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameFocus = FocusNode();

  String _role = 'DRIVER';
  String _salaryType = 'Monthly';
  bool _obscurePassword = true;
  int? _editingId;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _salaryController.dispose();
    _passwordController.dispose();
    _nameFocus.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final list = await DBHelper.getEmployees();
    if (!mounted) return;
    setState(() {
      _employees = list;
      _loading = false;
    });
  }

  Future<void> _showForm([Employee? emp]) async {
    _editingId = emp?.id;
    _nameController.text = emp?.name ?? '';
    _phoneController.text = emp?.phone ?? '';
    _salaryController.text = emp?.salary != null && emp!.salary > 0
        ? emp.salary.toString()
        : '';
    _passwordController.clear();
    _role = emp?.role ?? 'DRIVER';
    _salaryType = emp?.salaryType ?? 'Monthly';
    _obscurePassword = true;

    Future.delayed(
      const Duration(milliseconds: 300),
      () => _nameFocus.requestFocus(),
    );

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text(_editingId == null ? 'Add Employee' : 'Edit Employee'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // show employee ID on edit
                if (_editingId != null) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Employee ID',
                          style: TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                        Text(
                          emp!.employeeId,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                TextField(
                  controller: _nameController,
                  focusNode: _nameFocus,
                  autofocus: false,
                  decoration: const InputDecoration(
                    labelText: 'Full name',
                    border: OutlineInputBorder(),
                  ),
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _role,
                  decoration: const InputDecoration(
                    labelText: 'Role',
                    border: OutlineInputBorder(),
                  ),
                  items: ['DRIVER', 'HELPER', 'DSR']
                      .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                      .toList(),
                  onChanged: (v) => setDialogState(() => _role = v!),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _salaryController,
                  decoration: const InputDecoration(
                    labelText: 'Salary',
                    border: OutlineInputBorder(),
                    prefixText: '৳ ',
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d+\.?\d{0,2}'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _salaryType,
                  decoration: const InputDecoration(
                    labelText: 'Salary type',
                    border: OutlineInputBorder(),
                  ),
                  items: ['Daily', 'Monthly']
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (v) => setDialogState(() => _salaryType = v!),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: _editingId == null
                        ? 'Password'
                        : 'New password (leave blank to keep)',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () => setDialogState(
                        () => _obscurePassword = !_obscurePassword,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => _save(ctx, emp),
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save(BuildContext ctx, Employee? existing) async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    // password: required on add, optional on edit
    final newPass = _passwordController.text.trim();
    if (_editingId == null && newPass.isEmpty) return;

    final employeeId = _editingId == null
        ? await DBHelper.generateEmployeeId()
        : existing!.employeeId;

    final password = (_editingId == null || newPass.isNotEmpty)
        ? newPass
        : existing!.password;

    final emp = Employee(
      id: _editingId,
      employeeId: employeeId,
      name: name,
      phone: _phoneController.text.trim(),
      role: _role,
      salary: double.tryParse(_salaryController.text.trim()) ?? 0.0,
      salaryType: _salaryType,
      password: password,
    );

    if (_editingId == null) {
      await DBHelper.insertEmployee(emp);
    } else {
      await DBHelper.updateEmployee(emp);
    }

    if (ctx.mounted) Navigator.pop(ctx);
    _load();
  }

  Future<void> _confirmDelete(Employee emp) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete employee?'),
        content: Text('Delete "${emp.name}"? This cannot be undone.'),
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
      await DBHelper.deleteEmployee(emp.id!);
      _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _employees.isEmpty
          ? const Center(child: Text('No employees yet. Tap + to add one.'))
          : ListView.separated(
              itemCount: _employees.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (ctx, i) {
                final e = _employees[i];
                return Dismissible(
                  key: ValueKey(e.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  confirmDismiss: (_) async {
                    await _confirmDelete(e);
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
                    title: Text(
                      e.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${e.employeeId}  •  ${e.role}  •  ৳${e.salary.toStringAsFixed(0)}/${e.salaryType}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      onPressed: () => _showForm(e),
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
