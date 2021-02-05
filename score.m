% Eşleşme skoru
%
% Kullaım:  [ si ] = score( T1, T2 );
%
% Değişkenler:   T1 -  Transform veya Transform2 fonksiyonları kullanılmış parmak izi verisi
%             T2 -  Transform veya Transform2 fonksiyonları kullanılmış parmak izi verisi
%               
% Return:    sm - Benzerlik skoru

% Vahid. K. Alilou
% Department of Computer Engineering
% The University of Semnan
%
% July 2013

%{
Count1= T1'in satır sayısı
Count2=T2'nin satır sayısı

İşlemler:
-n=0 Score üretmek için gereken değişken oluşturulur.
1-Count1 kadar dönen bir for döngüsü açılır. Her döngüde T matrisinin bir
satırı eşleştirme skoru çıkarmak için denenir.
2-Found=0 ve J=1 değişkenleri while döngüsü içinde kullanılmak üzere
oluşturulur.
3-While döngüsü, Found=0  ve j=Count2 olduğu sürece dönmeye devam eder. Her
döngüde J, 1 artırılır.
4-dx(distance x)=(T1'in dönüştürülmüş x değeri)-(T2'nin dönüştürülmüş x
değeri) matematiksel işlemi ile bulunur.
5-dy(distance y)=(T1'in dönüştürülmüş y değeri)-(T2'nin dönüştürülmüş y
değeri) matematiksel işlemi ile bulunur.
6-d(distance)=(x ve y değerleri arasında pisagor yapılarak iki nokta arasındaki
uzaklığı bulunur)
7- eğer d(distance) eşik olarak belirlenen T(15) değerinden küçük ise
işlemlere devam edilir.
8-İşlem devam ederse;
DTheta(distance Theta)=((T1'in dönüştürülmüş açısı)-(T2'nin dönüştürülmüş açısı)) 180 ile
çarpılıp pi'ye bölünür. Bu şekilde iki açı arasındaki fark bulunmuş olunur.
9-min(DTheta,360-DTheta) bulunur ve eğer bu değer açı içi eşik olarak
belirlenen TT=14 den küçükse o nokta için eşleşme tamamlanmış olur. 
n(Score artırmak için oluşturulan değişken) değeri 1 artırılır, found=1
yapılır ve while dan çıkılmış olunur. For döngüsü devam ettirilerek her
satırdaki değerler için bu doğrulama işlemleri yapılır.
sm(Benzerlik skoru)= sqrt(n^2/(Count1*Count2)) ile belirlenir
%}

function [ sm ] = score( T1, T2 )
    Count1=size(T1,1); Count2=size(T2,1); n=0;
    T=15;  %Mesafe için eşik değeri
    TT=14; %Theta için eşik değeri
    for i=1:Count1
        Found=0; j=1;
        while (Found==0) && (j<=Count2)
            dx=(T1(i,1)-T2(j,1));
            dy=(T1(i,2)-T2(j,2));
            d=sqrt(dx^2+dy^2);    %Euclidean Distance between T1(i) & T2(i)
            if d<T
                DTheta=abs(T1(i,3)-T2(j,3))*180/pi;
                DTheta=min(DTheta,360-DTheta);
                if DTheta<TT
                    n=n+1;        %Artış değeri
                    Found=1;
                end
            end
            j=j+1;
        end
    end
    sm=sqrt(n^2/(Count1*Count2));       %Benzerlik skoru
end