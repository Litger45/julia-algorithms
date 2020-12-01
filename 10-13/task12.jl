include("../roblib.jl")

# global vars

CELL_SIZE = 0
ROBOT_CURRENT_POS = [0, 0]

function mark_chess(r::Robot, n::Int = 0)
    global CELL_SIZE
    
    if n != 0
        CELL_SIZE = n
    end

    side = Right
    mark_row(r, side)
    while isborder(r, Up) == false
        move_decart!(r, Up)
        side = inverse(side)
        mark_row(r,side)
    end

end

function get_cell_size()
    global CELL_SIZE
    println("Введите размер клетки: ")
    CELL_SIZE = parse(Int, readline())
end

function mark_row(r::Robot, side::HorizonSide)       
    putmarker_chess!(r)
    while isborder(r, side) == false
        move_decart!(r, side)
        putmarker_chess!(r)
    end
end

function putmarker_chess!(r::Robot)
    global ROBOT_CURRENT_POS
    if (mod(ROBOT_CURRENT_POS[1], 2 * CELL_SIZE)) < CELL_SIZE && (mod(ROBOT_CURRENT_POS[2], 2 * CELL_SIZE)) < CELL_SIZE || (mod(ROBOT_CURRENT_POS[1] + CELL_SIZE, 2 * CELL_SIZE)) < CELL_SIZE && (mod(ROBOT_CURRENT_POS[2], 2 * CELL_SIZE)) >= CELL_SIZE
        putmarker!(r)
    end
end

function move_decart!(r::Robot, side::HorizonSide)
    global ROBOT_CURRENT_POS
    if side == Up
        ROBOT_CURRENT_POS[2] += 1
    elseif side == Down
        ROBOT_CURRENT_POS[2] -= 1
    elseif side == Right
        ROBOT_CURRENT_POS[1] += 1
    else
        ROBOT_CURRENT_POS[1] -= 1
    end
    move!(r, side)
end