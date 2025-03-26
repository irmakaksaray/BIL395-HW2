# BIL395 - HW2: Multi-language Simple Calculator Interpreter

This project is a homework assignment for the BIL395 course. It includes the implementation of a simple calculator interpreter in different programming languages. 

## Languages and Folder Structure

Each language implementation is stored in a separate folder:

```
HW2/
├── rust_calc/         # Interpreter implemented in Rust
├── ada_calc/          # Interpreter written in Ada
├── perl_calc/         # Perl interpreter
├── scheme_calc/       # Interpreter in Racket (Scheme)
├── prolog_calc/       # Prolog interpreter
```


## How to Run

### Rust
```bash
cd rust_calc
cargo run
```

## Sample Usage
>> x = 4
x = 4
>> y = x + 3
y = 7
>> print y
7
>> x * y
Result: 28
>> exit
```

### Ada
```bash
cd ada_calc
gnatmake main.adb
./main
```

## Sample Usage
>> x := 4
x =  4
>> y := x + 3
y =  7
>> x * y
Result:  28
>> print x
 4
>> exit


### Perl
```bash
cd perl_calc
perl calculator.pl
```

## Sample Usage
>> x = 4
x = 4
>> y = x + 3
y = 7
>> print y
7
>> x * y
Result: 28
>> exit


### Scheme (Racket)
```bash
cd scheme_calc
racket calculator.scm
```
## Sample Usage
>> x = 4
x = 4
>> y = (+ x 3)
y = 7
>> (* x y)
Result: 28
>> print (+ x 2)
6
>> exit

### Prolog
```bash
cd prolog_calc
swipl
?- [calculator].
?- start.
```

## Sample Usage
>> x = 4.
x = 4
>> y = x + 3.
y = 7
>> print(y).
7
>> x * y.
Result: 28
>> z + 1.
Error: Undefined variable "z".
>> 3 / 0.
Error: Division by zero!
>> exit.
```


