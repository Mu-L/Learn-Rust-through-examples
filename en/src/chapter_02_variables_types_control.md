# Chapter 2: Variables, Data Types, and Control Flow

## Learning objectives

- Master the basic syntax for declaring and using variables in Rust
- Understand the characteristics and typical use cases of Rust’s data types
- Use control-flow statements to express program logic
- Learn how to define and call functions

---

## 2.1 Variables and mutability

### 2.1.1 Basic variable bindings

In Rust, variables are declared with the `let` keyword and are immutable by default. This means that once a name is bound to a value, you can’t reassign it. This design improves safety and predictability by preventing accidental side effects. Rust can usually infer types automatically, but you can also annotate them explicitly (for example, `let x: i32 = 5;`).

```rust
// Basic variable bindings (immutable)
fn variable_basics() {
    let x = 42;                    // integer
    let y = 3.14;                  // float
    let name = "Rust";             // string literal
    let is_rust_awesome = true;    // boolean
    
    println!("Integer: {}", x);
    println!("Float: {}", y);
    println!("String: {}", name);
    println!("Boolean: {}", is_rust_awesome);
    
    // Variable shadowing
    let x = x + 10;                // creates a new x; the old x is shadowed
    {
        let x = "shadowed";        // another x; the outer x is shadowed in this block
        println!("x inside shadowing: {}", x);
    }
    println!("x after shadowing: {}", x);
}
```

**Result:**

``` shell
Integer: 42
Float: 3.14
String: Rust
Boolean: true
x inside shadowing: shadowed
x after shadowing: 52
```

**Key points**:

- Use `let` to bind a value.
- Identifiers are case-sensitive and typically follow `snake_case`.
- Bindings are scoped to a function/block and are dropped when out of scope (ownership).
  
### 2.1.2 Mutable variables

Rust’s default immutability is strict. If you need to change a value, declare the binding as mutable with the `mut` keyword. This allows reassignment, but you must opt in at declaration time to make the intent explicit. Mutability is scoped: within a scope, a binding is either mutable or immutable—you can’t switch it halfway through.

```rust
fn mutable_variables() {
    // Mutable variable binding
    let mut counter = 0;
    println!("Initial: {}", counter);
    
    // Update a mutable binding
    counter += 1;
    counter *= 2;
    println!("After update: {}", counter);
    
    // A typical use: accumulate in a loop
    let mut sum = 0;  // initialize to 0
    let numbers = vec![1, 2, 3, 4, 5];  // create a vector
    
    for num in numbers {
        sum += num;                // accumulate
    }
    
    println!("Sum: {}", sum);
}
```

**Result:**

``` shell
Initial: 0
After update: 2
Sum: 15
```

**Key points**:

- Declare a mutable binding with `let mut`.
- Mutable bindings can be reassigned.
- Mutability is often used for accumulation in loops and incremental updates.
- Prefer minimizing mutability to reduce accidental changes and bugs.
- Under Rust’s borrowing rules, mutable borrows (`&mut`) are restricted to ensure safety.
- Within a scope, a binding is either mutable or immutable.

Mutable bindings are a key part of Rust’s ergonomics, but in combination with ownership and the borrow checker you’ll sometimes need to structure code carefully to satisfy the compiler.

### 2.1.3 Constants

Constants are declared with the `const` keyword. They are always immutable, and their values must be known at compile time (so they cannot depend on runtime input). If declared at module scope they are globally accessible and live for the entire program. Constants are a good fit for stable configuration values or mathematical constants. A type annotation is required, and `const` cannot be `mut`.

```rust
// Constant declarations (always immutable, must have a type annotation)
fn constants_example() {
    const PI: f64 = 3.14159265359;  // floating-point constant
    const MAX_SIZE: usize = 1000; // unsigned integer constant
    const GREETING: &str = "Hello, World!"; // string slice constant
    
    println!("PI = {}", PI);
    println!("Max size: {}", MAX_SIZE);
    println!("Greeting: {}", GREETING);
    
    // Constant expressions
    const AREA: f64 = PI * 10.0 * 10.0;  // circle area formula
    println!("Circle area: {}", AREA);
}
```

**Result:**

``` shell
PI = 3.14159265359
Max size: 1000
Greeting: Hello, World!
Circle area: 314.15926535899996
```

**Key points**:

- Use the form `const NAME: Type = value;` and name constants in `SCREAMING_SNAKE_CASE`.
- The value must be a constant expression (literals and simple computations); it can’t depend on runtime input.
- `static` is related but has different semantics; `const` is more common for simple values.
- Constants are computed at compile time, improving maintainability and enabling optimization.
- Constants are immutable and represent stable “facts” or configuration.

Constants improve maintainability because they encode immutable “facts” and can be optimized at compile time.

---

## 2.2 Primitive data types

Rust’s primitive data types fall into two categories: scalar types and compound types. Scalars represent a single value; compound types group multiple values. These types have a known size at compile time, which helps Rust deliver safety and performance.

### Scalar types

- **Integers**: signed (`i8`, `i16`, `i32`, `i64`, `i128`, `isize`) and unsigned (`u8`, `u16`, `u32`, `u64`, `u128`, `usize`). Default is `i32`.
- **Floating-point**: `f32` (single precision) and `f64` (double precision, default).
- **Boolean**: `bool`, either `true` or `false`.
- **Character**: `char`, a Unicode scalar value (e.g. `'a'`).

### Compound types

- **Tuples**: fixed-size heterogeneous collections like `(i32, bool)`.
- **Arrays**: fixed-length homogeneous collections like `[i32; 5]` (five `i32`s).

### 2.2.1 Integer types

```rust
fn integer_types() {
    // Signed integers
    let i8_val: i8 = -128;          // range: -128 to 127
    let i16_val: i16 = -32768;      // range: -32768 to 32767
    let i32_val: i32 = -2147483648; // default integer type
    let i64_val: i64 = -9223372036854775808;
    let i128_val: i128 = -170141183460469231731687303715884105728;
    
    // Unsigned integers
    let u8_val: u8 = 255;           // range: 0 to 255
    let u16_val: u16 = 65535;
    let u32_val: u32 = 4294967295;
    let u64_val: u64 = 18446744073709551615;
    let u128_val: u128 = 340282366920938463463374607431768211455;
    
    // Platform-sized integers
    let isize: isize = -1;          // size depends on architecture
    let usize: usize = 1;           // size depends on architecture
    
    // Numeric literals
    let decimal = 98_222;           // decimal (underscores allowed)
    let hex = 0xff;                 // hexadecimal
    let octal = 0o77;               // octal
    let binary = 0b1111_0000;       // binary
    let byte = b'A';                // byte literal (u8 only)
    
    println!("Integer literals: {}, {}, {}, {}", decimal, hex, octal, binary);
}
```

**Result:**

```shell
Integer literals: 98222, 255, 63, 240
```

**Key points:**

- Rust provides both signed and unsigned integers. Signed integers can represent negatives; unsigned integers are non-negative.
- There are multiple widths (8/16/32/64/128-bit) as well as platform-sized `isize`/`usize`.
- `isize` and `usize` depend on the target architecture (commonly 64-bit on modern machines).
- Numeric literals can be written in decimal, hex, octal, and binary; underscores improve readability.
- Integer types have fixed ranges. In debug builds, overflow typically panics; in release builds it wraps (unless you use checked/saturating/wrapping operations).
- Rust offers methods like `wrapping_add`, `checked_add`, and `saturating_add` for explicit overflow behavior.
- ...
  
### 2.2.2 Floating-point types

```rust
fn float_types() {
    let f32_val: f32 = 3.141592653589793; // 32-bit float
    let f64_val: f64 = 3.141592653589793; // 64-bit float (default)

    // Special values
    let infinity = f32::INFINITY;
    let neg_infinity = f32::NEG_INFINITY;
    let not_a_number = f32::NAN;

    println!("f32: {}", f32_val);
    println!("f64: {}", f64_val);
    println!("Infinity: {}", infinity);
    println!("Negative infinity: {}", neg_infinity);
    println!("NaN: {}", not_a_number);

    // Math
    let result = f32::sqrt(2.0);
    println!("√2 = {}", result);

    // Comparisons
    let x: f64 = 1.0;   // explicitly typed
    let y: f64 = 0.1 + 0.1 + 0.1 + 0.1 + 0.1;
    println!("x == y: {}", x == y); // avoid direct float equality when possible
    println!("(x - y).abs() < 1e-10: {}", (x - y).abs() < 1e-10);
}
```

**Result:**

```shell
f32: 3.1415927
f64: 3.141592653589793
Infinity: inf
Negative infinity: -inf
NaN: NaN
√2 = 1.4142135
x == y: false
(x - y).abs() < 1e-10: false
```

**Key points:**

