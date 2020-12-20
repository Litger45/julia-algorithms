# Переопределение сторон
Left  = West
Up    = Nord
Right = Ost 
Down  = Sud


"""
    inverse(side::HorizonSide)

-- Возвращает направление, противоположное заданному    
"""
inverse(side::HorizonSide) = HorizonSide(mod(Int(side)+2, 4))

"""
    left(side::HorizonSide)

-- Возвращает направление, следующее против часовой стрелке, по отношению к заданному    
"""
left(side::HorizonSide) =  HorizonSide(mod(Int(side)+1, 4))

"""
    right(side::HorizonSide)

-- Возвращает направление, следующее по часовой стрелке, по отношению к заданному    
"""
right(side::HorizonSide) = HorizonSide(mod(Int(side)-1, 4))

"""
    putmarkers!(r::Robot, side::HorizonSide)

-- Ставит маркеры в указанном направлении, пока не наткнется на ограду
"""
function putmarkers!(r::Robot, side::HorizonSide)
    putmarker!(r)
    while isborder(r,side)==false
        move!(r,side)
        putmarker!(r)
    end
end

"""
    putmarkers!(r::Robot, side::HorizonSide, count::Int)

-- Ставит маркеры в указанном направлении, пока не обнулится счетчик
"""
function putmarkers!(r::Robot, side::HorizonSide, count::Int)
    putmarker!(r)
    while count!=0
        move!(r,side)
        putmarker!(r)
        count -= 1
    end
end

"""
    move_by_markers(r::Robot, side::HorizonSide)

-- Двигается по маркерам в указанном направлении
"""
move_by_markers(r::Robot, side::HorizonSide) = while ismarker(r)==true move!(r,side) end

"""
    movements!(r::Robot, side::HorizonSide)

-- Перемещает Робота в заданном направлении до стенки    
"""
movements!(r::Robot, side::HorizonSide) = while isborder(r,side)==false move!(r,side) end 

"""
    movements!(r::Robot, side::HorizonSide, num_steps::Int)

-- Перемещает Робота в заданном направлении на заданное число шагов    
"""
movements!(r::Robot, side::HorizonSide, num_steps::Int) = for _ in 1:num_steps move!(r,side) end

"""
    get_num_movements!(r::Robot, side::HorizonSide)

-- Перемещает Робота в заданном направлении до стенки и возвращает сделанное число шагов    
"""
function get_num_movements!(r::Robot, side::HorizonSide)
    num_steps = 0
    while isborder(r,side)==false 
        move!(r,side) 
        num_steps += 1    
    end
    return num_steps
end

"""
    movements!(r, sides::NTuple{2,HorizonSide}, num_steps::Vector{Any})

-- перемещает Робота по пути, представленного двумя последовательностями, sides и num_steps 
-- sides - содержит последовательность направлений перемещений
-- num_steps - содержит последовательность чисел шагов в каждом из этих направлений, соответственно; при этом, если длина последовательности sides меньше длины последовательности num_steps, то предполагается, что последовательность sides должна быть продолжена периодически        
"""
function movements!(r, sides::NTuple{2,HorizonSide}, num_steps::Vector{Any})
    for (i,n) in enumerate(num_steps)
        movements!(r, sides[mod(i-1, length(sides))+1], n)
    end
end

"""
    through_rectangles_into_angle(r,angle::NTuple{2,HorizonSide})

-- Перемещает Робота в заданный угол, прокладывая путь межу внутренними прямоугольными перегородками и возвращает массив, содержащий числа шагов в каждом из заданных направлений на этом пути
"""
function through_rectangles_into_angle(r,angle::NTuple{2,HorizonSide})
    num_steps = []
    while (isborder(r,angle[1]) == false || isborder(r,angle[2]) == false)
        push!(num_steps, get_num_movements!(r, angle[2]))
        push!(num_steps, get_num_movements!(r, angle[1]))
    end
    return num_steps
end

