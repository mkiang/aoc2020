# You catch the airport shuttle and try to book a new flight to your vacation
# island. Due to the storm, all direct flights have been cancelled, but a route
# is available to get around the storm. You take it.
#
# While you wait for your flight, you decide to check in with the Elves back at
# the North Pole. They're playing a memory game and are ever so excited to
# explain the rules!
#
# In this game, the players take turns saying numbers. They begin by taking
# turns reading from a list of starting numbers (your puzzle input). Then, each
# turn consists of considering the most recently spoken number:
#
# If that was the first time the number has been spoken, the current player says
# 0. Otherwise, the number had been spoken before; the current player announces
# how many turns apart the number is from when it was previously spoken. So,
# after the starting numbers, each turn results in that player speaking aloud
# either 0 (if the last number is new) or an age (if the last number is a
# repeat).
#
# For example, suppose the starting numbers are 0,3,6:
#
# Turn 1: The 1st number spoken is a starting number, 0. Turn 2: The 2nd number
# spoken is a starting number, 3. Turn 3: The 3rd number spoken is a starting
# number, 6. Turn 4: Now, consider the last number spoken, 6. Since that was the
# first time the number had been spoken, the 4th number spoken is 0. Turn 5:
# Next, again consider the last number spoken, 0. Since it had been spoken
# before, the next number to speak is the difference between the turn number
# when it was last spoken (the previous turn, 4) and the turn number of the time
# it was most recently spoken before then (turn 1). Thus, the 5th number spoken
# is 4 - 1, 3. Turn 6: The last number spoken, 3 had also been spoken before,
# most recently on turns 5 and 2. So, the 6th number spoken is 5 - 2, 3. Turn 7:
# Since 3 was just spoken twice in a row, and the last two turns are 1 turn
# apart, the 7th number spoken is 1. Turn 8: Since 1 is new, the 8th number
# spoken is 0. Turn 9: 0 was last spoken on turns 8 and 4, so the 9th number
# spoken is the difference between them, 4. Turn 10: 4 is new, so the 10th
# number spoken is 0. (The game ends when the Elves get sick of playing or
# dinner is ready, whichever comes first.)
#
# Their question for you is: what will be the 2020th number spoken? In the
# example above, the 2020th number spoken will be 436.
#
# Here are a few more examples:
#
# Given the starting numbers 1,3,2, the 2020th number spoken is 1. Given the
# starting numbers 2,1,3, the 2020th number spoken is 10. Given the starting
# numbers 1,2,3, the 2020th number spoken is 27. Given the starting numbers
# 2,3,1, the 2020th number spoken is 78. Given the starting numbers 3,2,1, the
# 2020th number spoken is 438. Given the starting numbers 3,1,2, the 2020th
# number spoken is 1836. Given your starting numbers, what will be the 2020th
# number spoken?

input <- c(6, 3, 15, 13, 1, 0)

last_spoken_num <- function(input, last_ix) {
    spoken_nums <- rep(NA, last_ix)
    spoken_nums[1:NROW(input)] <- input
    for (i in (NROW(input) + 1): last_ix) {
        ix <- which(spoken_nums == spoken_nums[i - 1])
        spoken_nums[i] <- ifelse(NROW(ix) == 1,
                                 0,
                                 ix[NROW(ix)] - ix[(NROW(ix) - 1)])
    }
    spoken_nums[last_ix]
}
last_spoken_num(input, 2020)


# --- Part Two --- Impressed, the Elves issue you a challenge: determine the
# 30000000th number spoken. For example, given the same starting numbers as
# above:
#
# Given 0,3,6, the 30000000th number spoken is 175594. Given 1,3,2, the
# 30000000th number spoken is 2578. Given 2,1,3, the 30000000th number spoken is
# 3544142. Given 1,2,3, the 30000000th number spoken is 261214. Given 2,3,1, the
# 30000000th number spoken is 6895259. Given 3,2,1, the 30000000th number spoken
# is 18. Given 3,1,2, the 30000000th number spoken is 362. Given your starting
# numbers, what will be the 30000000th number spoken?

## Part 1 function is too slow to do this so we need a better way to track
## the last number. Slightly modified version of Part 1 -- it's still very slow
## which suggests there's probably a faster way to do this that I can't think
## of right now.

last_spoken_num_2 <- function(input, last_ix) {
    ## We need to keep track of 0 so spoken_nums is now num + 1 and instead
    ## of tracking the numbers spoken, we just track the last time that index
    ## was spoken.
    spoken_nums <- rep(NA, last_ix)
    spoken_nums[input[1:(NROW(input) - 1)] + 1] <- 1:(NROW(input) - 1)
    
    last_num <- input[NROW(input)]
    
    for (i in (NROW(input) + 1):last_ix) {
        ix <- spoken_nums[last_num + 1L]
        
        current_num <- ifelse(is.na(ix),
                              0,
                              i - ix - 1)
        
        spoken_nums[last_num + 1] <- i - 1
        last_num <- current_num
    }
    last_num
}
last_spoken_num_2(input, 30000000)
