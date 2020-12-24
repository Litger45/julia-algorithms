include("../roblib.jl")

function mark_it_all(r::Robot)
    numsteps_hor = get_num_movements!(r, Left)
    numsteps_vert = get_num_movements!(r, Down)
    
    while isborder(r, Up)==false || isborder(r, Left)==false || ismarker(r)==false # пока не вернёмся в северо-западный угол(оттуда проще вернуться в начальную точку)
        for side in (Right, Left)    
            putmark(r,side)
            putmarker!(r) # маркер в точке остановки
            if isborder(r, Up)==false
                move!(r, Up)
            end
        end
    end
    
    movements!(r, Down) # перемещаемся в юго-западный
    back(r, Up, numsteps_vert) # возвращаемся в начальную точку
    back(r, Down, numsteps_hor)
end

function putmark(r::Robot, side::HorizonSide)
    while isborder(r, side) == false
        if ismarker(r) == false
            putmarker!(r)
            move!(r,side)
        else
            move!(r,side)
        end    
    end
end

function back(r::Robot, side::HorizonSide, numsteps::Int)
    for _ in 1:numsteps
        move!(r,side)
    end
end    