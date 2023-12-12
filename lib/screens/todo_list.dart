import 'dart:convert';

import 'package:flutter/material.dart';
//Import the page add_page.dart
import 'package:flutterapp_notes/screens/add_page.dart';
import 'package:http/http.dart' as http;

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  bool isLoading = true;
  List items = [];

  //Get all the elements when the page charge
  @override
  void initState() {
    super.initState();
    fetchTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),

      body: Visibility(
        visible: isLoading,
        child: Center(child: CircularProgressIndicator()),
        //RefreshIndicator
        replacement: RefreshIndicator(
            onRefresh: fetchTodo,
            child: Visibility(
              visible: items
                  .isNotEmpty, //if the items isnt empty, the listview is visible
              replacement: Center(
                child: Text(
                  'No hay elementos',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ), //else show the message
              //The ListView
              child: ListView.builder(
                itemCount: items.length,
                padding: EdgeInsets.all(8),
                itemBuilder: (context, index) {
                  final item = items[index] as Map;
                  final id = item['_id'];
                  return Card(
                      child: ListTile(
                    leading: CircleAvatar(child: Text('${index + 1}')),
                    title: Text(item['title']),
                    subtitle: Text(item['description']),
                    trailing: PopupMenuButton(onSelected: (value) {
                      //if the value is edit open Edit Page
                      if (value == 'edit') {
                        navigateToEditPage(item);
                      } else {
                        //Remove the item
                        deleteById(id);
                      }
                    }, itemBuilder: (context) {
                      //List of options
                      return [
                        const PopupMenuItem(
                            child: Text('Editar'), value: 'edit'),
                        const PopupMenuItem(
                            child: Text('Borrar'), value: 'delete'),
                      ];
                    }),
                  ));
                },
              ),
            )),
      ),

      //Button for navigate to another page
      floatingActionButton: FloatingActionButton.extended(
        onPressed: navigateToAddPage,
        label: const Text('Agregar'),
      ),
    );
  }

  //Method Navigate to another page , in this case for edit
  Future<void> navigateToEditPage(Map item) async {
    final route = MaterialPageRoute(
      builder: (context) => AddTodoPage(todo: item),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  //Method Navigate to another page
  Future<void> navigateToAddPage() async {
    final route = MaterialPageRoute(
      builder: (context) => const AddTodoPage(),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  //get the todoList
  Future<void> fetchTodo() async {
    const url = 'https://api.nstack.in/v1/todos?page=1&limit=10';

    final uri = Uri.parse(url);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json['items'] as List;
      setState(() {
        //Add the result to the array items, or List
        items = result;
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  //Function for delete by id
  Future<void> deleteById(String id) async {
    final url = 'https://api.nstack.in/v1/todos/$id';

    final uri = Uri.parse(url);
    final response = await http.delete(uri);

    if (response.statusCode == 200) {
      //Remove item succesfuly
      //Search the elements and show
      final filtered = items.where((element) => element['_id'] != id).toList();
      setState(() {
        items = filtered;
      });
    } else {
      //Show error message
      showErrorMessage('Error al borrar');
    }
  }

  //The other method that shows the Error message
  void showErrorMessage(String message) {
    final snackBar = SnackBar(
      content: Text(message, style: const TextStyle(color: Colors.white)),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
