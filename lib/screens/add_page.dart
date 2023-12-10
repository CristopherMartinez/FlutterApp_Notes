import 'dart:convert';

import 'package:flutter/material.dart';

//For create using (stf) and wait the autocomplete
//We need use a package HTTP for send the data to the server,in the file pubspec.yaml we need to add
import 'package:http/http.dart' as http;

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({super.key});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController titleController =
      TextEditingController(); //For get the title
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //The appbar (top)
      appBar: AppBar(
        title: const Text('Add Todo'),
      ),

      //The body of the page add_page
      body: ListView(
        padding: const EdgeInsets.all(20), //For center the ListView
        children: [
          //Inputs
          //Textfiel Title
          TextField(
              controller: titleController,
              decoration: const InputDecoration(hintText: 'Titulo')),
          const SizedBox(
              height:
                  20), //Create a space between the textfiel and the other textfiel
          //Textfiel Description
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(hintText: 'Descripción'),
            keyboardType:
                TextInputType.multiline, //For the type of the texfield, entry
            minLines: 5,
            maxLines: 8,
          ),
          const SizedBox(height: 20), //Create a space
          //Button (end)
          ElevatedButton(
            onPressed: submitData, //Call the method for submit the data
            child: const Text('Enviar'),
          )
        ],
      ),
    );
  }

  //Submit the data of the form
  Future<void> submitData() async {
    //First get the data from the form
    final title = titleController.text;
    final description = descriptionController.text;

    //This is a Json that we can use to send to the server
    final body = {
      "title": title,
      "description": description,
      "is_completed": false
    };

    //Second submit data to the server
    //The url
    const url = "https://api.nstack.in/v1/todos";

    final uri = Uri.parse(url);
    //The response    //Send the json, uri, and the headers
    final response = await http.post(uri,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});

    //After submit show success or fail message based on the status

    if (response.statusCode == 201) {
      //Success
      //Put the texfields empty
      titleController.text = '';
      descriptionController.text = '';
      showSuccesMessage('Creado correctamente');
    } else {
      //Fail
      showErrorMessage('Error al enviar');
    }
  }

  //Create a method that shows the success message, with the message in the parameter
  void showSuccesMessage(String message) {
    final snackbar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
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
