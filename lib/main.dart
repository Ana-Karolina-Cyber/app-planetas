import 'package:flutter/material.dart';
import 'package:myapp/telas/tela_planeta.dart';
import 'controles/controle_planeta.dart';
import 'modelos/planeta.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Planetas',
      
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 150, 27, 27)),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,

      home: const MyHomePage(title: 'App - Planetas',),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Planeta> _planetas = [];
  final ControlePlaneta _controlePlaneta = ControlePlaneta();

  @override
  void initState() {
    super.initState();
    _lerPlanetas();
  }

  Future<void> _lerPlanetas() async {
    final resultado = await _controlePlaneta.lerPlaneta();
    setState(() {
      _planetas = resultado;
    });
  }

  void _incluirPlaneta(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => TelaPlaneta(
              planeta: Planeta.empty(),
              onFinalizado: () {
                _lerPlanetas();
              },
            ),
      ),
    );
  }

  void _excluirPlaneta(int id) async {
    await _controlePlaneta.excluirPlaneta(id);
    _lerPlanetas();
  }

  void _alterarPlaneta(BuildContext context, Planeta planeta) {
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => TelaPlaneta(
              planeta: planeta,
              onFinalizado: () {
                _lerPlanetas();
              },
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: ListView.builder(
        itemCount: _planetas.length,
        itemBuilder: (context, index) {
          final planeta = _planetas[index];
          return ListTile(
            title: Text(planeta.nome),
            subtitle: Text(planeta.apelido),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () => _alterarPlaneta(context, planeta),
                  icon: const Icon(Icons.edit),
                ),
                IconButton(
                  onPressed: () => _excluirPlaneta(planeta.id!),
                  icon: const Icon(Icons.delete),
                ),
              ],
            ),
          );
        },
            ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _incluirPlaneta(context);
        },
        tooltip: 'Adicionar Planeta',
        child: const Icon(Icons.add),
      ),
    );
  }
}