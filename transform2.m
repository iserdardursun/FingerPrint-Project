% TRANSFORM2 FUNCTION
%
% Kullanım:  [ Tnew ] = transform2( T, alpha );
%
% Değişkenler:   T     - transform fonksiyonu kullanılmış parmak izi.
%             alpha - dönüş açısı
%               
% Return:    Tnew  - elde edilen yeni T değerimiz


%{
Transform fonksiyonu kullanılmış parmak izinin üzerinde yeniden işlemler
yapar.

Örnek T çıktısı(sadece 1 satır):
14.5358    3.7028    3.0387         0


İşlemler,

-Count: T'deki satır sayısı

1-Tnew, 4 kolonlu ve Count satırlı boş bir matris olarak oluşturulur.

2-R, gelen alpha açısı ile sinüs ve kosinüs ile matematik işlemler yapıp
matris oluşturur. Örnek R çıktısı:

    -0.9691    0.2469         0
    -0.2469   -0.9691         0
          0         0    1.0000


3-Count kadar döndürülen bir for döngüsü açar, B değişkenini oluşturur.
4- B değişkeni, 
14.5358    3.7028    3.0387         0
gibi olan T değerinden referans olarak aldığı,
0 0 alpha 0
değerlerinin çıkarılmasından oluşturulur. Tüm T değerleri bu şekilde değiştirilmiş
olur.
5- Elde edilen B değerinin transpose'u alınır (B')

R ile B' değerleri matris çarpım yapılarak,
 -149.9155   35.5857   -2.0866    3.0000
gibi(yukarıdaki sadece 1 satırdır. satır sayısı T nin satır sayısı kadardır) Tnew
değeri oluşturulur.


%}

function [ Tnew ] = transform2( T, alpha )
    Count=size(T,1);
    Tnew=zeros(Count,4);
    R=[cos(alpha) sin(alpha) 0 0;...
      -sin(alpha) cos(alpha) 0 0;...
      0 0 1 0; 0 0 0 1];             % Transformation Matrix
    for i=1:Count
        B=T(i,:)-[0 0 alpha 0];
        Tnew(i,:)=R*B';
    end
end