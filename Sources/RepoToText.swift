import Foundation

@main
struct RepoToText {
    static func main() {
        // MARK: - Parsing Command-Line Arguments
        let arguments = CommandLine.arguments
        
        guard arguments.count >= 2 else {
            print("Usage: \(arguments[0]) <directory-path> [output-file-path]")
            exit(1)
        }
        
        // 1. Directory to scan
        let targetDirectory = arguments[1]
        
        // 2. Optional custom output path, or default
        let outputFilePath: String = {
            if arguments.count > 2 {
                // If user explicitly provides output file
                return arguments[2]
            } else {
                // If not provided, create a file in current directory
                // named <DirectoryName>_RepoContents.txt
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
        processDirectory(at: targetDirectory, into: fileHandle)
        
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
func processDirectory(at path: String, into outputHandle: FileHandle) {
    let fileManager = FileManager.default
    
    guard let enumerator = fileManager.enumerator(atPath: path) else {
        print("Error enumerating path: \(path)")
        return
    }
    
    while let relativePath = enumerator.nextObject() as? String {
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
