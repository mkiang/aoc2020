# --- Day 16: Ticket Translation --- As you're walking to yet another connecting
# flight, you realize that one of the legs of your re-routed trip coming up is
# on a high-speed train. However, the train ticket you were given is in a
# language you don't understand. You should probably figure out what it says
# before you get to the train station after the next flight.
#
# Unfortunately, you can't actually read the words on the ticket. You can,
# however, read the numbers, and so you figure out the fields these tickets must
# have and the valid ranges for values in those fields.
#
# You collect the rules for ticket fields, the numbers on your ticket, and the
# numbers on other nearby tickets for the same train service (via the airport
# security cameras) together into a single document you can reference (your
# puzzle input).
#
# The rules for ticket fields specify a list of fields that exist somewhere on
# the ticket and the valid ranges of values for each field. For example, a rule
# like class: 1-3 or 5-7 means that one of the fields in every ticket is named
# class and can be any value in the ranges 1-3 or 5-7 (inclusive, such that 3
# and 5 are both valid in this field, but 4 is not).
#
# Each ticket is represented by a single line of comma-separated values. The
# values are the numbers on the ticket in the order they appear; every ticket
# has the same format. For example, consider this ticket:
#
# .--------------------------------------------------------. | ????: 101
# ?????: 102   ??????????: 103     ???: 104 | |
# | | ??: 301  ??: 302             ???????: 303      ??????? | | ??: 401  ??:
# 402           ???? ????: 403    ????????? |
# '--------------------------------------------------------' Here, ? represents
# text in a language you don't understand. This ticket might be represented as
# 101,102,103,104,301,302,303,401,402,403; of course, the actual train tickets
# you're looking at are much more complicated. In any case, you've extracted
# just the numbers in such a way that the first number is always the same
# specific field, the second number is always a different specific field, and so
# on - you just don't know what each position actually means!
#
# Start by determining which tickets are completely invalid; these are tickets
# that contain values which aren't valid for any field. Ignore your ticket for
# now.
#
# For example, suppose you have the following notes:
#
# class: 1-3 or 5-7 row: 6-11 or 33-44 seat: 13-40 or 45-50
#
# your ticket: 7,1,14
#
# nearby tickets: 7,3,47 40,4,50 55,2,20 38,6,12 It doesn't matter which
# position corresponds to which field; you can identify invalid nearby tickets
# by considering only whether tickets contain values that are not valid for any
# field. In this example, the values on the first nearby ticket are all valid
# for at least one field. This is not true of the other three nearby tickets:
# the values 4, 55, and 12 are are not valid for any field. Adding together all
# of the invalid values produces your ticket scanning error rate: 4 + 55 + 12 =
# 71.
#
# Consider the validity of the nearby tickets you scanned. What is your ticket
# scanning error rate?
library(tidyverse)
input <- readLines("./16_input.txt")

x <- input[1:(which(input == "")[1] - 1)]
nums <- as.numeric(unlist(str_extract_all(sapply(strsplit(x, ": "), function(x) x[[2]]), "(\\d)+")))
valid_nums <- c()
for (i in seq(1, NROW(x), 2)) {
    valid_nums <- c(valid_nums, nums[i]:nums[i + 1])
}
valid_nums <- sort(unique(valid_nums))

tickets <- input[(which(input == "")[2] + 2):NROW(input)]
invalid_nums <- NULL
invalid_tickets <- NULL
for (i in 1:NROW(tickets)) {
    ticket_nums <- as.numeric(unlist(strsplit(tickets[i], ",")))
    invalid_nums <- c(invalid_nums,
                      ticket_nums[!(ticket_nums %in% valid_nums)])
    
    if (!all(ticket_nums %in% valid_nums)) {
        invalid_tickets <- c(invalid_tickets, i)
    }
}
sum(invalid_nums)

# --- Part Two --- Now that you've identified which tickets contain invalid
# values, discard those tickets entirely. Use the remaining valid tickets to
# determine which field is which.
#
# Using the valid ranges for each field, determine what order the fields appear
# on the tickets. The order is consistent between all tickets: if seat is the
# third field, it is the third field on every ticket, including your ticket.
#
# For example, suppose you have the following notes:
#
# class: 0-1 or 4-19 row: 0-5 or 8-19 seat: 0-13 or 16-19
#
# your ticket: 11,12,13
#
# nearby tickets: 3,9,18 15,1,5 5,14,9 Based on the nearby tickets in the above
# example, the first position must be row, the second position must be class,
# and the third position must be seat; you can conclude that in your ticket,
# class is 12, row is 11, and seat is 13.
#
# Once you work out which field is which, look for the six fields on your ticket
# that start with the word departure. What do you get if you multiply those six
# values together?
rules <- tibble(rule_name = sapply(strsplit(x, ": "), function(x) x[[1]]),
                rule_text = sapply(strsplit(x, ": "), function(x) x[[2]]),
                column_pos = NA
                ) %>%
    separate(
        rule_text,
        into = c("start1", "stop1", "start2", "stop2"),
        remove = FALSE,
        convert = TRUE, sep = "[^[:digit:]]+"
    )

tickets <- tickets[-invalid_tickets]
ticket_matrix <- matrix(as.numeric(unlist(strsplit(tickets, ","))),
                        byrow = TRUE,
                        nrow = NROW(tickets))

## For each rule (row), list all valid (1) and invalid (0) column positions
rules_matrix <- matrix(rep(0, NROW(rules) * NCOL(ticket_matrix)),
                       nrow = NROW(rules))
for (rule in 1:NROW(rules)) {
    for (i in 1:NCOL(ticket_matrix)) {
        rules_matrix[rule, i] <- all(
            between(ticket_matrix[, i], rules$start1[rule], rules$stop1[rule]) |
                between(ticket_matrix[, i], rules$start2[rule], rules$stop2[rule])
        ) + 0
    }
}

while(any(is.na(rules$column_pos))) {
    c_sums <- colSums(rules_matrix)
    current_col <- which(c_sums == 1)
    current_rule <- which(rules_matrix[, current_col] == 1)
    rules$column_pos[current_rule] <- current_col
    
    ## Reset the rules matrix for this rule and column position
    rules_matrix[, current_col] <- 0
    rules_matrix[current_rule,] <- 0
}

my_ticket <- input[(which(input == "")[1] + 2):(which(input == "")[1] + 2)]
my_ticket <- as.numeric(unlist(strsplit(my_ticket, split = ",")))
as.character(prod(my_ticket[rules %>%
                                filter(grepl("departure", rule_name)) %>%
                                pull(column_pos)]))
