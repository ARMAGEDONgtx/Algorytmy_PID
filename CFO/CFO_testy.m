% TESTOWANE POPULACJA = 100, ITERACJE = 100


Populacja = input('podaj liczbe populacji');
max_kp = input('podaj maxymalna wartosc kp');
max_Td = input('podaj maxymalna wartosc Td');
max_Ti = input('podaj wartosc Ti'); %ZMIANA DO TEST�W
iteracje = input('podaj ilosc krokow');
r1 = 1;
r2 = -1;
v1 = 0.5;
v2 = -0.5;

max_wartosc = [max_kp ,max_Td]; %ZMIANA DO TEST�W
%Cell[kp,  Td, ISE] %ZMIANA DO TEST�W

best_cells = ones(1,3); %ZMIANA DO TEST�W
best_cells(3) = 10000; %ZMIANA DO TEST�W
Cells = ones(Populacja,3); %ZMIANA DO TEST�W

%inicjalizacja obiektow
for i = 1:Populacja
    Cells(i,1) = rand*max_kp;
    %Cells(i,2) = max_Ti; %ZMIANA DO TEST�W
    Cells(i,2) = rand*max_Td;
    kp = Cells(i,1);
    Ti = max_Ti; %ZMIANA DO TEST�W
    Td = Cells(i,2);
    sim('regulator');
    Cells(i,3) = ISE(end); %ZMIANA DO TEST�W
    if (Cells(i,3) < best_cells(1,3))
        best_cells(1) = Cells(i,1);
        best_cells(2) = Cells(i,2); 
        best_cells(3) = Cells(i,3);
        %best_cells(4) = Cells(i,4); %ZMIANA DO TEST�W
    end
end

%podzia� na grupy wg CFO
rozmiar_grupy = floor(Populacja/4);
PierwszaGrupa = ones(rozmiar_grupy,3); %ZMIANA DO TEST�W
DrugaGrupa = ones(rozmiar_grupy,3); %ZMIANA DO TEST�W
TrzeciaGrupa = ones(rozmiar_grupy,3); %ZMIANA DO TEST�W
CzwartaGrupa = ones(Populacja - rozmiar_grupy*3,3); %ZMIANA DO TEST�W

%przypisanie do grup
licznik = 1;
for i = 1:rozmiar_grupy 
    PierwszaGrupa(i) = Cells(licznik);
    licznik = licznik +1;
end
for i = 1:rozmiar_grupy 
    DrugaGrupa(i) = Cells(licznik);
    licznik = licznik +1;
end
for i = 1:rozmiar_grupy 
    TrzeciaGrupa(i) = Cells(licznik);
    licznik = licznik +1;
end
for i = 1:(Populacja - rozmiar_grupy*3)
    CzwartaGrupa(i) = Cells(licznik);
    licznik = licznik +1;
end

