import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:lista_tarefas/models/tarefa.dart';
import 'package:lista_tarefas/models/tarefa.dart';

class TarefaListItem extends StatelessWidget {
  const TarefaListItem({
    Key? key,
    required this.tarefa,
    required this.onDelete,
  }) : super(key: key);

  final Tarefa tarefa;
  final Function(Tarefa) onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Slidable(
        actionExtentRatio: 0.20,
        actionPane: const SlidableDrawerActionPane(),
        secondaryActions: [
          IconSlideAction(
            color: Colors.red,
            icon: Icons.delete,
            caption: "Deletar",
            onTap: () {
              onDelete(tarefa);
            },
          ),
          IconSlideAction(
            color: Colors.blue,
            icon: Icons.edit,
            caption: "Editar",
            onTap: () {},
          )
        ],
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Colors.grey[200],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                DateFormat("dd/MM/yyyy - HH:mm").format(tarefa.dateTime),
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
              Text(
                tarefa.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
