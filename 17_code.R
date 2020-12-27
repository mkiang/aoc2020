input <- c(
    ".#.#.#..",
    "..#....#",
    "#####..#",
    "#####..#",
    "#####..#",
    "###..#.#",
    "#..##.##",
    "#.#.####"
    )

## Convert input into a matrix 
input_matrix <- matrix(unlist(strsplit(input, "")), byrow = TRUE, nrow = NROW(input))

get_neighbor_coords <- function(xx, yy, zz, final_dim) {
    res <- expand.grid(x = (xx - 1):(xx + 1),
                       y = (yy - 1):(yy + 1),
                       z = (zz - 1):(zz + 1))
    res <- res[!(res$x == xx & res$y == yy & res$z == zz), ]
    res <- res[res$x > 0 & res$y > 0 & res$z > 0, ]
    res[res$x <= final_dim[1] &
            res$y <= final_dim[2] &
            res$z <= final_dim[3], ]
}

n_iter <- 6
layer_buffer <- 200
z_buffer <- 4

## Make an array that's far too big
final_dim <- c(rep(NROW(input) + 2 * (n_iter - 1) + layer_buffer, 2), 
               z_buffer + (n_iter - 1) * 2)
n_elements <- prod(final_dim)
expanded_matrix <- array(rep(".", n_elements),
           dim = final_dim)

## Insert the initial input somewhere near the middle
expanded_matrix[(layer_buffer / 2):((layer_buffer / 2) + nchar(input[1]) - 1),
                (layer_buffer / 2):((layer_buffer / 2) + NROW(input) - 1),
                ceiling(final_dim[3] / 2)] <- input_matrix

## Then it's just for loops all the way down.
## NOTE: This brute force method is highly inefficient. We should really be
## growing the initial input outwards as necessary instead of creating a space
## and inserting it.
new_matrix <- expanded_matrix
for (r in 1:n_iter) {
    for (i in 1:final_dim[1]) {
        for (j in 1:final_dim[2]) {
            for (k in 1:final_dim[3]) {
                current_cube <- expanded_matrix[i, j, k]
                current_nbors <- get_neighbor_coords(i, j, k, final_dim)
                active_neighbors <- 0
                for (l in 1:NROW(current_nbors)) {
                    if (expanded_matrix[current_nbors$x[l],
                                        current_nbors$y[l],
                                        current_nbors$z[l]] == "#")
                        active_neighbors <- active_neighbors + 1
                }
                
                if (current_cube == "#") {
                    new_matrix[i, j, k] <- ifelse(active_neighbors %in% 2:3, "#", ".")
                }
                
                if (current_cube == ".") {
                    new_matrix[i, j, k] <- ifelse(active_neighbors == 3, "#", ".")
                }
            }
        }
    }
    expanded_matrix <- new_matrix
}
sum(expanded_matrix == "#")

# --- Part Two --- For some reason, your simulated results don't match what the
# experimental energy source engineers expected. Apparently, the pocket
# dimension actually has four spatial dimensions, not three.
#
# The pocket dimension contains an infinite 4-dimensional grid. At every integer
# 4-dimensional coordinate (x,y,z,w), there exists a single cube (really, a
# hypercube) which is still either active or inactive.
#
# Each cube only ever considers its neighbors: any of the 80 other cubes where
# any of their coordinates differ by at most 1. For example, given the cube at
# x=1,y=2,z=3,w=4, its neighbors include the cube at x=2,y=2,z=3,w=3, the cube
# at x=0,y=2,z=3,w=4, and so on.
#
# The initial state of the pocket dimension still consists of a small flat
# region of cubes. Furthermore, the same rules for cycle updating still apply:
# during each cycle, consider the number of active neighbors of each cube.
#
# For example, consider the same initial state as in the example above. Even
# though the pocket dimension is 4-dimensional, this initial state represents a
# small 2-dimensional slice of it. (In particular, this initial state defines a
# 3x3x1x1 region of the 4-dimensional space.)
#
# Simulating a few cycles from this initial state produces the following
# configurations, where the result of each cycle is shown layer-by-layer at each
# given z and w coordinate:

## Previous method is too slow. Really we should be creating a new n-dim array
## every iteration where we just add +2 to every dimension around the original
## array. 
