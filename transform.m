% COORDINATION TRANSFORM FUNCTION
%
% Kullanım:  [ T ] = transform( M, i );

% Vahid. K. Alilou
% Department of Computer Engineering
% The University of Semnan
%
% July 2013

%{



-------------------------------
 R değişkeni, 
 (
  sinüs,  cosinüs ,0
 -sinüs,  cosinüs ,0
  0    ,  0       ,1
 )
 açıyı kullanarak bir matrise dönüştürür.

 Örnek R çıktısı:
    -0.9691    0.2469         0
    -0.2469   -0.9691         0
          0         0    1.0000

-------------------------------
XRef,YRef,ThRef değişkenleri,
1. satırdaki x,y ve açı değerleridir. Referans olarak bu değerleri alır.
-------------------------------
M değişkeni,
Fonksiyona gelen parmak izinin veritabanına dönüştürülmüş halidir.
-------------------------------
 B değişkeni, 
 (
 M(i,1)-XRef, 
 M(i,1)-YRef, 
 M(i,1)-YRef
 )
 M(i,1) for dönügüsü içinde i değerini artırarak hesaplanıyor. satır satır değer çekiyor. 
 Bunları bir matrise dönüştürüyor(M ve Ref değerleri hemen yukarıda açıklanmıştır.)
 Örnek B çıktısı:
    -36.0000
    -38.0000
     3.3544

-------------------------------
Özet: 
Bu fonksiyon parmak izini veritabanı haliyle alır. Oluşturulan R ve B matrislerini çarpar. 
Çarpımın sonucunu T değişkenine atar ve T'yi return eder.

Örnek T çıktısı(sadece 1 satır):
14.5358    3.7028    3.0387         0


%}


function [ T ] = transform( M, i )
    Count=size(M,1);
    XRef=M(i,1); YRef=M(i,2); ThRef=M(i,4);
    T=zeros(Count,4);
    R=[cos(ThRef) sin(ThRef) 0;...
      -sin(ThRef) cos(ThRef) 0; 0 0 1];  % Transformation Matrix
    for i=1:Count
        B=[M(i,1)-XRef; M(i,2)-YRef; M(i,4)-ThRef];
        T(i,1:3)=R*B;
        T(i,4)=M(i,3);
    end
end