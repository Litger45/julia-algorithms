include("../roblib.jl")

function horizion_borders(r::Robot)
    
    while isborder(r, Left)==false || isborder(r, Down)==false
        moves!(r, Down)
        moves!(r, Left)
    end
    
    num_steps = get_num_movements!(r, Right) # определяем размер поля
    num_borders = 0
    
    while isborder(r, Up) == false || isborder(r, Right) == false # пока не дойдёт до верхней границы поля
        for side in(Left, Right)
            if isborder(r, Up) == true && isborder(r, Right) == true # дошёл до верхней границы  поля
                break
            end    
            num_borders += search_border(r, side, num_steps)
            if isborder(r, Up)==false
                move!(r, Up)
            end    
        end    
    end   
    
    print(num_borders)
end  

function search_border(r::Robot, side::HorizonSide, numsteps::Int)
    num_borders = 0
    num_steps = 0
    state = false
    
    for _ in 1:numsteps
        if isborder(r,side)==false
            move!(r,side)
            if isborder(r,Up)==true && state==false
                num_borders += 1
                state = true
            else
                state=false
            end    
        else # обходит вертикальную перегородку
            while isborder(r,side)==true
                move!(r, Down)
                num_steps += 1
            end      
            move!(r, side)       
            for _ in 1:num_steps
                move!(r, Up)
            end
            num_steps=0
        end
    end                   
    
    return(num_borders)
end            