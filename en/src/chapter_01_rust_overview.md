# Chapter Chapter 1: Rust Overview and Environment Setup

## Learning Goals

- Understand Rust’s design philosophy and core features
- Set up a standard Rust development environment
- Learn to use Cargo (Rust’s package manager)
- Understand how Rust code is compiled and run

---

## 1.1 Rust at a Glance

### 1.1.1 Why Rust?

Rust is a systems programming language started at Mozilla in 2006. The goal was to keep C/C++-level performance while fixing long-standing memory-safety problems.

```rust
// Rust’s philosophy: safety, concurrency, practicality
// No garbage collector required
// Memory safety enforced at compile time
// Zero-cost abstractions (high-level code without runtime overhead)
```

### 1.1.2 Core Features

#### Memory Safety

Rust prevents common memory bugs (null dereference, buffer overflow, data races, dangling pointers) by enforcing strict rules at compile time (ownership and borrowing). This avoids a runtime garbage collector while keeping performance high—especially valuable for systems programming.

```rust
// Prevent common memory bugs at compile time
fn demonstrate_memory_safety() {
    let string = String::from("Hello");
    let slice = &string; // borrow, do not move ownership
    println!("{}", slice);

    // let mut data = vec![1, 2, 3];
    // let slice = &data;  // immutable borrow
    // data.push(4);       // compile error! violates borrowing rules
}
```

#### Zero-Cost Abstractions

Rust lets you write expressive, high-level code (generics, traits, iterators) without paying runtime cost. After compilation and optimization, the generated machine code can be as efficient as hand-written low-level loops.

```rust
// High-level style without performance penalty
fn high_level_abstraction() {
    let numbers: Vec<i32> = (0..1000).collect();

    let sum: i32 = numbers
        .iter()
        .filter(|&&x| x % 2 == 0) // keep even numbers
        .map(|&x| x * x)          // square
        .sum();                   // sum

    println!("Sum of squared even numbers: {}", sum);
}
```

#### The Ownership System

Rust’s key innovation is ownership: every value has a single owner, and when the owner goes out of scope, the value is automatically dropped. Ownership can be moved, or values can be borrowed via references (`&T` and `&mut T`). The compiler enforces these rules to prevent double-free, use-after-free, and invalid access.

```rust
// Ownership and borrowing ensure memory safety
fn ownership_demo() {
    let data = vec![1, 2, 3];
    let transferred = data; // move ownership to transferred

    // println!("{:?}", data); // compile error! data was moved
    println!("{:?}", transferred);

    let reference = &transferred;
    println!("Borrowed value: {:?}", reference);

    let another_ref = &transferred;
    println!("Two borrows: {:?}, {:?}", reference, another_ref);

    // You cannot create a mutable borrow while immutable borrows exist
    // let mut_ref = &mut transferred; // compile error!
}
```

---

## 1.2 Installing the Rust Toolchain

### 1.2.1 Installing via rustup

```bash
# Install Rust toolchain
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Reload environment
source ~/.cargo/env

# Verify
rustc --version
cargo --version

# Update Rust
rustup update

# Show installed toolchains
rustup show
```

### 1.2.2 Toolchain Management

```bash
# List installed targets
rustup target list --installed

# Add targets
rustup target add x86_64-pc-windows-msvc
rustup target add x86_64-apple-darwin
rustup target add aarch64-unknown-linux-gnu

# Switch toolchain
rustup default stable
rustup default nightly
```

### 1.2.3 Recommended Development Tools

```bash
# Install common tools
cargo install cargo-watch     # watch files and rebuild
cargo install cargo-audit     # check dependency vulnerabilities
cargo install cargo-clippy    # lints
cargo install rust-analyzer   # language server

# VS Code extensions
# - rust-analyzer
# - Rust Test Explorer
# - CodeLLDB (debugger)
```

---

## 1.3 Cargo: Package Manager and Build Tool

### 1.3.1 Creating a Project

```bash
# Create a binary project
cargo new my_project
cd my_project

# Create a library project
cargo new --lib my_library

# Generate from a template
cargo generate --git https://github.com/rustwasm/wasm-pack-template
```

### 1.3.2 The Cargo.toml Manifest

```toml
# my_project/Cargo.toml
[package]
name = "my_project"           # project name
version = "0.1.0"            # version
edition = "2021"             # Rust edition
authors = ["Your Name <email@example.com>"]
license = "MIT"
description = "A sample Rust project"
repository = "https://github.com/user/my_project"
keywords = ["rust", "example", "demo"]
categories = ["development-tools"]
documentation = "https://docs.rs/my_project"
readme = "README.md"

[dependencies]
serde = { version = "1.0", features = ["derive"] }
serde_json = "1.0"
tokio = { version = "1.0", features = ["full"] }

rand = "0.8"
chrono = { version = "0.4", optional = true }

[dev-dependencies]
tempfile = "3.0"
mockall = "0.11"

[build-dependencies]
cc = "1.0"

[features]
default = ["json"]
json = ["serde_json"]
csv = ["serde_csv"]
chrono_time = ["chrono"]
```

### 1.3.3 Typical Project Layout

