# RepoToText

**RepoToText** is a Swift-based command-line tool that scans a directory (e.g., a code repository) and outputs one consolidated `.txt` file containing each file's path and contents. Great for sharing repo structures with Large Language Models or collaborators.

## Table of Contents

1. [Features](#features)  
2. [Requirements](#requirements)  
3. [Installation](#installation)  
    - [Build with SwiftPM (Recommended)](#build-with-swiftpm-recommended)  
    - [Optional: Copy binary to /usr/local/bin](#optional-copy-binary-to-usrlocalbin)  
4. [Usage](#usage)  
    - [Basic Use](#basic-use)  
    - [Custom Output File](#custom-output-file)  
5. [FAQ](#faq)  
6. [Troubleshooting](#troubleshooting)  
7. [License](#license)  
8. [Additional Notes](#additional-notes)

---

## Features

- Recursively exports directories and files.  
- Produces a single `.txt` with file paths & contents.  
- Easily share or archive a project's structure.  

---

## Requirements

- **macOS or Linux** with Swift 5.5+ installed.  
  - Check by running:  
    ```bash
    swift --version
    ```

---

## Installation

### Build with SwiftPM (Recommended)

1. **Clone the Repo**:
   ```bash
   git clone https://github.com/YourUsername/RepoToText.git
   cd RepoToText
   ```

2. **Build in release mode**:
   ```bash
   swift build -c release
   ```

3. **The final binary will be located at**:
   ```bash
   .build/release/repototext
   ```

### Optional: Copy binary to /usr/local/bin

For easier usage:

```zsh
sudo cp .build/release/repototext /usr/local/bin
```

Now you can run `repototext` from anywhere.

> Note: If `/usr/local/bin` isn't in your `$PATH`, you'll need to add this line to your `~/.zshrc`:
> ```zsh
> export PATH="/usr/local/bin:$PATH"
> ```
> Then run `source ~/.zshrc` to apply the changes.

## Usage

### Basic Use

Run it with two arguments:

```bash
repototext <directory-to-export>
```

If `<directory-to-export>` is `~/Projects/HelloWorld`, the tool creates `HelloWorld_RepoContents.txt` in your current working directory.

Example:
```bash
repototext ~/Projects/HelloWorld
```

### Custom Output File

Optionally specify an output path:

```bash
repototext <directory-to-export> <path/to/output.txt>
```

Example:
```bash
repototext ~/Projects/HelloWorld ~/Desktop/ExportedHelloWorld.txt
```

## FAQ

1. **Can I exclude specific files or folders?**
   - Not yet. You can modify the processDirectory function if you want to skip certain patterns.

2. **The output file is huge.**
   - Large repos produce large files. Consider ignoring big files or only scanning subfolders.

3. **Permission denied when running repototext.**
   - Make sure the file is executable:
     ```bash
     chmod +x .build/release/repototext
     ```
   - Or install it in `/usr/local/bin`.

4. **I see "Could not read file: …".**
   - Check read permissions on that file or directory.

5. **Does this work on Linux?**
   - Yes, if Swift 5.5+ is installed. The steps are the same (clone, swift build -c release, etc.).

## Troubleshooting

- **Command not found**: Did you copy the binary to `/usr/local/bin` (or another directory in your `$PATH`)?
  - For zsh users: Make sure `/usr/local/bin` is in your PATH by checking `echo $PATH`
  - If needed, add it to your `~/.zshrc` as shown in the installation section
- **Permissions**: Use `chmod +x .build/release/repototext`
- **Swift version too old**: Update your Swift toolchain if you see errors about language compatibility

## License

This tool is distributed under the MIT License. You're free to use, modify, and distribute it.

## Additional Notes

- **Security & Privacy**: The script dumps everything (including potential secrets) in plain text. Be mindful of what you share.
- **Fork & Customize**: If you'd like to skip large binaries or certain folders, you can adapt the processDirectory function.

---

### **Usage Summary**

1. **Clone** the repo containing `Package.swift` and the `Sources/` folder.  
2. Run `swift build -c release`.  
3. You'll get an executable in `.build/release/repototext`.  
4. (Optional) Install to `/usr/local/bin` so you can just run `repototext` from anywhere.
