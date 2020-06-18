  /* Petre Alexandra - 325CB */

IMPLEMENTAREA TEMEI

Labelul next_char1
  Se citeste byte cu byte cu lodsb si se evalueaza fiecare element citit
  Daca este operator se apeleaza labelul specific pentru a se efectua operatia
  Daca este un numar atunci se contruieste numarul la labelul creare_numar_pozitiv
  In cazul in care numarul este negativ acest lucru se verifica la
  labelul minus.

creare_numar_pozitiv si creare_numar_negativ
  Se scade din valoarea elementului 48, ca sa fie din valoarea ascii in cea
  reala, dupa se construieste numarul in baza 10 prin inmultiri succesive
  cu 10 si adunari

  Numarul negativ se adauga in stiva dupa ce este transformat in numar negativ (neg),
  initial acesta fiind pozitiv.

Label: adunare// scadere// inmultire // impartire
  Se scot din stiva 2 elemente si se efectueaza operatia sugerata de caracterul
  citit. Rezultatul fiecarei operatii se introduce inapoi in stiva si se continua
  citirea elementelor din expresie.

  Atunci cand se termina expresia se sare la labelul done, unde se extrage din
  stiva rezultatul si se afiseaza.
