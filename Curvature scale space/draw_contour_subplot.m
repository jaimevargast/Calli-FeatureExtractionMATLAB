function draw_contour_subplot (xcor, ycor)

h = plot(xcor,ycor);
set(h, 'lineWidth',1);
hold on;

h1=plot( xcor(1), ycor(1),'*');   
%get(h1);
set(h1,'color',[0.0 1.0 0.0]);