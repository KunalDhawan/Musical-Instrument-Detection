function featurevector = kdmfcc_edited (wav_file,C)    

    Tw = 25;                % analysis frame duration (ms)
    Ts = 10;                % analysis frame shift (ms)
    alpha = 0.97;           % preemphasis coefficient
    M = 20;                 % number of filterbank channels 
    %C = 12;                 % number of cepstral coefficients
    L = 22;                 % cepstral sine lifter parameter
    LF = 300;               % lower frequency limit (Hz)
    HF = 3700;              % upper frequency limit (Hz)
    

    % Read speech samples, sampling rate and precision from file
    [temp, fs ] = audioread( wav_file );
    speech = (temp(:, 1)+temp(:,2))/2;

    % Feature extraction (feature vectors as columns)
    [ out, FBEs, frames ] = ...
                    mfcc( speech, fs, Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
            
     options = statset('MaxIter',1000);
     gmm1=fitgmdist(out',128,'SharedCov',true,'Options',options);
     mean1=gmm1.mu;
     var1=gmm1.Sigma;
     meanfinal=mean1(:);
     varfinal=var1(:);
     featurevector=[meanfinal ; varfinal];
     
end


function [ CC, FBE, frames ] = mfcc( speech, fs, Tw, Ts, alpha, window, R, M, N, L )
    %% PRELIMINARIES 

    % Ensure correct number of inputs

    % Explode samples to the range of 16 bit shorts
    if( max(abs(speech))<=1 ), speech = speech * 2^15; end;

    Nw = round( 1E-3*Tw*fs );    % frame duration (samples)
    Ns = round( 1E-3*Ts*fs );    % frame shift (samples)

    nfft = 2^nextpow2( Nw );     % length of FFT analysis 
    K = nfft/2+1;                % length of the unique part of the FFT 


    %% HANDY INLINE FUNCTION HANDLES

    % Forward and backward mel frequency warping (see Eq. (5.13) on p.76 of [1]) 
    % Note that base 10 is used in [1], while base e is used here and in HTK code
    hz2mel = @( hz )( 1127*log(1+hz/700) );     % Hertz to mel warping function
    mel2hz = @( mel )( 700*exp(mel/1127)-700 ); % mel to Hertz warping function

    % Type III DCT matrix routine (see Eq. (5.14) on p.77 of [1])
    dctm = @( N, M )( sqrt(2.0/M) * cos( repmat([0:N-1].',1,M) ...
                                       .* repmat(pi*([1:M]-0.5)/M,N,1) ) );

    % Cepstral lifter routine (see Eq. (5.12) on p.75 of [1])
    ceplifter = @( N, L )( 1+0.5*L*sin(pi*[0:N-1]/L) );


    %% FEATURE EXTRACTION 

    % Preemphasis filtering (see Eq. (5.1) on p.73 of [1])
    speech = filter( [1 -alpha], 1, speech ); % fvtool( [1 -alpha], 1 );

    % Framing and windowing (frames as columns)
    frames = vec2frames( speech, Nw, Ns, 'cols', window, false );

    % Magnitude spectrum computation (as column vectors)
    MAG = abs( fft(frames,nfft,1) ); 

    % Triangular filterbank with uniformly spaced filters on mel scale
    H = trifbank( M, K, R, fs, hz2mel, mel2hz ); % size of H is M x K 

    % Filterbank application to unique part of the magnitude spectrum
    FBE = H * MAG(1:K,:); % FBE( FBE<1.0 ) = 1.0; % apply mel floor

    % DCT matrix computation
    DCT = dctm( N, M );

    % Conversion of logFBEs to cepstral coefficients through DCT
    CC =  DCT * log( FBE );

    % Cepstral lifter computation
    lifter = ceplifter( N, L );

    % Cepstral liftering gives liftered cepstral coefficients
    CC = diag( lifter ) * CC; % ~ HTK's MFCCs


% EOF

end



function [ frames, indexes ] = vec2frames( vec, Nw, Ns, direction, window, padding )

    % usage information
    usage = 'usage: [ frames, indexes ] = vec2frames( vector, frame_length, frame_shift, direction, window, padding );';

    % default settings 
    switch( nargin )
    case { 0, 1, 2 }, error( usage );
    case 3, padding=false; window=false; direction='cols';
    case 4, padding=false; window=false; 
    case 5, padding=false; 
    end

    % input validation
    if( isempty(vec) || isempty(Nw) || isempty(Ns) ), error( usage ); end;
    if( min(size(vec))~=1 ), error( usage ); end;
    if( Nw==0 || Ns==0 ), error( usage ); end;

    vec = vec(:);                       % ensure column vector

    L = length( vec );                  % length of the input vector
    M = floor((L-Nw)/Ns+1);             % number of frames 


    % perform signal padding to enable exact division of signal samples into frames 
    % (note that if padding is disabled, some samples may be discarded)
    if( ~isempty(padding) )
 
        % figure out if the input vector can be divided into frames exactly
        E = (L-((M-1)*Ns+Nw));

        % see if padding is actually needed
        if( E>0 ) 

            % how much padding will be needed to complete the last frame?
            P = Nw-E;

            % pad with zeros
            if( islogical(padding) && padding ) 
                vec = [ vec; zeros(P,1) ];

            % pad with a specific numeric constant
            elseif( isnumeric(padding) && length(padding)==1 ) 
                vec = [ vec; padding*ones(P,1) ];

            % pad with a low variance white Gaussian noise
            elseif( isstr(padding) && strcmp(padding,'noise') ) 
                vec = [ vec; 1E-6*randn(P,1) ];

            % pad with a specific variance white Gaussian noise
            elseif( iscell(padding) && strcmp(padding{1},'noise') ) 
                if( length(padding)>1 ), scale = padding{2}; 
                else, scale = 1E-6; end;
                vec = [ vec; scale*randn(P,1) ];

            % if not padding required, decrement frame count
            % (not a very elegant solution)
            else
                M = M-1;

            end

            % increment the frame count
            M = M+1;
        end
    end


    % compute index matrix 
    switch( direction )

    case 'rows'                                                 % for frames as rows
        indf = Ns*[ 0:(M-1) ].';                                % indexes for frames      
        inds = [ 1:Nw ];                                        % indexes for samples
        indexes = indf(:,ones(1,Nw)) + inds(ones(M,1),:);       % combined framing indexes
    
    case 'cols'                                                 % for frames as columns
        indf = Ns*[ 0:(M-1) ];                                  % indexes for frames      
        inds = [ 1:Nw ].';                                      % indexes for samples
        indexes = indf(ones(Nw,1),:) + inds(:,ones(1,M));       % combined framing indexes
    
    otherwise
        error( sprintf('Direction: %s not supported!\n', direction) ); 

    end


    % divide the input signal into frames using indexing
    frames = vec( indexes );


    % return if custom analysis windowing was not requested
    if( isempty(window) || ( islogical(window) && ~window ) ), return; end;
    
    % if analysis window function handle was specified, generate window samples
    if( isa(window,'function_handle') )
        window = window( Nw );
    end
    
    % make sure analysis window is numeric and of correct length, otherwise return
    if( isnumeric(window) && length(window)==Nw )

        % apply analysis windowing beyond the implicit rectangular window function
        switch( direction )
        case 'rows', frames = frames * diag( window );
        case 'cols', frames = diag( window ) * frames;
        end

    end


% EOF 
end

function [ H, f, c ] = trifbank( M, K, R, fs, h2w, w2h )
% TRIFBANK Triangular filterbank.
    if( nargin~= 6 ), help trifbank; return; end; % very lite input validation

    f_min = 0;          % filter coefficients start at this frequency (Hz)
    f_low = R(1);       % lower cutoff frequency (Hz) for the filterbank 
    f_high = R(2);      % upper cutoff frequency (Hz) for the filterbank 
    f_max = 0.5*fs;     % filter coefficients end at this frequency (Hz)
    f = linspace( f_min, f_max, K ); % frequency range (Hz), size 1xK
    fw = h2w( f );

    % filter cutoff frequencies (Hz) for all filters, size 1x(M+2)
    c = w2h( h2w(f_low)+[0:M+1]*((h2w(f_high)-h2w(f_low))/(M+1)) );
    cw = h2w( c );

    H = zeros( M, K );                  % zero otherwise
    for m = 1:M 

        % implements Eq. (6.140) on page 314 of [1] 
        % k = f>=c(m)&f<=c(m+1); % up-slope
        % H(m,k) = 2*(f(k)-c(m)) / ((c(m+2)-c(m))*(c(m+1)-c(m)));
        % k = f>=c(m+1)&f<=c(m+2); % down-slope
        % H(m,k) = 2*(c(m+2)-f(k)) / ((c(m+2)-c(m))*(c(m+2)-c(m+1)));

        % implements Eq. (6.141) on page 315 of [1]
        k = f>=c(m)&f<=c(m+1); % up-slope
        H(m,k) = (f(k)-c(m))/(c(m+1)-c(m));
        k = f>=c(m+1)&f<=c(m+2); % down-slope
        H(m,k) = (c(m+2)-f(k))/(c(m+2)-c(m+1));
       
   end

end
