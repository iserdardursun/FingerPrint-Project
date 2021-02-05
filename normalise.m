% NORMALISE - Normalises image values to 0-1, or to desired mean and variance
% NORMALISE - Parmak izinin imajını 0-1 arasında değerlere çevirir. Bu değerlerin ne olacağı parmak izinin özelliklerine göre bağlıdır.
%
% Usage:
%             n = normalise(im)
%
% Offsets and rescales image so that the minimum value is 0
% and the maximum value is 1.  Result is returned in n.  If the image is
% colour the image is converted to HSV and the value/intensity component
% is normalised to 0-1 before being converted back to RGB.
%
% İmajı minimum 0 ve maksimum 1 değerleri arasında olacak şekilde yeniden ölçeklendirir.
% Sonuç n şeklinde geri döner.
% İmajın renkleri HSVye dönüştürüldüyse, değer/yoğunluk bileşeni RGBye geri 
% dönüştürülmeden 0-1 değerleri arasına tekrar normalize edilir.
%
%
%
%
%             n = normalise(im, reqmean, reqvar)
%
% Arguments:  im      - A grey-level input image.
%             reqmean - The required mean value of the image.
%             reqvar  - The required variance of the image.
%
% Offsets and rescales image so that it has mean reqmean and variance
% reqvar.  Colour images cannot be normalised in this manner.
%
%Normalize Algoritması: Normalize algoritması, görseldeki sayıların birbirlerine çok uzak olmasından dolayı hesaplamayamadığından kullanılıyor.
%Birbirine yakın değerler üretmek için normalize işlemi yapar.
%Örnek: sayılar 2000 ile 4000 arasında değişkenlik gösterecekken, normalize işlemi sonrasında değerler 0-1 arasında bir değere dönüşecektir. 
%Bu da hesaplama işlemlerini daha kolaya indirgeyecektir.
% 
%

% Copyright (c) 1996-2005 Peter Kovesi
% School of Computer Science & Software Engineering
% The University of Western Australia
% http://www.csse.uwa.edu.au/
% 
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, subject to the following conditions:
% 
% The above copyright notice and this permission notice shall be included in 
% all copies or substantial portions of the Software.
%
% The Software is provided "as is", without warranty of any kind.

% January 2005 - modified to allow desired mean and variance


function n = normalise(im, reqmean, reqvar)

    if ~(nargin == 1 | nargin == 3)%Fonksiyondaki argümanlar boş bırakılmamalıdır.
       error('No of arguments must be 1 or 3');
    end
    
    if nargin == 1   % Normalise 0 - 1 %Eğer gelen argüman 1 ise ki o da sadece im argümanı ise.
	if ndims(im) == 3         % Assume colour image  %im parametresinin boyutu  3 ise bu işlemleri yaptırır. Eğer görüntü burada renkli ise ona göre işleme tabi tutup normalize etmesi gerek.
	    hsv = rgb2hsv(im);    %Burada rgb2hsv yaparak renk tonu, doygunluk ve değer olarak dönüştürme yapıyor.
	    v = hsv(:,:,3); 	  %değer türü 3 olacak şekilde v adlı değişkene tanımlama yağpılıyor.
	    v = v - min(v(:));    % Just normalise value component %değer bileşenleri bulunuyor.
	    v = v/max(v(:));	  %normalize işlemi için gerekli adımlardan biri. iki değer arasındaki fark bölü max değer.
	    hsv(:,:,3) = v;		  %son değer hsv işlemine atanıyor.
	    n = hsv2rgb(hsv);	  %görsel normalize halde tekrar eski haline getiriliyor.
	else                      % Assume greyscale 
	    if ~isa(im,'double'), im = double(im); end %Eğer verilen im parametresi double değer ise double türüne convert ediliyor.
	    n = im - min(im(:));  					   %Bu iki satırda ise 2 veri ile normalize işlemi yapılıyor.
	    n = n/max(n(:));						   %n değişkeni ile return ediliyor.
	end
	
    else  % Normalise to desired, mean and variance % İstenilen, ortalama ve varyansa normalize et
	
	if ndims(im) == 3         % colour image? %görsel renkli ise renkli ve 2 boyutlu görseli normalize edemez.
	    error('cannot normalise colour image to desired mean and variance');
	end

	if ~isa(im,'double'), im = double(im); end	%Double olan görseli double türüne çeviriyoruz.
	im = im - mean(im(:));    %im görseli matris türüne çeviriyoruz. ve önceki boyutundan çıkarıyoruz.
	im = im/std(im(:));      % Zero mean, unit std dev % Matrislerin standart sapmaları alınıyor.

	n = reqmean + im*sqrt(reqvar);  %im parametresinin son hali ile reqvar değişkenin kök hali çarpılıyor ve reqmean değişkeni ile toplanıyor. daha sonrasında return ediliyor.
    end
    
