function y = output_memory_curve(memory_curve,grid)

    y = -grid.Vals(1,end);
   
    for k=2:length(memory_curve)
        Qk = interp2(grid.X,grid.Y,grid.Vals,memory_curve(k,1),memory_curve(k,2))-...
             interp2(grid.X,grid.Y,grid.Vals,memory_curve(k,1),memory_curve(k-1,2));

        y = y +  2*Qk;
    end
end