"""
    move_if_possible!(r::Robot, side::HorizonSide)

-- Двигается в заданном направлении, пока возможно, минуя внутренние перегородки    
"""
function move_if_possible!(r::Robot, direct_side::HorizonSide)::Bool
    left_side = right(direct_side)
    right_side = inverse(left_side)
    num_of_steps = 0

    if isborder(r, direct_side) == false
        move!(r, direct_side)
        result = true
    else
        while isborder(r, direct_side) == true
            if isborder(r, left_side) == false
                move!(r, left_side)
                num_of_steps += 1
            else
                break
            end
        end
        if isborder(r, direct_side) == false
            move!(r, direct_side)
            while isborder(r, right_side) == true
                move!(r, direct_side)
            end
            result = true
        else
            result = false
        end
        while num_of_steps > 0
            num_of_steps -= 1
            move!(r, right_side)
        end
    end

    return result
end

"""
    movements_if_possible!(r::Robot, side::HorizonSide)

-- Перемещает Робота в заданном направлении до стенки, минуя внутренние перегородки    
"""
movements_if_possible!(r::Robot, side::HorizonSide) = while isborder(r,side)==false move_if_possible!(r,side) end 


"""
    movements_if_possible!(r::Robot, side::HorizonSide)

-- Перемещает Робота в заданном направлении на определенное количетво шагов, минуя внутренние перегородки
"""
movements_if_possible!(r::Robot, side::HorizonSide, num_steps::Int) = for _ in 1:num_steps move_if_possible!(r,side) end

"""
    movements_if_possible!(r, sides::NTuple{2,HorizonSide}, num_steps::Vector{Any})

-- перемещает Робота по пути, представленного двумя последовательностями, sides и num_steps 
-- sides - содержит последовательность направлений перемещений
-- num_steps - содержит последовательность чисел шагов в каждом из этих направлений, соответственно; при этом, если длина последовательности sides меньше длины последовательности num_steps, то предполагается, что последовательность sides должна быть продолжена периодически        
"""
function movements_if_possible!(r, sides::NTuple{2,HorizonSide}, num_steps::Vector{Any})
    for (i,n) in enumerate(num_steps)
        movements_if_possible!(r, sides[mod(i-1, length(sides))+1], n)
    end
end

"""
    putmarkers_if_possible!(r::Robot, side::HorizonSide)

-- Ставит маркеры в указанном направлении, пока не наткнется на ограду, минуя внутренние перегородки
"""
function putmarkers_if_possible!(r::Robot, side::HorizonSide)
    putmarker!(r)
    while move_if_possible!(r, side) == true
        putmarker!(r)
    end
end

"""
    putmarkers_if_possible!(r::Robot, side::HorizonSide, count::Int)

-- Ставит маркеры в указанном направлении, минуя внутренние перегородки, пока не обнулится счетчик
"""
function putmarkers_if_possible!(r::Robot, side::HorizonSide, count::Int)
    putmarker!(r)
    while count!=0
        move_if_possible!(r, side)
        putmarker!(r)
        count -= 1
    end
end

"""
    get_num_movements_if_possible!(r::Robot, side::HorizonSide)

-- Перемещает Робота в заданном направлении до стенки, минуя внутренние перегородки, и возвращает сделанное число шагов    
"""
function get_num_movements_if_possible!(r::Robot, side::HorizonSide)
    num_steps = 0 
    while move_if_possible!(r, side) == true
        num_steps += 1
    end 
    return num_steps
end

"""
    mark_and_enumerate_if_possible!(r::Robot, side::HorizonSide)

--  Ставит маркеры в указанном направлении, пока не наткнется на ограду, не считая внутренние перегородки, а также считает количетво шагов сделанных в эту сторону и возвращает их
"""
function mark_and_enumerate_if_possible!(r::Robot, side::HorizonSide)
    num_steps = 0 

    putmarker!(r)
    while move_if_possible!(r, side) == true
        putmarker!(r)
        num_steps += 1
    end 
    return num_steps
end