- Rust provides two float types: `f32` and `f64`.
- Floats support special values like infinity, negative infinity, and NaN.
- Floating-point arithmetic is approximate; prefer comparing within an epsilon rather than using direct equality.
- Float operators include addition (+), subtraction (-), multiplication (*), division (/), and remainder (%).
- The standard library provides many floating-point operations such as square root (`sqrt`), exponentiation (`exp`), logarithms (`log`), and trigonometric functions.
- Rust does not perform implicit numeric promotion between integers and floats; use explicit casts (e.g. `x as f64`) when mixing numeric types.
- Floats cannot be “mixed” with booleans or strings in arithmetic; convert/format explicitly when needed.
- ...

### 2.2.3 Boolean type

```rust
fn boolean_types() {
    let is_learning_rust = true;
    let is_difficult = false;

    // Conditional expression
    let message = if is_learning_rust {
        "Keep going!"
    } else {
        "Try harder!"
    };

    // Boolean logic
    let both_true = is_learning_rust && !is_difficult;
    let either_or = is_learning_rust || is_difficult;

    println!("{} {}", message, both_true);
    println!("Either learning or difficult: {}", either_or);

    // Booleans in pattern matching
    match (is_learning_rust, is_difficult) {
        (true, false) => println!("Perfect learning situation!"),
        (true, true) => println!("Challenging but rewarding!"),
        (false, _) => println!("Maybe try something else?"),
    }
}
```

**Result:**

```shell
Keep going! true
Either learning or difficult: true
Perfect learning situation!
```

**Key points:**

- The boolean type has only two values: `true` and `false`.
- Booleans are used in conditions (`if`, `while`) and logical expressions (`&&`, `||`, `!`).
- Rust does not implicitly convert between `bool` and numeric/string types; convert explicitly when needed.

### 2.2.4 Character type

In Rust, a `char` is a Unicode scalar value. You can iterate over the characters of a string with `.chars()`. A `char` is a logical character unit, not a single byte.

A character literal uses single quotes and represents exactly one `char`.
A string is stored as UTF-8 bytes (`[u8]`), and you can view them via `.as_bytes()`.

Note: byte-level operations are efficient, but slicing arbitrary byte offsets may split a multi-byte character and produce invalid UTF-8.

```rust
fn character_types() {
    let c1 = 'z';                          // a single character
    let c2 = 'ℤ';                          // a Unicode character
    let c3 = '😊';                         // an emoji
    
    println!("Chars: {}, {}, {}", c1, c2, c3);
    
    // Escape sequences
    let newline = '\n';
    let tab = '\t';
    let quote = '\'';
    let backslash = '\\';
    
    // Characters in a string
    let string = "Hello, 世界! 🌍";
    for (index, ch) in string.chars().enumerate() {
        println!("Character {}: {}", index, ch);
    }
    
    // Bytes
    let bytes = string.as_bytes();
    println!("String length (bytes): {}", bytes.len());
}
```

**Result:**

```shell
Chars: z, ℤ, 😊
Character 0: H
Character 1: e
Character 2: l
Character 3: l
Character 4: o
Character 5: ,
Character 6:  
Character 7: 世
Character 8: 界
Character 9: !
Character 10:  
Character 11: 🌍
String length (bytes): 19
```

**Key points:**

- A `char` is a Unicode scalar value.
- A `String`/`&str` is UTF-8 bytes; `.as_bytes()` gives you a byte view.
- Use `.chars()` (optionally with `.enumerate()`) to iterate by Unicode scalar values.
- String length in bytes (`.len()`) is not the same as “number of characters”.
- Slicing strings by byte indices can break UTF-8 unless you slice on character boundaries.
- ...

---

## 2.3 Compound types: tuples and arrays

### 2.3.1 Tuples

A tuple is a fixed-length ordered collection that can contain elements of different types. Its length is fixed once created, but the element types can be heterogeneous.

#### Tuple basics

```rust
fn tuple_basics() {
    // Create tuples
    let tup: (i32, f64, u8) = (500, 6.4, 1);
    let tup2 = (42, "Hello", true);
    
    // Access tuple elements (by index)
    let x = tup.0;  // 500
    let y = tup.1;  // 6.4
    let z = tup.2;  // 1
    
    println!("Tuple values: ({}, {}, {})", x, y, z);
    
    // Destructuring assignment (pattern matching)
    let (a, b, c) = tup;
    println!("Destructured: a={}, b={}, c={}", a, b, c);
    
    // Single-element tuple (note the comma)
    let single_tuple: (i32,) = (5,);
    println!("Single-element tuple: {:?}", single_tuple);
}
```

**Result:**

```shell
Tuple values: (500, 6.4, 1)
Destructured: a=500, b=6.4, c=1
Single-element tuple: (5,)
```

**Key points:**

- Tuples are fixed-length ordered collections that can contain mixed types.
- Access elements with `.0`, `.1`, etc.
- Use destructuring (`let (a, b) = tup;`) to bind elements to variables.
- A single-element tuple needs a trailing comma: `(5,)`.
- Tuples are commonly used to return multiple values from a function.
- ...

#### Practical tuple examples

```rust
fn practical_tuples() {
    // Returning multiple values
    let result = divide_and_remainder(17, 5);
    let (quotient, remainder) = result;
    println!("17 divided by 5 => quotient {}, remainder {}", quotient, remainder);
    
    // Destructure directly
    let (sum, product) = calculate_sum_product(10, 20);
    println!("Sum: {}, Product: {}", sum, product);
    
    // Storing mixed-type data
    let person_info = ("Alice", 25, 175.5, true);
    let (name, age, height, is_student) = person_info;
    println!(
        "{} is {} years old, {:.1} cm tall, status: {}",
        name,
        age,
        height,
        if is_student { "student" } else { "not a student" }
    );
    
    // Nested tuple
    let nested_tuple = (1, (2, 3), 4);
    let inner_tuple = nested_tuple.1;
    let first_inner = inner_tuple.0;  // 2
    println!("Value inside nested tuple: {}", first_inner);
}

// Functions returning tuples
fn divide_and_remainder(dividend: i32, divisor: i32) -> (i32, i32) {
    let quotient = dividend / divisor;
    let remainder = dividend % divisor;
    (quotient, remainder)
}

fn calculate_sum_product(a: i32, b: i32) -> (i32, i32) {
    (a + b, a * b)
}
```

**Result:**

```shell
17 divided by 5 => quotient 3, remainder 2
Sum: 30, Product: 200
Alice is 25 years old, 175.5 cm tall, status: student
Value inside nested tuple: 2
```

#### Tuples in pattern matching

```rust
fn tuple_pattern_matching() {
    let coordinates = (10, 20);
    
    match coordinates {
        (0, 0) => println!("Origin"),
        (x, 0) => println!("On the X-axis, x = {}", x),
        (0, y) => println!("On the Y-axis, y = {}", y),
        (x, y) => println!("Point: ({}, {})", x, y),
    }
    
    // Patterns with guards
    let point = (15, 30);
    match point {
        (x, y) if x == y => println!("On the diagonal: ({}, {})", x, y),
        (x, y) if x + y == 45 => println!("x + y is 45: ({}, {})", x, y),
        (x, y) => println!("General point: ({}, {})", x, y),
    }
    
    // Destructure a function result
    let (name, age) = get_person_info();
    println!("Person: {}, age {}", name, age);
}

fn get_person_info() -> (&'static str, u32) {
    ("Bob", 30)
}
```

**Result:**

```shell
Point: (10, 20)
x + y is 45: (15, 30)
Person: Bob, age 30
```

**Key points:**

- Tuples can hold values of different types.
- Pattern matching works well with tuples to extract and transform values.
- Tuples are a common way to return multiple values.
- Destructuring lets you assign multiple bindings at once.
- Match guards (`if ...`) refine patterns with additional conditions.
- ...

### 2.3.2 Arrays

An array is a fixed-length collection of elements of the same type. The length is known at compile time and cannot grow dynamically.

#### Array basics

```rust
fn array_basics() {
    // Declaration and initialization
    let numbers: [i32; 5] = [1, 2, 3, 4, 5];
    let floats = [3.14, 2.71, 1.41, 1.73];  // type inference
    let chars = ['R', 'u', 's', 't'];       // char array
    
    // Indexing
    let first = numbers[0];
    let last = numbers[4];
    println!("First element: {}, last element: {}", first, last);
    
    // Length
    println!("numbers length: {}", numbers.len());
    
    // Repeat initialization
    let repeated = [0; 10];  // length 10, all zeros
    println!("repeated length: {}", repeated.len());
    
    // Iteration
    for (index, &value) in numbers.iter().enumerate() {
        println!("numbers[{}] = {}", index, value);
    }
}
```

**Result:**

```shell
First element: 1, last element: 5
numbers length: 5
repeated length: 10
numbers[0] = 1
numbers[1] = 2
numbers[2] = 3
numbers[3] = 4
numbers[4] = 5
```

**Key points:**

- Array lengths are fixed at compile time and can’t grow dynamically.
- All elements in an array have the same type.
- Index elements with `[index]`.
- Use `.len()` to get the length.
- Use `[value; N]` to initialize an array with repeated values.
- Iterate safely with `.iter()` (immutable) or `.iter_mut()` (mutable).
- Use `.enumerate()` when you need both index and value.
- Use `.get(index)` / `.get_mut(index)` to avoid panics on out-of-bounds access (they return `Option`).
- ...

