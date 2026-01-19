

# Learn Rust through Examples

A systematic tutorial for learning Rust from scratch, helping you master the Rust programming language through examples and practice.

<div align="center">

<a href="README">中文</a> | English

</div>

---




## 📚 About This Book

This book is built with [mdBook](https://github.com/rust-lang/mdBook) and covers a complete learning path from Rust basics to advanced applications. Through practical examples and hands-on projects, it helps developers systematically learn and master Rust programming.

## 📖 Table of Contents

- **Chapter 01**: Rust Overview
- **Chapter 02**: Variables, Types, and Control Flow
- **Chapter 03**: Ownership and Borrowing
- **Chapter 04**: Structs and Enums
- **Chapter 05**: Generics and Traits
- **Chapter 06**: Error Handling
- **Chapter 07**: Collections
- **Chapter 08**: Module System
- **Chapter 09**: Concurrency
- **Chapter 10**: Network Programming
- **Chapter 11**: Database Operations
- **Chapter 12**: Web Development
- **Chapter 13**: Performance Optimization
- **Chapter 14**: Secure Programming
- **Chapter 15**: Testing and Debugging
- **Chapter 16**: Deployment and Operations

## 🚀 Quick Start

### Prerequisites

- Install [Rust](https://www.rust-lang.org/tools/install)
- Install [mdBook](https://rust-lang.github.io/mdBook/guide/installation.html)

```bash
# Install mdBook
cargo install mdbook
```

### Building the Book

```bash
# Clone the repository
git clone <repository-url>
cd Learn-Rust-through-examples
```

### 🌐 Multi-language Usage Guide

- **Directory Structure**:
  - `zh/` - Chinese version (contains all Chinese chapters)
  - `en/` - English version (manually add or translate English chapters)
- Each language directory has its own `book.toml` configuration file and `src/` source directory.

- **Build Process (Recommended)**: The repository root provides a `Makefile` with common targets. Example commands:

```bash
# Build English version (builds en/ and copies to book/en)
make build-en

# Build Chinese version (builds zh/ and copies to book/zh)
make build-zh

# Build all configured languages
make build-all

# Preview Chinese version (view in browser with live reload)
make serve-zh

# Preview English version (view in browser with live reload)
make serve-en

# Clean build artifacts
make clean
```

- **Manual Build** (without Makefile):

```bash
# Build Chinese version
cd zh
mdbook build
cp -r book ../book/zh

# Build English version
cd ../en
mdbook build
cp -r book ../book/en
```

- **Manual Preview** (without Makefile):

```bash
# Preview Chinese version (view at http://localhost:3000)
cd zh
mdbook serve

# Preview English version (view at http://localhost:3000)
cd en
mdbook serve
```

- **Prerequisites**: Ensure `mdbook` is installed (e.g., `cargo install mdbook`). The Makefile uses `mdbook build`, so it must be installed and available in PATH.

- **Output Location**: After building, static site files will be located at:
  - `book/zh/` - Chinese version
  - `book/en/` - English version
  
  Deploy these directories to a static hosting service (e.g., GitHub Pages) to provide multi-language access at paths `/zh/` and `/en/`.

---
After building, open `http://localhost:3000` in your browser to view.

### View Built Version

The built HTML files are located in the `book/` directory. You can directly open `book/index.html` in your browser.

## 📂 Project Structure

```
rust_from_0/
├── book.toml          # mdBook config (deprecated, use language-specific configs)
├── README             # Project documentation (Chinese)
├── README.en.md       # Project documentation (English)
├── Makefile           # Multi-language build script
├── zh/                # Chinese version source files
│   ├── book.toml      # Chinese version config
│   └── src/           # Chinese Markdown source files
│       ├── SUMMARY.md # Table of contents
│       ├── chapter_*.md # Chapter contents
│       └── chapter_*.rs # Code examples
├── en/                # English version source files
│   ├── book.toml      # English version config
│   └── src/           # English Markdown source files
│       ├── SUMMARY.md # Table of contents
│       ├── chapter_*.md # Chapter contents
│       └── chapter_*.rs # Code examples
└── book/              # Build output directory
    ├── zh/            # Chinese version build artifacts
    └── en/            # English version build artifacts
```

## 💡 Learning Tips

1. **Step by Step**: Follow the chapter order, as each builds on previous knowledge
2. **Hands-on Practice**: Run and modify example code to deepen understanding
3. **Complete Exercises**: Practice problems in each chapter help solidify knowledge
4. **Reference Official Docs**: Study alongside [The Rust Programming Language](https://doc.rust-lang.org/book/)

## 🤝 Contributing

We welcome bug reports, improvement suggestions, and content contributions:

1. Fork this repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under an open-source license. See the LICENSE file for details.

## 👤 Author

lihongchao

Email: singlemice@gmail.com

## 🔗 Related Resources

- [Rust Official Website](https://www.rust-lang.org/)
- [Rust Official Documentation](https://doc.rust-lang.org/)
- [Rust Standard Library Documentation](https://doc.rust-lang.org/std/)
- [mdBook Documentation](https://rust-lang.github.io/mdBook/)

---


**Happy Coding! 🦀**
