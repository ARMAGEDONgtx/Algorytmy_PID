%ALGORYTM PSO DO TESTOWANIA, TYLKO 2 parametry regulatora
%DOSTOSOWANY DO DU¯EJ ILOŒCI KROKÓW(mniejsza populacja, wiecej ruchów) >500



liczba_mrowek = input('podaj liczbe mrowek');
max_kp = input('podaj maxymalna wartosc kp');
max_Td = input('podaj maxymalna wartosc Td');
max_Ti = input('podaj wartosc Ti'); %ZMIANA DO TESTÓW
iteracje = input('podaj liczbe iteracji');
inercja = 2;
%mrowki[kp, Ti, Td,vp,vi,vd]
%pbest[wskaznik,kpbest, Tibest, Tdbest]

mrowki = ones(liczba_mrowek,6);
pbest = ones(liczba_mrowek,4);
%inicjowanie roju(pozycja, predkosc)
for i = 1:liczba_mrowek
    mrowki(i,1) = rand*max_kp;
    mrowki(i,2) = max_Ti; %ZMIANA DO TESTÓW
    mrowki(i,3) = rand*max_Td;
    mrowki(i,4) = max_kp*0.05*(rand+1)*inercja;
    mrowki(i,5) = 0; %ZMIANA DO TESTÓW
    mrowki(i,6) = max_Td*0.05*(rand+1)*inercja;
   
    kp = mrowki(i,1);
    Ti = mrowki(i,2);
    Td = mrowki(i,3);
    sim('regulator');
    
    pbest(i,1) = ISE(end);
    pbest(i,2) = mrowki(i,1);  %na poczatek , pierwsza pozycja jako najelpszea
    pbest(i,3) = mrowki(i,2);
    pbest(i,4) = mrowki(i,3);
    
end

%obliczanie global best 
%best[wskaznik, kpbest, tibest,Tdbest]
gbest = pbest(1,:);
for i=2:liczba_mrowek
    if gbest(1) > pbest(i,1)
        gbest(1) = pbest(i,1);
    end
end

%drogi pokonywane przez mrowki
%droga[kp ti td .... ; nastepna mrowka]
droga_k = mrowki(1,1);
droga_Td = mrowki(1,3);
droga_ISE = ISE(end);
%glowna petla algorytmu
licznik = iteracje;
while licznik > 0 
    %aktualizuj pozycje
    for i = 1:liczba_mrowek
        mrowki(i,1) = mrowki(i,1) + mrowki(i,4)*inercja + (pbest(i,2)-mrowki(i,1))*0.1*rand + (gbest(2)-mrowki(i,1))*0.1*rand;
        %mrowki(i,2) = mrowki(i,2) + mrowki(i,5)*inercja + (pbest(i,3)-mrowki(i,2))*0.1*rand + (gbest(3)-mrowki(i,2))*0.1*rand;
        mrowki(i,3) = mrowki(i,3) + mrowki(i,6)*inercja + (pbest(i,4)-mrowki(i,3))*0.1*rand + (gbest(4)-mrowki(i,3))*0.1*rand;
    end
    
    %aktualizuj pbest i gbest
    for i = 1:liczba_mrowek
        if(mrowki(i,1) > max_kp)
            mrowki(i,1) = max_kp;
        end
        if(mrowki(i,1) <= 0)
            mrowki(i,1) = 0.001;
        end
        if(mrowki(i,3) > max_Td)
            mrowki(i,3) = max_Td;
        end
        if(mrowki(i,3) <= 0)
            mrowki(i,3) = 0.001 ;
        end
        
        kp = mrowki(i,1);
        Ti = mrowki(i,2);
        Td = mrowki(i,3);
        sim('regulator');
        
        if pbest(i,1) > ISE(end) 
            pbest(i,:) = [ISE(end), mrowki(i,1), mrowki(i,2),mrowki(i,3)];
        end
        if (gbest(1,1) > ISE(end)) 
            gbest = [ISE(end), mrowki(i,1), mrowki(i,2),mrowki(i,3)];
        end  
        
        %generowanie drog
        droga_ISE = [droga_ISE, ISE(end)];
        droga_k = [droga_k,mrowki(i,1)];
        droga_Td = [droga_Td,mrowki(i,3)];
        
    end
    
    %sprawdzanie granic, jezeli poza -> nowa predkosc
    for i = 1:liczba_mrowek
        if (mrowki(i,1) == 0.001)
            mrowki(i,4) = max_kp*0.05*(1+rand)*inercja;
        elseif (mrowki(i,1) == max_kp)
            mrowki(i,4) = max_kp*0.05*(-1-rand)*inercja;
        end
        if (mrowki(i,3) == 0.001)
            mrowki(i,6) = max_Td*0.05*(1+rand)*inercja;
        elseif (mrowki(i,3) == max_Td)
            mrowki(i,6) = max_Td*0.05*(-1-rand)*inercja;
        end
    end
    
  
   
    licznik = licznik-1;
    inercja = inercja *0.995; %zmniejszanie inrecji wraz z czasen
    display('     kp       Ti       Td        Vkp       VTi         VTd');
    display(mrowki); %do analizy przemieszczen podczas przebiegu symulacji algorytmu
end




