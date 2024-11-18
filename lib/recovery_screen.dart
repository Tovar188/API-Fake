import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RecoveryScreen extends StatefulWidget {
  const RecoveryScreen({Key? key}) : super(key: key);

  @override
  _RecoveryScreenState createState() => _RecoveryScreenState();
}

class _RecoveryScreenState extends State<RecoveryScreen> {
  List<dynamic> photos = [];
  int currentIndex = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPhotos();
  }

  Future<void> fetchPhotos() async {
    final response = await http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/photos'));
    if (response.statusCode == 200) {
      setState(() {
        photos = json
            .decode(response.body)
            .take(10)
            .toList(); // Limitar a 10 elementos
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load photos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Fake'),
        backgroundColor: Colors.blue[800],
      ),
      body: Container(
        color: Colors.grey[100], // Fondo claro
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (photos.isNotEmpty)
                    Column(
                      children: [
                        // Imagen con borde redondeado
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: Image.network(
                            photos[currentIndex]['url'],
                            height: 200,
                            width: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Título estilizado
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            photos[currentIndex]['title'],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Botones estilizados
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Botón "Atrás"
                            if (currentIndex != 0)
                              ElevatedButton.icon(
                                onPressed: () {
                                  setState(() {
                                    currentIndex--;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue[800],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                ),
                                icon: const Icon(Icons.arrow_back, size: 16),
                                label: const Text(
                                  'Atrás',
                                  style: TextStyle(
                                      color: Colors.white), // Letra blanca
                                ),
                              ),

                            // Botón "Siguiente"
                            if (currentIndex != photos.length - 1)
                              ElevatedButton.icon(
                                onPressed: () {
                                  setState(() {
                                    currentIndex++;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue[800],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                ),
                                icon: const Icon(Icons.arrow_forward, size: 16),
                                label: const Text(
                                  'Siguiente',
                                  style: TextStyle(
                                      color: Colors.white), // Letra blanca
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                ],
              ),
      ),
    );
  }
}
