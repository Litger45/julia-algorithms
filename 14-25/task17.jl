include("../roblib.jl")

function mark_ladder(r)
    num_steps = through_rectangles_into_angle(r, (Down, Left))

    cells_in_raw = mark_and_enumerate_if_possible!(r, Right)
    cells_to_mark = cells_in_raw - 1
    
    while (isborder(r, Up) == false) || (isborder(r, Left) == false)
        movements_if_possible!(r, Left)
        if (isborder(r, Up) == false)
            move!(r, Up)
        end
        cells_to_not_mark = cells_in_raw - get_num_movements_if_possible!(r, Right)
        movements_if_possible!(r, Left, cells_in_raw)
        cells_remained = move_and_check(r, Right, cells_to_mark)
        if ((cells_remained - cells_to_not_mark) > 0)
            putmarkers_if_possible!(r, Right, cells_remained - cells_to_not_mark)
        end
        cells_to_mark -= 1
    end

    through_rectangles_into_angle(r, (Down, Left))
    movements_if_possible!(r, (Up, Right), reverse(num_steps))
end

function move_and_check(r, side, count)
    putmarker!(r)
    while (count!=0 && isborder(r, side) == false)
        move!(r,side)
        putmarker!(r)
        count -= 1
    end

    return count
end