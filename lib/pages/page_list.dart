import 'package:flutter/material.dart';
import 'package:lista_tarefas/models/tarefa.dart';
import 'package:lista_tarefas/respositories/lista_repository.dart';
import 'package:lista_tarefas/widgets/tarefa_list_item.dart';

class PageList extends StatefulWidget {
  const PageList({Key? key}) : super(key: key);

  @override
  State<PageList> createState() => _PageListState();
}

class _PageListState extends State<PageList> {
  final TextEditingController tarefasController = TextEditingController();
  final ListaRepository listaRepository = ListaRepository();

  List<Tarefa> Listtarefas = [];
  Tarefa? deletarTarefa;
  int? deletarTarefaPosicao;

  @override
  void initState() {
    super.initState();
    
    listaRepository.getListaTarefas().then((value) {
      setState(() {
        Listtarefas = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: tarefasController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Adicione uma tarefa",
                          hintText: "Estudar Flutter",
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        String text = tarefasController.text;
                        setState(() {
                          Tarefa newTarefa = Tarefa(
                            title: text,
                            dateTime: DateTime.now(),
                          );
                          Listtarefas.add(newTarefa);
                        });
                        tarefasController.clear();
                        listaRepository.saveListTarefas(Listtarefas);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: const Color(0xff00d7f3),
                        padding: const EdgeInsets.all(14),
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 30,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      for (Tarefa tarefa in Listtarefas)
                        TarefaListItem(
                          tarefa: tarefa,
                          onDelete: onDelete,
                        ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Você possui ${Listtarefas.length} tarefas pendentes",
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    ElevatedButton(
                      onPressed: showDeleteTarefasConfirmationDialog,
                      style: ElevatedButton.styleFrom(
                        primary: const Color(0xff00d7f3),
                        padding: const EdgeInsets.all(14),
                      ),
                      child: const Text("Limpar tudo"),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onDelete(Tarefa tarefa) {
    deletarTarefa = tarefa;
    deletarTarefaPosicao = Listtarefas.indexOf(tarefa);

    setState(() {
      Listtarefas.remove(tarefa);
    });
    listaRepository.saveListTarefas(Listtarefas);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Tarefa ${tarefa.title} foi removida com sucesso!",
          style: const TextStyle(
            color: Color(0xff060708),
          ),
        ),
        backgroundColor: Colors.white,
        action: SnackBarAction(
          label: "Desfazer",
          textColor: const Color(0xff00d7f3),
          onPressed: () {
            setState(() {
              Listtarefas.insert(deletarTarefaPosicao!, deletarTarefa!);
            });
            listaRepository.saveListTarefas(Listtarefas);
          },
        ),
      ),
    );
  }

  void showDeleteTarefasConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Limpar tudo?"),
        content: const Text("Você tem certeza que deseja apagar todas as tarefas?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(primary: const Color(0xff00d7f3),),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              deleteAllTarefas();
            },
            style: TextButton.styleFrom(primary: Colors.red,),
            child: const Text("Limpar Tudo"),
          ),
        ],
      ),
    );
  }

  void deleteAllTarefas(){
    setState(() {
      Listtarefas.clear();
    });
    listaRepository.saveListTarefas(Listtarefas);
  }
}