#### Arrays and loops

```rust
fn array_loops() {
    let arr = [10, 20, 30, 40, 50];
    let mut sum = 0;
    
    // Approach 1: index-based loop
    let len = arr.len();
    for i in 0..len {
        sum += arr[i];
        println!("Add arr[{}] = {}, running sum: {}", i, arr[i], sum);
    }
    println!("Array sum: {}", sum);
    
    // Approach 2: iterate elements directly (safer)
    let mut sum2 = 0;
    for &value in &arr {
        sum2 += value;
        println!("Value: {}", value);
    }
    println!("Recomputed sum: {}", sum2);
    
    // Approach 3: enumerate
    for (i, &value) in arr.iter().enumerate() {
        println!("Index {}: value {}", i, value);
    }
}
```

**Result:**

```shell
Add arr[0] = 10, running sum: 10
Add arr[1] = 20, running sum: 30
Add arr[2] = 30, running sum: 60
Add arr[3] = 40, running sum: 100
Add arr[4] = 50, running sum: 150
Array sum: 150
Value: 10
Value: 20
Value: 30
Value: 40
Value: 50
Recomputed sum: 150
Index 0: value 10
Index 1: value 20
Index 2: value 30
Index 3: value 40
Index 4: value 50
```

**Key points:**

- Use `&arr` / `arr.iter()` for immutable iteration.
- Use `arr.iter_mut()` for mutable iteration.
- Use `enumerate()` when you need indices.
- ...

#### Multidimensional arrays

```rust
fn multidimensional_arrays() {
    // 2D array
    let matrix: [[i32; 3]; 2] = [
        [1, 2, 3],
        [4, 5, 6],
    ];
    
    println!("Matrix contents:");
    for (i, row) in matrix.iter().enumerate() {
        for (j, &value) in row.iter().enumerate() {
            print!("matrix[{}][{}] = {}  ", i, j, value);
        }
        println!();
    }
    
    // Indexing a 2D array
    let element = matrix[1][2];  // row 2, col 3 => 6
    println!("matrix[1][2] = {}", element);
    
    // 3D array example
    let three_d: [[[i32; 2]; 2]; 2] = [
        [[1, 2], [3, 4]],
        [[5, 6], [7, 8]],
    ];
    
    println!("3D array contents:");
    for (i, depth) in three_d.iter().enumerate() {
        for (j, row) in depth.iter().enumerate() {
            for (k, &value) in row.iter().enumerate() {
                print!("[{}][{}][{}] = {}  ", i, j, k, value);
            }
            println!();
        }
    }
}
```

**Result:**

```shell
Matrix contents:
matrix[0][0] = 1  matrix[0][1] = 2  matrix[0][2] = 3
matrix[1][0] = 4  matrix[1][1] = 5  matrix[1][2] = 6
matrix[1][2] = 6
3D array contents:
[0][0][0] = 1  [0][0][1] = 2
[0][1][0] = 3  [0][1][1] = 4
[1][0][0] = 5  [1][0][1] = 6
[1][1][0] = 7  [1][1][1] = 8
```

**Key points:**

- Use `.get()` / `.get_mut()` for safe access without panics (they return `Option`).
- Use `.iter()` with `.enumerate()` to traverse with indices.
- Use `match` (or `if let`) on the returned `Option` to handle out-of-bounds cases.
- For multidimensional arrays, nest loops or iterators per dimension.
- `print!` / `println!` help format output.
- ...

#### Bounds checking

```rust
fn array_bounds_checking() {
    let arr = [10, 20, 30];
    
    // Safe access
    if let Some(&value) = arr.get(1) {
        println!("arr[1] = {}", value);
    }
    
    // Out-of-bounds handling
    match arr.get(5) {
        Some(value) => println!("arr[5] = {}", value),
        None => println!("Out of bounds! Max index: {}", arr.len() - 1),
    }
    
    // Slices (borrowing part of an array)
    let slice = &arr[0..2];  // includes indices 0 and 1
    println!("Slice: {:?}", slice);
    
    let slice_to_end = &arr[1..];  // from index 1 to the end
    println!("Slice from index 1: {:?}", slice_to_end);
    
    let slice_from_start = &arr[..2];  // from start up to index 2 (exclusive)
    println!("Slice up to index 2: {:?}", slice_from_start);
    
    let full_slice = &arr[..];  // the whole array
    println!("Full slice: {:?}", full_slice);
}
```

**Result:**

```shell
arr[1] = 20
Out of bounds! Max index: 2
Slice: [10, 20]
Slice from index 1: [20, 30]
Slice up to index 2: [10, 20]
Full slice: [10, 20, 30]
```

**Key points:**

- Use `.get()` to access elements safely without panics.
- Match on the returned `Option` to handle the absence of a value.
- Use slices (`&arr[a..b]`) to borrow a portion of an array.
- ...

#### Practical array operations

```rust
fn array_operations() {
    let mut numbers = [64, 34, 25, 12, 22, 11, 90];
    
    println!("Original: {:?}", numbers);
    
    // Max and min
    let max = numbers.iter().max().unwrap();
    let min = numbers.iter().min().unwrap();
    println!("Max: {}, Min: {}", max, min);
    
    // Sum and average
    let sum: i32 = numbers.iter().sum();
    let average = sum as f64 / numbers.len() as f64;
    println!("Sum: {}, Average: {:.2}", sum, average);
    
    // Filter and transform
    let even_numbers: Vec<_> = numbers.iter()
        .filter(|&&x| x % 2 == 0)
        .copied()
        .collect();
    println!("Even numbers: {:?}", even_numbers);
    
    let squared: Vec<_> = numbers.iter()
        .map(|&x| x * x)
        .collect();
    println!("Squared: {:?}", squared);
    
    // Membership and position
    let contains_25 = numbers.contains(&25);
    let position = numbers.iter().position(|&x| x == 25);
    println!("Contains 25: {}, position: {:?}", contains_25, position);
    
    // Sort
    let mut sorted = numbers;
    sorted.sort();
    println!("Sorted: {:?}", sorted);
}
```

**Result:**

```shell
Original: [64, 34, 25, 12, 22, 11, 90]
Max: 90, Min: 11
Sum: 258, Average: 36.86
Even numbers: [64, 34, 12, 22, 90]
Squared: [4096, 1156, 625, 144, 484, 121, 8100]
Contains 25: true, position: Some(2)
Sorted: [11, 12, 22, 25, 34, 64, 90]
```

**Key points:**

- `iter()` returns an iterator over references to elements.
- `sum()` reduces an iterator to a total.
- `copied()` turns `&T` into `T` for `Copy` types.
- `filter()` keeps elements matching a predicate.
- `map()` transforms elements.
- `contains()` checks for membership.
- `position()` finds the index of the first match.
- `sort()` sorts in ascending order.
- `enumerate()` yields `(index, item)` pairs.
- ...

#### String arrays and character processing

```rust
fn string_and_char_arrays() {
    // Array of string slices
    let fruits = ["apple", "banana", "orange", "grape"];
    
    for (i, fruit) in fruits.iter().enumerate() {
        println!("fruits[{}] = {}", i, fruit);
    }
    
    // Char array
    let word = ['R', 'u', 's', 't'];
    let word_str: String = word.iter().collect();
    println!("Char array to String: {}", word_str);
    
    // Iterate over chars
    for ch in &word {
        println!("Char: {}", ch);
        // Convert to ASCII code (safe here because these are ASCII letters)
        println!("ASCII: {}", *ch as u8);
    }
    
    // Count characters vs bytes
    let multi_char_str = "你好，世界！ 🌍";
    let chars: Vec<char> = multi_char_str.chars().collect();
    println!("String: {}", multi_char_str);
    println!("Char count: {}", chars.len());
    println!("Byte length: {}", multi_char_str.len());
}
```

**Result:**

```shell
fruits[0] = apple
fruits[1] = banana
fruits[2] = orange
fruits[3] = grape
Char array to String: Rust
Char: R
ASCII: 82
Char: u
ASCII: 117
Char: s
ASCII: 115
Char: t
ASCII: 116
String: 你好，世界！ 🌍
Char count: 8
Byte length: 23
```

**Key points:**

- `iter()` produces an iterator over references.
- `enumerate()` provides indices.
- `collect()` materializes an iterator into a collection.
- `chars()` iterates Unicode scalar values.
- `len()` on `&str` returns the byte length, not the number of characters.
- ...

<!-- (Removed an empty, broken code fence that prevented mdbook from rendering.) -->

#### Arrays in functions

