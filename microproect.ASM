format PE console

entry start

include 'win32a.inc'

section '.data' data readable writable

        ru db 'Russian',0   ; ��� ������� ������

        string db 'n: %u fn=: %u',13,10,0 ;������ ��� ������ ������������� �������� ��� ������������
        ;u -����� ��� �����
        res db '�����: n=%u ������������ n, ��� ������� �� ����� ������������.',13,10,0 ;
        t1 dd 0  ;t_n-1-�� �������
        t2 dd 0  ;t_n-2
        t3 dd 0  ;t_n-3
        t4 dd 1  ;t_n-4
        tn dd ?  ;n-�� �������
        ans dd 3 ;n - �������� � 4( �� +=1 ������ ����� �������, ��� ������ ������� ������ ���� 4, ������� ������������� ���� 3

        NULL = 0

section '.code' code readable executable

        start:
               cinvoke setlocale,0,ru ;������������� ������� ������
               mov eax,0
               mov [tn],0       ;�������� ������� �������
               mov eax, [t1]    ;���������� � ������� ��� ����������� ����������
               add [tn], eax    ;���������� ������� ������� � ������ (tn=tl)
        jc output               ;��������� � �����(output) ���� ���� ������������
                                ;��������� ����� ������� ��������
               mov eax, [t2]    ;���������� � ������� ��� ����������� ����������
               add [tn], eax    ;���������� ������� ������� �� ������ (tn=t1+t2)
        jc output               ;��������� �� ������������
               mov eax, [t3]    ;���������� � ������� ��� ����������� ����������
               add [tn], eax    ;���������� ������� ������� �� ������ (tn=t1+t2+t3)
        jc output               ;��������� �� ������������
               mov eax, [t4]    ;���������� � ������� ��� ����������� ����������
               add [tn],eax     ;���������� ������� ������� �� ������ (tn=t1+t2+t3+t4)
        jc output               ;��������� �� ������������
                inc[ans]        ;���� ������������ �� ����, �� ����������� n �� 1
                mov eax,[t2]    ;�������� ��������: t1<-t2, t2<-t3, t3<-t4; t4<-tn
                mov [t1],eax
                mov eax, [t3]
                mov [t2], eax
                mov eax, [t4]
                mov [t3], eax
                mov eax, [tn]
                mov [t4], eax
                 push [t4]      ;������� f_n
                 push [ans]     ;� n
                 push string    ;�� ����� ����� ���������� ����� �� ������ ����� ��������
                 call [printf]

        jmp start               ;��������� ������

        output:                 ;������� ����� ���������� n �� �����
                push [ans]
                push res
                call [printf]

                call [getch]     ;"������������" �����
                push NULL
                call [ExitProcess]


section '.idata' import data readable

       library kernel,'kernel32.dll',\
                msvcrt,'msvcrt.dll'
 
        import kernel,\
               ExitProcess,'ExitProcess'

                                     ;��������������� ���������� � �������
        import msvcrt,\
               setlocale,'setlocale',\
               printf,'printf',\
               system,'system',\
               getch, '_getch'