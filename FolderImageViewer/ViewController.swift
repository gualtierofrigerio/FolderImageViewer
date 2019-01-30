//
//  ViewController.swift
//  FolderImageViewer
//
//  Created by Gualtiero Frigerio on 30/01/2019.
//

import UIKit

class ViewController: UIViewController {
    
    let dataSource = DataSource()
    let imageProvider = ImageProvider()
    var navigation:UINavigationController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let path = Bundle.main.resourcePath! + "/test"
        dataSource.setBasePath(path: path)
    }
    
    @IBAction func tapOnButton(_ sender:Any) {
        let firstFoldersTVC = createFoldersTableViewController(withFolderName: "", title:"Root folder")
        navigation = UINavigationController(rootViewController: firstFoldersTVC)
        show(navigation, sender:self)
    }
    
    private func createFoldersTableViewController(withFolderName folderName:String, title:String) -> FoldersTableViewController {
        let storyboard = UIStoryboard(name:"Main", bundle:nil)
        let newVC = storyboard.instantiateViewController(withIdentifier: "FoldersTableViewController") as! FoldersTableViewController
        newVC.setDataSource(dataSource, currentFolder: folderName, title: title)
        newVC.imageProvider = imageProvider
        newVC.delegate = self
        return newVC
    }
    
    private func createImageScrollViewController(withFiles files:[FilesystemEntry]) -> ImageScrollViewController {
        let storyboard = UIStoryboard(name:"Main", bundle:nil)
        let newVC = storyboard.instantiateViewController(withIdentifier: "ImageScrollViewController") as! ImageScrollViewController
        newVC.imageProvider = imageProvider
        return newVC
    }

}

extension ViewController : FoldersTableViewControllerDelegate {
    func showFolder(folderName: String, currentFolder: String) {
        let newFolderName = currentFolder + "/" + folderName
        let newFolderVC = createFoldersTableViewController(withFolderName: newFolderName, title: folderName)
        navigation.pushViewController(newFolderVC, animated: true)
    }
    
    func showFiles(_ files: [FilesystemEntry], startIndex: Int) {
        let newImageScrollVC = createImageScrollViewController(withFiles: files)
        navigation.pushViewController(newImageScrollVC, animated: true)
    }
}