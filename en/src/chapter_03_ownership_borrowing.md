# Chapter 3: Ownership and Borrowing

## Table of contents

- [3.1 Introduction: Rust’s memory safety revolution](#31-introduction-rusts-memory-safety-revolution)
- [3.2 Ownership basics](#32-ownership-basics)
- [3.3 References and borrowing](#33-references-and-borrowing)
- [3.4 Lifetimes](#34-lifetimes)
- [3.5 Smart pointers](#35-smart-pointers)
- [3.6 Practical project: Build a memory-safe file processing tool](#36-practical-project-build-a-memory-safe-file-processing-tool)
- [3.7 Best practices](#37-best-practices)
- [3.8 Summary](#38-summary)
- [3.9 Acceptance criteria](#39-acceptance-criteria)
- [3.10 Exercises](#310-exercises)
- [3.11 Further reading](#311-further-reading)

## Learning objectives

After this chapter, you will be able to:

- Understand the core concepts of Rust’s ownership system
- Explain how the borrow checker works
- Use lifetimes to ensure memory safety
- Handle files safely and reason about memory management
- Apply these ideas in a practical project: a memory-safe file processing tool

## 3.1 Introduction: Rust’s memory safety revolution

In modern programming, memory safety is a critical concern. Traditional systems languages like C and C++ can deliver great performance, but require manual memory management, which often leads to:

- **Memory leaks**: forgetting to free allocated memory
- **Double free**: freeing the same allocation twice
- **Dangling pointers**: accessing memory that has already been freed
- **Buffer overflows**: writing past the end of an allocated region

Rust achieves memory safety at compile time through its unique ownership system—without relying on a garbage collector. This is the key mechanism that allows Rust to compete with C++ on performance while providing strong memory-safety guarantees.

## 3.2 Ownership basics

### 3.2.1 What is ownership?

In Rust, **every value has exactly one owner**. When the owner goes out of scope, the value is automatically dropped.

**The three core ownership rules (memorize these):**

| Rule | Name | What it means | What happens if you violate it |
|---|---|---|---|
| 1 | One owner per value | At any time, only one variable “owns” a piece of memory | Compile error |
| 2 | Ownership can move | Assigning to another variable or passing by value moves ownership | The old binding becomes invalid |
| 3 | Dropped at end of scope | When the owner leaves its `{}` scope, Rust runs `drop()` automatically | Normal behavior |

Let’s start with a small example:

```rust
fn main() {
	let s1 = String::from("Hello");
	let s2 = s1; // ownership moves from s1 to s2


	## 3.7 Best practices

	### 3.7.1 Ownership guidelines

	1. **Prefer borrowing**: use references instead of taking ownership unless ownership is required.
	2. **Move rather than clone**: for large data structures, prefer moving ownership rather than duplicating data.
	3. **Choose the right smart pointer**:
	   - Use `Box<T>` to own a value on the heap (single ownership)
	   - Use `Rc<T>` for shared ownership within a single thread
	   - Use `Arc<T>` for shared ownership across threads

	### 3.7.2 Borrow-checker techniques

	1. **Separate immutable and mutable borrows**:

	   ```rust
	   let mut data = vec![1, 2, 3];
	   let first = &data[0];
	   // Cannot take a mutable borrow here
	   // let first_mut = &mut data[0];
	   ```

	2. **Use interior mutability when appropriate**:

	   ```rust
	   use std::cell::RefCell;
	   let data = RefCell::new(vec![1, 2, 3]);
	   data.borrow_mut().push(4); // mutate behind an immutable binding
	   ```

	3. **Use lifetime parameters when needed**:

	   ```rust
	   fn longest_with_announcement<'a, T>(
	       x: &'a str,
	       y: &'a str,
	       ann: T,
	   ) -> &'a str
	   where
	       T: std::fmt::Display,
	   {
	       println!("Announcement: {}", ann);
	       if x.len() > y.len() {
	           x
	       } else {
	           y
	       }
	   }
	   ```

	### 3.7.3 Performance optimization

	1. **Avoid unnecessary ownership moves**:

	   ```rust
	   // Not ideal
	   fn process_string(s: String) -> String {
	       // process
	       s
	   }

	   // Better
	   fn process_string(s: &str) -> String {
	       // process
	       s.to_string()
	   }
	   ```

	2. **Use zero-copy techniques**:

	   ```rust
	   fn parse_csv_line(line: &str) -> (&str, &str, &str) {
	       // Use slices instead of allocating new strings
	       let mut iter = line.split(',');
	       (
	           iter.next().unwrap(),
	           iter.next().unwrap(),
	           iter.next().unwrap(),
	       )
	   }
	   ```

	3. **Batch work to reduce allocations**:

	   ```rust
	   fn process_batch(items: &[Item], batch_size: usize) {
	       for chunk in items.chunks(batch_size) {
	           process_chunk(chunk);
	       }
	   }
	   ```

	## 3.8 Summary

	This chapter covered Rust’s ownership system—one of the language’s defining features. You learned to:

	1. **Understand ownership**: every value has one owner and is dropped when the owner goes out of scope
	2. **Use borrowing safely**: references let you use values without transferring ownership
	3. **Manage lifetimes**: ensure references remain valid
	4. **Use smart pointers**: handle more complex ownership scenarios
	5. **Build a practical tool**: implement a memory-safe file processing project

	Rust’s ownership model makes it possible to achieve memory safety without sacrificing performance. In real-world code, using borrowing, smart pointers, and lifetime annotations effectively helps you build Rust programs that are both safe and fast.

	## 3.9 Acceptance criteria

	After completing this chapter, you should be able to:

	- [ ] Explain the relationship between ownership, borrowing, and lifetimes
	- [ ] Identify and fix borrow-checker errors
	- [ ] Choose an appropriate smart pointer type for a given scenario
	- [ ] Implement a memory-safe file processing program
	- [ ] Write efficient batch-processing code
	- [ ] Design production-grade error handling and recovery mechanisms

	## 3.10 Exercises

	1. **Ownership transfer**: implement a function that takes ownership of a `Vec<T>` and returns a processed `Vec<T>`.
	2. **Borrowing refactor**: refactor code to borrow instead of moving ownership.
	3. **Lifetime annotations**: add correct lifetime parameters to more complex functions.
	4. **Performance comparison**: compare performance between borrowing and ownership-moving approaches.
	5. **Error handling**: add retry and rollback behavior to the file processing tool.

	## 3.11 Further reading

	- [The Rust Book: Ownership](https://doc.rust-lang.org/book/ch04-00-understanding-ownership.html)
	- [The Rustonomicon: Ownership](https://doc.rust-lang.org/nomicon/ownership.html)
	- [Effective Rust](https://www.lurklurk.org/effective-rust/)

```shell
The length of 'hello' is 5.
```

### 3.3.2 Mutable references

If you need to modify a value through a reference, you can use a mutable reference:

```rust
fn main() {
	let mut s = String::from("hello");
	change(&mut s); // pass a mutable reference

	println!("{}", s); // prints "hello, world"
}

fn change(some_string: &mut String) {
	some_string.push_str(", world");
}
```

**Result:**

```shell
hello, world
```

Important restrictions for mutable references:

- At any given time, you can have **either** one mutable reference **or** any number of immutable references to a value.
- You cannot have a mutable reference and immutable references to the same value at the same time.

```rust
fn main() {
	let mut s = String::from("hello");

	let r1 = &s; // immutable reference
	let r2 = &s; // another immutable reference
	// let r3 = &mut s; // compile error: cannot borrow as mutable while borrowed as immutable

	println!("{} and {}", r1, r2);

	println!("{}", r1);
	// Now it's okay to create a mutable reference because r1/r2 are no longer used
	let r3 = &mut s;
	println!("{}", r3);
}
```

**Result:**

```shell
hello and hello
hello
hello
```

### 3.3.3 The borrow checker

Rust’s borrow checker validates references at compile time and guarantees:

1. **No dangling references**
2. **References never outlive the data they refer to**

```rust
fn main() {
	let r;
	{
		let x = 5;
		r = &x; // compile error: x does not live long enough
	}
	println!("{}", r);
}
```

```shell
   Compiling playground v0.0.1 (/playground)
error[E0597]: `x` does not live long enough
 --> src/main.rs:5:13
  |
4 |         let x = 5;
  |             - binding `x` declared here
5 |         r = &x; // compile error: x does not live long enough
  |             ^^ borrowed value does not live long enough
6 |     }
  |     - `x` dropped here while still borrowed
7 |     println!("{}", r);
  |                    - borrow later used here

For more information about this error, try `rustc --explain E0597`.
error: could not compile `playground` (bin "playground") due to 1 previous error
```

In this example, `x` is dropped at the end of the inner scope, but `r` is used afterwards. That would create a dangling reference, so Rust rejects it.

## 3.4 Lifetimes

### 3.4.1 What is a lifetime?

A lifetime is the scope for which a reference is valid. Rust must ensure that references are always valid, which is why the borrow checker tracks lifetimes.

At its core, lifetime checking answers one question:

> Will any reference outlive the data it points to?

The key rule:

> A borrow cannot last longer than the value being borrowed.

In many cases, Rust can infer lifetimes automatically. But when a function returns a reference, Rust sometimes needs help.

```rust
fn main() {
	let string1 = String::from("abcd");
	let string2 = "xyz";

	let result = longest(string1.as_str(), string2);
	println!("The longest string is {}", result);
}

fn longest(x: &str, y: &str) -> &str {
	if x.len() > y.len() {
		x
	} else {
		y
	}
}
```

```shell
   Compiling playground v0.0.1 (/playground)
error[E0106]: missing lifetime specifier
 --> src/main.rs:9:33
  |
9 | fn longest(x: &str, y: &str) -> &str {
  |               ----     ----     ^ expected named lifetime parameter
  |
  = help: this function's return type contains a borrowed value, but the signature does not say whether it is borrowed from `x` or `y`
help: consider introducing a named lifetime parameter
  |
9 | fn longest<'a>(x: &'a str, y: &'a str) -> &'a str {
  |           ++++     ++          ++          ++

For more information about this error, try `rustc --explain E0106`.
error: could not compile `playground` (bin "playground") due to 1 previous error
```

Why does this fail? The function returns a `&str`, but the compiler cannot tell whether the returned reference is tied to `x` or to `y`. Rust needs to know:

- Which input lifetime the output reference depends on
- That the returned reference will not outlive its source
- How to reason about the case where either `x` or `y` might be returned

We can fix it by adding an explicit lifetime parameter:

```rust
fn longest<'a>(x: &'a str, y: &'a str) -> &'a str {
	if x.len() > y.len() {
		x
	} else {
		y
	}
}
```

Meaning of the annotation:

- `'a` is a generic lifetime parameter.
- `x: &'a str` means `x` is valid for at least `'a`.
- `y: &'a str` means `y` is valid for at least `'a`.
- `-> &'a str` means the returned reference is also valid for `'a`.

In practice, this tells the compiler: the returned reference will be valid for **the shorter of the two input lifetimes**.

Full fixed example:

```rust
fn main() {
	let string1 = String::from("abcd");
	let string2 = "xyz";

	let result = longest(string1.as_str(), string2);
	println!("The longest string is {}", result);
}

fn longest<'a>(x: &'a str, y: &'a str) -> &'a str {
	if x.len() > y.len() {
		x
	} else {
		y
	}
}
```

**Result:**

```shell
The longest string is abcd
```

### 3.4.2 Lifetime annotations

When a function returns a reference, you often need to annotate lifetimes explicitly:

```rust
fn longest<'a>(x: &'a str, y: &'a str) -> &'a str {
	if x.len() > y.len() {
		x
	} else {
		y
	}
}
```

Here, `'a` means the returned reference lives at least as long as the shorter of the two input references.

### 3.4.3 Lifetimes in structs

If a struct contains references, it must declare lifetime parameters:

```rust
struct ImportantExcerpt<'a> {
	part: &'a str,
}

impl<'a> ImportantExcerpt<'a> {
	fn level(&self) -> i32 {
		3
	}
}

fn main() {
	let novel = String::from("Call me Ishmael. Some years ago...");
	let first_sentence = novel.split('.').next().expect("Could not find a '.'");

	let i = ImportantExcerpt {
		part: first_sentence,
	};

	println!("Excerpt: {}", i.part);
}
```

**Result:**

```shell
Excerpt: Call me Ishmael
```

How to read this example:

- `novel` owns the heap-allocated string data.
- `first_sentence` is a `&str` slice that references data inside `novel`.
- The struct `ImportantExcerpt<'a>` stores a reference, so its instance cannot outlive the referenced data.
- The compiler can often infer the correct relationships here, but the struct still needs an explicit lifetime parameter because it contains a reference.

## 3.5 Smart pointers

### 3.5.1 `Box<T>`: heap allocation with single ownership

`Box<T>` is the most basic smart pointer in Rust. It allocates data on the heap instead of the stack. This is useful when data is large or when the size is only known at runtime.

`Box<T>` implements `Deref` and `Drop`, so you can access inner data via `*` (or through auto-deref), and the heap allocation is freed automatically when the `Box` goes out of scope.

`Box<T>` is also commonly used to represent recursive types (e.g., linked lists, trees), because the compiler needs to know a type’s size at compile time; boxing introduces indirection and makes the size known.

```rust
fn main() {
	let b = Box::new(5);
	println!("b = {}", b);
} // b is dropped automatically
```

**Result:**

```shell
b = 5
```

### 3.5.2 `Rc<T>`: reference counting (single-threaded)

`Rc<T>` (Reference Counting) enables **shared ownership**: multiple owners can point to the same allocation. It works by tracking a reference count; cloning an `Rc` increments the count, dropping an `Rc` decrements it, and when the count reaches zero the data is freed.

`Rc<T>` is **not thread-safe** because its reference counting is non-atomic. Use it only when the data stays within a single thread.

Also note: data behind `Rc<T>` is generally immutable. If you need shared mutability, combine `Rc<T>` with interior mutability (e.g., `RefCell<T>`).

```rust
use std::rc::Rc;

fn main() {
	let s = Rc::new(String::from("hello"));
	let s1 = Rc::clone(&s);
	let s2 = Rc::clone(&s);

	println!("s: {}, ref count: {}", s, Rc::strong_count(&s));
	println!("s1: {}, ref count: {}", s1, Rc::strong_count(&s));
	println!("s2: {}, ref count: {}", s2, Rc::strong_count(&s));
} // after s1/s2 are dropped, s is dropped too
```

**Result:**

```shell
s: hello, ref count: 3
s1: hello, ref count: 3
s2: hello, ref count: 3
```

### 3.5.3 `Arc<T>`: atomic reference counting (multi-threaded)

`Arc<T>` (Atomic Reference Counting) is the thread-safe version of `Rc<T>`. It uses atomic operations to update the reference count, which is safe across threads but has extra overhead compared to `Rc<T>`.

Like `Rc<T>`, `Arc<T>` is mainly for shared read-only data. For shared mutability, combine it with synchronization primitives such as `Mutex<T>`, `RwLock<T>`, or atomics.

```rust
use std::sync::Arc;

fn main() {
	let s = Arc::new(String::from("hello"));
	let s1 = Arc::clone(&s);
	let s2 = Arc::clone(&s);

	println!("Reference count: {}", Arc::strong_count(&s));
	println!("s1: {}", s1);
	println!("s2: {}", s2);
}
```

**Result:**

```shell
Reference count: 3
s1: hello
s2: hello
```

## 3.6 Practical project: Build a memory-safe file processing tool

Now let’s implement a complete file-processing tool to demonstrate ownership, borrowing, and lifetimes in a realistic setting.

### 3.6.1 Project design

**Project name**: `rust-file-processor`

**Core features**:

1. Safe file reading (avoid leaks and unsafe patterns)
2. Streaming processing for large files
3. Batch file renaming
4. File integrity verification
5. Concurrent file processing

### 3.6.2 Project layout

```
rust-file-processor/
├── src/
│   ├── main.rs
│   ├── processors/
│   │   ├── mod.rs
│   │   ├── csv.rs
│   │   ├── json.rs
│   │   ├── text.rs
│   │   └── image.rs
│   ├── utilities/
│   │   ├── mod.rs
│   │   ├── file_ops.rs
│   │   ├── encoding.rs
│   │   └── validation.rs
│   ├── concurrent/
│   │   ├── mod.rs
│   │   ├── worker.rs
│   │   └── pool.rs
│   └── config/
│       ├── mod.rs
│       └── settings.rs
├── tests/
├── examples/
└── fixtures/
	├── sample.csv
	├── sample.json
	└── large_file.txt
```

### 3.6.3 Core implementation

#### 3.6.3.1 A safe file reader

**src/utilities/file_ops.rs**

```rust
use std::fs::File;
use std::io::{BufRead, BufReader, BufWriter, Read, Write};
use std::path::{Path, PathBuf};
use std::error::Error;
use std::sync::Arc;
use rayon::prelude::*;

#[derive(Debug)]
pub struct FileReader {
	path: Arc<PathBuf>,
	buffer_size: usize,
	encoding: Encoding,
}

#[derive(Debug, Clone, Copy)]
pub enum Encoding {
	UTF8,
	GBK,
	ASCII,
}

impl FileReader {
	pub fn new<P: Into<PathBuf>>(path: P) -> Self {
		Self {
			path: Arc::new(path.into()),
			buffer_size: 8192,
			encoding: Encoding::UTF8,
		}
	}

	pub fn with_buffer_size(mut self, size: usize) -> Self {
		self.buffer_size = size;
		self
	}

	pub fn with_encoding(mut self, encoding: Encoding) -> Self {
		self.encoding = encoding;
		self
	}

	/// Use borrowing to avoid moving ownership.
	pub fn process_lines<F, T>(&self, processor: F) -> Result<T, Box<dyn Error>>
	where
		F: Fn(&str) -> Result<T, Box<dyn Error>> + Send + Sync,
		T: Send,
	{
		let file = File::open(&*self.path)?;
		let reader = BufReader::new(file);

		// Stream processing to avoid loading the entire file into memory.
		let lines = reader.lines().filter_map(|line| match line {
			Ok(line) => Some(line),
			Err(e) => {
				eprintln!("Warning: Skipping invalid line: {}", e);
				None
			}
		});

		// Process lines in parallel (processor borrows each line).
		let results: Vec<Result<T, Box<dyn Error>>> = lines
			.par_iter()
			.map(|line| processor(line))
			.collect();

		// Collect results; if any processing fails, return the error.
		let mut processed_results = Vec::new();
		for result in results {
			match result {
				Ok(result) => processed_results.push(result),
				Err(e) => return Err(e),
			}
		}

		Ok(self.combine_results(processed_results))
	}

	/// Batch process files.
	pub fn process_batch<P, F, T>(&self, files: &[P], processor: F) -> Result<Vec<T>, Box<dyn Error>>
	where
		P: AsRef<Path> + Send + Sync,
		F: Fn(&Path) -> Result<T, Box<dyn Error>> + Send + Sync,
		T: Send,
	{
		files.par_iter().map(|path| {
			processor(path.as_ref())
		}).collect()
	}

	/// Stream-process a large file.
	pub fn stream_process<P, F, T>(&self, output: &P, processor: F) -> Result<T, Box<dyn Error>>
	where
		P: AsRef<Path>,
		F: Fn(&str) -> Result<String, Box<dyn Error>>,
	{
		let input_file = File::open(&*self.path)?;
		let output_file = File::create(output.as_ref())?;

		let mut reader = BufReader::new(input_file);
		let mut writer = BufWriter::new(output_file);

		let mut buffer = String::new();
		let mut results = Vec::new();

		while reader.read_line(&mut buffer)? > 0 {
			let processed_line = processor(&buffer)?;
			writeln!(writer, "{}", processed_line)?;
			results.push(processed_line);
			buffer.clear();
		}

		Ok(self.combine_results(results))
	}

	/// Verify file integrity.
	pub fn verify_integrity(&self) -> Result<bool, Box<dyn Error>> {
		let metadata = self.path.metadata()?;
		let file_size = metadata.len();

		// Simple integrity check: verify the file can be fully read.
		let file = File::open(&*self.path)?;
		let mut reader = BufReader::new(file);
		let mut buffer = Vec::new();

		reader.read_to_end(&mut buffer)?;

		Ok(buffer.len() == file_size as usize)
	}

	/// Rename the file.
	pub fn rename<P: AsRef<Path>>(&self, new_path: P) -> Result<(), Box<dyn Error>> {
		std::fs::rename(&*self.path, new_path.as_ref())?;
		Ok(())
	}

	/// Get file metadata.
	pub fn metadata(&self) -> Result<std::fs::Metadata, Box<dyn Error>> {
		self.path.metadata().map_err(|e| e.into())
	}

	/// Combine processed results (type-specific).
	fn combine_results(&self, results: Vec<T>) -> T {
		// In a real implementation, you'd combine results based on T.
		// Simplified example:
		if !results.is_empty() {
			results.into_iter().next().unwrap()
		} else {
			// Return an appropriate default value based on T.
			todo!("Return appropriate default value based on type")
		}
	}
}

impl Clone for FileReader {
	fn clone(&self) -> Self {
		Self {
			path: Arc::clone(&self.path),
			buffer_size: self.buffer_size,
			encoding: self.encoding,
		}
	}
}
```

#### 3.6.3.2 File encoding handling

**src/utilities/encoding.rs**

```rust
use std::io::{Read, Write, Result as IoResult};
use std::str;
use encoding_rs::{GBK, UTF_8};
use encoding_rs_io::DecodeReaderBytesBuilder;

pub enum TextEncoding {
	UTF8,
	GBK,
	ASCII,
}

impl TextEncoding {
	pub fn from_name(name: &str) -> Option<Self> {
		match name.to_lowercase().as_str() {
			"utf-8" | "utf8" => Some(TextEncoding::UTF8),
			"gbk" | "gb2312" => Some(TextEncoding::GBK),
			"ascii" => Some(TextEncoding::ASCII),
			_ => None,
		}
	}

	pub fn decode(&self, bytes: &[u8]) -> Result<String, Box<dyn std::error::Error>> {
		match self {
			TextEncoding::UTF8 => {
				Ok(String::from_utf8(bytes.to_vec())?)
			}
			TextEncoding::GBK => {
				let (decoded, _, _) = GBK.decode(bytes);
				Ok(decoded.into())
			}
			TextEncoding::ASCII => {
				Ok(String::from_utf8(bytes.to_vec())?)
			}
		}
	}

	pub fn encode(&self, text: &str) -> Result<Vec<u8>, Box<dyn std::error::Error>> {
		match self {
			TextEncoding::UTF8 => {
				Ok(text.as_bytes().to_vec())
			}
			TextEncoding::GBK => {
				let (encoded, _, _) = GBK.encode(text);
				Ok(encoded.to_vec())
			}
			TextEncoding::ASCII => {
				Ok(text.as_bytes().to_vec())
			}
		}
	}
}

/// A generic encoding-aware reader.
pub struct EncodingReader<R> {
	reader: R,
	encoding: TextEncoding,
}

impl<R: Read> EncodingReader<R> {
	pub fn new(reader: R, encoding: TextEncoding) -> Self {
		Self { reader, encoding }
	}

	pub fn read_to_string(&mut self) -> Result<String, Box<dyn std::error::Error>> {
		let mut buffer = Vec::new();
		self.reader.read_to_end(&mut buffer)?;
		self.encoding.decode(&buffer)
	}

	pub fn read_lines(&mut self) -> Result<Vec<String>, Box<dyn std::error::Error>> {
		let content = self.read_to_string()?;
		Ok(content.lines().map(|line| line.to_string()).collect())
	}
}
```
#### 3.6.3.3 Concurrent processing

**src/concurrent/worker.rs**

```rust
use std::sync::{Arc, Mutex};
use std::thread;
use std::time::Duration;
use std::path::{Path, PathBuf};
use std::error::Error;
use rayon::prelude::*;
use futures::executor::ThreadPool;

type Job = Box<dyn FnOnce() + Send + 'static>;

pub struct WorkerPool {
	workers: Vec<Worker>,
	sender: crossbeam::channel::Sender<Job>,
}

struct Worker {
	id: usize,
	thread: Option<thread::JoinHandle<()>>,
}

impl WorkerPool {
	pub fn new(size: usize) -> WorkerPool {
		assert!(size > 0);

		let (sender, receiver) = crossbeam::channel::unbounded();
		let receiver = Arc::new(Mutex::new(receiver));

		let mut workers = Vec::with_capacity(size);

		for id in 0..size {
			workers.push(Worker::new(id, Arc::clone(&receiver)));
		}

		WorkerPool { workers, sender }
	}

	pub fn execute<F>(&self, f: F)
	where
		F: FnOnce() + Send + 'static,
	{
		let job = Box::new(f);
		self.sender.send(job).unwrap();
	}
}

impl Worker {
	fn new(id: usize, receiver: Arc<crossbeam::channel::Receiver<Job>>) -> Worker {
		let thread = thread::spawn(move || loop {
			let job = receiver.lock().unwrap().recv();
			match job {
				Ok(job) => {
					job();
				}
				Err(_) => {
					// Shutdown signal received
					break;
				}
			}
		});

		Worker {
			id,
			thread: Some(thread),
		}
	}
}

impl Drop for WorkerPool {
	fn drop(&mut self) {
		// Close the channel by dropping the sender (signals shutdown).
		drop(self.sender);

		for worker in &mut self.workers {
			if let Some(thread) = worker.thread.take() {
				thread.join().unwrap();
			}
		}
	}
}

/// A file-processing job.
pub struct FileProcessingJob {
	files: Vec<PathBuf>,
	processor: Arc<dyn Fn(&Path) -> Result<(), Box<dyn Error>> + Send + Sync>,
	progress: Arc<Mutex<Progress>>,
}

#[derive(Debug, Default)]
pub struct Progress {
	pub total: usize,
	pub completed: usize,
	pub failed: usize,
}

impl FileProcessingJob {
	pub fn new(
		files: Vec<PathBuf>,
		processor: Arc<dyn Fn(&Path) -> Result<(), Box<dyn Error>> + Send + Sync>,
	) -> Self {
		let total = files.len();
		Self {
			files,
			processor,
			progress: Arc::new(Mutex::new(Progress { total, ..Default::default() })),
		}
	}

	pub fn execute(&self, pool: &WorkerPool) -> Result<Progress, Box<dyn Error>> {
		// Use rayon for parallel processing.
		let results: Vec<Result<(), Box<dyn Error>>> = self.files
			.par_iter()
			.map(|file| {
				let result = (self.processor)(file);

				{
					let mut progress = self.progress.lock().unwrap();
					if result.is_ok() {
						progress.completed += 1;
					} else {
						progress.failed += 1;
					}
				}

				result
			})
			.collect();

		// If any task failed, return the error.
		for result in results {
			result?;
		}

		Ok(self.progress.lock().unwrap().clone())
	}

	pub fn get_progress(&self) -> Progress {
		self.progress.lock().unwrap().clone()
	}
}
```

#### 3.6.3.4 Text processor

**src/processors/text.rs**

```rust
use crate::utilities::file_ops::FileReader;
use crate::utilities::encoding::TextEncoding;
use std::path::Path;
use std::error::Error;
use std::collections::HashMap;

pub struct TextProcessor {
	encoding: TextEncoding,
	ignore_patterns: Vec<String>,
}

impl TextProcessor {
	pub fn new(encoding: TextEncoding) -> Self {
		Self {
			encoding,
			ignore_patterns: Vec::new(),
		}
	}

	pub fn add_ignore_pattern(&mut self, pattern: String) {
		self.ignore_patterns.push(pattern);
	}

	/// Find and replace text.
	pub fn find_and_replace<P, Q>(
		&self,
		input: P,
		output: Q,
		replacements: &HashMap<&str, &str>,
	) -> Result<usize, Box<dyn Error>>
	where
		P: AsRef<Path>,
		Q: AsRef<Path>,
	{
		let reader = FileReader::new(input).with_encoding(self.encoding);

		reader.stream_process(output, |line| {
			let mut result = line.to_string();
			for (from, to) in replacements {
				result = result.replace(from, to);
			}
			Ok(result)
		})?;

		Ok(replacements.len())
	}

	/// Extract text statistics.
	pub fn analyze_text(&self, file: &Path) -> Result<TextStats, Box<dyn Error>> {
		let reader = FileReader::new(file);

		let stats = reader.process_lines(|line| {
			Ok((
				line.len(),
				line.chars().count(),
				line.split_whitespace().count(),
			))
		})?;

		Ok(stats)
	}

	/// Deduplicate text lines.
	pub fn deduplicate<P, Q>(&self, input: P, output: Q) -> Result<usize, Box<dyn Error>>
	where
		P: AsRef<Path>,
		Q: AsRef<Path>,
	{
		let mut lines = std::fs::read_to_string(input)?;

		// Deduplicate while preserving order.
		lines.lines().collect::<std::collections::HashSet<_>>();

		let reader = FileReader::new(input).with_encoding(self.encoding);
		let mut unique_lines = Vec::new();

		reader.process_lines(|line| {
			if !unique_lines.contains(&line) {
				unique_lines.push(line);
			}
			Ok(())
		})?;

		let output_content = unique_lines.join("\n");
		std::fs::write(output, output_content)?;

		Ok(unique_lines.len())
	}
}

#[derive(Debug, Default)]
pub struct TextStats {
	pub total_lines: usize,
	pub total_chars: usize,
	pub total_words: usize,
	pub avg_line_length: f64,
	pub longest_line: usize,
	pub shortest_line: usize,
}

impl std::fmt::Display for TextStats {
	fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
		write!(f, "Text Statistics:
	Total lines: {}
	Total characters: {}
	Total words: {}
	Average line length: {:.2}
	Longest line: {} characters
	Shortest line: {} characters",
			self.total_lines, self.total_chars, self.total_words,
			self.avg_line_length, self.longest_line, self.shortest_line)
	}
}
```

#### 3.6.3.5 Main program

**src/main.rs**

```rust
use rust_file_processor::processors::text::TextProcessor;
use rust_file_processor::utilities::encoding::TextEncoding;
use rust_file_processor::concurrent::worker::FileProcessingJob;
use std::path::PathBuf;
use std::collections::HashMap;
use std::sync::Arc;
use std::error::Error;
use clap::{Arg, Command};
use indicatif::{ProgressBar, ProgressStyle};
use rayon;

fn main() -> Result<(), Box<dyn Error>> {
	// Configure the rayon thread pool.
	rayon::ThreadPoolBuilder::new()
		.thread_name(|i| format!("worker-{}", i))
		.build_global()?;

	let matches = Command::new("rust-file-processor")
		.version("1.0")
		.about("Memory-safe file processing tool")
		.subcommand_required(true)
		.arg_required_else_help(true)

		.subcommand(
			Command::new("process")
				.about("Process files with text transformations")
				.arg(Arg::new("input")
					.required(true)
					.help("Input file or directory"))
				.arg(Arg::new("output")
					.required(true)
					.help("Output file or directory"))
				.arg(Arg::new("encoding")
					.long("encoding")
					.value_name("ENCODING")
					.help("Text encoding (utf-8, gbk, ascii)")
					.default_value("utf-8"))
				.arg(Arg::new("replace")
					.long("replace")
					.value_name("FROM=TO")
					.help("Text replacement in format FROM=TO")
					.multiple_values(true))
		)

		.subcommand(
			Command::new("analyze")
				.about("Analyze text files")
				.arg(Arg::new("input")
					.required(true)
					.help("Input file or directory"))
				.arg(Arg::new("encoding")
					.long("encoding")
					.value_name("ENCODING")
					.help("Text encoding")
					.default_value("utf-8"))
		)

		.subcommand(
			Command::new("verify")
				.about("Verify file integrity")
				.arg(Arg::new("input")
					.required(true)
					.help("Input file or directory"))
		)

		.get_matches();

	match matches.subcommand() {
		Some(("process", args)) => {
			let input = PathBuf::from(args.value_of("input").unwrap());
			let output = PathBuf::from(args.value_of("output").unwrap());
			let encoding = TextEncoding::from_name(args.value_of("encoding").unwrap())
				.ok_or("Invalid encoding")?;

			let mut processor = TextProcessor::new(encoding);

			if let Some(replacements) = args.values_of("replace") {
				let mut replace_map = HashMap::new();
				for replacement in replacements {
					if let Some((from, to)) = replacement.split_once('=') {
						replace_map.insert(from, to);
					}
				}

				if input.is_file() {
					let files = vec![input.clone()];
					process_files_batch(&files, &output, &replace_map, &processor)?;
				} else {
					process_directory_batch(&input, &output, &replace_map, &processor)?;
				}
			}

			println!("Processing completed successfully!");
		}

		Some(("analyze", args)) => {
			let input = PathBuf::from(args.value_of("input").unwrap());
			let encoding = TextEncoding::from_name(args.value_of("encoding").unwrap())
				.ok_or("Invalid encoding")?;

			let processor = TextProcessor::new(encoding);

			if input.is_file() {
				let stats = processor.analyze_text(&input)?;
				println!("{}", stats);
			} else {
				analyze_directory(&input, &processor)?;
			}
		}

		Some(("verify", args)) => {
			let input = PathBuf::from(args.value_of("input").unwrap());

			if input.is_file() {
				let result = rust_file_processor::utilities::file_ops::FileReader::new(&input)
					.verify_integrity()?;
				println!("File integrity: {}", if result { "OK" } else { "FAILED" });
			} else {
				verify_directory(&input)?;
			}
		}

		_ => unreachable!(),
	}

	Ok(())
}

fn process_files_batch(
	files: &[PathBuf],
	output: &PathBuf,
	replacements: &HashMap<&str, &str>,
	processor: &TextProcessor,
) -> Result<(), Box<dyn Error>> {
	let total_files = files.len();
	let progress_bar = ProgressBar::new(total_files as u64);
	progress_bar.set_style(
		ProgressStyle::default_bar()
			.template("{spinner:.green} [{elapsed_precise}] [{wide_bar:.cyan/blue}] {pos}/{len} {msg}")
			.unwrap()
	);

	for (i, file) in files.iter().enumerate() {
		let output_file = output.join(file.file_name().unwrap());
		let replacements = replacements.clone();
		let processor = processor.clone();

		let result = processor.find_and_replace(file, &output_file, &replacements);

		match result {
			Ok(_) => {
				progress_bar.set_message(format!("Processing: {:?}", file.file_name().unwrap()));
			}
			Err(e) => {
				eprintln!("Error processing {:?}: {}", file, e);
			}
		}

		progress_bar.inc(1);
	}

	progress_bar.finish_with_message("Processing complete!");
	Ok(())
}

fn process_directory_batch(
	input_dir: &PathBuf,
	output_dir: &PathBuf,
	replacements: &HashMap<&str, &str>,
	processor: &TextProcessor,
) -> Result<(), Box<dyn Error>> {
	// Recursively find all files.
	let files: Vec<PathBuf> = walkdir::WalkDir::new(input_dir)
		.into_iter()
		.filter_map(|entry| entry.ok())
		.filter(|entry| entry.file_type().is_file())
		.map(|entry| entry.path().to_path_buf())
		.collect();

	std::fs::create_dir_all(output_dir)?;

	let total_files = files.len();
	let progress_bar = ProgressBar::new(total_files as u64);
	progress_bar.set_style(
		ProgressStyle::default_bar()
			.template("{spinner:.green} [{elapsed_precise}] [{wide_bar:.cyan/blue}] {pos}/{len} {msg}")
			.unwrap()
	);

	// Concurrent processing.
	let pool = rust_file_processor::concurrent::worker::WorkerPool::new(num_cpus::get());

	for file in files {
		let output_file = output_dir.join(file.strip_prefix(input_dir).unwrap());
		let replacements = replacements.clone();
		let processor = processor.clone();

		pool.execute(move || {
			let result = processor.find_and_replace(&file, &output_file, &replacements);
			match result {
				Ok(_) => println!("Processed: {:?}", file),
				Err(e) => eprintln!("Error processing {:?}: {}", file, e),
			}
		});
	}

	progress_bar.set_message("Processing all files...");
	drop(pool); // wait for all tasks to finish

	progress_bar.finish_with_message("Batch processing complete!");
	Ok(())
}

fn analyze_directory(
	input_dir: &PathBuf,
	processor: &TextProcessor,
) -> Result<(), Box<dyn Error>> {
	let files: Vec<PathBuf> = walkdir::WalkDir::new(input_dir)
		.into_iter()
		.filter_map(|entry| entry.ok())
		.filter(|entry| entry.file_type().is_file())
		.map(|entry| entry.path().to_path_buf())
		.collect();

	let progress_bar = ProgressBar::new(files.len() as u64);
	progress_bar.set_style(
		ProgressStyle::default_bar()
			.template("{spinner:.green} [{elapsed_precise}] [{wide_bar:.cyan/blue}] {pos}/{len} {msg}")
			.unwrap()
	);

	for file in files {
		if let Ok(stats) = processor.analyze_text(&file) {
			println!("\nFile: {:?}", file);
			println!("{}", stats);
		}
		progress_bar.inc(1);
	}

	progress_bar.finish_with_message("Analysis complete!");
	Ok(())
}

fn verify_directory(input_dir: &PathBuf) -> Result<(), Box<dyn Error>> {
	let files: Vec<PathBuf> = walkdir::WalkDir::new(input_dir)
		.into_iter()
		.filter_map(|entry| entry.ok())
		.filter(|entry| entry.file_type().is_file())
		.map(|entry| entry.path().to_path_buf())
		.collect();

	let progress_bar = ProgressBar::new(files.len() as u64);
	progress_bar.set_style(
		ProgressStyle::default_bar()
			.template("{spinner:.green} [{elapsed_precise}] [{wide_bar:.cyan/blue}] {pos}/{len} {msg}")
			.unwrap()
	);

	let mut failed_files = Vec::new();

	for file in files {
		let result = rust_file_processor::utilities::file_ops::FileReader::new(&file)
			.verify_integrity();

		match result {
			Ok(true) => println!("✓ {:?}", file),
			Ok(false) => {
				println!("✗ {:?}", file);
				failed_files.push(file);
			}
			Err(e) => {
				println!("✗ {:?} (Error: {})", file, e);
				failed_files.push(file);
			}
		}

		progress_bar.inc(1);
	}

	progress_bar.finish_with_message("Verification complete!");

	if !failed_files.is_empty() {
		eprintln!("\nFailed files:");
		for file in failed_files {
			eprintln!("  {:?}", file);
		}
		return Err("Some files failed integrity check".into());
	}

	println!("\nAll files passed integrity check!");
	Ok(())
}
```

#### 3.6.3.6 Project configuration

**Cargo.toml**

```toml
[package]
name = "rust-file-processor"
version = "1.0.0"
edition = "2021"
authors = ["Your Name <your.email@example.com>"]
description = "Memory-safe file processing tool"
license = "MIT"
repository = "https://github.com/yourname/rust-file-processor"

[dependencies]
# Async and concurrency
rayon = "1.7"
crossbeam = "0.8"
futures = "0.3"

# File processing
walkdir = "2.4"
encoding_rs = "0.8"
encoding_rs_io = "0.1"

# CLI
clap = { version = "4.0", features = ["derive"] }

# User interface
indicatif = "0.17"
colored = "2.0"

# System information
num_cpus = "1.16"

# Error handling
anyhow = "1.0"

[dev-dependencies]
tempfile = "3.5"
criterion = "0.5"

[[example]]
name = "basic_usage"
path = "examples/basic_usage.rs"

[[example]]
name = "concurrent_processing"
path = "examples/concurrent_processing.rs"

[profile.release]
opt-level = 3
lto = true
codegen-units = 1
panic = "abort"
```

### 3.6.4 Usage examples

#### 3.6.4.1 Basic usage

**examples/basic_usage.rs**

```rust
use rust_file_processor::utilities::file_ops::FileReader;
use rust_file_processor::utilities::encoding::TextEncoding;
use rust_file_processor::processors::text::TextProcessor;
use std::collections::HashMap;

fn main() -> Result<(), Box<dyn std::error::Error>> {
	// Create a text processor.
	let processor = TextProcessor::new(TextEncoding::UTF8);

	// Read and analyze.
	let stats = processor.analyze_text("sample.txt")?;
	println!("Text statistics: {}", stats);

	// Text replacement.
	let mut replacements = HashMap::new();
	replacements.insert("hello", "world");
	replacements.insert("foo", "bar");

	processor.find_and_replace("input.txt", "output.txt", &replacements)?;
	println!("Text replacement completed");

	Ok(())
}
```

#### 3.6.4.2 Concurrent processing example

**examples/concurrent_processing.rs**

```rust
use rust_file_processor::concurrent::worker::{FileProcessingJob, WorkerPool};
use std::path::PathBuf;
use std::sync::Arc;
use std::error::Error;

fn main() -> Result<(), Box<dyn Error>> {
	// Prepare a list of files.
	let files = vec![
		PathBuf::from("file1.txt"),
		PathBuf::from("file2.txt"),
		PathBuf::from("file3.txt"),
	];

	// Create a processing closure.
	let processor = Arc::new(|file: &Path| -> Result<(), Box<dyn Error>> {
		println!("Processing: {:?}", file);
		// Simulate file processing.
		std::thread::sleep(std::time::Duration::from_millis(100));
		Ok(())
	});

	// Create the job.
	let job = FileProcessingJob::new(files, processor);

	// Create a worker pool.
	let pool = WorkerPool::new(num_cpus::get());

	// Execute.
	let progress = job.execute(&pool)?;

	println!("Processing completed:");
	println!("  Total: {}", progress.total);
	println!("  Completed: {}", progress.completed);
	println!("  Failed: {}", progress.failed);

	Ok(())
}
```

### 3.6.5 Performance tests

**tests/performance.rs**

```rust
use rust_file_processor::utilities::file_ops::FileReader;
use std::path::Path;
use std::time::Instant;

#[test]
fn test_large_file_processing() {
	// Create a large test file.
	let test_file = "test_large.txt";
	create_large_file(test_file, 1024 * 1024); // 1MB

	let start = Instant::now();

	// Test streaming processing.
	let reader = FileReader::new(test_file).with_buffer_size(8192);
	let line_count = reader.process_lines(|_| Ok(()));

	let duration = start.elapsed();

	assert!(duration.as_millis() < 1000); // should finish within 1 second
	assert!(line_count.is_ok());

	// Cleanup.
	std::fs::remove_file(test_file).ok();
}

fn create_large_file(path: &str, size: usize) {
	use std::fs::File;
	use std::io::Write;

	let mut file = File::create(path).unwrap();
	let line = "This is a test line for large file processing. ".repeat(10);

	for _ in 0..(size / line.len()) {
		writeln!(file, "{}", line).unwrap();
	}
}
```

### 3.6.6 Production-grade considerations

#### 3.6.6.1 Monitoring memory usage

In production, monitoring memory usage is crucial:

```rust
use sysinfo::{System, SystemExt, ProcessExt};

pub struct MemoryMonitor {
	sys: System,
}

impl MemoryMonitor {
	pub fn new() -> Self {
		Self {
			sys: System::new_all(),
		}
	}

	pub fn get_memory_usage(&mut self) -> MemoryUsage {
		self.sys.refresh_all();

		MemoryUsage {
			total: self.sys.total_memory(),
			available: self.sys.available_memory(),
			used: self.sys.used_memory(),
			used_percent: (self.sys.used_memory() as f64 / self.sys.total_memory() as f64) * 100.0,
		}
	}

	pub fn warn_if_high_usage(&mut self, threshold: f64) -> bool {
		let usage = self.get_memory_usage();
		if usage.used_percent > threshold {
			eprintln!("Warning: Memory usage is {}%", usage.used_percent);
			true
		} else {
			false
		}
	}
}

#[derive(Debug, Clone)]
pub struct MemoryUsage {
	pub total: u64,
	pub available: u64,
	pub used: u64,
	pub used_percent: f64,
}
```

#### 3.6.6.2 Atomic file operations

Ensure file writes are atomic:

```rust
use std::fs;
use std::path::Path;
use std::io::{self, Write, Read};

pub fn atomic_file_write<P: AsRef<Path>, C: AsRef<[u8]>>(
	path: P,
	content: C
) -> io::Result<()> {
	let temp_path = format!("{}.tmp", path.as_ref().display());

	// Write to a temporary file.
	{
		let mut temp_file = fs::File::create(&temp_path)?;
		temp_file.write_all(content.as_ref())?;
	}

	// Atomically rename into place.
	fs::rename(&temp_path, path)?;
	Ok(())
}
```

#### 3.6.6.3 Error recovery

```rust
use std::collections::HashSet;
use std::path::PathBuf;

pub struct ErrorRecovery {
	processed_files: HashSet<PathBuf>,
	failed_files: Vec<PathBuf>,
	max_retries: usize,
}

impl ErrorRecovery {
	pub fn new(max_retries: usize) -> Self {
		Self {
			processed_files: HashSet::new(),
			failed_files: Vec::new(),
			max_retries,
		}
	}

	pub fn mark_processed(&mut self, file: PathBuf) {
		self.processed_files.insert(file);
	}

	pub fn mark_failed(&mut self, file: PathBuf) {
		self.failed_files.push(file);
	}

	pub fn retry_failed(&mut self) -> Result<(), Box<dyn std::error::Error>> {
		let mut retry_count = 0;

		while !self.failed_files.is_empty() && retry_count < self.max_retries {
			retry_count += 1;
			let failed = std::mem::take(&mut self.failed_files);

			for file in failed {
				if self.processed_files.contains(&file) {
					continue; // already processed
				}

				// Retry processing.
				match self.process_file(&file) {
					Ok(_) => {
						self.mark_processed(file);
					}
					Err(_) => {
						self.failed_files.push(file); // re-add to the failed list
					}
				}
			}
		}

		if !self.failed_files.is_empty() {
			return Err("Some files failed to process after retries".into());
		}

		Ok(())
	}

	fn process_file(&self, file: &Path) -> Result<(), Box<dyn std::error::Error>> {
		// Implement file processing logic.
		Ok(())
	}
}
```

	## 3.7 Best practices

	### 3.7.1 Ownership guidelines

	1. **Prefer borrowing**: use references instead of taking ownership unless ownership is required.
	2. **Move rather than clone**: for large data structures, prefer moving ownership rather than duplicating data.
	3. **Choose the right smart pointer**:
	   - Use `Box<T>` to own a value on the heap (single ownership)
	   - Use `Rc<T>` for shared ownership within a single thread
	   - Use `Arc<T>` for shared ownership across threads

	### 3.7.2 Borrow-checker techniques

	1. **Separate immutable and mutable borrows**:

	   ```rust
	   let mut data = vec![1, 2, 3];
	   let first = &data[0];
	   // Cannot take a mutable borrow here
	   // let first_mut = &mut data[0];
	   ```

	2. **Use interior mutability when appropriate**:

	   ```rust
	   use std::cell::RefCell;
	   let data = RefCell::new(vec![1, 2, 3]);
	   data.borrow_mut().push(4); // mutate behind an immutable binding
	   ```

	3. **Use lifetime parameters when needed**:

	   ```rust
	   fn longest_with_announcement<'a, T>(
		   x: &'a str,
		   y: &'a str,
		   ann: T,
	   ) -> &'a str
	   where
		   T: std::fmt::Display,
	   {
		   println!("Announcement: {}", ann);
		   if x.len() > y.len() {
			   x
		   } else {
			   y
		   }
	   }
	   ```

	### 3.7.3 Performance optimization

	1. **Avoid unnecessary ownership moves**:

	   ```rust
	   // Not ideal
	   fn process_string(s: String) -> String {
		   // process
		   s
	   }

	   // Better
	   fn process_string(s: &str) -> String {
		   // process
		   s.to_string()
	   }
	   ```

	2. **Use zero-copy techniques**:

	   ```rust
	   fn parse_csv_line(line: &str) -> (&str, &str, &str) {
		   // Use slices instead of allocating new strings
		   let mut iter = line.split(',');
		   (
			   iter.next().unwrap(),
			   iter.next().unwrap(),
			   iter.next().unwrap(),
		   )
	   }
	   ```

	3. **Batch work to reduce allocations**:

	   ```rust
	   fn process_batch(items: &[Item], batch_size: usize) {
		   for chunk in items.chunks(batch_size) {
			   process_chunk(chunk);
		   }
	   }
	   ```

	## 3.8 Summary

	This chapter covered Rust’s ownership system—one of the language’s defining features. You learned to:

	1. **Understand ownership**: every value has one owner and is dropped when the owner goes out of scope
	2. **Use borrowing safely**: references let you use values without transferring ownership
	3. **Manage lifetimes**: ensure references remain valid
	4. **Use smart pointers**: handle more complex ownership scenarios
	5. **Build a practical tool**: implement a memory-safe file processing project

	Rust’s ownership model makes it possible to achieve memory safety without sacrificing performance. In real-world code, using borrowing, smart pointers, and lifetime annotations effectively helps you build Rust programs that are both safe and fast.

	## 3.9 Acceptance criteria

	After completing this chapter, you should be able to:

	- [ ] Explain the relationship between ownership, borrowing, and lifetimes
	- [ ] Identify and fix borrow-checker errors
	- [ ] Choose an appropriate smart pointer type for a given scenario
	- [ ] Implement a memory-safe file processing program
	- [ ] Write efficient batch-processing code
	- [ ] Design production-grade error handling and recovery mechanisms

	## 3.10 Exercises

	1. **Ownership transfer**: implement a function that takes ownership of a `Vec<T>` and returns a processed `Vec<T>`.
	2. **Borrowing refactor**: refactor code to borrow instead of moving ownership.
	3. **Lifetime annotations**: add correct lifetime parameters to more complex functions.
	4. **Performance comparison**: compare performance between borrowing and ownership-moving approaches.
	5. **Error handling**: add retry and rollback behavior to the file processing tool.

	## 3.11 Further reading

	- [The Rust Book: Ownership](https://doc.rust-lang.org/book/ch04-00-understanding-ownership.html)
	- [The Rustonomicon: Ownership](https://doc.rust-lang.org/nomicon/ownership.html)
	- [Effective Rust](https://www.lurklurk.org/effective-rust/)
**src/utilities/file_ops.rs**

```rust
use std::fs::File;
use std::io::{BufRead, BufReader, BufWriter, Read, Write};
use std::path::{Path, PathBuf};
use std::error::Error;
use std::sync::Arc;
use rayon::prelude::*;

#[derive(Debug)]
pub struct FileReader {
	path: Arc<PathBuf>,
	buffer_size: usize,
	encoding: Encoding,
}

#[derive(Debug, Clone, Copy)]
pub enum Encoding {
	UTF8,
	GBK,
	ASCII,
}

impl FileReader {
	pub fn new<P: Into<PathBuf>>(path: P) -> Self {
		Self {
			path: Arc::new(path.into()),
			buffer_size: 8192,
			encoding: Encoding::UTF8,
		}
	}

	pub fn with_buffer_size(mut self, size: usize) -> Self {
		self.buffer_size = size;
		self
	}

	pub fn with_encoding(mut self, encoding: Encoding) -> Self {
		self.encoding = encoding;
		self
	}

	/// Use borrowing to avoid moving ownership.
	pub fn process_lines<F, T>(&self, processor: F) -> Result<T, Box<dyn Error>>
	where
		F: Fn(&str) -> Result<T, Box<dyn Error>> + Send + Sync,
		T: Send,
	{
		let file = File::open(&*self.path)?;
		let reader = BufReader::new(file);

		// Stream processing to avoid loading the entire file into memory.
		let lines = reader.lines().filter_map(|line| match line {
			Ok(line) => Some(line),
			Err(e) => {
				eprintln!("Warning: Skipping invalid line: {}", e);
				None
			}
		});

		// Process lines in parallel (processor borrows each line).
		let results: Vec<Result<T, Box<dyn Error>>> = lines
			.par_iter()
			.map(|line| processor(line))
			.collect();

		// Collect results; if any processing fails, return the error.
		let mut processed_results = Vec::new();
		for result in results {
			match result {
				Ok(result) => processed_results.push(result),
				Err(e) => return Err(e),
			}
		}

		Ok(self.combine_results(processed_results))
	}

	/// Batch process files.
	pub fn process_batch<P, F, T>(&self, files: &[P], processor: F) -> Result<Vec<T>, Box<dyn Error>>
	where
		P: AsRef<Path> + Send + Sync,
		F: Fn(&Path) -> Result<T, Box<dyn Error>> + Send + Sync,
		T: Send,
	{
		files.par_iter().map(|path| {
			processor(path.as_ref())
		}).collect()
	}

	/// Stream-process a large file.
	pub fn stream_process<P, F, T>(&self, output: &P, processor: F) -> Result<T, Box<dyn Error>>
	where
		P: AsRef<Path>,
		F: Fn(&str) -> Result<String, Box<dyn Error>>,
	{
		let input_file = File::open(&*self.path)?;
		let output_file = File::create(output.as_ref())?;

		let mut reader = BufReader::new(input_file);
		let mut writer = BufWriter::new(output_file);

		let mut buffer = String::new();
		let mut results = Vec::new();

		while reader.read_line(&mut buffer)? > 0 {
			let processed_line = processor(&buffer)?;
			writeln!(writer, "{}", processed_line)?;
			results.push(processed_line);
			buffer.clear();
		}

		Ok(self.combine_results(results))
	}

	/// Verify file integrity.
	pub fn verify_integrity(&self) -> Result<bool, Box<dyn Error>> {
		let metadata = self.path.metadata()?;
		let file_size = metadata.len();

		// Simple integrity check: verify the file can be fully read.
		let file = File::open(&*self.path)?;
		let mut reader = BufReader::new(file);
		let mut buffer = Vec::new();

		reader.read_to_end(&mut buffer)?;

		Ok(buffer.len() == file_size as usize)
	}

	/// Rename the file.
	pub fn rename<P: AsRef<Path>>(&self, new_path: P) -> Result<(), Box<dyn Error>> {
		std::fs::rename(&*self.path, new_path.as_ref())?;
		Ok(())
	}

	/// Get file metadata.
	pub fn metadata(&self) -> Result<std::fs::Metadata, Box<dyn Error>> {
		self.path.metadata().map_err(|e| e.into())
	}

	/// Combine processed results (type-specific).
	fn combine_results(&self, results: Vec<T>) -> T {
		// In a real implementation, you'd combine results based on T.
		// Simplified example:
		if !results.is_empty() {
			results.into_iter().next().unwrap()
		} else {
			// Return an appropriate default value based on T.
			todo!("Return appropriate default value based on type")
		}
	}
}

impl Clone for FileReader {
	fn clone(&self) -> Self {
		Self {
			path: Arc::clone(&self.path),
			buffer_size: self.buffer_size,
			encoding: self.encoding,
		}
	}
}
```

#### 3.6.3.2 File encoding handling

**src/utilities/encoding.rs**

```rust
use std::io::{Read, Write, Result as IoResult};
use std::str;
use encoding_rs::{GBK, UTF_8};
use encoding_rs_io::DecodeReaderBytesBuilder;

pub enum TextEncoding {
	UTF8,
	GBK,
	ASCII,
}

impl TextEncoding {
	pub fn from_name(name: &str) -> Option<Self> {
		match name.to_lowercase().as_str() {
			"utf-8" | "utf8" => Some(TextEncoding::UTF8),
			"gbk" | "gb2312" => Some(TextEncoding::GBK),
			"ascii" => Some(TextEncoding::ASCII),
			_ => None,
		}
	}

	pub fn decode(&self, bytes: &[u8]) -> Result<String, Box<dyn std::error::Error>> {
		match self {
			TextEncoding::UTF8 => {
				Ok(String::from_utf8(bytes.to_vec())?)
			}
			TextEncoding::GBK => {
				let (decoded, _, _) = GBK.decode(bytes);
				Ok(decoded.into())
			}
			TextEncoding::ASCII => {
				Ok(String::from_utf8(bytes.to_vec())?)
			}
		}
	}

	pub fn encode(&self, text: &str) -> Result<Vec<u8>, Box<dyn std::error::Error>> {
		match self {
			TextEncoding::UTF8 => {
				Ok(text.as_bytes().to_vec())
			}
			TextEncoding::GBK => {
				let (encoded, _, _) = GBK.encode(text);
				Ok(encoded.to_vec())
			}
			TextEncoding::ASCII => {
				Ok(text.as_bytes().to_vec())
			}
		}
	}
}

/// A generic encoding-aware reader.
pub struct EncodingReader<R> {
	reader: R,
	encoding: TextEncoding,
}

impl<R: Read> EncodingReader<R> {
	pub fn new(reader: R, encoding: TextEncoding) -> Self {
		Self { reader, encoding }
	}

	pub fn read_to_string(&mut self) -> Result<String, Box<dyn std::error::Error>> {
		let mut buffer = Vec::new();
		self.reader.read_to_end(&mut buffer)?;
		self.encoding.decode(&buffer)
	}

	pub fn read_lines(&mut self) -> Result<Vec<String>, Box<dyn std::error::Error>> {
		let content = self.read_to_string()?;
		Ok(content.lines().map(|line| line.to_string()).collect())
	}
}
```

<!-- CHAPTER_03_CONTINUE -->
