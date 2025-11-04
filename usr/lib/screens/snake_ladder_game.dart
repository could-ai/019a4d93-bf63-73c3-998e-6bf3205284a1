import 'package:flutter/material.dart';
import 'dart:math';

class SnakeAndLadderGame extends StatefulWidget {
  const SnakeAndLadderGame({Key? key}) : super(key: key);

  @override
  _SnakeAndLadderGameState createState() => _SnakeAndLadderGameState();
}

class _SnakeAndLadderGameState extends State<SnakeAndLadderGame> {
  // Define snake and ladder start/end positions
  final Map<int, int> snakes = {
    16: 6,
    47: 26,
    49: 11,
    56: 53,
    62: 19,
    64: 60,
    87: 24,
    93: 73,
    95: 75,
    98: 78,
  };

  final Map<int, int> ladders = {
    1: 38,
    4: 14,
    9: 31,
    21: 42,
    28: 84,
    36: 44,
    51: 67,
    71: 91,
    80: 100,
  };

  // Track positions for two players
  List<int> playerPositions = [0, 0];
  int currentPlayer = 0;
  int diceRoll = 0;
  final Random random = Random();

  // Roll dice and move player, then check for snakes/ladders and win condition
  void rollDice() {
    setState(() {
      diceRoll = random.nextInt(6) + 1;
      int newPos = playerPositions[currentPlayer] + diceRoll;
      if (newPos <= 100) {
        playerPositions[currentPlayer] = newPos;
        if (snakes.containsKey(newPos)) {
          playerPositions[currentPlayer] = snakes[newPos]!;
        } else if (ladders.containsKey(newPos)) {
          playerPositions[currentPlayer] = ladders[newPos]!;
        }
      }
      // Check win condition
      if (playerPositions[currentPlayer] == 100) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Player ${currentPlayer + 1} wins!'),
            actions: [
              TextButton(
                onPressed: () {
                  setState(() {
                    playerPositions = [0, 0];
                    currentPlayer = 0;
                    diceRoll = 0;
                  });
                  Navigator.of(context).pop();
                },
                child: const Text('Restart'),
              ),
            ],
          ),
        );
      } else {
        // Switch to next player
        currentPlayer = (currentPlayer + 1) % playerPositions.length;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Calculate board cell size based on screen width
    double boardSize = MediaQuery.of(context).size.width;
    double cellSize = boardSize / 10;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Snake and Ladder'),
      ),
      body: Column(
        children: [
          // Game board grid
          SizedBox(
            width: boardSize,
            height: boardSize,
            child: Stack(
              children: [
                // 10x10 numbered grid
                GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 100,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 10,
                  ),
                  itemBuilder: (context, index) {
                    int number = 100 - index;
                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12),
                      ),
                      child: Center(
                        child: Text(
                          '$number',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    );
                  },
                ),
                // Player tokens
                for (int i = 0; i < playerPositions.length; i++)
                  if (playerPositions[i] > 0)
                    Builder(builder: (context) {
                      int pos = playerPositions[i];
                      int gridIndex = 100 - pos;
                      int row = gridIndex ~/ 10;
                      int col = gridIndex % 10;
                      return Positioned(
                        top: row * cellSize,
                        left: col * cellSize + (i * 14),
                        child: CircleAvatar(
                          radius: cellSize / 4,
                          backgroundColor: i == 0 ? Colors.red : Colors.blue,
                          child: Text(
                            '${i + 1}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: cellSize / 4,
                            ),
                          ),
                        ),
                      );
                    }),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Display current player and last dice roll
          Text('Current Player: ${currentPlayer + 1}', style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 8),
          Text('Last Roll: $diceRoll', style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 8),
          // Roll dice button
          ElevatedButton(
            onPressed: rollDice,
            child: const Text('Roll Dice'),
          ),
        ],
      ),
    );
  }
}