```rust
fn array_in_functions() {
    let arr = [1, 2, 3, 4, 5];
    
    // Pass array slices (borrows)
    let sum = sum_array(&arr);
    let max = max_array(&arr);
    
    println!("Array: {:?}", arr);
    println!("Sum: {}, Max: {}", sum, max);
    
    // Modify via mutable slice
    let mut mut_arr = [10, 20, 30];
    modify_array(&mut mut_arr);
    println!("After modify: {:?}", mut_arr);
    
    // Return a computed Vec
    let squared = square_array(&arr);
    println!("Squared: {:?}", squared);
}

// Sum of a slice
fn sum_array(arr: &[i32]) -> i32 {
    arr.iter().sum()
}

// Max of a slice
fn max_array(arr: &[i32]) -> i32 {
    arr.iter().max().copied().unwrap_or(0)
}

// Modify via mutable slice
fn modify_array(arr: &mut [i32]) {
    for i in 0..arr.len() {
        arr[i] *= 2;
    }
}

// Produce a new Vec
fn square_array(arr: &[i32]) -> Vec<i32> {
    arr.iter().map(|&x| x * x).collect()
}
```

**Result:**

```shell
Array: [1, 2, 3, 4, 5]
Sum: 15, Max: 5
After modify: [20, 40, 60]
Squared: [1, 4, 9, 16, 25]
```

**Key points:**

- Prefer taking `&[T]` (a slice) in function parameters so you can accept arrays and vectors.
- Use `&mut [T]` when the function needs to mutate elements.
- Passing `&arr` borrows the array; ownership is not moved.
- Use `&mut` only when mutation is required.
- ...

---

## 2.4 Strings

### 2.4.1 String literals and slices

In Rust, a string literal is immutable, hard-coded text written with double quotes, like "hello". Its type is `&str` (a string slice) which points to a UTF-8 byte sequence stored in the program binary. More generally, a slice is a view into existing data (e.g. `&[T]`). A string slice `&str` is an immutable view into a string’s UTF-8 bytes.

```rust
fn string_slices() {
    // String literals (&str) are compile-time constants
    let greeting = "Hello, Rust!";
    let name = "World";
    
    // Slices (borrowed views, no ownership)
    // Note: indexing a &str by ranges works only on valid UTF-8 boundaries.
    let slice = &greeting[0..5];              // "Hello"
    let slice_from_middle = &greeting[7..11]; // "Rust"
    
    println!("Full greeting: {}", greeting);
    println!("Slice: {}", slice);
    
    // String methods
    let trimmed = "  hello  ".trim();      // "hello"
    let uppercase = "rust".to_uppercase(); // "RUST"
    let lowercase = "RUST".to_lowercase(); // "rust"
    
    // Search and split
    let text = "one,two,three,four";
    let parts: Vec<&str> = text.split(',').collect();
    println!("Split parts: {:?}", parts);
    
    // Replace
    let replaced = "hello world".replace("world", "Rust");
    println!("Replaced: {}", replaced);
}
```

**Result:**

```shell
Full greeting: Hello, Rust!
Slice: Hello
Split parts: ["one", "two", "three", "four"]
Replaced: hello Rust
```

**Key points:**

- String literals have the `'static` lifetime and are `&'static str`.
- A slice borrows data; it doesn’t own it. String slicing by indices must be on valid UTF-8 boundaries (otherwise it panics).
- `&str` is commonly used in function parameters to avoid unnecessary allocations.
- A `&str` can refer to a string literal or a `String`’s contents.
- Common operations include splitting (`split`), replacing (`replace`), and searching.
- Convert `&str` to `String` with `.to_string()` or `.to_owned()`.
- ...

### 2.4.2 The `String` type

`String` is a growable, mutable, owned UTF-8 string stored on the heap. Unlike `&str`, a `String` owns its data and can be modified (for example, by appending). It dereferences to `&str`, so it can be used where a string slice is expected.

```rust
fn string_type() {
    // `String` owns its data
    let mut s = String::new();              // empty string
    let s1 = String::from("hello");        // from a string literal
    let s2 = "world".to_string();          // to a `String`
    
    // Append
    s.push('A');                            // push a char
    s.push_str("pple");                     // push a string slice
    s += " Banana";                         // append with `+=`
    
    println!("String s: {}", s);
    
    // Formatting
    let name = "Alice";
    let age = 30;
    let formatted = format!("{} is {} years old", name, age);
    println!("Formatted: {}", formatted);
    
    // Using macros
    println!("Test value: {}, another value: {}", 42, "text");
    
    // Ownership example
    let original = String::from("original");
    let moved = original;                   // move ownership
    // println!("{}", original);            // compile error: original was moved
    println!("Moved string: {}", moved);
}
```

**Result:**

```shell
String s: Apple Banana
Formatted: Alice is 30 years old
Test value: 42, another value: text
Moved string: original
```

**Key points:**

- Create a `String` with `String::new()`, `String::from(...)`, or `.to_string()`.
- Append with `push` (char) and `push_str` (string slice).
- Ownership rules apply: after a move, the original binding can’t be used unless you clone.
- `format!` builds a `String` using formatting without printing.
- `println!` prints formatted values.
- ...

---

## 2.5 Control flow

### 2.5.1 `if` expressions

In Rust, `if` is an expression: it can produce a value. Parentheses around the condition are optional, and `else` / `else if` are supported. The condition must be a `bool` (there is no implicit conversion from integers).

```rust
fn conditional_statements() {
    let number = 7;
    
    // Basic if/else
    if number < 5 {
        println!("Number is less than 5");
    } else if number == 5 {
        println!("Number equals 5");
    } else {
        println!("Number is greater than 5");
    }
    
    // `if` as an expression (produces a value)
    let grade = if number >= 90 {
        "A"
    } else if number >= 80 {
        "B"
    } else if number >= 70 {
        "C"
    } else {
        "F"
    };
    
    println!("Grade: {}", grade);
    
    // Conditional assignment
    let status = if number % 2 == 0 {
        "even"
    } else {
        "odd"
    };
    println!("{} is {}", number, status);
}
```

**Result:**

```shell
Number is greater than 5
Grade: F
7 is odd
```

**Key points:**

- `if` chooses branches based on a boolean condition.
- Because `if` is an expression, you can assign its result to a variable.
- All branches used as an expression must evaluate to compatible types.
- Rust does not implicitly convert numeric types to `bool`.
- ...

---

### 2.5.2 Loops

#### `loop` (infinite loop)

`loop` repeats forever until you explicitly `break`. Like many constructs in Rust, it can be used as an expression and can return a value. Labels can help control nested loops.

```rust
fn loop_examples() {
    // Basic loop
    let mut counter = 0;
    loop {
        counter += 1;
        println!("Counter: {}", counter);
        
        if counter >= 5 {
            break;                          // exit the loop
        }
    }
    
    // `loop` as an expression (returns a value)
    let result = loop {
        counter += 1;
        
        if counter == 10 {
            break counter;                 // break with a value
        }
    };
    
    println!("Loop result: {}", result);
}
```

**Result:**

```shell
Counter: 1
Counter: 2
Counter: 3
Counter: 4
Counter: 5
Loop result: 10
```

**Key points:**

- `break` exits a loop.
- `break value` exits and returns a value from a `loop` expression.
- `continue` skips to the next iteration.
- Labels (e.g. `'outer: loop { ... }`) can control which loop to `break`/`continue` in nested loops.
- ...

#### `while` (conditional loop)

`while` repeats while a condition is `true`. The condition must be a `bool`.

```rust
fn while_examples() {
    let mut number = 3;
    
    while number != 0 {
        println!("Countdown: {}", number);
        number -= 1;
    }
    
    println!("Liftoff!");
    
    // Array traversal
    let array = [10, 20, 30, 40, 50];
    let mut index = 0;
    
    while index < array.len() {
        println!("Index {}: value {}", index, array[index]);
        index += 1;
    }
}
```

**Result:**

```shell
Countdown: 3
Countdown: 2
Countdown: 1
Liftoff!
Index 0: value 10
Index 1: value 20
Index 2: value 30
Index 3: value 40
Index 4: value 50
```

**Key points:**

- Rust has no built-in do-while loop; you can simulate it with `loop { ...; if !cond { break } }`.
- Use `while` when you have a loop condition but don’t naturally iterate a collection.
- For arrays/vectors/iterators, prefer `for` loops for safety and clarity.
- ...

#### `for` loops and iterators

`for` iterates over ranges and iterators. Syntax: `for item in iterator { ... }`. It works well with Rust’s ownership model.

```rust
fn for_loop_examples() {
    // Basic for loop
    for i in 0..5 {                        // 0 to 4
        println!("for loop: {}", i);
    }
    
    // Inclusive range
    for i in 0..=5 {                       // 0 to 5
        println!("inclusive: {}", i);
    }
    
    // Array iteration
    let array = [1, 2, 3, 4, 5];
    for item in array {
        println!("array item: {}", item);
    }
    
    // Index + value
    let names = vec!["Alice", "Bob", "Charlie"];
    for (index, name) in names.iter().enumerate() {
        println!("{}: {}", index, name);
    }
    
    // Iterate chars
    let text = "Rust";
    for ch in text.chars() {
        println!("Char: {}", ch);
    }
    
    // Iterate bytes
    for byte in text.bytes() {
        println!("Byte: {}", byte);
    }
}
```

**Result:**

```shell
for loop: 0
for loop: 1
for loop: 2
for loop: 3
for loop: 4
inclusive: 0
inclusive: 1
inclusive: 2
inclusive: 3
inclusive: 4
inclusive: 5
array item: 1
array item: 2
array item: 3
array item: 4
array item: 5
0: Alice
1: Bob
2: Charlie
Char: R
Char: u
Char: s
Char: t
Byte: 82
Byte: 117
Byte: 115
Byte: 116
```

