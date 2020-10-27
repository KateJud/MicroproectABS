format PE console

entry start

include 'win32a.inc'

section '.data' data readable writable

        ru db 'Russian',0   ; Для русской локали

        string db 'n: %u fn=: %u',13,10,0 ;Строка для вывода промежуточных значения для пользователя
        ;u -целое без знака
        res db 'Ответ: n=%u максимальное n, при котором не будет переполнения.',13,10,0 ;
        t1 dd 0  ;t_n-1-ый элемент
        t2 dd 0  ;t_n-2
        t3 dd 0  ;t_n-3
        t4 dd 1  ;t_n-4
        tn dd ?  ;n-ый элемент
        ans dd 3 ;n - начинаем с 4( но +=1 делаем перед выводом, при первом проходе должно быть 4, поэтому устанавливаем знач 3

        NULL = 0

section '.code' code readable executable

        start:
               cinvoke setlocale,0,ru ;Устанавливаем русскую локаль
               mov eax,0
               mov [tn],0       ;Обнуляем текущий элемент
               mov eax, [t1]    ;Записываем в регистр для последующих вычислений
               add [tn], eax    ;Складываем текущий элемент с первым (tn=tl)
        jc output               ;Переходим к метке(output) если было переполнение
                                ;проверяем после каждого сложения
               mov eax, [t2]    ;Записываем в регистр для последующих вычислений
               add [tn], eax    ;складываем текущий элемент со вторым (tn=t1+t2)
        jc output               ;проверяем на переполнение
               mov eax, [t3]    ;Записываем в регистр для последующих вычислений
               add [tn], eax    ;складываем текущий элемент со вторым (tn=t1+t2+t3)
        jc output               ;проверяем на переполнение
               mov eax, [t4]    ;Записываем в регистр для последующих вычислений
               add [tn],eax     ;складываем текущий элемент со вторым (tn=t1+t2+t3+t4)
        jc output               ;проверяем на переполнение
                inc[ans]        ;Если переполнения не было, то увеличиваем n на 1
                mov eax,[t2]    ;Сдвигаем элементы: t1<-t2, t2<-t3, t3<-t4; t4<-tn
                mov [t1],eax
                mov eax, [t3]
                mov [t2], eax
                mov eax, [t4]
                mov [t3], eax
                mov eax, [tn]
                mov [t4], eax
                 push [t4]      ;Выводим f_n
                 push [ans]     ;и n
                 push string    ;на экран после вычисления суммы на каждом этапе рекурсии
                 call [printf]

        jmp start               ;Повторяем заново

        output:                 ;выводим номер последнего n на экран
                push [ans]
                push res
                call [printf]

                call [getch]     ;"Замораживаем" экран
                push NULL
                call [ExitProcess]


section '.idata' import data readable

       library kernel,'kernel32.dll',\
                msvcrt,'msvcrt.dll'
 
        import kernel,\
               ExitProcess,'ExitProcess'

                                     ;импортированные библиотеки и функции
        import msvcrt,\
               setlocale,'setlocale',\
               printf,'printf',\
               system,'system',\
               getch, '_getch'