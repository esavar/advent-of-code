You make a map (your puzzle input) of the open squares (.) and trees (#) you can see.  
The same pattern repeats to the right many times.  

You start on the open square (.) in the top-left corner and need to reach the bottom (below the bottom-most row on your map).  

From your starting position at the top-left, check the position that is right *x* and down *y*.   
Then, check the position that is right *x* and down *y* from there, and so on until you go past the bottom of the map.  

Determine the number of trees you would encounter if, for each of the following slopes,   
you start at the top-left corner and traverse the map all the way to the bottom:  
  
Right 1, down 1.  
Right 3, down 1.  
Right 5, down 1.  
Right 7, down 1.  
Right 1, down 2.  

What do you get if you multiply together the number of trees encountered on each of the listed slopes?  

Your puzzle answer was 262.

### Part Two
Time to check the rest of the slopes - you need to minimize the probability of a sudden arboreal stop, after all.

Determine the number of trees you would encounter if, for each of the following slopes, you start at the top-left corner and traverse the map all the way to the bottom:

Right 1, down 1.  
Right 3, down 1. (This is the slope you already checked.)    
Right 5, down 1.  
Right 7, down 1.  
Right 1, down 2.  
In the above example, these slopes would find 2, 7, 3, 4, and 2 tree(s) respectively; multiplied together, these produce the answer 336.

What do you get if you multiply together the number of trees encountered on each of the listed slopes?

Your puzzle answer was 2698900776.
