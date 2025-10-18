import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Můj To-Do List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[50],
      ),
      home: const TodoPage(),
    );
  }
}

class TodoItem {
  String text;
  bool done;
  TodoItem({required this.text, this.done = false});
}

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final TextEditingController _controller = TextEditingController();
  final List<TodoItem> _items = [];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showSnackBar(String text, {Color? backgroundColor}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text), backgroundColor: backgroundColor),
    );
  }

  void _addTask() {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      _showSnackBar('Chyba: zadejte text úkolu', backgroundColor: Colors.red);
      return;
    }
    setState(() => _items.add(TodoItem(text: text)));
    _controller.clear();
    FocusScope.of(context).unfocus();
    _showSnackBar('Úkol přidán');
  }

  void _deleteTask(int index) {
    final removed = _items.removeAt(index);
    setState(() {});
    debugPrint('Deleted: ${removed.text}');
    _showSnackBar('Úkol smazán', backgroundColor: Colors.red);
  }

  void _toggleDone(int index, bool? value) {
    if (value == null) return;
    setState(() => _items[index].done = value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Můj To-Do List'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // vnější odsazení 16 px
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Můj To-Do List',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16), // mezera mezi nadpisem a odstavci
            const Text(
              'Jednoduchá aplikace pro správu úkolů. Přidejte úkol, označte jej jako splněný nebo jej smažte.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text(
              'Seznam je uložen pouze v paměti aplikace. Použijte pole níže pro zadání nového úkolu a tlačítko "Přidat".',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Zadejte nový úkol',
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    onSubmitted: (_) => _addTask(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(onPressed: _addTask, child: const Text('Přidat')),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _items.isEmpty
                  ? const Center(child: Text('Žádné úkoly. Přidejte první úkol.'))
                  : ListView.builder(
                      itemCount: _items.length,
                      itemBuilder: (context, index) {
                        final item = _items[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8.0), // mezera mezi řádky
                          child: Material(
                            borderRadius: BorderRadius.circular(8), // 8 px border radius
                            elevation: 1,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0), // vnitřní padding 12 px
                              child: Row(
                                children: [
                                  Checkbox(
                                    value: item.done,
                                    onChanged: (v) => _toggleDone(index, v),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      item.text,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: item.done ? Colors.grey : Colors.black,
                                        decoration: item.done
                                            ? TextDecoration.lineThrough
                                            : TextDecoration.none,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () => _deleteTask(index),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
