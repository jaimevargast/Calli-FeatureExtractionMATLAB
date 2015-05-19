% This is the main function:
% it transforms a contour to a robust Curvature Scale Space (CSS) representation 
% (i.e., A. Rattarangsi, and R. T. Chin, "Scale-based detection of corners of planar curves," Pattern Analysis and Machine
% Intelligence, vol. 14, pp. 430-449, Apr. 1992.)
%
% Input:
%       a_contour       - the current contour
%       
%       Display Options: 
%       DISPLAY_NAME      - discription of the the current contour
%       DISPLAY_ORIGINAL - (boolean) if display the original a_contour
%       DISPLAY_STEP     - the steps in which sigma needs to be plotted in
%                          y-axis of CSSI
%       MAX_SUBPLOT      - how many sub plots to have
% Written by Richard Xu @UTS - email, yida.xu@uts.edu.au


function [cssi] = CSSIFunction (a_contour, DISPLAY_NAME, DISPLAY_ORIGINAL, DISPLAY_STEP, MAX_SUBPLOT, SIGMA_MAX, SIGMA_STEP)

% SIGMA_MAX = 120.0;
% SIGMA_STEP = 0.1;
s_index = 1;
f_index = 1;
plot_index = 0;
my_plot_index = 0;

if DISPLAY_ORIGINAL == 1
    
    plot_index = plot_index +1;
    my_plot_index = my_plot_index + 1;
    figure( f_index);
    clf(f_index);
    set(gcf, 'Name', DISPLAY_NAME);
    subplot('position',[(plot_index -1) * (1/MAX_SUBPLOT), 0.3 (1/MAX_SUBPLOT) * 0.9 0.65]);
    draw_contour_subplot (a_contour(:,1), a_contour(:,2));
    
    set(gca,'YDir','reverse');
    title('original');
    hold off;
    
else
    figure(1);
    %set(gcf, 'Visible', 'off');
    set(gcf, 'Name', DISPLAY_NAME);
    draw_contour_subplot (a_contour(:,1), a_contour(:,2));
    set(gca,'DataAspectRatio',[1 1 1], 'PlotBoxAspectRatio',[1 2 1]);
    saveas(gcf,[ DISPLAY_NAME '.bmp']);
    hold off;
    return;
end

clear cssi;

for sigma = 1.0 : SIGMA_STEP : SIGMA_MAX    
    

    
    isPlot = 0;
        
    if DISPLAY_STEP > 0 && sigma > 1.0
        
        p_index = floor((sigma - 1)/SIGMA_STEP) + 1;
        
        if p_index == my_plot_index + DISPLAY_STEP;
            my_plot_index = my_plot_index + DISPLAY_STEP;
            plot_index = plot_index + 1;
            isPlot = 1;
            %display(p_index);
        end
        
    end
        
    zero_crossings = get_cssi_zero_crossings(sigma, a_contour, isPlot, plot_index, MAX_SUBPLOT);
     
    if size(zero_crossings,2) == 1 && zero_crossings(1) == -1
        %fprintf('--- sigma = %f generates no zero-crossings ---\n', sigma);
        break;    
    end
    
    cssi(s_index).sigma = sigma;
    cssi(s_index).zero_crossings = zero_crossings;
        
    if sigma / 2 == ceil(sigma/2) 
        %fprintf('--- process sigma %f ---\n', sigma);
    end
       
    s_index = s_index + 1;


end
   
subplot('position',[0.05 0.05 0.9 0.2]);

for i = 1 : length(cssi)
    
        
	x_range = cssi(i).zero_crossings;
    y_range = repmat(cssi(i).sigma,[1 length(x_range)]);
    plot(x_range,y_range,'.') ;     
    
    hold on;    
end

 
hold off;
