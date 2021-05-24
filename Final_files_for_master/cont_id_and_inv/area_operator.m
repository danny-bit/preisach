function [ area_vector ] = area_operator( edge_vector, minmax_coor, pgrid )
%AREA_OPERATOR Summary of this function goes here
%   Detailed explanation goes here
h = (pgrid(2)-pgrid(1))/2;
k = 2;
area_vector = zeros(1,length(edge_vector(1,:)));
for i=1:length(edge_vector(1,:))
    max_y = pgrid(edge_vector(2,i)) + h;
    min_y = pgrid(edge_vector(2,i)) - h;
    max_x = pgrid(edge_vector(1,i)) + h;
    min_x = pgrid(edge_vector(1,i)) - h;
    A_plus = 0;
    A_minus = 0;
    
    %First if the relay element is triangluar, that is the last in the edge
    %vector:
    if i== length(edge_vector(1,:))
        %If edges in the triangle:
        while (k <= length(minmax_coor(1,:))-1 && inpolygon(minmax_coor(1,k),minmax_coor(2,k), [min_x,min_x,max_x], [min_y,max_y,max_y]))
            x_k_1 = minmax_coor(1,k-1);
            x_k = minmax_coor(1,k);
            y_k_1 = minmax_coor(2,k-1);
            y_k = minmax_coor(2,k);
            
            if y_k < y_k_1
                width = x_k - (pgrid(edge_vector(1,i))-h); %can replace pgrid(..)-h with min_x
                height = min(y_k_1 - y_k, pgrid(edge_vector(2,i))+h - y_k); %can replace pgrid(..)+h with max_y
                A_plus = A_plus + width*height;
            elseif x_k > x_k_1
                width = min(x_k-x_k_1,x_k-(pgrid(edge_vector(1,i))-h)); %can replace pgrid(..)-h with min_x
                height = pgrid(edge_vector(2,i))+h-y_k;
                A_minus = A_minus + width*height;
            end
            k = k+1;
        end
        if k < length(minmax_coor(1,:))
            error('Not all corners detected in area_operator');
        end
        x_k_1 = minmax_coor(1,k-1);
        x_k = minmax_coor(1,k);
        y_k_1 = minmax_coor(2,k-1);
        y_k = minmax_coor(2,k);
        
        if x_k > x_k_1
            height = pgrid(edge_vector(2,i))+h - y_k; %can replace pgrid(..)+h with max_y
            width = min(x_k-x_k_1,x_k - (pgrid(edge_vector(1,i))-h)); %can replace pgrid(..)-h with min_x
            A_minus = A_minus + height*width;
            A_minus = A_minus + (height*height)/2;
            height = y_k - (pgrid(edge_vector(2,i))-h); %can replace pgrid(..)-h with min_y
            A_plus = A_plus + (height*height)/2;
        elseif y_k < y_k_1
            width = x_k - (pgrid(edge_vector(1,i))-h); %can replace pgrid(..)-h with min_x
            height = min(pgrid(edge_vector(2,i))+h-y_k, y_k_1-y_k); %can replace pgrid(..)+h with max_y
            A_plus = A_plus + width*height;
            A_plus = A_plus + (width*width)/2;
            width = pgrid(edge_vector(1,i))+h - x_k;%can replace pgrid(..)+h with max_x
            A_minus = A_minus + (width*width)/2;
        else %the point is in the lower or higher corner
            if x_k < pgrid(1)
                A_minus = A_minus + ((2*h)^2)/2;
            else
                A_plus = A_plus + ((2*h)^2)/2;
            end
        end
    else %The preisach element is a square
        iscorner = 0;
        while (k <= (length(minmax_coor(1,:))-1) && max_y >= minmax_coor(2,k) && min_y <= minmax_coor(2,k) && max_x >= minmax_coor(1,k) && min_x <= minmax_coor(1,k))
            iscorner = 1;
            x_k_1 = minmax_coor(1,k-1);
            x_k = minmax_coor(1,k);
            y_k_1 = minmax_coor(2,k-1);
            y_k = minmax_coor(2,k);
            
            if y_k < y_k_1
                if k > 2 && minmax_coor(2,k-2) < max_y
                    width = min(x_k - (pgrid(edge_vector(1,i))-h),x_k_1 - minmax_coor(1,k-2));
                else
                    width = x_k - (pgrid(edge_vector(1,i))-h);
                end
                height = min(2*h,y_k_1-(pgrid(edge_vector(2,i))-h));
                A_plus = A_plus + width*height;
            elseif x_k > x_k_1
                width = min(2*h, (pgrid(edge_vector(1,i))+h) - x_k_1);
                if k > 2 && minmax_coor(1,k-2) > min_x
                    height = min(pgrid(edge_vector(2,i))+h-y_k_1,minmax_coor(2,k-2)-y_k_1);
                else
                    height = pgrid(edge_vector(2,i))+h-y_k_1;
                end
                A_minus = A_minus + width*height;
            end
            k = k+1;
        end
        x_k_1 = minmax_coor(1,k-1);
        x_k = minmax_coor(1,k);
        y_k_1 = minmax_coor(2,k-1);
        y_k = minmax_coor(2,k);
        
        if iscorner
            if y_k < y_k_1
                height = y_k_1 - (pgrid(edge_vector(2,i))-h);
                width = min(x_k_1 - (pgrid(edge_vector(1,i))-h),x_k_1 - minmax_coor(1,k-2));
                A_plus = A_plus + height*width;
                A_minus = A_minus + height*(2*h-(x_k_1 - (pgrid(edge_vector(1,i))-h)));
            elseif x_k > x_k_1
                width = pgrid(edge_vector(1,i))+h - x_k_1;
                height = min(pgrid(edge_vector(2,i))+h - y_k_1, minmax_coor(2,k-2) - y_k_1);
                A_minus = A_minus + width*height;
                A_plus = A_plus + width*(2*h -(pgrid(edge_vector(2,i))+h - y_k_1));
            end
        elseif iscorner ==0
            if y_k < y_k_1
                height = 2*h;
                width = x_k - (pgrid(edge_vector(1,i))-h);
                A_plus = A_plus + height*width;
                A_minus = A_minus + height*(2*h-width);
            elseif x_k > x_k_1
                height = y_k - (pgrid(edge_vector(2,i))-h);
                width = 2*h;
                A_plus = A_plus + height*width;
                A_minus = A_minus + (2*h-height)*width;
            else
                if minmax_coor(end) == pgrid(1);
                    A_plus = 0;
                    A_minus = ((2*h)^2);
                else
                    A_minus = 0;
                    A_plus = ((2*h)^2);
                end
            end
        end
    end
    if i==length(edge_vector(1,:))
        A_plus = A_plus/(((2*h)^2)/2);
        A_minus = A_minus/(((2*h)^2)/2);
        
    else
        A_plus = A_plus/((2*h)^2);
        A_minus = A_minus/((2*h)^2);
    end
    summing = A_plus+A_minus;
    
    %error checking:
    
    if summing < 0.99 && summing > 1.01
        msg = ['A_plus+A_minus = ', num2str(A_plus+A_minus), ', i = ', num2str(i)];
        disp(msg);
        error('A_plus + A_minus is not equal to 1');
    end
    
    area_vector(i) = A_plus - A_minus;
end
end