**Key points:**

- `for` loops work over any iterator (ranges, arrays, vectors, strings, etc.).
- `0..5` is a half-open range (0 through 4), while `0..=5` includes 5.
- Use `.enumerate()` when you need indices.
- ...

### 2.5.3 Pattern matching

Pattern matching with `match` lets you destructure values and handle multiple cases. Matches must be exhaustive (or use `_` as a wildcard). Rust supports bindings, guards, and nested patterns.

```rust
fn pattern_matching() {
    let x = 42;
    
    match x {
        0 => println!("zero"),
        1..=10 => println!("between 1 and 10"),
        20 | 30 | 40 => println!("20, 30, or 40"),
        n if n % 2 == 0 => println!("even: {}", n),
        _ => println!("other: {}", x),    // wildcard
    }
    
    // Bind a matched value
    match x {
        0 => println!("zero"),
        1 => println!("one"),
        n => println!("other: {}", n),
    }
    
    // Compound patterns
    let point = (0, 7);
    match point {
        (0, 0) => println!("origin"),
        (0, y) => println!("on the Y axis: y = {}", y),
        (x, 0) => println!("on the X axis: x = {}", x),
        (x, y) => println!("point ({}, {})", x, y),
    }
}
```

**Result:**

```shell
even: 42
other: 42
on the Y axis: y = 7
```

**Key points:**

- `match` must be exhaustive; use `_` as a catch-all.
- Patterns can destructure tuples/structs and bind values.
- Guards (`if ...`) allow additional conditions.
- `if let` / `while let` can simplify matching on `Option`/`Result`.
- `match` can also be used as an expression that returns a value.
- ...

---

## 2.6 Defining and calling functions

### 2.6.1 Function basics

In Rust, a function is a reusable block of code defined with the `fn` keyword. Function names typically use `snake_case`. Functions can take parameters and optionally return a value. Every program has a `main` function as the entry point. Function bodies are enclosed in `{}` and may contain statements and expressions. Rust is statically typed, so parameter and return types are checked at compile time.

```rust
// Function definition
fn greet(name: &str) {
    println!("Hello, {}!", name);
}

// Function with a return value
fn add(a: i32, b: i32) -> i32 {
    a + b                                 // no semicolon => expression is returned
}

// Explicit return
fn multiply(x: i32, y: i32) -> i32 {
    return x * y;
}

// Calling functions
fn function_examples() {
    greet("Rust");
    let sum = add(5, 3);
    let product = multiply(4, 7);
    
    println!("5 + 3 = {}", sum);
    println!("4 * 7 = {}", product);
    
    // A block used as an expression
    let result = {
        let a = 10;
        let b = 20;
        a + b                             // last expression is the block value
    };
    println!("Block expression result: {}", result);
}
```

**Result:**

```shell
Hello, Rust!
5 + 3 = 8
4 * 7 = 28
Block expression result: 30
```

**Key points:**

- Define functions with `fn`.
- Parameter types come after parameter names.
- Return types come after `->`.
- The last expression in a function/block (without a semicolon) becomes the return value.
- Call functions with `name(args...)`.
- Rust does not have variadic functions in stable Rust; pass a slice (`&[T]`) or a collection instead.
- ...

### 2.6.2 Parameters and return values

Parameters are defined in parentheses and must have types. Rust’s ownership rules apply: parameters can be passed by value (moving ownership) or by reference (borrowing). Use `mut` when you need mutability.
Return types are written after `-> Type`. A function returns the last expression implicitly, or you can return explicitly with `return`. If a function returns nothing, its return type is `()` (the unit type). To return multiple values, use a tuple.

```rust
// Multiple parameters
fn calculate_area(length: f64, width: f64) -> f64 {
    length * width
}

// Accept a variable number of values via a slice
fn print_values(values: &[i32]) {
    for value in values {
        println!("Value: {}", value);
    }
}

// Return a tuple
fn get_coordinates() -> (i32, i32) {
    (10, 20)
}

// Return a named struct
#[derive(Debug)]
struct Rectangle {
    width: f64,
    height: f64,
}

fn create_rectangle(width: f64, height: f64) -> Rectangle {
    Rectangle { width, height }
}

fn calculate_rectangle_area(rect: &Rectangle) -> f64 {
    rect.width * rect.height
}

fn function_parameters() {
    let area = calculate_area(5.0, 3.0);
    println!("Rectangle area: {}", area);
    
    let values = vec![1, 2, 3, 4, 5];
    print_values(&values);
    
    let (x, y) = get_coordinates();
    println!("Coordinates: ({}, {})", x, y);
    
    let rectangle = create_rectangle(4.0, 6.0);
    let rect_area = calculate_rectangle_area(&rectangle);
    println!("Rectangle area: {}", rect_area);
}
```

**Result:**

```shell
Rectangle area: 15
Value: 1
Value: 2
Value: 3
Value: 4
Value: 5
Coordinates: (10, 20)
Rectangle area: 24
```

**Key points:**

- Function parameter and return types must be explicit.
- Parameters can be moved or borrowed depending on whether you pass by value or reference.
- Use tuples or structs to return multiple values.
- ...

### 2.6.3 Higher-order functions

```rust
// Basic functions
fn add(a: i32, b: i32) -> i32 {
    a + b
}

fn multiply(a: i32, b: i32) -> i32 {
    a * b
}

// Function as a parameter
fn apply_function<F>(value: i32, f: F) -> i32
where
    F: Fn(i32) -> i32,
{
    f(value)
}

// Function as a return value
fn get_operation(operation: &str) -> fn(i32, i32) -> i32 {
    match operation {
        "add" => add,
        "multiply" => multiply,
        _ => add, // default
    }
}

fn higher_order_functions() {
    let result1 = apply_function(5, |x| x * x); // closure
    let result2 = apply_function(10, |x| x + 100);

    println!("Square: {}", result1);
    println!("Plus 100: {}", result2);

    let operation = get_operation("add");
    let result3 = operation(15, 25);
    println!("Function pointer result: {}", result3);
}
```

**Result:**

```shell
Square: 25
Plus 100: 110
Function pointer result: 40
```

**Key points:**

- Functions and closures can be passed as parameters.
- Functions can be returned (often as function pointers or boxed trait objects).
- Closures are anonymous functions that can capture environment.
- Function pointers (`fn(...) -> ...`) represent non-capturing functions.
- Generics let you accept different callable types via traits like `Fn`.
- ...

---

## 2.7 Practical project: a scientific calculator and data processing tool

### 2.7.1 Requirements

Build a feature-complete scientific calculator that supports:

- Basic and scientific operations
- Expression parsing and evaluation
- Statistical analysis
- History tracking

### 2.7.2 Project structure

```rust
// src/main.rs
mod calculator;
mod data;
mod history;
mod utils;

use calculator::{Calculator, Operation};
use data::Statistics;
use history::HistoryManager;
use utils::Error;

fn main() -> Result<(), Error> {
    println!("=== Scientific Calculator v1.0 ===");
    
    let mut calculator = Calculator::new();
    let mut history = HistoryManager::new();
    
    // Example calculations
    run_example_calculations(&mut calculator, &mut history)?;
    
    Ok(())
}

fn run_example_calculations(
    calc: &mut Calculator, 
    history: &mut HistoryManager
) -> Result<(), Error> {
    // Basic operations
    let result1 = calc.add(10.0, 5.0)?;
    println!("10 + 5 = {}", result1);
    history.add_record("10 + 5", result1);
    
    let result2 = calc.multiply(result1, 2.0)?;
    println!("({}) * 2 = {}", result1, result2);
    history.add_record("(10 + 5) * 2", result2);
    
    // Scientific operations
    let result3 = calc.sqrt(16.0)?;
    println!("sqrt(16) = {}", result3);
    history.add_record("sqrt(16)", result3);
    
    let result4 = calc.sin(30.0_f64.to_radians())?;
    println!("sin(30°) = {}", result4);
    history.add_record("sin(30°)", result4);
    
    // Expression evaluation
    let expr_result = calc.evaluate_expression("(10 + 5) * 2 - sqrt(16)")?;
    println!("(10 + 5) * 2 - sqrt(16) = {}", expr_result);
    history.add_record("(10 + 5) * 2 - sqrt(16)", expr_result);
    
    // Statistics
    let data = vec![1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0];
    let stats = calc.calculate_statistics(&data)?;
    println!("Dataset statistics: {:?}", stats);
    
    history.display();
    
    Ok(())
}
```

### 2.7.3 Calculator core module

