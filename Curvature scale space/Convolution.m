function output_signal = Convolution (input_signal, kernel);
	
	if size(input_signal,2) < size(input_signal,1)
      input_signal = input_signal';
    end 

    
    %fprintf('size(input_signal,2) = %d, size(kernel,2) = %d)\n', size(input_signal,2), size(kernel,2));  

    for  i = 1: size(input_signal,2)
		
        output_signal(i) = 0.0;

		for k = 1: size(kernel,2)
			
			input_signal_pos = k + i - ceil(size(kernel,2)/ 2);

			% (0) -> size(input_signal,2)
			if input_signal_pos < 1
				input_signal_pos = size(input_signal,2) + input_signal_pos;
            end
            
			% size(input_signal,2) -> (0)
			if (input_signal_pos > size(input_signal,2))
				input_signal_pos = input_signal_pos - size(input_signal,2);
            end	
				
			output_signal(i) =	output_signal(i) + input_signal(input_signal_pos) * kernel(k);	
			
        end

    end