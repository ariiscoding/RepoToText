import Foundation

@main
struct RepoToText {
    static func main() {
        // A simple approach to parse arguments & flags
        let allArgs = CommandLine.arguments.dropFirst() // drop the app name
        var nonFlagArgs = [String]()
        var omitHidden = true  // Default: skip hidden items
        
        // Parse flags vs. non-flag arguments
        for arg in allArgs {
            switch arg {
            case "--include-hidden":
                omitHidden = false
            default:
                nonFlagArgs.append(arg)
            }
        }
        
        // Now interpret nonFlagArgs
        guard nonFlagArgs.count >= 1 else {
            print("""
            Usage: repototext [--include-hidden] <directory-path> [output-file-path]

            By default, hidden directories/files are omitted.
            Use --include-hidden to include them.
            """)
            exit(1)
        }
        
        // 1. Directory to scan
        let targetDirectory = nonFlagArgs[0]
        
        // 2. Optional custom output path, or default
        let outputFilePath: String = {
            if nonFlagArgs.count > 1 {
                return nonFlagArgs[1]
            } else {
                // If not provided, create a file in current directory
                let cwd = FileManager.default.currentDirectoryPath
                var directoryName = URL(fileURLWithPath: targetDirectory).lastPathComponent
                
                if directoryName.isEmpty || directoryName == "." {
                    directoryName = URL(fileURLWithPath: cwd).lastPathComponent
                }
                
                return (cwd as NSString).appendingPathComponent("\(directoryName)_RepoContents.txt")
            }
        }()
        
        // Validate directory existence
        var isDir: ObjCBool = false
        guard FileManager.default.fileExists(atPath: targetDirectory, isDirectory: &isDir), isDir.boolValue else {
            print("Error: The specified path \(targetDirectory) is not a directory or doesn't exist.")
            exit(1)
        }
        
        // Create output file
        FileManager.default.createFile(atPath: outputFilePath, contents: nil, attributes: nil)
        guard let fileHandle = FileHandle(forWritingAtPath: outputFilePath) else {
            print("Error: Could not open file handle at \(outputFilePath)")
            exit(1)
        }
        
        // Header
        let startHeader = "Repository export for directory: \(targetDirectory)\n"
        if let data = startHeader.data(using: .utf8) {
            fileHandle.write(data)
        }
        
        // Process directory
        processDirectory(
            at: targetDirectory,
            into: fileHandle,
            omitHidden: omitHidden
        )
        
        // Footer
        let endNote = "\n=== End of repository export ===\n"
        if let data = endNote.data(using: .utf8) {
            fileHandle.write(data)
        }
        
        fileHandle.closeFile()
        print("Successfully created \(outputFilePath)")
    }
}

/// Recursively scans a directory and writes file/directory info to the given `FileHandle`.
/// Skips hidden items if `omitHidden == true`.
func processDirectory(at path: String, into outputHandle: FileHandle, omitHidden: Bool) {
    let fileManager = FileManager.default
    
    guard let enumerator = fileManager.enumerator(atPath: path) else {
        print("Error enumerating path: \(path)")
        return
    }
    
    while let relativePath = enumerator.nextObject() as? String {
        
        // If omitting hidden, skip any path that has a dot-prefixed component
        if omitHidden {
            let components = relativePath.split(separator: "/")
            if components.contains(where: { $0.hasPrefix(".") }) {
                // Skip this entire path (and its children if it's a directory)
                continue
            }
        }
        
        let fullPath = (path as NSString).appendingPathComponent(relativePath)
        
        var isSubDir: ObjCBool = false
        if fileManager.fileExists(atPath: fullPath, isDirectory: &isSubDir) {
            // Write a header for each item
            if let headerData = "\n=== \(fullPath) ===\n".data(using: .utf8) {
                outputHandle.write(headerData)
            }
            
            if isSubDir.boolValue {
                // It's a directory
                if let dirData = "[Directory]\n".data(using: .utf8) {
                    outputHandle.write(dirData)
                }
            } else {
                // It's a file
                do {
                    let contents = try String(contentsOfFile: fullPath, encoding: .utf8)
                    if let contentsData = contents.data(using: .utf8) {
                        outputHandle.write(contentsData)
                    }
                } catch {
                    if let errorData = "[Could not read file: \(error)]\n".data(using: .utf8) {
                        outputHandle.write(errorData)
                    }
                }
            }
        }
    }
}
