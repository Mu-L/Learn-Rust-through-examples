
# Learn Rust through Examples

一个从零开始学习 Rust 的系统性教程，通过实例和实践帮助你掌握 Rust 编程语言。

<div align="center">

中文 | <a href="README.en.md">English</a>

</div>

---

## 📚 关于本书

本书使用 [mdBook](https://github.com/rust-lang/mdBook) 构建，涵盖了从 Rust 基础到高级应用的完整学习路径。通过实际示例和项目实践，帮助开发者系统性地学习和掌握 Rust 编程。

## 📖 目录结构

- **第 01 章**: Rust 概览
- **第 02 章**: 变量、类型与控制流
- **第 03 章**: 所有权与借用
- **第 04 章**: 结构体与枚举
- **第 05 章**: 泛型与特征
- **第 06 章**: 错误处理
- **第 07 章**: 集合
- **第 08 章**: 模块系统
- **第 09 章**: 并发编程
- **第 10 章**: 网络编程
- **第 11 章**: 数据库操作
- **第 12 章**: Web 开发
- **第 13 章**: 性能优化
- **第 14 章**: 安全编程
- **第 15 章**: 测试与调试
- **第 16 章**: 部署与运维

## 🚀 快速开始

### 前置要求

- 安装 [Rust](https://www.rust-lang.org/tools/install)
- 安装 [mdBook](https://rust-lang.github.io/mdBook/guide/installation.html)

```bash
# 安装 mdBook
cargo install mdbook
```

### 构建本书

```bash
# 克隆仓库
git clone <repository-url>
cd Learn-Rust-through-examples
```

### 🌐 多语言使用说明

- **目录结构**：
  - `zh/` - 中文版（包含所有中文章节）
  - `en/` - 英文版（请手动添加或翻译英文章节）
- 每个语言目录都有独立的 `book.toml` 配置文件和 `src/` 源文件目录。

- **构建流程（推荐）**：仓库根提供 `Makefile`，包含常用目标。示例命令：

```bash
# 在仓库根运行（将 en 构建并复制到 book/en）
make build-en

# 如果存在 zh/，构建并复制到 book/zh
make build-zh

# 构建所有已配置语言
make build-all

# 预览中文版（在浏览器中查看，自动重载）
make serve-zh

# 预览英文版（在浏览器中查看，自动重载）
make serve-en

# 清理构建产物
make clean
```

- **手动构建**（不使用 Makefile）：

```bash
# 构建中文版
cd zh
mdbook build
cp -r book ../book/zh

# 构建英文版
cd ../en
mdbook build
cp -r book ../book/en
```

- **手动预览**（不使用 Makefile）：

```bash
# 预览中文版（在 http://localhost:3000 查看）
cd zh
mdbook serve

# 预览英文版（在 http://localhost:3000 查看）
cd en
mdbook serve
```

- **前置要求**：确保已安装 `mdbook`（例如 `cargo install mdbook`）。Makefile 使用 `mdbook build`，请先安装并在 PATH 中可用。

- **输出位置**：构建完成后，静态站点文件将位于：
  - `book/zh/` - 中文版
  - `book/en/` - 英文版
  
  将这些目录部署到静态托管服务（例如 GitHub Pages）即可提供多语言访问，路径为 `/zh/` 和 `/en/`。

---

构建完成后，在浏览器中打开 `http://localhost:3000` 即可查看。

### 查看已构建版本

构建后的 HTML 文件位于 `book/` 目录，可以直接在浏览器中打开 `book/index.html` 查看。

## 📂 项目结构

```
WORKDIR/
├── book.toml          # mdBook 配置文件（已弃用，使用各语言目录下的配置）
├── README             # 项目说明文档
├── Makefile           # 多语言构建脚本
├── zh/                # 中文版源文件
│   ├── book.toml      # 中文版配置
│   └── src/           # 中文 Markdown 源文件
│       ├── SUMMARY.md # 目录结构
│       ├── chapter_*.md # 各章节内容
│       └── chapter_*.rs # 代码示例
├── en/                # 英文版源文件
│   ├── book.toml      # 英文版配置
│   └── src/           # 英文 Markdown 源文件
│       └── SUMMARY.md # 目录结构
│       ├── chapter_*.md # 各章节内容
│       └── chapter_*.rs # 代码示例
└── book/              # 构建输出目录
    ├── zh/            # 中文版构建产物
    └── en/            # 英文版构建产物
```

## 💡 学习建议

1. **循序渐进**: 按照章节顺序学习，每章都基于前面的知识
2. **动手实践**: 运行和修改示例代码，加深理解
3. **完成练习**: 每章的练习题帮助巩固所学知识
4. **参考官方文档**: 配合 [The Rust Programming Language](https://doc.rust-lang.org/book/) 学习

## 🤝 贡献

欢迎提交问题报告、改进建议或内容贡献：

1. Fork 本仓库
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启 Pull Request

## 📝 许可证

本项目采用开源许可证，详见 LICENSE 文件。

## 👤 作者

lihongchao

Email: singlemice@gmail.com

## 🔗 相关资源

- [Rust 官方网站](https://www.rust-lang.org/)
- [Rust 官方文档](https://doc.rust-lang.org/)
- [Rust 标准库文档](https://doc.rust-lang.org/std/)
- [mdBook 文档](https://rust-lang.github.io/mdBook/)

---

**Happy Coding! 🦀**