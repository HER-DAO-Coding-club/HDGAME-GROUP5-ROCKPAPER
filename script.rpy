init python:
    import random

# Define las imágenes que se utilizarán
image bg sala = "sala.jpg"

# Start of the story
label start:
    scene bg sala

    "You are BMO, a small game console with a thirst for adventure."
    
    "Eileen: Hello, BMO! Ready to play rock, paper, or scissors?"

    $ score_player = 0
    $ score_computer = 0
    $ choices = ['Rock', 'Paper', 'Scissors']

    # Usamos un mapa para determinar el ganador de cada posible juego
    $ win_map = {'Rock': 'Scissors', 'Paper': 'Rock', 'Scissors': 'Paper'}

    while score_player < 3 and score_computer < 3:
        "Scores: BMO - [score_player] | Eileen - [score_computer]"

        menu:
            "What do you choose?"
            "Rock":
                $ player_choice = 'Rock'
            "Paper":
                $ player_choice = 'Paper'
            "Scissors":
                $ player_choice = 'Scissors'

        $ computer_choice = random.choice(choices) # Usamos random.choice para elegir un elemento aleatorio de la lista
        "You choose [player_choice]. Eileen chooses [computer_choice]."

        if player_choice == computer_choice:
            "It's a tie!"
        elif win_map[player_choice] == computer_choice: # Usamos el mapa para determinar el ganador
            "You win the game!"
            $ score_player += 1
        else:
            "Eileen wins the game."
            $ score_computer += 1

    if score_player == 3:
        "You won the match! Well done, BMO!"
    else:
        "Eileen won the match. Better luck next time, BMO!"

    return
