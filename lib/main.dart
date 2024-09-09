import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
    debugShowCheckedModeBanner: false,
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int currentPlayer = 1; // Tracks the current player (1 to 4)
  int n1 = 1, n2 = 1, n3 = 1, n4 = 1; // Dice values for each player
  int score1 = 0, score2 = 0, score3 = 0, score4 = 0; // Scores for each player
  bool player1Active = true; // Tracks if Player 1 is active
  bool player2Active = false; // Tracks if Player 2 is active
  bool player3Active = false; // Tracks if Player 3 is active
  bool player4Active = false; // Tracks if Player 4 is active
  bool player1Finished = false; // Tracks if Player 1 has finished their turn
  bool player2Finished = false; // Tracks if Player 2 has finished their turn
  bool player3Finished = false; // Tracks if Player 3 has finished their turn
  bool player4Finished = false; // Tracks if Player 4 has finished their turn

  void rollDice() {
    setState(() {
      int roll = Random().nextInt(6) + 1; // Generate a random number between 1 and 6
      switch (currentPlayer) {
        case 1:
          n1 = roll;
          score1 += roll;
          if (roll == 6) {
            // If the roll is 6, keep the turn for the same player
          } else {
            // If not 6, move to the next player
            player1Active = false;
            player1Finished = true;
            currentPlayer = 2;
            player2Active = true;
          }
          break;
        case 2:
          n2 = roll;
          score2 += roll;
          if (roll == 6) {
            // If the roll is 6, keep the turn for the same player
          } else {
            // If not 6, move to the next player
            player2Active = false;
            player2Finished = true;
            currentPlayer = 3;
            player3Active = true;
          }
          break;
        case 3:
          n3 = roll;
          score3 += roll;
          if (roll == 6) {
            // If the roll is 6, keep the turn for the same player
          } else {
            // If not 6, move to the next player
            player3Active = false;
            player3Finished = true;
            currentPlayer = 4;
            player4Active = true;
          }
          break;
        case 4:
          n4 = roll;
          score4 += roll;
          if (roll == 6) {
            // If the roll is 6, keep the turn for the same player
          } else {
            // If not 6, move to the next player
            player4Active = false;
            player4Finished = true;
            if (player1Finished && player2Finished && player3Finished && player4Finished) {
              // If all players have finished their turns, show results
              checkGameFinished();
            } else {
              currentPlayer = 1;
              player1Active = true;
            }
          }
          break;
      }
    });
  }

  void checkGameFinished() {
    Future.delayed(Duration(seconds: 2), () {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Game Finished'),
            content: Text('All players have completed their turn!'),
          );
        },
      );

      Future.delayed(Duration(seconds: 5), () {
        Navigator.of(context).pop();
        showHighestScore();
      });
    });
  }

  void showHighestScore() {
    int highestScore = max(max(score1, score2), max(score3, score4));
    List<String> tiedPlayers = [];

    if (score1 == highestScore) tiedPlayers.add("Player 1");
    if (score2 == highestScore) tiedPlayers.add("Player 2");
    if (score3 == highestScore) tiedPlayers.add("Player 3");
    if (score4 == highestScore) tiedPlayers.add("Player 4");

    String message;
    if (tiedPlayers.length == 4) {
      message = "All players have the same score! Please play again to get a result.";
    } else {
      message = '${tiedPlayers.join(", ")} have the highest score of $highestScore!';
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Game Result'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                resetGame();
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void resetGame() {
    setState(() {
      currentPlayer = 1;
      n1 = n2 = n3 = n4 = 1;
      score1 = score2 = score3 = score4 = 0;
      player1Active = true;
      player2Active = false;
      player3Active = false;
      player4Active = false;
      player1Finished = false;
      player2Finished = false;
      player3Finished = false;
      player4Finished = false;
    });
  }

  Color getPlayerColor(int player) {
    switch (player) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.blue;
      case 3:
        return Colors.green;
      case 4:
        return Colors.yellow;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ludo Dice Game',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome Players',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 36,
              ),
            ),
            SizedBox(height: 70),
            // Display scores (top two players) above their respective dice
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: player1Active ? rollDice : null,
                        child: Text('Roll Dice'),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Player 1 Score: $score1',
                        textAlign: TextAlign.center,
                      ),
                      Container(
                        color: player1Active ? Colors.orange : getPlayerColor(1),
                        child: Image(
                          image: AssetImage('assets/Img/dice$n1.png'),
                          width: 120,
                          height: 120,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: player2Active ? rollDice : null,
                        child: Text('Roll Dice'),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Player 2 Score: $score2',
                        textAlign: TextAlign.center,
                      ),
                      Container(
                        color: player2Active ? Colors.orange : getPlayerColor(2),
                        child: Image(
                          image: AssetImage('assets/Img/dice$n2.png'),
                          width: 120,
                          height: 120,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Dice images (bottom two) with button below each dice
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        color: player3Active ? Colors.orange : getPlayerColor(3),
                        child: Image(
                          image: AssetImage('assets/Img/dice$n3.png'),
                          width: 120,
                          height: 120,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Player 3 Score: $score3',
                        textAlign: TextAlign.center,
                      ),
                      ElevatedButton(
                        onPressed: player3Active ? rollDice : null,
                        child: Text('Roll Dice'),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        color: player4Active ? Colors.orange : getPlayerColor(4),
                        child: Image(
                          image: AssetImage('assets/Img/dice$n4.png'),
                          width: 120,
                          height: 120,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Player 4 Score: $score4',
                        textAlign: TextAlign.center,
                      ),
                      ElevatedButton(
                        onPressed: player4Active ? rollDice : null,
                        child: Text('Roll Dice'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
