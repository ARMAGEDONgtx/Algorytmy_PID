Populacja = input('podaj liczbe populacji');
max_kp = input('podaj maxymalna wartosc kp');
max_Td = input('podaj maxymalna wartosc Td');
max_Ti = input('podaj maxymalna wartosc Ti');
iteracje = input('podaj ilosc krokow');
r1 = 1;
r2 = -1;
v1 = 0.5;
v2 = -0.5;

max_wartosc = [max_kp,max_Ti,max_Td];
%Cell[kp, Ti, Td, ISE]

best_cells = ones(1,4);
best_cells(4) = 10000;
Cells = ones(Populacja,4);

%inicjalizacja obiektow
for i = 1:Populacja
    Cells(i,1) = rand*max_kp;
    Cells(i,2) = rand*max_Ti;
    Cells(i,3) = rand*max_Td;
    kp = Cells(i,1);
    Ti = Cells(i,2);
    Td = Cells(i,3);
    sim('regulator');
    Cells(i,4) = ISE(end);
    if (Cells(i,4) < best_cells(1,4))
        best_cells(1) = Cells(i,1);
        best_cells(2) = Cells(i,2); 
        best_cells(3) = Cells(i,3);
        best_cells(4) = Cells(i,4);
    end
end

%podzia³ na grupy wg CFO
rozmiar_grupy = floor(Populacja/4);
PierwszaGrupa = ones(rozmiar_grupy,4);
DrugaGrupa = ones(rozmiar_grupy,4);
TrzeciaGrupa = ones(rozmiar_grupy,4);
CzwartaGrupa = ones(Populacja - rozmiar_grupy*3,4);

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
wti = [1];
wtd = [1];

%glowna petla CFO
for o = 1:iteracje
    temp_points = ones(1,4);
    reflection = 0;
    visibility = 0;
    
    AV  = (best_cells(1) + best_cells(2) + best_cells(3))/3;
    %pierwsza grupa
    for i=1:rozmiar_grupy
        for x = 1:3
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
        Ti = temp_points(2);
        Td = temp_points(3);
        sim('regulator');
        temp_points(4) = ISE(end);
        if(temp_points(4) < best_cells(4))
            best_cells = temp_points;
        end
        if(temp_points(4) < PierwszaGrupa(i,4))
            PierwszaGrupa(i,:) = temp_points;
        end   
        wkp = [wkp, temp_points(1)];
        wti = [wti, temp_points(2)];
        wtd = [wtd, temp_points(3)];
    end
    
    display('     kp       Ti       Td        ISE');
    display(PierwszaGrupa);
    
    %druga grupa
    for i=1:rozmiar_grupy
        for x = 1:3
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
        Ti = temp_points(2);
        Td = temp_points(3);
        sim('regulator');
        temp_points(4) = ISE(end);
        if(temp_points(4) < best_cells(4))
            best_cells = temp_points;
        end
        if(temp_points(4) < DrugaGrupa(i,4))
            DrugaGrupa(i,:) = temp_points;
        end
        wkp = [wkp, temp_points(1)];
        wti = [wti, temp_points(2)];
        wtd = [wtd, temp_points(3)];
    end 
    
    display('     kp       Ti       Td        ISE');
    display(DrugaGrupa);
    
    %trzecia grupa
    for i=1:rozmiar_grupy
        for x = 1:3
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
        Ti = temp_points(2);
        Td = temp_points(3);
        sim('regulator');
        temp_points(4) = ISE(end);
        if(temp_points(4) < best_cells(4))
            best_cells = temp_points;
        end
        if(temp_points(4) < TrzeciaGrupa(i,4))
            TrzeciaGrupa(i,:) = temp_points;
        end
        wkp = [wkp, temp_points(1)];
        wti = [wti, temp_points(2)];
        wtd = [wtd, temp_points(3)];
    end 
    
    display('     kp       Ti       Td        ISE');
    display(TrzeciaGrupa);
    
    %czwarta grupa
    for i=1:rozmiar_grupy
        for x = 1:3
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
        Ti = temp_points(2);
        Td = temp_points(3);
        sim('regulator');
        temp_points(4) = ISE(end);
        if(temp_points(4) < best_cells(4))
            best_cells = temp_points;
        end
        if(temp_points(4) < CzwartaGrupa(i,4))
            CzwartaGrupa(i,:) = temp_points;
        end
        wkp = [wkp, temp_points(1)];
        wti = [wti, temp_points(2)];
        wtd = [wtd, temp_points(3)];
    end    
    
    display('     kp       Ti       Td        ISE');
    display(CzwartaGrupa);
   
end
        
 plot3(wkp,wti,wtd)        
        
        