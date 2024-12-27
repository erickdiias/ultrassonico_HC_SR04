# Módulo de Controle para Sensor Ultrassônico HC-SR04 🚀

Este projeto implementa, em VHDL, um módulo para controlar o sensor ultrassônico **HC-SR04**, ideal para medir distâncias com precisão. Ele também inclui uma integração com LEDs para indicar os resultados de forma visual.

---

## 🗂️ Arquivos do Projeto

### HC_SR04.vhd
Este é o módulo principal que controla o sensor HC-SR04. Ele:
- Gera o pulso de disparo (**trigger**) para iniciar a medição.
- Mede o tempo do pulso de resposta (**echo**) para calcular a distância.
- Sinaliza quando a medição é concluída ou se ocorreu um timeout.
- Utiliza uma máquina de estados para organizar as etapas do processo.

### top.vhd
Este módulo demonstra como usar o **HC_SR04** em um sistema integrado. Ele:
- Controla LEDs para indicar visualmente a distância medida.
- Configura medições periódicas usando um contador baseado no clock do FPGA.
- Serve como um exemplo prático para integrar o sensor em projetos maiores.

---

## 🎯 Funcionalidades

- **Medição precisa de distância:** Utiliza o HC-SR04 para medir com confiabilidade.
- **Indicação visual com LEDs:** Os LEDs acendem dependendo da distância detectada.
- **Sinal de timeout:** Indica quando a medição está fora do alcance do sensor.
- **Estrutura modular:** Fácil de adaptar e reutilizar em diferentes aplicações.

---

## 💡 Possíveis Aplicações

- **Robótica:** Detecção de obstáculos e navegação autônoma.
- **Automação:** Controle de dispositivos com base em proximidade.
- **Ensino:** Projetos educacionais envolvendo sistemas embarcados e VHDL.

---

## ⚙️ O Que Você Precisa

### Hardware:
- Um FPGA ou dispositivo que suporte VHDL.
- O sensor ultrassônico HC-SR04.
- LEDs para indicar visualmente a distância.

### Software:
- Simulador ou ferramenta de síntese VHDL (como ModelSim ou Quartus).
- Configuração de clock de 50 MHz para o sensor.

---

## 🚀 Como Usar

1. **Conecte o Sensor:** Ligue o HC-SR04 ao FPGA, conectando os pinos de Trigger e Echo corretamente.
2. **Configure o Módulo:** Instancie o **HC_SR04** no seu projeto e ajuste os parâmetros como timeout e frequência do clock.
3. **Teste com LEDs:** Use o módulo **top.vhd** como referência para acender LEDs com base na distância medida.
4. **Simule ou Implemente:** Execute uma simulação para verificar o funcionamento ou implemente diretamente no FPGA.

---

## 🔧 Personalize

- **Parâmetros Ajustáveis:** Configure a frequência do clock e o tempo de timeout conforme necessário.
- **Expansão do Sistema:** Integre com outros dispositivos, como displays ou sistemas de controle, para funcionalidades extras.

---

## 🖍️ Licença

Este projeto é distribuído sob a licença MIT. Consulte o arquivo `LICENSE` para mais informações.

---

