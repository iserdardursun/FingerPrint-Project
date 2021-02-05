clc,clear,close all
load database person minutiae
[m,n]=size(minutiae);
for i=2:n
    for j=1:m

        
         gecici= table2array(minutiae(j,i));
         
         if i==5
             gecici=cell2mat(gecici);
         end
         [p,k]=size(gecici);
         if(k>=4)
             if k==4
         gecici=reshape(gecici,2,2).';
         gecici=decrypt(gecici,5,'araba');
         gecici=str2num(gecici);
         data(j,i)=gecici;
             else
                 gecici=reshape(gecici,3,3).';
                 gecici=decrypt(gecici,5,'araba');
                 gecici=str2num(gecici);
                 data(j,i)=gecici;
             end
         else 
         gecici=decrypt(gecici,5,'araba');
         gecici=str2num(gecici);
         data(j,i)=gecici;
             end
         end
end
    temp=minutiae(:,1);
    
   
    
    yeni_data=struct('ID',temp(:,1),'X',data(:,2),'Y',data(:,3),'Type',data(:,4),'Angle',data(:,5),'S1',data(:,6),'S2',data(:,7));
    yeni_data=struct2table(yeni_data);
         
        
 
           
           