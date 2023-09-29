import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class Record {
  String title;
  String description;
  String state;

  Record({required this.title, required this.description, required this.state});
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Record> records = [];

  final StreamController<List<Record>> _streamController =
      StreamController<List<Record>>();

  @override
  void dispose() {
    // Cerrar el controlador del flujo cuando el widget se elimina
    _streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: Text('Pendientes'),
            ),
            body: Center(
                child: Column(children: <Widget>[
              Center(
                child: ElevatedButton(
                    onPressed: () {
                      // _createModal(context);
                      registroModal(context, "Datos de nuevo pendiente", -1,
                          true, '', '', '');
                    },
                    child: const Text("Crear pendiente")),
              ),
              Expanded(
                  child: StreamBuilder(
                      stream: _streamController.stream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<Record>? regs = snapshot.data;
                          return ListView.builder(
                            itemCount: regs?.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text('Dato: ${regs?[index].title}'),
                                subtitle:
                                    Text('Número: ${regs?[index].description}'),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          registroModal(
                                              context,
                                              'Edición de Registro',
                                              index,
                                              true,
                                              records[index].title,
                                              records[index].description,
                                              records[index].state);
                                        },
                                        icon: const Icon(Icons.edit)),
                                    IconButton(
                                        onPressed: () {
                                          records.removeAt(index);
                                          _streamController.add(records);
                                        },
                                        icon: const Icon(Icons.delete)),
                                  ],
                                ),
                                onTap: () {
                                  registroModal(
                                      context,
                                      'Detalles del Registro',
                                      -1,
                                      false,
                                      records[index].title,
                                      records[index].description,
                                      records[index].state);
                                },
                              );
                            },
                          );
                        } else {
                          // return CircularProgressIndicator();
                          return Text("Sin datos");
                        }
                      }))
            ]))));
  }

  // '', 0, null

  void registroModal(BuildContext context, String sub, int index,
      bool allowedit, String title, String description, String state) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(sub),
          ),
          content: Column(children: [
            const Text(""),
            TextFormField(
              enabled: allowedit,
              style: const TextStyle(
                color: Colors
                    .black, // Establece el color del texto cuando está deshabilitado
              ),
              initialValue: title,
              decoration: const InputDecoration(labelText: 'Titulo'),
              onChanged: (value) {
                title = value;
              },
            ),
            TextFormField(
              enabled: allowedit,
              style: const TextStyle(
                color: Colors
                    .black, // Establece el color del texto cuando está deshabilitado
              ),
              initialValue: description,
              decoration: const InputDecoration(labelText: 'Descripción'),
              keyboardType: TextInputType.text,
              onChanged: (value) {
                description = value;
              },
            ),
            TextFormField(
              enabled: allowedit,
              style: const TextStyle(
                color: Colors
                    .black, // Establece el color del texto cuando está deshabilitado
              ),
              initialValue: state,
              decoration: const InputDecoration(labelText: 'Estado'),
              keyboardType: TextInputType.text,
              onChanged: (value) {
                state = value;
              },
            ),
          ]),
          actions: <Widget>[
            Visibility(
              visible: allowedit,
              child: TextButton(
                onPressed: () {
                  if (title.isNotEmpty &&
                      description.isNotEmpty &&
                      state.isNotEmpty) {
                    if (index <= -1) {
                      records.add(Record(
                          title: title,
                          description: description,
                          state: state));
                    } else {
                      records[index] = Record(
                          title: title, description: description, state: state);
                    }

                    _streamController.add(records);
                    Navigator.of(context).pop();
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Error'),
                          content:
                              const Text("Por favor, complete todos los datos"),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Cerrar'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: const Text('Guardar'),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }
}
