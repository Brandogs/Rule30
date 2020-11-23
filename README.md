# Rule30
Rule 30 Cellular Automata.

## Description
The user can tap the top row of squares to turn on/off the initial row. The app will then generate the following rows, representing the sequential generations or iterations of the automata as they live and die based on Rule 30 - (left cell XOR (current cell OR right cell)). 

Additionally, the user can turn on and off an animation delay that allows a delay between each updates generation. This delay can also be updated in a range of 0.1 to 1.0 seconds. These settings can be found by tapping the button in the top right of the navigation bar.

The app simulates an infinite array. In the initial array, it is assumed that offscreen cells are initially false or "dead." As the app runs and creates future generations row by row, off screen automaton cells can be marked as true or "living" assuming that Rule 30 allows it from the previous generation.
