%--------------------------------------------------------------------------
%fft_enhance_cubs
%enhances the fingerprint image  %Görselin iyileştirmesi
%syntax:
%[oimg,fimg,bwimg,eimg,enhimg] =  fft_enhance_cubs(img, BlockSize)
%oimg -  [OUT] block orientation image(can be viewed using
%        view_orientation_image.m)
%fimg  - [OUT] block frequency image(indicates ridge spacing) %Sırt aralıklarının gösterilmiş hali.
%bwimg - [OUT] shows angular bandwidth image(filter bandwidth adapts near the  %Açısal genişliklerinin çıkarıldığı görsel
%        singular points)
%eimg  - [OUT] energy image. Indicates the 'ridgeness' of a block (can be %parmak izi segmantasyonu için sırtsal bölgeleri negatifsel olarak çıkarır.
%        used for fingerprint segmentation)
%enhimg- [OUT] enhanced image %iyileştirilmiş görsel
%img   - [IN]  input fingerprint image (HAS to be of DOUBLE type) %double türünden img dosyası.
%Contact:
%   ssc5@eng.buffalo.edu
%   www.eng.buffalo.edu/~ssc5
%Reference:
%S. Chikkerur,C. Wu and Govindaraju, "A Systematic approach for 
%feature extraction in fingerprint images",ICBA 2004
%--------------------------------------------------------------------------
function [enhimg, cimg, oimg,fimg,bwimg,eimg] =  fft_enhance_cubs(img, BlockSize)
    global NFFT;

    if BlockSize > 0 
       NFFT        =   32;     %size of FFT %FFT Boyutu
       OVRLP       =   2;      %size of overlap %Üst üste gelme boyutu
       ALPHA       =   0.5;    %root filtering %alfa açısı filtreleme
       RMIN        =   4;%%3;  %min allowable ridge spacing %izin verilen en az sırt aralığı
       RMAX        =   40;     %maximum allowable ridge spacing %izin verilen en fazla sırt aralığı
       ESTRETCH    =   20;     %for contrast enhancement %kontrast iyili için
       ETHRESH     =   19;      %threshold for the energy %enerji için eşik
    else 
       NFFT        =   32;     %size of FFT 
       BlockSize   =   12;     %size of the block
       OVRLP       =   6;      %size of overlap
       ALPHA       =   0.5;    %root filtering
       RMIN        =   3;      %min allowable ridge spacing
       RMAX        =   18;     %maximum allowable ridge spacing
       ESTRETCH    =   20;     %for contrast enhancement
       ETHRESH     =   6;      %threshold for the energy
    end
    
    [nHeightImg,nWidhtImg]   =   size(img);  
    img                      =   double(img);    %görsel double tip dönüşümü.
    nBlockHeight             =   floor((nHeightImg-2*OVRLP)/BlockSize);
    nBlockWidht              =   floor((nWidhtImg-2*OVRLP)/BlockSize);
    fftSrc                   =   zeros(nBlockHeight*nBlockWidht,NFFT*NFFT); %Görselin boyutunu ve FFT için verilen 32x32'lik boyutu, 2 boyutlu bir diziye aktarımı.
    nWindowSize              =   BlockSize+2*OVRLP; %size of analysis window. %Görüntünün ekran boyutu
    %-------------------------
    %allocate outputs %çıktıları matrise çevirme işlemi yapılmıştır.
    %-------------------------
    oimg        =   zeros(nBlockHeight,nBlockWidht);
    fimg        =   zeros(nBlockHeight,nBlockWidht);
    bwimg       =   zeros(nBlockHeight,nBlockWidht);
    eimg        =   zeros(nBlockHeight,nBlockWidht);
    enhimg      =   zeros(nHeightImg,nWidhtImg);
    
    %-------------------------
    %precomputations %ön hesaplamalar.
    %-------------------------
    [x,y]       =   meshgrid(0:nWindowSize-1,0:nWindowSize-1); %windowsSizeı 2 boyutlu array e çevirme işlemi
    dMult       =   (-1).^(x+y); %used to center the FFT
    [x,y]       =   meshgrid(-NFFT/2:NFFT/2-1,-NFFT/2:NFFT/2-1);
    r           =   sqrt(x.^2+y.^2)+eps; %xkare+ykare kök içinde
    th          =   atan2(y,x);%ters tanjantı alınır.
    th(th<0)    =   th(th<0)+pi;
    w           =   raised_cosine_window(BlockSize,OVRLP); %spectral window

    %-------------------------
    %Load filters %açısal filtreleme işlemleri
    %-------------------------
    load angular_filters_pi_4;   %now angf_pi_4 has filter coefficients
    angf_pi_4 = angf;
    load angular_filters_pi_2;   %now angf_pi_2 has filter coefficients
    angf_pi_2 = angf;
    %-------------------------
    %Bandpass filter %şerit geçişleri için filtreleme
    %-------------------------
    FLOW        =   NFFT/RMAX;
    FHIGH       =   NFFT/RMIN;
    
    dRLow       =   1./(1+(r/FHIGH).^4);    %low pass butterworth filter
    dRHigh      =   1./(1+(FLOW./r).^4);    %high pass butterworth filter
    dBPass      =   dRLow.*dRHigh;          %bandpass
    
    %-------------------------
    %FFT Analysis: Fourier Dönüşümü, bir görüntüyü görüntünün frekans alanındaki bir temsili olan gerçek ve hayali bileşenlerine ayrıştırır.
    %Giriş sinyali bir görüntü ise, frekans alanındaki frekansların sayısı görüntüdeki veya 
    %uzaysal alandaki piksel sayısına eşittir. Ters dönüşüm, frekansları uzaysal alanda görüntüye dönüştürür. 
    %
    %FFT, parmak izi görüntüsünün bloklara ayrılmasından sonra ortaya çıkar.
    %Daha sonra | FFT | n ile çarpılır, burada n deneme yanılma ile 2.2 olarak elde edilir.
    %En iyi geliştirme sonuçları, 4 x 4 blok büyüklüğü için elde edildi. 
    %Bu yaklaşımda, sırtlardaki deliklerin yaması ve süreksiz sırtların birleştirilmesi sağlanmıştır.
    %Bu yöntem, farklı geleneksel geliştirme teknikleri ile karşılaştırıldı. Burada 32x32 bloklar kullanılmıştır.


    %-------------------------
    for i = 0:nBlockHeight-1
        nRow = i*BlockSize+OVRLP+1;  
        for j = 0:nBlockWidht-1
            nCol = j*BlockSize+OVRLP+1;
            %extract local block
            blk     =   img(nRow-OVRLP:nRow+BlockSize+OVRLP-1,nCol-OVRLP:nCol+BlockSize+OVRLP-1); %img bloklara bölünüyor. 32x32
            %remove dc
            dAvg    =   sum(sum(blk))/(nWindowSize*nWindowSize);
            blk     =   blk-dAvg;   %remove DC content 
            blk     =   blk.*w;     %multiply by spectral window
            %--------------------------
            %do pre filtering
            %--------------------------
            blkfft  =   fft2(blk.*dMult,NFFT,NFFT); %bloklara ayrılmış img, FFT merkezi üs olarak alınır. Daha sonra 32x32 olan blok ile FFT işlemi yapılır.
            blkfft  =   blkfft.*dBPass;             %band pass filtering %Yüksek ve Düşük frekansları keskinleştirme.
            dEnergy =   abs(blkfft).^2;             %enerji olan yerleri keskinleştirmek için karesi alınmış.
            blkfft  =   blkfft.*sqrt(dEnergy);      %root filtering(for diffusion)
            fftSrc(nBlockWidht*i+j+1,:) = transpose(blkfft(:));
            dEnergy =   abs(blkfft).^2;             %----REDUCE THIS COMPUTATION----
            %--------------------------
            %compute statistics
            %--------------------------
            dTotal          =   sum(sum(dEnergy))/(NFFT*NFFT);
            fimg(i+1,j+1)   =   NFFT/(compute_mean_frequency(dEnergy,r)+eps); %ridge separation
            oimg(i+1,j+1)   =   compute_mean_angle(dEnergy,th);         %ridge angle
            eimg(i+1,j+1)   =   log(dTotal+eps);                        %used for segmentation
        end;%for j
    end;%for i

    %-------------------------
    %precomputations
    %-------------------------
    [x,y]       =   meshgrid(-NFFT/2:NFFT/2-1,-NFFT/2:NFFT/2-1);
    dMult       =   (-1).^(x+y); %used to center the FFT

    %-------------------------
    %process the resulting maps
    %-------------------------
    for i = 1:3
        oimg = smoothen_orientation_image(oimg);            %smoothen orientation image
    end;
    fimg    =   smoothen_frequency_image(fimg,RMIN,RMAX,5); %diffuse frequency image
    cimg    =   compute_coherence(oimg);                    %coherence image for bandwidth
    bwimg   =   get_angular_bw_image(cimg);                 %QUANTIZED bandwidth image
    %-------------------------
    %FFT reconstruction %Burada ise hatlar kesklinleştikten sonra görselin enerji frekanslarını tekrar eski haline getirerek görsel iyilşetirimi yapıldı.
    %-------------------------
    for i = 0:nBlockHeight-1
        for j = 0:nBlockWidht-1
            nRow = i*BlockSize+OVRLP+1;            
            nCol = j*BlockSize+OVRLP+1;
            %--------------------------
            %apply the filters
            %--------------------------
            blkfft  =   reshape(transpose(fftSrc(nBlockWidht*i+j+1,:)),NFFT,NFFT);
            %--------------------------
            %reconstruction
            %--------------------------
            af      =   get_angular_filter(oimg(i+1,j+1),bwimg(i+1,j+1),angf_pi_4,angf_pi_2);
            blkfft  =   blkfft.*(af); 
            blk     =   real(ifft2(blkfft).*dMult);
            enhimg(nRow:nRow+BlockSize-1,nCol:nCol+BlockSize-1)=blk(OVRLP+1:OVRLP+BlockSize,OVRLP+1:OVRLP+BlockSize); %FFT yapılmış görsel tekrardan bloklarla ayrılmış boyutuna geliyor.
        end;%for j
    end;%for i
    %end block processing
    %--------------------------
    %contrast enhancement
    %--------------------------
    enhimg =sqrt(abs(enhimg)).*sign(enhimg);
    mx     =max(max(enhimg));
    mn     =min(min(enhimg));
    enhimg =uint8((enhimg-mn)/(mx-mn)*254+1);%FFT yapılmış görsel üzerinden normalize işlemi yapılıyor.(siyah-beyaz görsel elde ediliyor.)
    
    %--------------------------
    %clean up the image
    %--------------------------
    emsk  = imresize(eimg,[nHeightImg,nWidhtImg]);
    enhimg(emsk<ETHRESH) = 128;
