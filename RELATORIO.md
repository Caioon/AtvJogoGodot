# Relatório do Projeto

## 1. As duas fases

**Fase 0 — Game.tscn:** O arquivo inicial que já existia. O jogador apenas deve ir até a porta aberta de uma casinha para ir para a primeira fase.

**Fase 1 — Winter:** o tema é uma área nevada com uma sessão de plataformas verticais. O jogador precisa subir pulando entre plataformas até alcançar o topo, onde uma casinha guarda a porta de transição para a próxima fase. Também existe um caminho alternativo à esquerda. Decisão de desenho: incluí esse caminho alternativo para dar uma opção de exploração além da rota óbvia de subida, evitando que a fase seja só um corredor vertical único.

**Fase 2 — Tropical:** o tema é uma área tropical com uma sessão de plataformas mais curta. O jogador pode seguir direto para a porta de saída ou dar a volta por cima para encontrar uma área secreta. Decisão de desenho: a rota secreta foi colocada como um desvio opcional em vez de obrigatório, para recompensar quem explora sem forçar todo mundo a passar por ela.

## 2. O parallax

Ajustei o `motion_scale` de cada camada testando valores e observando a sensação de profundidade durante o movimento horizontal. Camadas mais distantes (fundo) receberam valores próximos de 0.1–0.3, e camadas mais próximas do plano de jogo, valores mais altos, perto de 0.6–0.8, para acompanhar mais o movimento da câmera. Na primeira tentativa os valores estavam muito parecidos entre as camadas, o que fazia o fundo parecer "colado" ao cenário principal, sem sensação de distância. Na versão final, aumentei a diferença entre as camadas para reforçar a profundidade. Também ajustei verticalmente, na fase winter, aumentando o mirror para que o cenário ficasse aparente mesmo subindo nas plataformas.

## 3. A área secreta

A entrada da área secreta fica na Fase 2, acessível dando a volta por cima em vez de seguir direto para a porta. A pista é a visão parcial de algo do outro lado de uma parede que, inicialmente, o jogador não consegue alcançar. Separei pista e entrada em pontos diferentes do mapa de propósito: a pista desperta curiosidade antes mesmo de o jogador saber que existe um caminho até ali, criando uma pequena descoberta ao perceber depois como chegar até o que viu de longe.

## 4. A câmera

Optei por manter a Camera2D separada do player, como um nó próprio de cada mapa, em vez de deixá-la como filha do personagem. Isso permite ajustar os limites (`limit_left`, `limit_right`, `limit_top`, `limit_bottom`) de forma simples e específica para cada fase, sem depender do posicionamento do player. A alternativa (câmera filha do player) seria mais direta para seguir o personagem automaticamente, mas perderia esse controle fácil de limites por fase — eu precisaria reconfigurar ou trocar limites via código toda vez que a câmera devesse se comportar diferente em uma área específica, como fiz no túnel vertical.

## 5. A transição

A troca de fase não pode ser chamada diretamente dentro da função que detecta a colisão porque a lógica de trocar de cena precisa sobreviver ao momento em que a cena atual é destruída. Se colocarmos a chamada de troca de cena e ao mesmo tempo dependermos de dados (como para onde o jogador deve ir na cena seguinte) armazenados em um nó que faz parte da cena atual, esses dados são perdidos quando a cena é descarregada durante a troca. Por isso, usei um Autoload (`Transition`), que existe fora do ciclo de vida de qualquer fase específica: o colisor de transição apenas avisa esse Autoload sobre o destino e o ponto de spawn, e é o Autoload quem executa a troca de cena e mantém essa informação disponível para a fase seguinte usar assim que ela carregar.

## 6. O que travou

O momento mais difícil foi configurar a mudança dinâmica dos limites da câmera dentro do túnel vertical. Inicialmente, o script não funcionava e eu achei que o problema era o caminho até a Camera2D (`get_node("Camera2D")`), já que ela não era filha do player. Depois de mover a câmera e ainda assim não funcionar, usei prints para isolar o problema e percebi, pelo aviso do editor sobre um parâmetro não utilizado, que o sinal `body_exited` (e também o `body_entered`) tinha sido conectado por engano ao script do player, e não ao script da própria área de transição. A causa real era diferente da que eu tinha suposto de início: não era o caminho até o nó, era a conexão do sinal apontando para o nó errado. Descobri isso comparando o que o Output mostrava com o que eu esperava ver, o que revelou que a função estava sendo gerada no arquivo errado.
