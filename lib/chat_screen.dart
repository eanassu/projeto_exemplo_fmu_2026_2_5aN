import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _mensagens = [];
  late final WebSocketChannel _channel;

  // Altere conforme o ambiente:
  // - 'ws://10.0.2.2:8080' para Emulador Android na mesma máquina do servidor
  // - 'ws://localhost:8080' para Windows, macOS, Linux ou Web
  // - 'ws://192.168.X.X:8080' para celulares físicos ou outras máquinas na rede
  final String _urlServidor = 'ws://10.180.60.73:3000';

  @override
  void initState() {
    super.initState();
    _channel = WebSocketChannel.connect(Uri.parse(_urlServidor));

    // Escuta o fluxo contínuo do servidor e adiciona cada mensagem na lista
    _channel.stream.listen(
      (mensagem) {
        setState(() {
          _mensagens.add(mensagem.toString());
        });
      },
      onError: (erro) {
        setState(() {
          _mensagens.add('Erro de conexão: $erro');
        });
      },
      onDone: () {
        setState(() {
          _mensagens.add('Conexão encerrada pelo servidor.');
        });
      },
    );
  }

  void _enviarMensagem() {
    final texto = _controller.text.trim();
    if (texto.isNotEmpty) {
      _channel.sink.add(texto);
      _controller.clear();
    }
  }

  @override
  void dispose() {
    _channel.sink.close();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat da Turma (WebSocket)'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _mensagens.length,
              itemBuilder: (context, index) {
                final msg = _mensagens[index];
                final isSistema = msg.startsWith('Sistema:');

                return Card(
                  color: isSistema ? Colors.amber.shade50 : null,
                  child: ListTile(
                    leading: Icon(
                      isSistema ? Icons.info_outline : Icons.chat_bubble_outline,
                    ),
                    title: Text(
                      msg,
                      style: TextStyle(
                        fontStyle: isSistema ? FontStyle.italic : FontStyle.normal,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Enviar mensagem para a turma...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _enviarMensagem(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: _enviarMensagem,
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}