```rust
// src/calculator/mod.rs
pub mod operations;
pub mod parser;
pub mod evaluator;

use operations::Operation;
use parser::ExpressionParser;
use evaluator::ExpressionEvaluator;
use utils::Error;

pub struct Calculator {
    parser: ExpressionParser,
    evaluator: ExpressionEvaluator,
}

impl Calculator {
    pub fn new() -> Self {
        Self {
            parser: ExpressionParser::new(),
            evaluator: ExpressionEvaluator::new(),
        }
    }
    
    // Basic operations
    pub fn add(&self, a: f64, b: f64) -> Result<f64, Error> {
        Ok(a + b)
    }
    
    pub fn subtract(&self, a: f64, b: f64) -> Result<f64, Error> {
        Ok(a - b)
    }
    
    pub fn multiply(&self, a: f64, b: f64) -> Result<f64, Error> {
        Ok(a * b)
    }
    
    pub fn divide(&self, a: f64, b: f64) -> Result<f64, Error> {
        if b == 0.0 {
            return Err(Error::DivisionByZero);
        }
        Ok(a / b)
    }
    
    pub fn power(&self, base: f64, exponent: f64) -> Result<f64, Error> {
        Ok(base.powf(exponent))
    }
    
    pub fn sqrt(&self, value: f64) -> Result<f64, Error> {
        if value < 0.0 {
            return Err(Error::NegativeSquareRoot);
        }
        Ok(value.sqrt())
    }
    
    pub fn sin(&self, angle: f64) -> Result<f64, Error> {
        Ok(angle.sin())
    }
    
    pub fn cos(&self, angle: f64) -> Result<f64, Error> {
        Ok(angle.cos())
    }
    
    pub fn tan(&self, angle: f64) -> Result<f64, Error> {
        Ok(angle.tan())
    }
    
    pub fn ln(&self, value: f64) -> Result<f64, Error> {
        if value <= 0.0 {
            return Err(Error::InvalidLogarithm);
        }
        Ok(value.ln())
    }
    
    pub fn log(&self, value: f64, base: f64) -> Result<f64, Error> {
        if value <= 0.0 || base <= 0.0 || base == 1.0 {
            return Err(Error::InvalidLogarithm);
        }
        Ok(value.log(base))
    }
    
    pub fn factorial(&self, n: u64) -> Result<f64, Error> {
        if n > 20 {
            return Err(Error::FactorialTooLarge);
        }
        Ok((1..=n).product::<u64>() as f64)
    }
    
    // Expression evaluation
    pub fn evaluate_expression(&self, expression: &str) -> Result<f64, Error> {
        let tokens = self.parser.tokenize(expression)?;
        let ast = self.parser.parse(tokens)?;
        self.evaluator.evaluate(&ast)
    }
    
    // Statistics
    pub fn calculate_statistics(&self, data: &[f64]) -> Result<Statistics, Error> {
        if data.is_empty() {
            return Err(Error::EmptyDataSet);
        }
        
        let n = data.len() as f64;
        let sum: f64 = data.iter().sum();
        let mean = sum / n;
        
        // Variance
        let variance: f64 = data.iter()
            .map(|&x| (x - mean).powi(2))
            .sum::<f64>() / n;
        let std_dev = variance.sqrt();
        
        // Median
        let mut sorted_data = data.to_vec();
        sorted_data.sort_by(|a, b| a.partial_cmp(b).unwrap());
        let median = if n % 2.0 == 0.0 {
            (sorted_data[(n as usize / 2) - 1] + sorted_data[n as usize / 2]) / 2.0
        } else {
            sorted_data[n as usize / 2]
        };
        
        let min = data.iter().cloned().fold(f64::INFINITY, f64::min);
        let max = data.iter().cloned().fold(f64::NEG_INFINITY, f64::max);
        
        // Mode
        let mut frequency = std::collections::HashMap::new();
        for &value in data {
            *frequency.entry(value).or_insert(0) += 1;
        }
        let max_count = frequency.values().max().unwrap_or(&0).clone();
        let mode: Vec<f64> = frequency
            .into_iter()
            .filter(|&(_, count)| count == max_count)
            .map(|(value, _)| value)
            .collect();
        
        Ok(Statistics {
            count: data.len(),
            mean,
            median,
            mode,
            variance,
            std_dev,
            min,
            max,
            sum,
        })
    }
}
```

### 2.7.4 Expression parser

```rust
// src/calculator/parser.rs
use crate::utils::Error;

#[derive(Debug, Clone, PartialEq)]
pub enum Token {
    Number(f64),
    Identifier(String),
    Operator(Operator),
    LParen,
    RParen,
    Comma,
}

#[derive(Debug, Clone, PartialEq)]
pub enum Operator {
    Add,
    Subtract,
    Multiply,
    Divide,
    Power,
    Sqrt,
    Sin,
    Cos,
    Tan,
    Ln,
    Log,
    Factorial,
}

#[derive(Debug, Clone)]
pub enum AstNode {
    Number(f64),
    Identifier(String),
    UnaryOp(Operator, Box<AstNode>),
    BinaryOp(Operator, Box<AstNode>, Box<AstNode>),
    FunctionCall(String, Vec<AstNode>),
}

pub struct ExpressionParser {
    // Operator precedence
    precedence: std::collections::HashMap<Operator, i32>,
}

impl ExpressionParser {
    pub fn new() -> Self {
        let mut precedence = std::collections::HashMap::new();
        precedence.insert(Operator::Add, 1);
        precedence.insert(Operator::Subtract, 1);
        precedence.insert(Operator::Multiply, 2);
        precedence.insert(Operator::Divide, 2);
        precedence.insert(Operator::Power, 3);
        precedence.insert(Operator::Sqrt, 4);
        precedence.insert(Operator::Factorial, 5);
        precedence.insert(Operator::Sin, 6);
        precedence.insert(Operator::Cos, 6);
        precedence.insert(Operator::Tan, 6);
        precedence.insert(Operator::Ln, 6);
        precedence.insert(Operator::Log, 6);
        
        Self { precedence }
    }
    
    pub fn tokenize(&self, input: &str) -> Result<Vec<Token>, Error> {
        let mut tokens = Vec::new();
        let mut chars = input.chars().peekable();
        
        while let Some(ch) = chars.next() {
            match ch {
                '0'..='9' | '.' => {
                    let mut number_str = ch.to_string();
                    
                    // Keep reading digits and decimal points
                    while let Some(&next_ch) = chars.peek() {
                        if next_ch.is_numeric() || next_ch == &'.' {
                            number_str.push(chars.next().unwrap());
                        } else {
                            break;
                        }
                    }
                    
                    let number: f64 = number_str.parse()
                        .map_err(|_| Error::InvalidNumber(number_str))?;
                    tokens.push(Token::Number(number));
                }
                'a'..='z' | 'A'..='Z' | '_' => {
                    let mut ident = ch.to_string();
                    
                    // Keep reading identifier characters
                    while let Some(&next_ch) = chars.peek() {
                        if next_ch.is_alphanumeric() || next_ch == &'_' {
                            ident.push(chars.next().unwrap());
                        } else {
                            break;
                        }
                    }
                    
                    tokens.push(Token::Identifier(ident));
                }
                '+' => tokens.push(Token::Operator(Operator::Add)),
                '-' => tokens.push(Token::Operator(Operator::Subtract)),
                '*' => tokens.push(Token::Operator(Operator::Multiply)),
                '/' => tokens.push(Token::Operator(Operator::Divide)),
                '^' => tokens.push(Token::Operator(Operator::Power)),
                '(' => tokens.push(Token::LParen),
                ')' => tokens.push(Token::RParen),
                ',' => tokens.push(Token::Comma),
                ' ' | '\t' | '\n' | '\r' => continue, // skip whitespace
                _ => return Err(Error::InvalidCharacter(ch)),
            }
        }
        
        Ok(tokens)
    }
    
    pub fn parse(&self, tokens: Vec<Token>) -> Result<AstNode, Error> {
        let mut output = Vec::new();
        let mut operators = Vec::new();
        
        for token in tokens {
            match token {
                Token::Number(n) => output.push(AstNode::Number(n)),
                Token::Identifier(ident) => output.push(AstNode::Identifier(ident)),
                Token::Operator(op) => {
                    while let Some(Token::Operator(prev_op)) = operators.last() {
                        if self.get_precedence(prev_op) >= self.get_precedence(&op) {
                            self.pop_operator_to_output(&mut operators, &mut output)?;
                        } else {
                            break;
                        }
                    }
                    operators.push(Token::Operator(op));
                }
                Token::LParen => operators.push(token),
                Token::RParen => {
                    while let Some(op) = operators.pop() {
                        match op {
                            Token::LParen => break,
                            Token::Operator(op) => self.pop_operator_to_output(&operators, &mut output)?,
                            _ => return Err(Error::MismatchedParen),
                        }
                    }
                }
                Token::Comma => {
                    while let Some(token) = operators.pop() {
                        match token {
                            Token::LParen => return Err(Error::MismatchedParen),
                            Token::Operator(op) => self.pop_operator_to_output(&operators, &mut output)?,
                            _ => {}
                        }
                    }
                }
            }
        }
        
        while let Some(token) = operators.pop() {
            match token {
                Token::Operator(op) => self.pop_operator_to_output(&operators, &mut output)?,
                Token::LParen | Token::RParen | Token::Comma => 
                    return Err(Error::MismatchedParen),
            }
        }
        
        if output.len() != 1 {
            return Err(Error::InvalidExpression);
        }
        
        Ok(output.remove(0))
    }
    
    fn get_precedence(&self, op: &Operator) -> i32 {
        *self.precedence.get(op).unwrap_or(&0)
    }
    
    fn pop_operator_to_output(
        &self, 
        operators: &mut Vec<Token>, 
        output: &mut Vec<AstNode>
    ) -> Result<(), Error> {
        if let Some(Token::Operator(op)) = operators.pop() {
            match op {
                Operator::Sqrt | Operator::Sin | Operator::Cos | Operator::Tan 
                | Operator::Ln | Operator::Factorial => {
                    if let Some(operand) = output.pop() {
                        output.push(AstNode::UnaryOp(op, Box::new(operand)));
                    } else {
                        return Err(Error::InsufficientOperands);
                    }
                }
                _ => {
                    if let (Some(right), Some(left)) = (output.pop(), output.pop()) {
                        output.push(AstNode::BinaryOp(op, Box::new(left), Box::new(right)));
                    } else {
                        return Err(Error::InsufficientOperands);
                    }
                }
            }
        }
        Ok(())
    }
}
```

