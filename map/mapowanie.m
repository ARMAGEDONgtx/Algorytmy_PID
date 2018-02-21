
FIT = ones(500,500);

Ti = 10;

for KP = 1:1:500
    for TD = 1:1:500
            kp = KP/10;  
            Td = TD/10;
            sim('regulator');
            FIT(KP,TD) = ISE(end);
            KP
            TD
    end
end

