import HorizonSideRobots: isborder
include("../roblib.jl")

function mark_kross_x(r::Robot)
    for side in ((Up, Right), (Down, Right), (Down, Left), (Up, Left))
        move_and_putmarkers_diagonal!(r,side)
        return_back!(r, side)
    end
    putmarker!(r)
end

function move_and_putmarkers_diagonal!(r::Robot, side::NTuple{2, HorizonSide})
    while isborder(r, side) == false
        move_diagonal!(r, side)
        putmarker!(r)
    end
end

function return_back!(r::Robot, side::NTuple{2,HorizonSide}) 
    while ismarker(r) 
        move_diagonal!(r, inverse(side))
    end
end

function move_diagonal!(r::Robot, side::NTuple{2,HorizonSide})
    move!(r, side[1])
    move!(r, side[2])
end

isborder(r::Robot,side::NTuple{2,HorizonSide})::Bool = (isborder(r,side[1]) || isborder(r,side[2]))

inverse(side::NTuple{2,HorizonSide}) = (inverse(side[1]), inverse(side[2]))