import 'package:flutter/material.dart';
import 'package:myapp/controles/controle_planeta.dart';
import '../modelos/planeta.dart';

class TelaPlaneta extends StatefulWidget {
  final Function() onFinalizado;
  final Planeta planeta;

  const TelaPlaneta({
    super.key,
    required this.onFinalizado,
    required this.planeta,
  });

  @override
  State<TelaPlaneta> createState() => _TelaPlanetaState();
}

class _TelaPlanetaState extends State<TelaPlaneta> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _tamanhoController = TextEditingController();
  final TextEditingController _distanciaController = TextEditingController();
  final TextEditingController _apelidoController = TextEditingController();
  final ControlePlaneta _controlePlaneta = ControlePlaneta();

  late Planeta _planeta;

  //   // liberar os recursos da memoria
  @override
  void dispose() {
    _nameController.dispose();
    _apelidoController.dispose();
    _tamanhoController.dispose();
    _distanciaController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _planeta = widget.planeta;
    _nameController.text = _planeta.nome;
    _tamanhoController.text = _planeta.tamanho.toString();
    _distanciaController.text = _planeta.distancia.toString();
    _apelidoController.text = _planeta.apelido;
    super.initState();
  }

  Future<void> _inserirPlaneta() async {
    await _controlePlaneta.inserirPlaneta(_planeta);
  }

  Future<void> _alterarPlaneta() async {
    await _controlePlaneta.alterarPlaneta(_planeta);
  }

  void _enviarForm() {
    _formKey.currentState!.save();
    int? id = _planeta.id;
    if (id == null) {
      _inserirPlaneta();
    } else {
      _alterarPlaneta();
    }

    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Dados do planeta foram ${id == null ? 'incluidos' : 'alterados'} com sucesso',
          ),
        ),
      );
    }
    Navigator.pop(context);
    widget.onFinalizado();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _planeta.id == null ? 'Cadastrar Planeta' : 'Alterar Planeta',
        ),
        centerTitle: true,
        elevation: 5,
        backgroundColor: const Color.fromARGB(255, 159, 28, 28),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Form(
          key: _formKey,

          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nome',
                    border: OutlineInputBorder(),
                  ),
                  onSaved: (value) {
                    _planeta.nome = value!;
                  },

                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, informe o nome do planeta.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),

                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _tamanhoController,
                  decoration: const InputDecoration(
                    labelText: 'Tamanho (em km)',
                    border: OutlineInputBorder(),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty ) {
                      return 'Por favor, informe o tamanho do planeta.';
                    }
                    if (double.tryParse(value) == null && double.tryParse(value)! <= 0) {
                      return 'Por favor, informe um valor válido para o tamanho do planeta.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _planeta.tamanho = double.parse(value!);
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _distanciaController,
                  decoration: const InputDecoration(
                    labelText: 'Distância (em km)',
                    border: OutlineInputBorder(),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, informe a distancia do planeta.';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Por favor, informe um valor válido para a distancia do planeta.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _planeta.distancia = double.parse(value!);
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: _apelidoController,
                  decoration: const InputDecoration(
                    labelText: 'Apelido',
                    border: OutlineInputBorder(),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, informe o apelido do planeta.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _planeta.apelido = value!;
                  },
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _enviarForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 173, 29, 29),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Salvar'),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 181, 20, 20),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Cancelar'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}