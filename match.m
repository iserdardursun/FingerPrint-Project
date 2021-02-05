% Parmak izi eşleştirme skoru
%
% Kullanım:  [ S ] = match( M1, M2, display_flag );
%
% Parametreler:   M1 -  First Minutiae 
%             M2 -  Second Minutiae
%             display_flag
%               
% Return:    S - En iyi eşleşen veri satırının benzerlik skoru.

%{
count1=veritabanının satır sayısı
count2=parmak izi verisinin satır sayısı

işlemler:

1-count1 kadar dönen for döngüsü açılır

2-T1=veritabanındaki değerler transform fonksiyonu ile dönüştürülür.

3-count2 kadar dönen bir for döngüsü açılır

4-Parmak izi tipi eşleşiyorsa işlemlere devam eder

5-T2=Parmak izi değerleri transform fonksiyonu ile dönüştürülür.

6- -5'den 5'e kadar dönen for oluşturulur. (-5 ve 5 burada dereceyi temsil eder)

7- Transform2 fonksiyonu ve a açısı kullanılarak T2 verileri dönüştürülür.

8- S, en iyi eşleşme skoruna eşitlenir. Aynı şekilde bi,bj,ba da en iyi
eşleşme skorunun i j ve a değerleri olacak şekilde eşitlenir. bunun amacı
hangi değerlerin hangi değerlerle en iyi eşleştiğini ve bu eşleşme skorunun
kaç olduğunu tutmaktır.
%}

function [ S ] = match( M1, M2, display_flag )
    if nargin==2; display_flag=0; end %eğer fonksiyon sadece M1 ve M2 değerleri ile çağrılırsa display_flag=0 olarak kabul edilir.
    M1=M1(M1(:,3)<5,:);
    M2=M2(M2(:,3)<5,:);    
    count1=size(M1,1); count2=size(M2,1); 
    bi=0; bj=0; ba=0; % En iyi eşleşen veri satırının i,j,alpha değerleri
    S=0;            % En iyi eşleşen veri satırının benzerlik skoru.
    for i=1:count1
        T1=transform(M1,i);
        for j=1:count2
            if M1(i,3)==M2(j,3)
                T2=transform(M2,j);
                for a=-5:5                      %Alpha
                    T3=transform2(T2,a*pi/180);
                    sm=score(T1,T3);
                    if S<sm
                        S=sm;
                        bi=i; bj=j; ba=a;
                    end                
                end
            end
        end
    end
    
    %KULLANMIYORUZ
    if display_flag==1
        figure, title(['Similarity Measure : ' num2str(S)]);
        T1=transform(M1,bi);
        T2=transform(M2,bj);
        T3=transform2(T2,ba*pi/180);
        plot_data(T1,1);
        plot_data(T3,2);
    end
    
end