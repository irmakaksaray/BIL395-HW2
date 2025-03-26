use std::collections::HashMap;
use std::io::{self, Write};

fn tokenize(expr: &str) -> Vec<String> {
    let mut tokens = Vec::new();
    let mut current = String::new();

    for c in expr.chars() {
        if c.is_whitespace() {
            continue;
        } else if c.is_ascii_digit() || c.is_alphabetic() {
            current.push(c);
        } else if "+-*/()=".contains(c) {
            if !current.is_empty() {
                tokens.push(current.clone());
                current.clear();
            }
            tokens.push(c.to_string());
        } else {
            // bilinmeyen karakter
            continue;
        }
    }

    if !current.is_empty() {
        tokens.push(current);
    }

    tokens
}

fn eval_expr(tokens: &[String], vars: &HashMap<String, i32>) -> Result<i32, String> {
    let mut values: Vec<i32> = Vec::new();
    let mut ops: Vec<&str> = Vec::new();

    for token in tokens {
        if let Ok(num) = token.parse::<i32>() {
            values.push(num);
        } else if vars.contains_key(token) {
            values.push(*vars.get(token).unwrap());
        } else if ["+", "-", "*", "/"].contains(&token.as_str()) {
            ops.push(token);
        } else {
            return Err(format!("Tanımsız değişken veya geçersiz ifade: {}", token));
        }
    }

    while let Some(op) = ops.pop() {
        if values.len() < 2 {
            return Err("Eksik operand.".to_string());
        }

        let b = values.pop().unwrap();
        let a = values.pop().unwrap();

        let result = match op {
            "+" => a + b,
            "-" => a - b,
            "*" => a * b,
            "/" => {
                if b == 0 {
                    return Err("Sıfıra bölme hatası.".to_string());
                }
                a / b
            }
            _ => return Err("Bilinmeyen işlem.".to_string()),
        };

        values.push(result);
    }

    if values.len() == 1 {
        Ok(values[0])
    } else {
        Err("İfade çözümlenemedi.".to_string())
    }
}

fn main() {
    let mut vars: HashMap<String, i32> = HashMap::new();

    println!("Çıkmak için 'exit' yazın.");
 
    loop {
        print!(">> ");
        io::stdout().flush().unwrap();

        let mut input = String::new();
        if io::stdin().read_line(&mut input).is_err() {
            println!("Girdi okunamadı.");
            continue;
        }

        let trimmed = input.trim();
        if trimmed == "exit" {
            break;
        }

        if trimmed.starts_with("print ") {
            let expr = &trimmed[6..];
            let tokens = tokenize(expr);
            match eval_expr(&tokens, &vars) {
                Ok(val) => println!("{}", val),
                Err(e) => println!("Hata: {}", e),
            }
        } else if trimmed.contains('=') {
            let parts: Vec<&str> = trimmed.split('=').map(|s| s.trim()).collect();
            if parts.len() == 2 {
                let var = parts[0].to_string();
                let expr = parts[1];
                let tokens = tokenize(expr);
                match eval_expr(&tokens, &vars) {
                    Ok(val) => {
                        vars.insert(var.clone(), val);
                        println!("{} = {}", var, val);
                    }
                    Err(e) => println!("Hata: {}", e),
                }
            } else {
                println!("Geçersiz atama.");
            }
        } else {
            let tokens = tokenize(trimmed);
            match eval_expr(&tokens, &vars) {
                Ok(val) => println!("Result: {}", val),
                Err(e) => println!("Hata: {}", e),
            }
        }
    }
}