```
my_project/
├── src/
│   ├── main.rs
│   ├── lib.rs               # optional
│   ├── mod1/
│   │   ├── mod.rs
│   │   └── submodule.rs
│   └── utils/
│       ├── mod.rs
│       └── helpers.rs
├── Cargo.toml
├── Cargo.lock               # auto-generated
├── README.md
├── LICENSE
├── .gitignore
├── tests/
├── examples/
├── benches/
└── target/
    ├── debug/
    └── release/
```

---

## 1.4 Your First Rust Program

### 1.4.1 Hello, World

```rust
// src/main.rs

/*
   Multi-line comment
   This is our first Rust program
*/

fn main() {
    // println! is a macro (the ! indicates a macro)
    println!("Hello, Rust World!");

    // variables and types
    let name = "Rust Developer";
    let version = 1.0;
    let is_awesome = true;

    println!("Welcome {}! Rust version: {}", name, version);
    println!("Is Rust awesome? {}", is_awesome);

    // formatted output
    println!("{} is a {} programming language", "Rust", "modern");
    println!(
        "{subject} {verb} {object}",
        subject = "Rust",
        verb = "is",
        object = "safe"
    );

    // placeholders
    println!("Decimal: {}", 42);
    println!("Hex: {:#x}", 255);
    println!("Binary: {:#b}", 15);
    println!("Scientific: {}", 123.456789);

    // named arguments
    println!(
        "{language} was released in {year}!",
        language = "Rust",
        year = 2021
    );
}
```

---

## 1.4.2 Build and Run

```bash
# Build and run (debug)
cargo run

# Build (debug)
cargo build

# Build (release, optimized)
cargo build --release

# Type-check only (fast)
cargo check

# Run an example
cargo run --example hello_world

# Run tests
cargo test

# Run benchmarks
cargo bench
```

### 1.4.3 Managing Dependencies

```rust
// src/main.rs - using external crates
use rand::Rng;
use serde_json::json;

fn main() {
    let random_number = rand::thread_rng().gen_range(1..=100);
    println!("Random number: {}", random_number);

    let data = json!({
        "name": "Alice",
        "age": 30,
        "skills": ["Rust", "Python", "JavaScript"]
    });

    let json_string = serde_json::to_string_pretty(&data)
        .expect("JSON serialization failed");

    println!("JSON data:\n{}", json_string);
}
```

---

## 1.5 Mini Project: A Rust Dev Environment Setup Tool

### 1.5.1 Requirements

```rust
// Goals:
// 1. Detect current environment state
// 2. Install/update Rust toolchains
// 3. Configure development tools
// 4. Generate project templates
// 5. Provide rollback if needed
```

### 1.5.2 High-Level Design

```rust
use std::process;

mod commands;
mod utils;
mod config;

use commands::{EnvironmentDetector, ToolInstaller, TemplateGenerator};
use utils::{Logger, ErrorHandler};
use config::Settings;

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let logger = Logger::new("rustdev-setup");
    logger.info("Starting environment setup");

    let settings = Settings::load_from_file("config.toml")?;

    let detector = EnvironmentDetector::new(&logger);
    let environment = detector.detect()?;

    logger.info(format!("Detected environment: {:?}", environment));

    let installer = ToolInstaller::new(&settings, &logger);
    installer.install_all(&environment)?;

    let generator = TemplateGenerator::new(&settings, &logger);
    generator.generate_templates()?;

    logger.info("Environment setup complete!");
    Ok(())
}
```

---

## 1.6 Best Practices and Notes

### 1.6.1 Cargo Configuration Example

```toml
# ~/.cargo/config.toml
[toolchain]
channel = "stable"
targets = ["x86_64-unknown-linux-gnu"]
profile = "minimal"

[build]
target = "x86_64-unknown-linux-gnu"

[net]
git-fetch-with-cli = true
```

### 1.6.2 Quality Checks

```rust
use std::error::Error;

fn run_quality_checks() -> Result<(), Box<dyn Error>> {
    std::process::Command::new("cargo")
        .args(["fmt", "--check"])
        .status()?;

    std::process::Command::new("cargo")
        .args(["clippy"])
        .status()?;

    std::process::Command::new("cargo")
        .args(["audit"])
        .status()?;

    std::process::Command::new("cargo")
        .args(["test"])
        .status()?;

    Ok(())
}
```

---

## 1.7 Exercises

### Exercise 1.1: Environment Detection

Create a simple tool that checks:

- Current operating system
- Rust version information
- Installed Cargo tools

### Exercise 1.2: Project Template Generator

Design a scaffolding tool that can:

- Generate a standard Rust project layout
- Configure common dependencies
- Initialize a Git repository

### Exercise 1.3: Toolchain Management

Build a tool that can:

- Manage multiple Rust toolchains
- Switch the default toolchain
- Install and manage targets

---

## 1.8 Chapter Summary

In this chapter you learned:

1. **Rust fundamentals**: memory safety, ownership, zero-cost abstractions
2. **Environment setup**: installing and managing toolchains with `rustup`
3. **Cargo workflow**: project structure, dependencies, builds
4. **Practice project idea**: a dev-environment setup tool

### Key Takeaways

- Rust combines safety and performance via compile-time checks.
- Cargo is the standard workflow for building, testing, and managing dependencies.
- Hands-on practice is the fastest way to learn.

### Next Steps

- Dive deeper into Rust syntax
- Learn variables and data types
- Understand ownership and borrowing in detail
- Start building small real-world projects

---

**Practice is the best way to master Rust. See the next chapter for more!**
---