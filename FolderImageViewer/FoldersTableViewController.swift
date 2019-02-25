//
//  FoldersTableViewController.swift
//  FolderImageViewer
//
//  Created by Gualtiero Frigerio on 30/01/2019.
//

import UIKit

protocol FoldersTableViewControllerDelegate {
    func showFolder(folderName:String, currentFolder:String)
    func showFiles(_ files:[FilesystemEntry], startIndex:Int)
}

class FoldersTableViewController: UITableViewController {

    var dataSource:FilesystemDataSource?
    var imageProvider:ImageProvider?
    var delegate:FoldersTableViewControllerDelegate?
    var currentFolder = ""
    private var subfolders = [String]()
    private var files = [FilesystemEntry]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.accessibilityIdentifier = "foldersTableView"
    }
    
    func setDataSource(_ dataSource:FilesystemDataSource, currentFolder:String, title:String) {
        self.dataSource = dataSource
        self.currentFolder = currentFolder
        self.navigationItem.title = title
    }

    // MARK: - Table view data source

    // two sections: the first one display subfolders the second files
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let dataSource = dataSource {
            if section == 0 {
                if let folders = dataSource.getSubFolders(ofFolder: currentFolder) {
                    subfolders = folders
                    subfolders.sort()
                    return subfolders.count
                }
            }
            else {
                if let allFiles = dataSource.getFiles(inSubfolder: currentFolder) {
                    files = allFiles.sorted(by: {$0.path < $1.path})
                    return files.count
                }
            }
        }
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier = indexPath.section == 0 ? "folderIdentifier" : "fileIdentifier"
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        if indexPath.section == 0 {
            cell.textLabel?.text = subfolders[indexPath.row]
        }
        else {
            cell.detailTextLabel?.text = files[indexPath.row].path
            let fileURL = files[indexPath.row].url
            cell.textLabel?.text = files[indexPath.row].path
            if let image = imageProvider?.getImage(atFileURL: fileURL!) {
                cell.imageView?.image = image
                cell.imageView?.contentMode = .scaleAspectFill
                cell.textLabel?.textAlignment = .right
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let delegate = delegate else {
            return
        }
        if indexPath.section == 0 {
            let path = subfolders[indexPath.row]
            delegate.showFolder(folderName: path, currentFolder: currentFolder)
        }
        else {
            delegate.showFiles(files, startIndex: indexPath.row)
        }
    }
}
