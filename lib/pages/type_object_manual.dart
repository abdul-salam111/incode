import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:in_code/config/config.dart';

class Attribute {
  final int id;
  final String description;
  final int type;
  final bool required;
  final List<String> defaultValues;

  Attribute({
    required this.id,
    required this.description,
    required this.type,
    required this.required,
    required this.defaultValues,
  });

  factory Attribute.fromJson(Map<String, dynamic> json) {
    return Attribute(
      id: json['id_attribute'],
      description: json['description_attribute'],
      type: json['type_attribute'],
      required: json['required'],
      defaultValues: List<String>.from(json['default_values'] ?? []),
    );
  }
}

class TypeObject {
  final int id;
  final String description;
  final List<Attribute> attributes;

  TypeObject({
    required this.id,
    required this.description,
    required this.attributes,
  });

  factory TypeObject.fromJson(Map<String, dynamic> json) {
    return TypeObject(
      id: json['id_type_object'],
      description: json['description_type_object'],
      attributes: (json['attributes'] as List)
          .map((a) => Attribute.fromJson(a))
          .toList(),
    );
  }
}

class TypeObjectScreen extends StatefulWidget {
  final String codeObject;
  const TypeObjectScreen({required this.codeObject, super.key});

  @override
  State<TypeObjectScreen> createState() => _TypeObjectScreenState();
}

class _TypeObjectScreenState extends State<TypeObjectScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<TypeObject> typeObjects = [];
  TypeObject? selectedObject;
  final Map<String, dynamic> fieldValues = {};
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadTypeObjects();
  }

  Future<void> loadTypeObjects() async {
    final idUser = box.read('id_user');
    final version = 2;

    if (idUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Utente non loggato.")),
      );
      return;
    }

    try {
      final res = await http.post(
        Uri.parse('http://www.in-code.cloud:8888/api/1/type_object'),
        body: {
          'id_user': idUser.toString(),
          'version': version.toString(),
        },
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as List;
        final objects = data.map((item) => TypeObject.fromJson(item)).toList();
        setState(() {
          typeObjects = objects;
          loading = false;
          selectedObject = null;
          fieldValues.clear();
        });
      } else {
        throw Exception("Errore risposta ${res.statusCode}");
      }
    } on SocketException {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nessuna connessione a Internet.")),
      );
    } catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Errore: ${e.toString()}")),
      );
    }
  }

  Widget buildField(Attribute attr) {
    if (attr.defaultValues.isNotEmpty) {
      return DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: attr.description,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
          ),
        ),
        items: attr.defaultValues
            .map((v) => DropdownMenuItem(
                  value: v,
                  child: Text(v),
                ))
            .toList(),
        onChanged: (val) => fieldValues[attr.description] = val,
        validator: (val) =>
            attr.required && (val == null || val.trim().isEmpty)
                ? 'Campo obbligatorio'
                : null,
      );
    }

    return TextFormField(
      decoration: InputDecoration(
        labelText: attr.description,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
        ),
      ),
      validator: (val) =>
          attr.required && (val == null || val.trim().isEmpty)
              ? 'Campo obbligatorio'
              : null,
      onChanged: (val) => fieldValues[attr.description] = val,
    );
  }

  Future<void> submitData() async {
    if (!_formKey.currentState!.validate()) return;

    final idUser = box.read('id_user');
    final version = 2;

    if (idUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Utente non valido.")),
      );
      return;
    }

    final res = await http.post(
      Uri.parse('http://www.in-code.cloud:8888/api/1/object/set'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'version': version,
        'id_user': idUser,
        'code_object': widget.codeObject,
        'details_object': fieldValues,
      }),
    );

    if (res.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Oggetto salvato con successo!")),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Errore: ${res.statusCode}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 94,
                  color: const Color(0xFFC61323),
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Text(
                    'Tipo oggetto',
                    style: GoogleFonts.roboto(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                if (typeObjects.isEmpty)
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.warning, color: Colors.red[400], size: 40),
                          const SizedBox(height: 8),
                          Text(
                            'Nessun tipo oggetto configurato.',
                            style: GoogleFonts.roboto(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          DropdownButtonFormField<TypeObject>(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                                borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
                              ),
                            ),
                            hint: Text(
                              'Seleziona tipo di oggetto',
                              style: GoogleFonts.roboto(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF010101),
                              ),
                            ),
                            value: selectedObject,
                            items: typeObjects.map((obj) {
                              return DropdownMenuItem(
                                value: obj,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      obj.description,
                                      style: GoogleFonts.roboto(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xFF010101),
                                      ),
                                    ),
                                    const Divider(height: 1, color: Color(0xFFE5E5E5)),
                                  ],
                                ),
                              );
                            }).toList(),
                            onChanged: (val) {
                              setState(() {
                                selectedObject = val;
                                fieldValues.clear();
                              });
                            },
                          ),
                          const SizedBox(height: 20),
                          if (selectedObject != null)
                            Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  ...selectedObject!.attributes.map(buildField).toList(),
                                  const SizedBox(height: 20),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 47,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFFC61323),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                      onPressed: submitData,
                                      child: Text(
                                        "Conferma",
                                        style: GoogleFonts.roboto(
                                          fontSize: 18,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}
