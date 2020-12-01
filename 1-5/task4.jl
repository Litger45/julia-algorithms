include("../roblib.jl")

function mark_ladder(r)
    num_steps = through_rectangles_into_angle(r, (Down, Left))

    cell_to_mark = mark_and_enumerate!(r, Right) - 1
    while isborder(r, Up) == false
        movements!(r, Left)
        move!(r, Up)
        putmarkers!(r, Right, cell_to_mark)
        cell_to_mark -= 1
    end

    through_rectangles_into_angle(r, (Down, Left))
    movements!(r, (Up, Right), reverse(num_steps))
end

function mark_and_enumerate!(r, side)
    steps = 0
    
    putmarker!(r)
    while isborder(r, side) == false 
        move!(r, side)
        putmarker!(r) 
        steps += 1
    end
    
    return steps 
end