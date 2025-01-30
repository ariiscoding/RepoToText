# RepoToText

**RepoToText** is a macOS CLI tool (written in Swift) that recursively scans a directory (e.g., a repository) and creates one consolidated `.txt` file containing each file’s path and contents. This is especially handy if you need to share or review a repository’s structure and code in a single file—particularly for Large Language Models (LLMs).

## Table of Contents

1. [Features](#features)  
2. [Requirements](#requirements)  
3. [Installation](#installation)  
4. [Usage](#usage)  
   - [Basic Use](#basic-use)  
   - [Custom Output File](#custom-output-file)  
5. [How It Works](#how-it-works)  
   - [Shebang Explanation](#shebang-explanation)  
6. [Frequently Asked Questions (FAQ)](#frequently-asked-questions-faq)  
7. [Troubleshooting](#troubleshooting)  
8. [License](#license)  
9. [Additional Notes](#additional-notes)

---

## Features

- **Single file export**: Combines all your source files and subdirectories into a single text file.  
- **Recursive scanning**: It scans subdirectories automatically.  
- **Customizable**: You can modify or extend the script to skip certain file types (like large binaries).

---

## Requirements

- **macOS** (any fairly recent version).
- **Swift** (the script is tested with Swift versions typically bundled with recent Xcode releases).  
  - Check via:
    ~~~bash
    swift --version
    ~~~
- **Zsh-compatible**: Tested with the default macOS shell (Zsh). The shebang line (`#!/usr/bin/env swift`) should work fine under Zsh if Swift is installed.

---

## Installation

1. **Clone or Download** this repository.

2. **Make the script executable**:
   ~~~bash
   chmod +x RepoToText.swift
   ~~~

3. (Optional) **Add to your `$PATH`** for convenience:

   ~~~bash
   # Copies the script to /usr/local/bin named 'repototext'
   sudo cp RepoToText.swift /usr/local/bin/repototext
   ~~~

   or

   ~~~bash
   # Symlinks instead of copying
   sudo ln -s $(pwd)/RepoToText.swift /usr/local/bin/repototext
   ~~~

   - Make sure `/usr/local/bin` is in your `$PATH`. On Zsh, you can verify by running:
     ~~~bash
     echo $PATH
     ~~~
   - If `/usr/local/bin` isn’t there, add this line to your `~/.zshrc`:
     ~~~bash
     export PATH="/usr/local/bin:$PATH"
     ~~~
   - Then run:
     ~~~bash
     source ~/.zshrc
     ~~~

   - Once set, you should be able to run `repototext` from any directory.

   **Important**: If you used the exact commands above, the final command you’ll run is `repototext`, not `swifttotext`. The latter doesn’t exist unless you specifically named the script that way.

---

## Usage

### Basic Use

~~~bash
./RepoToText.swift <directory-to-export>
~~~

- **Example**: If you run
  ~~~bash
  ./RepoToText.swift /Users/MyUser/Projects/HelloWorld
  ~~~
  the script will produce a file called `HelloWorld_RepoContents.txt` in your **current** working directory.

- If you moved the script into your `$PATH` under the name `repototext`, just do:
  ~~~bash
  repototext /Users/MyUser/Projects/HelloWorld
  ~~~

### Custom Output File

~~~bash
./RepoToText.swift <directory-to-export> <desired-output-path>
~~~

- **Example**:
  ~~~bash
  ./RepoToText.swift /Users/MyUser/Projects/HelloWorld /Users/MyUser/Desktop/ExportedHelloWorld.txt
  ~~~
  This will create (or overwrite) `ExportedHelloWorld.txt`.

---

## How It Works

1. **Scans the specified directory** using the Swift `FileManager` enumerator.  
2. **For each subdirectory**, writes a note (like `[Directory]`).  
3. **For each file**, reads its contents and appends it to the output file.  
4. The resulting `.txt` file will look like:

Repository export for directory: /path/to/HelloWorld
=== /path/to/HelloWorld/README.md ===

HelloWorld

(contents)
=== /path/to/HelloWorld/Sources/main.swift ===
(contents)
…
=== End of repository export ===

### Shebang Explanation

The first line in the script is:

#!/usr/bin/env swift

This line (a “shebang”) tells the OS to use the `swift` interpreter found via the user’s environment. It allows you to run the script directly (e.g., `./RepoToText.swift`) instead of typing `swift RepoToText.swift`. It also works fine under Zsh, provided Swift is installed and visible in your `$PATH`.

---

## Frequently Asked Questions (FAQ)

1. **What if my repository is huge?**  
   - The output file might become extremely large. LLMs often have size/token limits, so consider excluding unnecessary files or folders before running the tool.

2. **How do I exclude file types (e.g., `.git`, `.png`)?**  
   - Currently, the script doesn’t have built-in exclusion logic. You can modify the `processDirectory` function to skip certain file extensions or patterns.

3. **I see `[Could not read file: ...]` in the output.**  
   - You likely don’t have read permissions, or the file might be locked. Update permissions (e.g., `chmod`, or run with `sudo`) if appropriate.

4. **Why do I get “permission denied” when trying to run the script?**  
   - Make sure it’s executable: `chmod +x RepoToText.swift`.

5. **Is there a Windows version?**  
   - Not officially. This script targets macOS. You can adapt it for other platforms if you have Swift installed there.

6. **Why isn’t my command recognized (e.g., “command not found”)?**  
   - You might have named it differently (like `repototext` vs. `swifttotext`), or `/usr/local/bin` might not be in your `$PATH`. Double-check the final name you copied or symlinked and verify your `$PATH` in Zsh.

---

## Troubleshooting

- **No output file generated**  
  - Double-check your arguments: `./RepoToText.swift <valid-directory-path>`.

- **Unsupported Swift version**  
  - Update Xcode or Swift if you encounter compatibility issues.

- **Command not found**  
  - Make sure you used the same name when copying (e.g., `repototext`), and confirm `/usr/local/bin` is in your `$PATH`.  
  - Reload Zsh config after edits: `source ~/.zshrc`.

---

## License

This repository is released under the MIT License. Feel free to use, modify, or distribute it as you wish.

---

## Additional Notes

- **Sensitive Data**: This script will expose *all* files (including potential secrets). Always review and remove sensitive info before sending it to an LLM or committing the output to a public repo.  
- **Modifications**: Feel free to add filters, chunk files, or otherwise customize the script to suit your needs.