### 2.7.5 Expression evaluator

```rust
// src/calculator/evaluator.rs
use super::parser::{AstNode, Operator};
use crate::utils::Error;

pub struct ExpressionEvaluator {
    functions: std::collections::HashMap<String, fn(&[f64]) -> Result<f64, Error>>,
}

impl ExpressionEvaluator {
    pub fn new() -> Self {
        let mut functions = std::collections::HashMap::new();
        
        // Register built-in functions
        functions.insert("sqrt".to_string(), |args| {
            if args.len() != 1 {
                return Err(Error::InvalidArgumentCount("sqrt".to_string(), 1, args.len()));
            }
            if args[0] < 0.0 {
                return Err(Error::NegativeSquareRoot);
            }
            Ok(args[0].sqrt())
        });
        
        functions.insert("sin".to_string(), |args| {
            if args.len() != 1 {
                return Err(Error::InvalidArgumentCount("sin".to_string(), 1, args.len()));
            }
            Ok(args[0].sin())
        });
        
        functions.insert("cos".to_string(), |args| {
            if args.len() != 1 {
                return Err(Error::InvalidArgumentCount("cos".to_string(), 1, args.len()));
            }
            Ok(args[0].cos())
        });
        
        functions.insert("tan".to_string(), |args| {
            if args.len() != 1 {
                return Err(Error::InvalidArgumentCount("tan".to_string(), 1, args.len()));
            }
            Ok(args[0].tan())
        });
        
        functions.insert("ln".to_string(), |args| {
            if args.len() != 1 {
                return Err(Error::InvalidArgumentCount("ln".to_string(), 1, args.len()));
            }
            if args[0] <= 0.0 {
                return Err(Error::InvalidLogarithm);
            }
            Ok(args[0].ln())
        });
        
        functions.insert("log".to_string(), |args| {
            if args.len() != 2 {
                return Err(Error::InvalidArgumentCount("log".to_string(), 2, args.len()));
            }
            if args[0] <= 0.0 || args[1] <= 0.0 || args[1] == 1.0 {
                return Err(Error::InvalidLogarithm);
            }
            Ok(args[0].log(args[1]))
        });
        
        functions.insert("factorial".to_string(), |args| {
            if args.len() != 1 {
                return Err(Error::InvalidArgumentCount("factorial".to_string(), 1, args.len()));
            }
            let n = args[0] as u64;
            if args[0] < 0.0 || args[0] - n as f64 != 0.0 {
                return Err(Error::InvalidFactorialArgument);
            }
            if n > 20 {
                return Err(Error::FactorialTooLarge);
            }
            Ok((1..=n).product::<u64>() as f64)
        });
        
        Self { functions }
    }
    
    pub fn evaluate(&self, ast: &AstNode) -> Result<f64, Error> {
        match ast {
            AstNode::Number(n) => Ok(*n),
            AstNode::Identifier(ident) => {
                // Handle constants and variables
                match ident.as_str() {
                    "pi" => Ok(std::f64::consts::PI),
                    "e" => Ok(std::f64::consts::E),
                    _ => Err(Error::UndefinedVariable(ident.clone())),
                }
            }
            AstNode::UnaryOp(op, operand) => {
                let value = self.evaluate(operand)?;
                self.evaluate_unary_op(*op, value)
            }
            AstNode::BinaryOp(op, left, right) => {
                let left_val = self.evaluate(left)?;
                let right_val = self.evaluate(right)?;
                self.evaluate_binary_op(*op, left_val, right_val)
            }
            AstNode::FunctionCall(name, args) => {
                let arg_values: Result<Vec<f64>, _> = 
                    args.iter().map(|arg| self.evaluate(arg)).collect();
                let arg_values = arg_values?;
                
                if let Some(func) = self.functions.get(name) {
                    func(&arg_values)
                } else {
                    Err(Error::UndefinedFunction(name.clone()))
                }
            }
        }
    }
    
    fn evaluate_unary_op(&self, op: Operator, value: f64) -> Result<f64, Error> {
        match op {
            Operator::Sqrt => {
                if value < 0.0 {
                    Err(Error::NegativeSquareRoot)
                } else {
                    Ok(value.sqrt())
                }
            }
            Operator::Sin => Ok(value.sin()),
            Operator::Cos => Ok(value.cos()),
            Operator::Tan => Ok(value.tan()),
            Operator::Ln => {
                if value <= 0.0 {
                    Err(Error::InvalidLogarithm)
                } else {
                    Ok(value.ln())
                }
            }
            Operator::Factorial => {
                if value < 0.0 || value.fract() != 0.0 {
                    return Err(Error::InvalidFactorialArgument);
                }
                let n = value as u64;
                if n > 20 {
                    return Err(Error::FactorialTooLarge);
                }
                Ok((1..=n).product::<u64>() as f64)
            }
            _ => Err(Error::InvalidOperator),
        }
    }
    
    fn evaluate_binary_op(&self, op: Operator, left: f64, right: f64) -> Result<f64, Error> {
        match op {
            Operator::Add => Ok(left + right),
            Operator::Subtract => Ok(left - right),
            Operator::Multiply => Ok(left * right),
            Operator::Divide => {
                if right == 0.0 {
                    Err(Error::DivisionByZero)
                } else {
                    Ok(left / right)
                }
            }
            Operator::Power => Ok(left.powf(right)),
            _ => Err(Error::InvalidOperator),
        }
    }
}
```

### 2.7.6 Statistics module

```rust
// src/data/mod.rs
pub mod types;
pub mod statistics;

use types::Statistics;

// Re-export
pub use statistics::Statistics;
```

```rust
// src/data/statistics.rs
use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Statistics {
    pub count: usize,
    pub mean: f64,
    pub median: f64,
    pub mode: Vec<f64>,
    pub variance: f64,
    pub std_dev: f64,
    pub min: f64,
    pub max: f64,
    pub sum: f64,
}

impl Statistics {
    pub fn print_detailed(&self) {
        println!("=== Statistics ===");
        println!("Count: {}", self.count);
        println!("Sum: {:.2}", self.sum);
        println!("Mean: {:.2}", self.mean);
        println!("Median: {:.2}", self.median);
        println!("Mode: {:?}", self.mode.iter()
            .map(|&x| format!("{:.2}", x))
            .collect::<Vec<_>>()
            .join(", "));
        println!("Min: {:.2}", self.min);
        println!("Max: {:.2}", self.max);
        println!("Variance: {:.4}", self.variance);
        println!("Std dev: {:.4}", self.std_dev);
        println!("==============");
    }
    
    pub fn get_range(&self) -> f64 {
        self.max - self.min
    }
    
    pub fn get_coefficient_of_variation(&self) -> f64 {
        if self.mean == 0.0 {
            0.0
        } else {
            self.std_dev / self.mean.abs()
        }
    }
}

// Linear regression
pub struct LinearRegression {
    pub slope: f64,
    pub intercept: f64,
    pub r_squared: f64,
}

impl LinearRegression {
    pub fn new(x_data: &[f64], y_data: &[f64]) -> Option<Self> {
        if x_data.len() != y_data.len() || x_data.is_empty() {
            return None;
        }
        
        let n = x_data.len() as f64;
        let sum_x: f64 = x_data.iter().sum();
        let sum_y: f64 = y_data.iter().sum();
        let sum_xy: f64 = x_data.iter().zip(y_data.iter())
            .map(|(&x, &y)| x * y).sum();
        let sum_x2: f64 = x_data.iter().map(|&x| x * x).sum();
        let sum_y2: f64 = y_data.iter().map(|&y| y * y).sum();
        
        let slope = (n * sum_xy - sum_x * sum_y) / (n * sum_x2 - sum_x * sum_x);
        let intercept = (sum_y - slope * sum_x) / n;
        
        // Compute R²
        let ss_tot: f64 = y_data.iter()
            .map(|&y| (y - sum_y / n).powi(2))
            .sum();
        let ss_res: f64 = x_data.iter().zip(y_data.iter())
            .map(|(&x, &y)| {
                let predicted = slope * x + intercept;
                (y - predicted).powi(2)
            })
            .sum();
        let r_squared = 1.0 - (ss_res / ss_tot);
        
        Some(Self {
            slope,
            intercept,
            r_squared,
        })
    }
    
    pub fn predict(&self, x: f64) -> f64 {
        self.slope * x + self.intercept
    }
    
    pub fn print_equation(&self) {
        println!("Linear regression: y = {:.4}x + {:.4}", self.slope, self.intercept);
        println!("Coefficient of determination (R²): {:.4}", self.r_squared);
    }
}
```

