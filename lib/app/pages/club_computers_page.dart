import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/booking_model.dart';        // у вас Computer
import '../services/api_service.dart';
import '../services/auth_service.dart';

class ClubComputersPage extends StatefulWidget {
  final ComputerClub club;
  const ClubComputersPage({required this.club, Key? key}) : super(key: key);

  @override
  _ClubComputersPageState createState() => _ClubComputersPageState();
}

class _ClubComputersPageState extends State<ClubComputersPage> {
  List<Computer> _comps = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadComputers();
  }

  Future<void> _loadComputers() async {
    setState(() => _loading = true);
    try {
      final list = await ApiService.getClubComputers(widget.club.id);
      setState(() => _comps = list);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка загрузки ПК: $e')),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _addComputer() async {
    final auth = context.read<AuthService>();
    final token = await auth.getServerToken();
    if (!auth.isManager && !auth.isAdmin) return;
    // простой диалог для ввода номера и описания
    final form = GlobalKey<FormState>();
    int pcNumber = 0;
    String desc = '';
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Новый компьютер'),
        content: Form(
          key: form,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Номер ПК'),
              keyboardType: TextInputType.number,
              onSaved: (v) => pcNumber = int.tryParse(v ?? '') ?? 0,
              validator: (v) => (v==null||v.isEmpty) ? 'Укажите номер' : null,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Описание'),
              onSaved: (v) => desc = v ?? '',
            ),
          ]),
        ),
        actions: [
          TextButton(onPressed: ()=>Navigator.pop(context,false), child: const Text('Отмена')),
          TextButton(onPressed: (){
            if (form.currentState!.validate()){
              form.currentState!.save();
              Navigator.pop(context,true);
            }
          }, child: const Text('Добавить')),
        ],
      ),
    );
    if (ok == true && token != null) {
      try {
        final comp = Computer(
          id: '',
          clubId: widget.club.id,
          pcNumber: pcNumber,
          description: desc,
          isAvailable: true,
        );
        await ApiService.createComputers(
            widget.club.id, [comp], token);
        await _loadComputers();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка добавления ПК: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final canManage = context.watch<AuthService>().isAdmin
        || context.read<AuthService>().isManager;

    return Scaffold(
      appBar: AppBar(
        title: Text('ПК в ${widget.club.name}'),
        backgroundColor: Colors.black,
        actions: [
          if (canManage)
            IconButton(icon: const Icon(Icons.add), onPressed: _addComputer),
        ],
      ),
      backgroundColor: Colors.black,
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _comps.isEmpty
          ? const Center(child: Text('Нет компьютеров', style: TextStyle(color: Colors.white70)))
          : ListView.builder(
        itemCount: _comps.length,
        itemBuilder: (_, i) {
          final c = _comps[i];
          return ListTile(
            leading: Icon(Icons.computer, color: c.isAvailable ? Colors.green : Colors.red),
            title: Text('ПК #${c.pcNumber}', style: const TextStyle(color: Colors.white)),
            subtitle: Text(c.description, style: const TextStyle(color: Colors.white70)),
          );
        },
      ),
    );
  }
}
