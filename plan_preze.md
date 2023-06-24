1. Hardver
    1. 3D print - štednja na materijalima
    2. Osovine motora plešu
        + aktivne dijelove motora zašerafili na istu stranu
        + duck tape
    3. Link ne može biti zašerafljen na treći motor (pogreška u dizajnu motora)
        + duck tape
    4. Osiguravanje mobilnost end effectora
        + čačkalice
2. Softver
    1. Direktna kinematika
        + koristili smo homogene matrice s predavanja
        + zadnji kut (q4) mora biti takav da je z_T = -z_0 (arccos)
    2. Inverzna kinematika
        + koristiili smo formule s predavanja
    3. Robot control center
    4. Computer Vision
        1. problem sa postavljanjem 3 ravnomjerno raspoređene točke na crnu podlogu
            + bouding box
        2. HSV threshold vrijednosti su hardcoded i zbog toga performanse robota ovise o osvjetljenju - FAT :)
3. Vlastito testiranje i FAT
    1. Body slamming
        + početni kutevi aktuatora prvotno su bili 0/360&deg;, što nije robusno
        + rješenje putem postavljanja referentnih kuteva na 180&deg; 
    2. Problem sa preciznošću u ponajprije Z smjeru, a nakon toga X i Y
        + Kp = 1 (tako da se šalje maksimalna snaga u motore)
        + montiranje end effectora takvo da postoji luft
        + investicija u moćne magnete (više njih)
            1. skriptarnica - nisu dovoljno jaki
            2. Chipoteka neodimijski magneti to the rescue
    