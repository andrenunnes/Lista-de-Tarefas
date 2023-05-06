import 'dart:convert';

import 'package:lista_tarefas/models/tarefa.dart';
import 'package:shared_preferences/shared_preferences.dart';

const listaTarefasKey = "lista_tarefas";

class ListaRepository{

  late SharedPreferences sharedPreferences;


  Future<List<Tarefa>> getListaTarefas() async {
    sharedPreferences = await SharedPreferences.getInstance();
    final String jsonString = sharedPreferences.getString(listaTarefasKey) ?? "[]";
    final List jsonDecoded = json.decode(jsonString) as List;
    return jsonDecoded.map((e) => Tarefa.fromJson(e)).toList();
  }

  void saveListTarefas(List<Tarefa> tarefas) {
    final jsonString = json.encode(tarefas);
    sharedPreferences.setString("lista_tarefas", jsonString);
  }
}