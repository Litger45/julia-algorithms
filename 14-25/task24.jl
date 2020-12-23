include("../roblib.jl")

function rect_border(r::Robot)
    
    while isborder(r, Left) == false || isborder(r, Down) == false # Перемещаем робота в юго-западный угол
        movements!(r, Down)
        movements!(r, Left)
    end
    
    num_steps = get_num_movements!(r, Right) # определяем размер поля

    max_S = 0
    rect_S = 0
    
    while isborder(r, Up) == false || isborder(r, Right) == false # пока не дойдёт до верхней границы поля
        for side in(Left, Right)
            if isborder(r, Up) == true && isborder(r, Right) == true # дошёл до верхней границы  поля
                break
            end    
            rect_S = search_border(r, side, num_steps)
            if rect_S > max_S
                max_S = rect_S
            end   
            if isborder(r, Up)==false
                move!(r, Up)
            end    
        end    
    end   
    
    print(max_S)
end


function search_border(r::Robot,side::HorizonSide,numsteps::Int)
    
    num_borders = 0
    rect_S = 0
    
    num_steps = 0
    length = 0
    
    state=false
    
    while numsteps != 0 # сделано так , а не через for , т.к. при обходе прямоугольной нужно уменьшать количество шагов
        if isborder(r,side) == false
            move!(r,side)
            numsteps-=1
            if isborder(r, Up) == true
                state = true
                num_borders += 1
            else
                state=false
                if num_borders > 0
                    length = num_borders
                    rect_S = check(r,side, length)  
                end    
                num_borders = 0
            end  
        else # обходит вертикальную перегородку
            while isborder(r, side) == true
                move!(r, Down)
                num_steps+=1
            end
            move!(r, side)
            numsteps -= 1 
            while isborder(r, Up) == true # на случай, если мы обходим прямоугольную
                move!(r, side)    
                numsteps -= 1
            end        
            for _ in 1:num_steps
                move!(r, Up)
            end
            num_steps = 0
        end
    end
    
    return(rect_S)
end

function check(r::Robot,side::HorizonSide, length::Int) # проверяем , имеется ли перегородка , совмещённая с горизонтальной , если да, то значит мы нашли прямоугольную
    width = 0
    
    move!(r, Up)
    
    if isborder(r, inverse(side)) == true
        width = find_width(r,side)
        for _ in 1: width + 1
            move!(r, Down)
        end    
    else
        move!(r, Down)
    end
    
    return(width * length)
end

function find_width(r::Robot, side::HorizonSide)
    width = 0
    
    while isborder(r,inverse(side))==true
        width += 1
        move!(r, Up)
    end
    
    return(width)    
end