import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Projeto Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.blue),
      ),
      home: const MyHomePage(title: 'Projeto Exemplo'),
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
  int _soma = 0;
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  void _calcularSoma() {
    setState(() {
      _soma = int.parse(_controller1.text) + int.parse(_controller2.text);
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
                labelText: 'Digite um número',
                hintText: 'um número',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20,),
            TextField(
              controller: _controller2,
              decoration: InputDecoration(
                labelText: 'Digite um número',
                hintText: 'um número',
                border: OutlineInputBorder(),
              ),
            ),
            Text('a soma é $_soma'),
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
