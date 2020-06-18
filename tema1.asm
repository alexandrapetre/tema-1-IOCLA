%include "io.inc"

%define MAX_INPUT_SIZE 4096

section .bss
	expr: resb MAX_INPUT_SIZE
section .data
    ;mystring db "85 -73 54 * -73 * -124 / 87 * - 55 + 65 -128 * -",0
    aux dw 0

section .text
global CMAIN
CMAIN:
   mov ebp, esp
	push ebp
	mov ebp, esp
   cld
	GET_STRING expr, MAX_INPUT_SIZE                     ; se muta in sursa expresia
    mov esi, expr
    
    xor ecx, ecx
    xor eax, eax
    
next_char1:
    lodsb                                          ;se muta in al fiecare octet al expresiei
    test al, al                                    ;se testeaza daca a ajuns la final
    jz done      
    cmp al, ' '                                    ;daca in al caracterul este egal cu spatiu se trece la urmatorul byte
    je next_char1
    cmp al, '-'                   ;pentru minus se testeaza in label-ul "minus" daca minusul este de la scadere//numar negativ
    je minus
    cmp al, '+'
    je adunare
    cmp al ,'/'
    je impartire
    cmp al, '*'
    je inmultire
    xor edx, edx
    jmp creare_numar_pozitiv      ;daca byte-ul citit nu este operator sau numar negativ inseamna ca este un nr pozitiv

    leave
    ret
	

minus:                                              ;se creaza numarul negativ daca dupa simbolul "-" nu este spatiu
    xor edx, edx                                    ;altfel se face scaderea intre cele 2 elemente din varful stivei
    xor eax, eax
    lodsb
    test al, al
    je scadere
    cmp al, ' '
    je scadere
        
numar_dec:                                          ; se construieste numarul 
    cmp al, ' '
    je creare_numar_negativ
    imul edx, 10
    sub al, 48
    add edx, eax
    lodsb
    test al, al     
    je next_char1
    jmp numar_dec
    
scadere:                                             ;se extrag 2 elemente din stiva si sa face scaderea
    pop ebx
    pop ecx
    sub ecx, ebx
    push ecx                                         ;se introduce in stiva rezultatul
    xor ecx, ecx
    xor ebx, ebx
    jmp next_char1
    
adunare:                                            ;se extrag 2 elemente din stiva si sa face adunarea
    pop ebx
    pop ecx
    add ecx, ebx
    push ecx                                        ;rezultatul se introduce in stiva
    xor ecx, ecx
    xor ebx, ebx
    jmp next_char1
    
inmultire:                                          ;se extrag din stiva 2 elemente
    pop ebx 
    pop ecx
    imul ecx, ebx                                   ;se efectueaza inmultirea
    push ecx                                        ;se introduce in stiva rezultatul operatiei
    xor ecx, ecx
    xor ebx, ebx
    jmp next_char1                                  ;se trece la urmatorul caracter

impartire:                                          ;se extrag din stiva 2 elemente
    pop eax
    mov dword [aux], eax                            ; am salvat intr-un auxiliar valoarea lui eax 
    pop eax
    xor edx, edx
    cdq
    idiv dword [aux]                                ;se efectueaza operatia de impartire
    mov ecx, eax                                    ;rezultatul salvat in edx se muta in ecx
    push ecx                                        ;se adauga in stiva rezultatul
    xor eax, eax
    xor ecx, ecx
    jmp next_char1

creare_numar_negativ:
    neg edx                                          ;functia neg face dintr-un nr pozitiv unul negativ
    push edx                                         ;se introduce in stiva elementul negativ
    jmp next_char1
    
creare_numar_pozitiv:                                ;se construieste din ascii in decimal numarul
    cmp al, ' '
    je numar_poz
    imul edx, 10
    sub al, 48                                       ;se scade 48
    add edx, eax                                     ;se construieste numarul in baza 10 in registru edx
    lodsb                                            ;se citesc in continuare elemente din sir pana se ajunge la spatiu
    test al, al     
    je next_char1 
    jmp creare_numar_pozitiv

numar_poz:
    push edx                                        ;se introduce in stiva elementul
    jmp next_char1

done:
    pop edx
    PRINT_DEC 4, edx

   leave
    ret
