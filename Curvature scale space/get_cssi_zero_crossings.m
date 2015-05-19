% This function detects all the zero-crossings of a contour
% Input:
%       sigma     - sigma of a Gaussian kernel
%       a_contour - the procssing contour
%       isPlot    - debug
%       MAX_SUBPLOT - how many subplots to generate

function cssi_zero_crossings = get_cssi_zero_crossings(sigma, a_contour , isPlot, plot_index, MAX_SUBPLOT)

    ksize = ceil(sigma * 8.0);
    
    % ------- G ------
	for u = 1 : ksize
		x = u - ksize / 2;
		G(u) =  exp(- x^2 / (2.0 * sigma^ 2))/sigma/sqrt(2.0*pi);
	end
	G = G / sum(G);
	
	
	% ------- Gu -------
	for u = 1: ksize-1
		Gu(u) = G(u+1) - G(u);
	end
	Gu(ksize) = 0.0;
	
	
	% ------- Guu -------
	for u = 1: ksize-1
		Guu(u) = Gu(u+1) - Gu(u);
	end
	Guu(ksize) = 0.0;
		

	Xcor = Convolution(a_contour(:,1),G);
	Ycor = Convolution(a_contour(:,2),G);
	
	Xcor_u = Convolution(a_contour(:,1),Gu);
	Ycor_u = Convolution(a_contour(:,2),Gu);
	
	Xcor_uu = Convolution(a_contour(:,1),Guu);
	Ycor_uu = Convolution(a_contour(:,2),Guu);   
    

	
	% ------- Kappa --------
	
	for k=1: size(a_contour,1)
		kappa(k) = (  Xcor_u(k) * Ycor_uu(k) - Xcor_uu(k) * Ycor_u(k) ) / ( (Xcor_u(k)^2 + Ycor_u(k)^2 )^(3/2) );
	end
	
	
	% ------- Zero crossing --------
 
    c_index = 1;
    
    cssi_zero_crossings(1) = -1;
    
	for k=1: size(a_contour,1)
        
		if k==1
			k_previous = size(a_contour,1);
		else
			k_previous = k -1;
        end
        
		k_current = k;
			
        if ( ( kappa(k_current) > 0.0000 && kappa(k_previous) < 0.0000 ) || ( kappa(k_current) < 0.0000 && kappa(k_previous) > 0.0000) )
             cssi_zero_crossings(c_index) = k_current;
             c_index = c_index + 1;
        end
        
	end

    if isPlot == 1 && plot_index <= MAX_SUBPLOT
 
        %figure(f_index);
        subplot('position',[(plot_index -1) * (1/MAX_SUBPLOT), 0.3 (1/MAX_SUBPLOT) * 0.8 0.65]);
        draw_contour_subplot ( Xcor, Ycor);
        set(gca,'YDir','reverse');
        
        title(['\sigma = ' num2str(sigma) ]);
        
        if cssi_zero_crossings(1) ~= -1 
        
            % plot the points of inflections
            for i = 1:size(cssi_zero_crossings,2)
                inflexPts_X(i) = Xcor(cssi_zero_crossings(i));
                inflexPts_Y(i) = Ycor(cssi_zero_crossings(i));
            end


            h=plot(inflexPts_X,inflexPts_Y,'*');

            %get(h);
            set(h,'color',[1.0 0.0 0.0]);
        
        end
        
        hold off;
    end
    
    
    