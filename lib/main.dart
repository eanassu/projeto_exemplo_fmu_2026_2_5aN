import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:projeto_exemplo/home_screen.dart';
import 'package:projeto_exemplo/tip_calculator.dart';


import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
    // Inicialização específica para diferentes plataformas
  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
    // O Sqflite por padrão vai usar o FFI para web se disponível
  } else if (defaultTargetPlatform == TargetPlatform.windows ||
             defaultTargetPlatform == TargetPlatform.linux ||
             defaultTargetPlatform == TargetPlatform.macOS) {
    // Para desktop, usamos sqflite_common_ffi
    sqfliteFfiInit(); // Inicializa o FFI para desktop
    databaseFactory = databaseFactoryFfi; // Define a factory para desktop
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Primeiro App Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.blue),
      ),
      home: const MyHomePage(title: 'Projeto Flutter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  int _soma = 0;

  void _calcularSoma() {
    setState(() {
      _soma = int.parse(_controller1.text)+int.parse(_controller2.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            TextField(
              controller: _controller1,
              decoration: InputDecoration(
                labelText: 'digite um número',
                hintText: 'Um número',
                border: OutlineInputBorder()
              )
              ,),
            SizedBox(height: 20),
            TextField(
              controller: _controller2,
              decoration: InputDecoration(
                labelText: 'digite um número',
                hintText: 'Um número',
                border: OutlineInputBorder()
              )
              ,),
              SizedBox(height: 20),
              Text(
                'a soma é $_soma',
                style: const TextStyle(fontSize:24, fontWeight: FontWeight.bold)
              ),
              ElevatedButton(
              onPressed: (){
                Navigator.push(context, 
                MaterialPageRoute(
                  builder: (context) => const TipCalculator()),
                );
              }, child: const Text('Calculadora de gorjeta')
            ),
            ElevatedButton(
              onPressed: () {
                // Navega para a Tela de Tarefas
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DatabaseHomeScreen()),
                );
              },
              child: const Text('Ir para Tarefas'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _calcularSoma,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}