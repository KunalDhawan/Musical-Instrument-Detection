function x = fft_radix2(x)
	% append zeros to make length of x a power of 2
	next_power = nextpow2(length(x));
	x = [x, zeros(1,(2^next_power)-length(x))];
	
	N = length(x);
	n_stages = log2(N);

	% Data has to be converted to bitreversed order
	x = bitrevorder(x);
    Half = 1;
	for stage = 1:n_stages                                                             
	    for index = 0:(2^stage):(N-1)                                            
	        for n = 0:(Half-1)                                                   
	            pos = n+index+1;                                                                                        
	            w = exp((-1i)*(2*pi)*n/2^stage);
                temp1 = x(pos)+x(pos+Half).*w;                                        
	            temp2 = x(pos)-x(pos+Half).*w;                                       
	            x(pos) = temp1;                                                       
	            x(pos+Half) = temp2;                                                  
	        end
	    end
	Half = 2*Half;                                                                
	end     
end
