function y = bilin_interp (queryPoint, grid, xRange, yRange)
    [nY, nX] = size(grid);

    dX = abs(diff(xRange))/...
             (nX-1);
    dY = abs(diff(yRange))/...
             (nY-1);

    x = queryPoint(1);
    y = queryPoint(2);
    
    x(x<xRange(1)) = xRange(1);
    x(x>=xRange(2)) = xRange(2)-1e-6;
    
    idxX = (x-xRange(1))/dX;
    idxX = floor(idxX);
    
    x1 = idxX*dX+xRange(1);
    x2 = (idxX+1)*dX+xRange(1);
    
    y(y<yRange(1)) = yRange(1);
    y(y>=yRange(2)) = yRange(2)-1e-6;

    idxY = (y-yRange(1))/dY;
    idxY = floor(idxY);
    
    y1 = idxY*dY+yRange(1);
    y2 = (idxY+1)*dY+yRange(1);
    
      %// 4 Neighboring Pixels
      idxX = idxX+1;
      idxNextX = idxX+1;
      idxY = idxY+1;
      idxNextY = idxY+1;
          NP1 = grid(idxY,idxX);
          NP2 = grid(idxY,idxNextX);
          NP3 = grid(idxNextY,idxX);
          NP4 = grid(idxNextY,idxNextX);
      %// 4 Pixels Weights
          dv = 1/((x2-x1)*(y2-y1));

          PW1 = (y2-y)*(x2-x);
          PW2 = (y2-y)*(x-x1);
          PW3 = (x2-x)*(y-y1);
          PW4 = (y-y1)*(x-x1);
          y = PW1 * NP1 + PW2 * NP2 + PW3 * NP3 + PW4 * NP4;
          y = dv*y;

end