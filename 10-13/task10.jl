include("../roblib.jl")

function get_average_temperature(r)
    count = 0
    all_temperature = 0
    direction = Right
    
    while ((isborder(r, Right) == false) || (isborder(r, Up) == false))
        if ismarker(r)
            count += 1
            all_temperature += temperature(r)
        end
        if isborder(r, direction)
            direction = inverse(direction)
            move!(r, Up)
        else move!(r, direction)
        end
    end

    println(all_temperature/count)
end