%sprawdzanie pokrycia obszapru
wkp = [1];
%wti = [1]; %ZMIANA DO TEST�W
wtd = [1];
wISE = [1];
%glowna petla CFO
for o = 1:iteracje
    temp_points = ones(1,3); %ZMIANA DO TEST�W
    reflection = 0;
    visibility = 0;
    
    AV  = (best_cells(1) + best_cells(2))/2; %ZMIANA DO TEST�W
    %pierwsza grupa
    for i=1:rozmiar_grupy
        for x = 1:2 %ZMIANA DO TEST�W
            reflection = (rand*(r1-r2)+r2)*PierwszaGrupa(i,x); 
            visibility = (best_cells(x) - PierwszaGrupa(i,x));
            temp_points(x) = reflection + visibility;
            if (temp_points(x) > max_wartosc(x))
                temp_points(x) = max_wartosc(x);
            end
            if (temp_points(x) < 0)
                temp_points(x) = 0.00001;
            end
        end
        kp = temp_points(1);
        %Ti = temp_points(2); %ZMIANA DO TEST�W
        Td = temp_points(2); %ZMIANA DO TEST�W
        sim('regulator');
        temp_points(3) = ISE(end); %ZMIANA DO TEST�W
        if(temp_points(3) < best_cells(3)) %ZMIANA DO TEST�W
            best_cells = temp_points;
        end
        if(temp_points(3) < PierwszaGrupa(i,3)) %ZMIANA DO TEST�W
            PierwszaGrupa(i,:) = temp_points;
        end   
        wkp = [wkp, temp_points(1)];
        %wti = [wti, temp_points(2)]; %ZMIANA DO TEST�W
        wtd = [wtd, temp_points(2)]; %ZMIANA DO TEST�W
        wISE = [wISE, temp_points(3)];
    end
    
    display('     kp       Td        ISE');
    display(PierwszaGrupa);
    
    %druga grupa
    for i=1:rozmiar_grupy
        for x = 1:2
            reflection = best_cells(x); 
            visibility = (rand*(v1-v2)+v2)*(best_cells(x) - DrugaGrupa(i,x));
            temp_points(x) = reflection + visibility;
            if (temp_points(x) > max_wartosc(x))
                temp_points(x) = max_wartosc(x);
            end
            if (temp_points(x) < 0)
                temp_points(x) = 0.00001;
            end
        end
        kp = temp_points(1);
        %Ti = temp_points(2);%ZMIANA DO TEST�W
        Td = temp_points(2); %ZMIANA DO TEST�W
        sim('regulator');
        temp_points(3) = ISE(end); %ZMIANA DO TEST�W
        if(temp_points(3) < best_cells(3)) %ZMIANA DO TEST�W
            best_cells = temp_points;
        end
        if(temp_points(3) < DrugaGrupa(i,3)) %ZMIANA DO TEST�W
            DrugaGrupa(i,:) = temp_points;
        end
        wkp = [wkp, temp_points(1)];
        %wti = [wti, temp_points(2)]; %ZMIANA DO TEST�W
        wtd = [wtd, temp_points(2)]; %ZMIANA DO TEST�W
        wISE = [wISE, temp_points(3)];
    end 
    
    display('     kp       Td        ISE');
    display(DrugaGrupa);
    
    %trzecia grupa
    for i=1:rozmiar_grupy
        for x = 1:2
            reflection = best_cells(x); 
            visibility = (rand*(v1-v2)+v2)*(best_cells(x) - AV);
            temp_points(x) = reflection + visibility;
            if (temp_points(x) > max_wartosc(x))
                temp_points(x) = max_wartosc(x);
            end
            if (temp_points(x) < 0)
                temp_points(x) = 0.00001;
            end
        end
        kp = temp_points(1);
        %Ti = temp_points(2); %ZMIANA DO TEST�W
        Td = temp_points(2); %ZMIANA DO TEST�W
        sim('regulator');
        temp_points(3) = ISE(end); %ZMIANA DO TEST�W
        if(temp_points(3) < best_cells(3)) %ZMIANA DO TEST�W
            best_cells = temp_points;
        end
        if(temp_points(3) < TrzeciaGrupa(i,3)) %ZMIANA DO TEST�W
            TrzeciaGrupa(i,:) = temp_points;
        end
        wkp = [wkp, temp_points(1)];
        %wti = [wti, temp_points(2)]; %ZMIANA DO TEST�W 
        wtd = [wtd, temp_points(2)]; %ZMIANA DO TEST�W
        wISE = [wISE, temp_points(3)];
    end 
    
    display('     kp       Td        ISE');
    display(TrzeciaGrupa);
    
    %czwarta grupa
    for i=1:rozmiar_grupy
        for x = 1:2
            reflection = rand*max_wartosc(x); 
            visibility = 0;
            temp_points(x) = reflection + visibility;
            if (temp_points(x) > max_wartosc(x))
                temp_points(x) = max_wartosc(x);
            end
            if (temp_points(x) < 0)
                temp_points(x) = 0.00001;
            end
        end
        kp = temp_points(1);
        %Ti = temp_points(2); %ZMIANA DO TEST�W
        Td = temp_points(2); %ZMIANA DO TEST�W
        sim('regulator');
        temp_points(3) = ISE(end); %ZMIANA DO TEST�W
        if(temp_points(3) < best_cells(3))%ZMIANA DO TEST�W
            best_cells = temp_points;
        end
        if(temp_points(3) < CzwartaGrupa(i,3)) %ZMIANA DO TEST�W
            CzwartaGrupa(i,:) = temp_points;
        end
        wkp = [wkp, temp_points(1)];
        %wti = [wti, temp_points(2)]; %ZMIANA DO TEST�W
        wtd = [wtd, temp_points(2)]; %ZMIANA DO TEST�W
        wISE = [wISE, temp_points(3)];
    end    
    
    display('     kp       Td        ISE');
    display(CzwartaGrupa);
   
end


                
        
        