%end function fft_enhance_cubs

%-----------------------------------
%<
%returns 1D spectral window %düşük gelen sinyalleri filtre edip düzenler.
%syntax:
%y = raised_cosine(nBlockSize,nOvrlp)
%y      - [OUT] 1D raised cosine function
%nBlockSize - [IN]  the window is constant here
%nOvrlp - [IN]  the window has transition here
%-----------------------------------
function y = raised_cosine(nBlockSize,nOvrlp)
    nWindowSize  =   (nBlockSize+2*nOvrlp);
    x       =   abs(-nWindowSize/2:nWindowSize/2-1);
    y       =   0.5*(cos(pi*(x-nBlockSize/2)/nOvrlp)+1);
    y(abs(x)<nBlockSize/2)=1;
%end function raised_cosine

%-----------------------------------
%raised_cosine_window %düşük gelen sinyalleri filtre edip düzenler.
%returns 2D spectral window
%syntax:
%w = raised_cosine_window(BlockSize,ovrlp)
%w      - [OUT] 1D raised cosine function
%nBlockSize - [IN]  the window is constant here
%nOvrlp - [IN]  the window has transition here
%-----------------------------------
function w = raised_cosine_window(BlockSize,ovrlp)
    y = raised_cosine(BlockSize,ovrlp);
    w = y(:)*y(:)';
