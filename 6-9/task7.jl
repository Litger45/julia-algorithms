include("../roblib.jl")

function mark_chess_and_return(r)
    num_steps = through_rectangles_into_angle(r, (Down, Left))

    direction       = Right
    put_marker_flag = true

    if (sum(num_steps[1:2:end]) % 2 != 0)
        put_marker_flag = false
    end

    while (isborder(r, Up) == false) || (isborder(r, Right) == false)
        if put_marker_flag
            putmarker!(r)
            put_marker_flag = false
        else
            put_marker_flag = true
        end
        if isborder(r, direction)
            direction = inverse(direction)
            move!(r, Up)
        else move!(r, direction)
        end
    end

    through_rectangles_into_angle(r, (Down, Left))
    movements!(r, (Up, Right), reverse(num_steps))
end