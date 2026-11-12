const WebSocket = require('ws');
const os = require('os');

const PORT = 3000;
const wss = new WebSocket.Server({ port: PORT });

let contadorAlunos = 0;

wss.on('connection', (ws) => {
  contadorAlunos++;
  const idAluno = `Aluno #${contadorAlunos}`;
  console.log(`[+] ${idAluno} entrou na sala. (Ativos: ${wss.clients.size})`);

  // Envia mensagem de boas-vindas apenas para quem acabou de conectar
  ws.send(`Sistema: Bem-vindo! Você foi identificado como ${idAluno}`);

  // Avisa todos os outros alunos que alguém entrou
  broadcast(`Sistema: ${idAluno} entrou no chat!`, ws);

  // Escuta mensagens enviadas por este aluno
  ws.on('message', (dados) => {
    // No pacote 'ws', a mensagem chega como Buffer; convertemos para String
    const texto = dados.toString('utf-8');
    console.log(`[Mensagem de ${idAluno}]: ${texto}`);

    // Faz o broadcast para TODOS os clientes conectados (inclusive quem enviou)
    broadcast(`${idAluno}: ${texto}`);
  });

  ws.on('close', () => {
    console.log(`[-] ${idAluno} saiu. (Ativos: ${wss.clients.size})`);
    broadcast(`Sistema: ${idAluno} saiu da sala.`);
  });
});

// Função que percorre todos os clientes conectados e envia a mensagem
function broadcast(mensagem, ignorarCliente = null) {
  wss.clients.forEach((cliente) => {
    if (cliente !== ignorarCliente && cliente.readyState === WebSocket.OPEN) {
      cliente.send(mensagem);
    }
  });
}

// Utilitário para mostrar o IP local da máquina do professor no terminal
function obterIpLocal() {
  const interfaces = os.networkInterfaces();
  for (const nome of Object.keys(interfaces)) {
    for (const iface of interfaces[nome]) {
      if (iface.family === 'IPv4' && !iface.internal) {
        return iface.address;
      }
    }
  }
  return 'localhost';
}

console.log('====================================================');
console.log(`Servidor WebSocket rodando na porta ${PORT}!`);
console.log(`- Na mesma máquina (Web/Desktop): ws://localhost:${PORT}`);
console.log(`- No Emulador Android:            ws://10.0.2.2:${PORT}`);
console.log(`- Na Rede Local (Celulares):      ws://${obterIpLocal()}:${PORT}`);
console.log('====================================================');