### 2.7.7 History management

```rust
// src/history/mod.rs
use serde::{Deserialize, Serialize};
use std::fs::{self, File};
use std::io::{self, BufRead, BufReader, Write};

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct HistoryRecord {
    pub expression: String,
    pub result: f64,
    pub timestamp: chrono::DateTime<chrono::Utc>,
}

pub struct HistoryManager {
    records: Vec<HistoryRecord>,
    max_records: usize,
}

impl HistoryManager {
    pub fn new() -> Self {
        Self::with_capacity(100)
    }
    
    pub fn with_capacity(capacity: usize) -> Self {
        let records = Self::load_from_file().unwrap_or_default();
        Self {
            records,
            max_records: capacity,
        }
    }
    
    pub fn add_record(&mut self, expression: &str, result: f64) {
        let record = HistoryRecord {
            expression: expression.to_string(),
            result,
            timestamp: chrono::Utc::now(),
        };
        
        self.records.push(record);
        
        // Enforce max history size
        if self.records.len() > self.max_records {
            self.records.remove(0);
        }
        
        // Persist to disk
        self.save_to_file().ok();
    }
    
    pub fn get_recent_records(&self, count: usize) -> &[HistoryRecord] {
        let start = if self.records.len() > count {
            self.records.len() - count
        } else {
            0
        };
        &self.records[start..]
    }
    
    pub fn search_records(&self, query: &str) -> Vec<&HistoryRecord> {
        self.records
            .iter()
            .filter(|record| 
                record.expression.contains(query) ||
                record.result.to_string().contains(query)
            )
            .collect()
    }
    
    pub fn clear(&mut self) {
        self.records.clear();
        self.save_to_file().ok();
    }
    
    pub fn display(&self) {
        if self.records.is_empty() {
            println!("No calculation history yet.");
            return;
        }
        
        println!("=== History ===");
        for (i, record) in self.records.iter().enumerate() {
            println!("{}. {} = {}", 
                i + 1, 
                record.expression, 
                record.result
            );
        }
        println!("=============");
    }
    
    fn get_history_file() -> std::path::PathBuf {
        let mut path = dirs::home_dir().unwrap_or_default();
        path.push(".rust_calculator_history.json");
        path
    }
    
    fn load_from_file() -> io::Result<Vec<HistoryRecord>> {
        let path = Self::get_history_file();
        if !path.exists() {
            return Ok(Vec::new());
        }
        
        let file = File::open(path)?;
        let reader = BufReader::new(file);
        
        let records: Vec<HistoryRecord> = serde_json::from_reader(reader)
            .unwrap_or_default();
        
        Ok(records)
    }
    
    fn save_to_file(&self) -> io::Result<()> {
        let path = Self::get_history_file();
        
        // Ensure directory exists
        if let Some(parent) = path.parent() {
            fs::create_dir_all(parent)?;
        }
        
        let file = File::create(path)?;
        serde_json::to_writer_pretty(file, &self.records)?;
        
        Ok(())
    }
}
```

### 2.7.8 Error handling

```rust
// src/utils/mod.rs
pub mod error;

pub use error::Error;
```

```rust
// src/utils/error.rs
use serde::{Deserialize, Serialize};

#[derive(Debug, thiserror::Error, Serialize, Deserialize)]
pub enum Error {
    #[error("division by zero")]
    DivisionByZero,
    
    #[error("square root of a negative number: {0}")]
    NegativeSquareRoot,
    
    #[error("invalid logarithm: base must be > 0 and != 1, argument must be > 0")]
    InvalidLogarithm,
    
    #[error("invalid factorial argument: must be a non-negative integer")]
    InvalidFactorialArgument,
    
    #[error("factorial too large: n > 20")]
    FactorialTooLarge,
    
    #[error("empty dataset")]
    EmptyDataSet,
    
    #[error("invalid number: {0}")]
    InvalidNumber(String),
    
    #[error("invalid character: {0}")]
    InvalidCharacter(char),
    
    #[error("mismatched parentheses")]
    MismatchedParen,
    
    #[error("invalid expression")]
    InvalidExpression,
    
    #[error("insufficient operands")]
    InsufficientOperands,
    
    #[error("invalid operator")]
    InvalidOperator,
    
    #[error("undefined variable: {0}")]
    UndefinedVariable(String),
    
    #[error("undefined function: {0}")]
    UndefinedFunction(String),
    
    #[error("function {0} argument count mismatch: expected {1}, got {2}")]
    InvalidArgumentCount(String, usize, usize),
    
    #[error("I/O error: {0}")]
    Io(#[from] std::io::Error),
    
    #[error("JSON serialization error: {0}")]
    Json(#[from] serde_json::Error),
    
    #[error("time parsing error: {0}")]
    Chrono(#[from] chrono::ParseError),
}
```

---

## 2.8 Exercises

### Exercise 2.1: Basic calculator

Implement a basic four-operation calculator:

- Support `+`, `-`, `*`, `/`
- Handle errors (division by zero, etc.)
- Provide a user-friendly interface

### Exercise 2.2: Temperature converter

Create a temperature conversion tool:

- Celsius ↔ Fahrenheit
- Celsius ↔ Kelvin
- Batch conversion
- Show conversion history

### Exercise 2.3: Data analysis tool

Build a simple data processor:

- Read a CSV file
- Compute basic statistics
- Find extremes and outliers
- Generate a report

### Exercise 2.4: Unit converter

Design a unit conversion system:

- Length units (meters, centimeters, feet, etc.)
- Weight units (kilograms, pounds, ounces, etc.)
- Temperature units
- Custom conversion functions

### Exercise 2.5: Tuple data processor

Create a tool that processes tuple-based data:

- Parse student info tuples (name, age, score)
- Implement coordinate geometry (distance, midpoint, etc.)
- Time conversions (hours, minutes, seconds)
- Practice returning multiple values

### Exercise 2.6: Array data analyzer

Build an array data processing program:

- Sorting, searching, and statistics on arrays
- Multidimensional array operations (matrix math)
- Replacing and deleting elements
- Classic algorithms (bubble sort, binary search, etc.)

---

## 2.9 Performance tips

### 2.9.1 Numeric computation

```rust
// Avoid repeated computation
fn optimized_calculation(data: &[f64]) -> (f64, f64) {
    let n = data.len() as f64;
    let sum: f64 = data.iter().sum();
    let mean = sum / n;
    
    // Compute variance in a single pass (given mean)
    let variance: f64 = data.iter()
        .map(|&x| (x - mean).powi(2))
        .sum::<f64>() / n;
    
    let std_dev = variance.sqrt();
    (mean, std_dev)
}

// Use iterator pipelines
fn iterator_optimization() {
    let numbers: Vec<i32> = (1..=1000).collect();
    
    // Chained operations
    let result: i32 = numbers
        .iter()
        .filter(|&&x| x % 2 == 0)    // keep even numbers
        .map(|&x| x * x)             // square
        .sum();                      // sum
    
    println!("Sum of squares of even numbers: {}", result);
}
```

### 2.9.2 Memory management

```rust
// Preallocate capacity
fn preallocate_example() {
    let mut numbers = Vec::with_capacity(1000);
    for i in 0..1000 {
        numbers.push(i);
    }
}

// Avoid unnecessary cloning
fn efficient_cloning() {
    let original = vec![1, 2, 3, 4, 5];
    
    // Use references instead of cloning
    let sum: i32 = original.iter().sum();
    
    // Clone only when needed
    if sum > 10 {
        let cloned = original.clone();
        // use cloned
    }
}
```

---

## 2.10 Summary

After this chapter, you should have learned:

### Core concepts

1. **Variable bindings**: `let`, `let mut`, `const`
2. **Primitive types**: integers, floats, booleans, chars, strings
3. **Compound types**: tuples (fixed-size heterogeneous), arrays (fixed-size homogeneous)
4. **Control flow**: `if`, `loop`, `while`, `for`, `match`
5. **Functions**: definitions, calls, parameters, return values

### Hands-on project

- A complete scientific calculator
- Expression parsing and evaluation
- Statistical analysis
- History management

### Best practices

- Naming conventions
- Error handling strategies
- Performance tips
- Code organization

### Next chapter preview

- Ownership and borrowing
- Memory safety guarantees
- References and slices
- Lifetimes

---

**With these fundamentals and the hands-on project practice, you now have a solid foundation in Rust. Next up: Rust’s signature feature—ownership and borrowing!**
