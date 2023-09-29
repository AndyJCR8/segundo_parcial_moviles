import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'dart:async';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
    theme: ThemeData.dark(useMaterial3: true),
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
        theme: ThemeData.dark(useMaterial3: true),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(
              title: const Text('Listado de pendientes'),
              backgroundColor: const Color.fromARGB(255, 64, 62, 82),
            ),
            body: Center(
                child: Column(children: <Widget>[
              Center(
                  child: Column(
                children: [
                  const Text(""),
                  ElevatedButton(
                    onPressed: () {
                      // _createModal(context);
                      registroModal(context, "Datos de nuevo pendiente", -1,
                          true, '', '', '');
                    },
                    child: SizedBox(
                        width: 135,
                        child: Row(
                          children: [
                            Icon(MdiIcons.plus),
                            const Text("Nuevo pendiente"),
                          ],
                        )),
                  ),
                  const Text(""),
                ],
              )),
              Expanded(
                  child: StreamBuilder(
                      stream: _streamController.stream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<Record>? recs = snapshot.data;
                          return ListView.builder(
                            itemCount: recs?.length,
                            itemBuilder: (context, index) {
                              return Card(
                                  child: ListTile(
                                leading: Icon(MdiIcons.check),
                                title: Text('${recs?[index].title}'),
                                subtitle: Text(
                                    '${recs?[index].description} - ${recs?[index].state}'),
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
                                        icon: Icon(MdiIcons.pencil)),
                                    IconButton(
                                        onPressed: () {
                                          records.removeAt(index);
                                          _streamController.add(records);
                                        },
                                        icon: Icon(MdiIcons.trashCan)),
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
                              ));
                            },
                          );
                        } else {
                          // return CircularProgressIndicator();
                          return const Text("Sin datos");
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
          content: SingleChildScrollView(
            child: Column(children: [
              const Text(""),
              TextFormField(
                enabled: allowedit,
                style: const TextStyle(
                  color: Colors
                      .white, // Establece el color del texto cuando está deshabilitado
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
                      .white, // Establece el color del texto cuando está deshabilitado
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
                      .white, // Establece el color del texto cuando está deshabilitado
                ),
                initialValue: state,
                decoration: const InputDecoration(labelText: 'Estado'),
                keyboardType: TextInputType.text,
                onChanged: (value) {
                  state = value;
                },
              ),
            ]),
          ),
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
