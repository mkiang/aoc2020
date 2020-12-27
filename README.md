# Advent of Code 2020

I thought I'd try my hand at doing the [Advent of Code](https://adventofcode.com/) challenges this year (in R).

## Recap

Unfortunately, a deluge of work and life events prevented me from finishing all 25 days. I got to 17 and did 29 of the 34 puzzles by then. This is my personal leaderboard:

```
      --------Part 1--------   --------Part 2--------
Day       Time   Rank  Score       Time   Rank  Score
 17   01:39:40   3979      0          -      -      -
 16   00:19:38   1940      0   21:05:51  19485      0
 15   12:07:11  20628      0   16:08:17  21612      0
 14   00:46:18   4260      0          -      -      -
 13   00:19:18   4218      0          -      -      -
 12   18:48:07  28966      0          -      -      -
 11   00:44:30   3876      0          -      -      -
 10   00:11:54   3107      0   01:38:49   5082      0
  9   00:09:50   2082      0   00:40:38   5660      0
  8   00:17:44   4734      0   13:38:37  32640      0
  7   23:38:51  42770      0       >24h  41449      0
  6   00:07:37   2496      0   00:19:27   3556      0
  5   00:19:07   3440      0   00:26:39   3285      0
  4   01:52:51  12778      0   02:35:26  10276      0
  3   02:43:40  16205      0   02:47:23  14740      0
  2   00:24:28   5063      0   00:37:15   5264      0
  1   01:16:19   6691      0   01:28:27   6538      0
```

A few things I'll need to keep in mind for next year:

- Before beginning, I had set a personal time limit to ~45-50 minutes per puzzle. Up until Day 11, this was enough time to finish both Part 1 and Part 2. For future reference, I think later days will require much more time. For example, Day 16 took about an hour and a half (15 minutes on Part 1 and 1 hour and 15 minutes on Part 2). Most days, I just couldn't dedicated that much time to the puzzles. 
- The timer starts at midnight ET so the "Time" elapsed above is relative to that epoch. In other words, it is not the amount of time since you first looked at the puzzle (as I had initially assumed would be the case).
- Later puzzles seem to be less abou coding and more about number theory. 
- Similarly, some puzzles are tricky only in that they require using integers that are large enough to give `R` trouble. 
- Knowing the in's and out's of the different types of flow control is key. So is using Boolean vectors/matrices (which are generally much faster in R than element-wise comparisons). 
- A couple puzzles required being smart about data structures -- these puzzles really made me miss Python where it's easier to work with explicit data structures off the shelf.

All in all, it was pretty fun and very cool to see how better programmers tackle the problems. Will try it again next year. Allotting more time in the later puzzles and probably doing a one-day delay since working on them after a long day is probably not the most efficient way to go about it.
