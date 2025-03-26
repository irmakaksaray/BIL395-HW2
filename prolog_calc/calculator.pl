:- dynamic var/2.

% Programı başlat
start :-
    write('Çıkmak için "exit." yazın.'), nl,
    loop.

% Kullanıcıdan komutları döngüyle al
loop :-
    write('>> '), flush_output(current_output),
    catch(
        ( read(Input),
          ( Input = exit -> true
          ; process(Input),
            loop
          )
        ),
        Error,
        ( print_message(error, Error), loop )
    ).

% Atama işlemi: x = 5.
process(=(Var, Expr)) :-
    number(Expr),
    atom(Var),
    retractall(var(Var, _)),
    assertz(var(Var, Expr)),
    format('~w = ~w~n', [Var, Expr]).

% Yazdırma işlemi: print(x + 2).
process(print(Expr)) :-
    ( evaluate(Expr, Val)
    -> format('~w~n', [Val])
    ;  true ).

% Doğrudan işlem: x + 3.
process(Expr) :-
    ( evaluate(Expr, Val)
    -> format('Result: ~w~n', [Val])
    ;  true ).

% İfadeleri değerlendir
evaluate(Expr, Val) :-
    Expr =.. [Op, A, B],
    safe_value(A, VA),
    safe_value(B, VB),
    ( compute(Op, VA, VB, Val)
    -> true
    ;  fail ).

% Sayı veya değişken çözümler
safe_value(X, X) :- number(X), !.
safe_value(X, V) :-
    atom(X),
    ( var(X, V)
    -> true
    ;  format('Hata: Tanımsız değişken "~w".~n', [X]),
       fail
    ).

% İşlem tablosu 
compute('+', A, B, R) :- R is A + B.
compute('-', A, B, R) :- R is A - B.
compute('*', A, B, R) :- R is A * B.
compute('/', _, 0, _) :- write('Hata: Sıfıra bölme!'), nl, fail.
compute('/', A, B, R) :-
    catch((R is A / B),
          error(evaluation_error(zero_divisor), _),
          (write('Hata: Sıfıra bölme (catch)!'), nl, fail)).
compute(Op, _, _, _) :-
    ( member(Op, [+, -, *, /]) -> fail
    ; write('Hata: Bilinmeyen işlem.'), nl, fail).