%end function raised_cosine_window
%'
%---------------------------------------------------------------------
%get_angular_filter %Açısal filtrelemeler ile düzletmeler yapar.
%generates an angular filter centered around 'th' and with bandwidth 'bw'
%the filters in angf_xx are precomputed using angular_filter_bank.m
%syntax:
%r = get_angular_filter(t0,bw)
%r - [OUT] angular filter of size NFFTxNFFT
%t0- mean angle (obtained from orientation image)
%bw- angular bandwidth(obtained from bandwidth image)
%angf_xx - precomputed filters (using angular_filter_bank.m)
%-----------------------------------------------------------------------
function r = get_angular_filter(t0,bw,angf_pi_4,angf_pi_2)
    global NFFT;
    TSTEPS = size(angf_pi_4,2);
    DELTAT = pi/TSTEPS;
    %get the closest filter
    i      = floor((t0+DELTAT/2)/DELTAT);
    i      = mod(i,TSTEPS)+1; 
    if(bw == pi/4)
        r      = reshape(angf_pi_4(:,i),NFFT,NFFT)';
    elseif(bw == pi/2)
        r      = reshape(angf_pi_2(:,i),NFFT,NFFT)';
    else
        r      = ones(NFFT,NFFT);
    end;
%end function get_angular_filter


%-----------------------------------------------------------
%get_angular_bw_image
%the bandwidth allocation is currently based on heuristics
%(domain knowledge :)). 
%syntax:
%bwimg = get_angular_bw_image(c)
%-----------------------------------------------------------
function bwimg = get_angular_bw_image(c)
    bwimg   =   zeros(size(c));
    bwimg(:,:)    = pi/2;                       %med bw
    bwimg(c<=0.7) = pi;                         %high bw
    bwimg(c>=0.9) = pi/4;                       %low bw
%end function get_angular_bw


%-----------------------------------------------------------
%get_angular_bw_image
%the bandwidth allocation is currently based on heuristics
%(domain knowledge :)). 
%syntax:
%bwimg = get_angular_bw_image(c)
%-----------------------------------------------------------
function mth = compute_mean_angle(dEnergy,th)
    global NFFT;
    sth         =   sin(2*th);
    cth         =   cos(2*th);
    num         =   sum(sum(dEnergy.*sth));
    den         =   sum(sum(dEnergy.*cth));
    mth         =   0.5*atan2(num,den);
    if(mth <0)
        mth = mth+pi;
    end;
%end function compute_mean_angle

%-----------------------------------------------------------
%get_angular_bw_image
%the bandwidth allocation is currently based on heuristics
%(domain knowledge :)). 
%syntax:
%bwimg = get_angular_bw_image(c)
%-----------------------------------------------------------
function mr = compute_mean_frequency(dEnergy,r)
    global NFFT;
    num         =   sum(sum(dEnergy.*r));
    den         =   sum(sum(dEnergy));
    mr          =   num/(den+eps);
%end function compute_mean_angle
