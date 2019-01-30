//
//  DataSource.swift
//  FolderImageViewer
//
//  Created by Gualtiero Frigerio on 21/01/2019.
//

import Foundation

/* Protocol containing funcionts to access
 * the file system by setting a base path
 * and getting a list of subfolders and
 * files
 */

protocol FilesystemDataSource {
    func setBasePath(path:String)
    func getFiles(inSubfolder folder:String) -> [FilesystemEntry]?
    func getSubFolders(ofFolder:String) -> [String]?
}

struct FilesystemEntry {
    var path:String!
    var fullPath:String!
    var url:URL!
}

class DataSource : FilesystemDataSource {
    
    private var basePath:String?
    private var fileManager:FileManager!
    
    init() {
        fileManager = FileManager.default
    }
    
    func setBasePath(path: String) {
        basePath = path
    }
    
    /*
     * returns an array of FilesystemEntry, with each file, excluded folders
     * contained in the specified folder
     */
    func getFiles(inSubfolder folder: String) -> [FilesystemEntry]? {
        let allFiles = getContents(ofFolder: folder, includeDirectories: false, includeFiles: true)
        return allFiles
    }
    
    /*
     * returns an array of strings with just the names of the subfolders
     */
    func getSubFolders(ofFolder folder: String) -> [String]? {
        guard let subfoldersEntries = getContents(ofFolder: folder, includeDirectories: true, includeFiles: false) else {
            return nil
        }
        let subfolders = subfoldersEntries.map{ (fileSystemEntry) -> String in
            return fileSystemEntry.path
        }
        return subfolders
    }
    
    /*
     * private function to return an array of FilesystemEntry with the possibility to include
     * directories and/or files
     */
    private func getContents(ofFolder folder:String, includeDirectories:Bool, includeFiles:Bool) -> [FilesystemEntry]? {
        guard let basePath = basePath else {
            return nil
        }
        let folderPath = basePath + "/" + folder
        let folderURL = URL(fileURLWithPath: folderPath)
        do {
            var contents = try fileManager.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil)
            contents = contents.filter({
                do {
                    let resourceValues = try $0.resourceValues(forKeys: [.isDirectoryKey])
                    if includeFiles && includeDirectories {
                        return true
                    }
                    else if includeFiles {
                        return !resourceValues.isDirectory!
                    }
                    else {
                        return resourceValues.isDirectory!
                    }
                }
                catch {
                    return false
                }
            })
            let filesystemEntries = contents.map{(url) -> FilesystemEntry in
                let fullPath = url.absoluteString
                var path = fullPath.replacingOccurrences(of: "file://", with: "")
                path = path.replacingOccurrences(of: folderPath, with: "")
                if path.last == "/" {
                    path = String(path.dropLast())
                }
                if path.first == "/" {
                    path = String(path.dropFirst())
                }
                return FilesystemEntry(path: path, fullPath: fullPath, url: url)
            }
            return filesystemEntries
        }
        catch {
            print("error while getting contents of directory \(folderPath)")
        }
        return nil
    }
}
