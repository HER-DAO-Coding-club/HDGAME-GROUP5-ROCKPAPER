pragma solidity ^0.8.0;

contract RockPaperScissors {
    enum Move {
        None,
        Rock,
        Paper,
        Scissors
    }
    enum Result {
        None,
        Player1Wins,
        Player2Wins,
        Draw
    }

    struct Game {
        address player1;
        address player2;
        Move move1;
        Move move2;
        Result result;
        uint256 betAmount;
        bool isCompleted;
    }

    mapping(address => uint256) public balances;
    mapping(bytes32 => Game) public games;

    event GameCreated(
        bytes32 indexed gameId,
        address indexed player1,
        address indexed player2,
        uint256 betAmount
    );
    event MoveSubmitted(
        bytes32 indexed gameId,
        address indexed player,
        Move move
    );
    event GameResult(bytes32 indexed gameId, Result result);

    function createGame(bytes32 gameId, address player2) external payable {
        require(msg.value > 0, "Bet amount must be greater than zero");
        require(player2 != address(0), "Invalid player address");
        require(games[gameId].player1 == address(0), "Game ID already exists");

        Game storage game = games[gameId];
        game.player1 = msg.sender;
        game.player2 = player2;
        game.betAmount = msg.value;

        emit GameCreated(gameId, msg.sender, player2, msg.value);
    }

    function submitMove(bytes32 gameId, Move move) external {
        Game storage game = games[gameId];
        require(!game.isCompleted, "Game is already completed");
        require(
            msg.sender == game.player1 || msg.sender == game.player2,
            "Invalid player"
        );

        if (msg.sender == game.player1) {
            require(game.move1 == Move.None, "Player1 move already submitted");
            game.move1 = move;
        } else {
            require(game.move2 == Move.None, "Player2 move already submitted");
            game.move2 = move;
        }

        emit MoveSubmitted(gameId, msg.sender, move);

        if (game.move1 != Move.None && game.move2 != Move.None) {
            determineWinner(gameId);
        }
    }

    function determineWinner(bytes32 gameId) internal {
        Game storage game = games[gameId];
        require(
            game.move1 != Move.None && game.move2 != Move.None,
            "Both players must submit their moves"
        );

        if (game.move1 == game.move2) {
            game.result = Result.Draw;
            balances[game.player1] += game.betAmount;
            balances[game.player2] += game.betAmount;
        } else if (
            (game.move1 == Move.Rock && game.move2 == Move.Scissors) ||
            (game.move1 == Move.Paper && game.move2 == Move.Rock) ||
            (game.move1 == Move.Scissors && game.move2 == Move.Paper)
        ) {
            game.result = Result.Player1Wins;
            balances[game.player1] += game.betAmount * 2;
        } else {
            game.result = Result.Player2Wins;
            balances[game.player2] += game.betAmount * 2;
        }

        game.isCompleted = true;

        emit GameResult(gameId, game.result);
    }
}
