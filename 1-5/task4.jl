include("../roblib.jl")

function mark_ladder(r)
    num_steps = through_rectangles_into_angle(r, (Down, Left))

    cells_to_mark = mark_and_enumerate!(r, Right) - 1
    while isborder(r, Up) == false
        movements!(r, Left)
        move!(r, Up)
        putmarkers!(r, Right, cells_to_mark)
        cells_to_mark -= 1
    end

    through_rectangles_into_angle(r, (Down, Left))
    movements!(r, (Up, Right), reverse(num_steps))
end

"""
    mark_and_enumerate(r, side::HorizonSide)

-- Ставит маркеры в указанном направлении, пока не наткнется на ограду, а также считает количетво шагов сделанных в эту сторону и возвращает их
"""
function mark_and_enumerate!(r, side::HorizonSide)
    steps = 0
    
    putmarker!(r)
    while isborder(r, side) == false 
        move!(r, side)
        putmarker!(r) 
        steps += 1
    end
    
    return steps 
end