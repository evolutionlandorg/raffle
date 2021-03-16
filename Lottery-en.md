# Lottery

The lottery uses a weighted random algorithm. Randomly select one from N elements with different weights, and make the overall selection result distributed according to the weight.
Assuming that 4 plots of land A, B, C, and D participate in lottery, the mortgage amounts are 1, 2, 3, and 4 respectively. In the random result, the ratio of A:B:C:D should be 1:2:3:4.
Accumulate the weights of each land A(1)-B(3)-C(6)-D(10), then the weight jurisdictional intervals of the 4 elements are (0,1], (1,3), ( 3,6], (6,10]. Then randomly generate a random number between (0,10]. In which interval, the elements of the interval are the elements hit by weight.
To select M pieces of land, you can select a piece of land according to the above method, remove the land from the collection, and then repeatedly extract the remaining land according to the above method.
The random number is selected as the hash of the block. If the final lottery block is B, start with B-M blocks, and draw a total of M block hashes as the random number for the lottery.
An example of a lucky draw on ropsten:
Assume that 4 plots of land A, B, C, and D participate in lottery, and the mortgage amount is 1, 2, 3, and 4 respectively
The final lottery block is 10000
The hash of the 9998th block is: 0x09cc4bb3ab6bb019e6bdca3a79d07c8d72919cf561489ac9101e4217b3cb8131
The remainder of 1e19 plus 1 is: 0.094 RING falls in the (0,1) interval, the corresponding land A wins,
After removing land A, the intervals of B, C, D are (0,2) (2,5) (5,9)
The hash of the 9999th block is:
0x9e552bad9996f391acea81a0d77556958e96314f897ed0abbb16d0d36a54668f
The remainder of 9e18 plus 1 is: 1.087 RING falls in the (0,2) interval, and the corresponding land B wins the prize.
The lottery draw is over, land A and land B win the prize.
