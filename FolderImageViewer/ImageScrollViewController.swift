//
//  ImageScrollViewController.swift
//  FolderImageViewer
//
//  Created by Gualtiero Frigerio on 30/01/2019.
//

import UIKit

private struct ImageViewInfo {
    var index:Int!
    var view:UIImageView?
    var disposable:Bool!
}

class ImageScrollViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    var imageProvider:ImageProvider?
    private var files:[FilesystemEntry]?
    private var imageViews = [ImageViewInfo]()
    private var currentIndex:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageViews.append(ImageViewInfo(index: -1, view: nil, disposable: true))
        imageViews.append(ImageViewInfo(index: -1, view: nil, disposable: true))
        imageViews.append(ImageViewInfo(index: -1, view: nil, disposable: true))
    }
    
    func setFiles(_ files:[FilesystemEntry]) {
        self.files = files;
        let totalWidth = scrollView.visibleSize.width * CGFloat(files.count)
        scrollView.contentSize = CGSize(width: totalWidth, height: scrollView.visibleSize.height)
    }
    
    func gotoIndex(_ index:Int) {
        let x = scrollView.visibleSize.width * CGFloat(index)
        scrollView.contentOffset = CGPoint(x: x, y: 0)
        currentIndex = index
        refreshScrollView()
    }
    
    private func refreshScrollView() {
        loadImageView(atIndex: currentIndex)
        loadImageView(atIndex: currentIndex - 1)
        loadImageView(atIndex: currentIndex + 1)
    }
    
    private func loadImageView(atIndex index:Int) {
        if index < 0 || index >= files!.count {
            return
        }
        let entryIndex = getImageViewEntryIndex(forImageAtIndex: index)
        var entry = imageViews[entryIndex]
        if entry.view == nil {
            entry.view = createImageView(withImageAtIndex: index)
        }
        imageViews[entryIndex] = entry
        if entry.view!.superview == nil {
            scrollView.addSubview(entry.view!)
        }
        var frame = entry.view!.frame
        frame.origin.x = frame.size.width * CGFloat(index)
        entry.view!.frame = frame
    }
    
    /*
     * search for an entry with the same index
     * if none of the 3 entries is valid we look for the first disposable one
     * and if none of them are disposable we take the first one
     */
    private func getImageViewEntryIndex(forImageAtIndex imageIndex:Int) -> Int {
        for i in 0..<imageViews.count {
            let entry = imageViews[i]
            if entry.index == imageIndex {
                return i
            }
        }
        for i in 0..<imageViews.count {
            let entry = imageViews[i]
            if entry.disposable {
                return i
            }
        }
        return 0
    }
    
    private func createImageView(withImageAtIndex index:Int) -> UIImageView {
        let size = scrollView.visibleSize
        let frame = CGRect(x:0, y:0, width:size.width, height: size.height)
        let imageView = UIImageView(frame: frame)
        let fileEntry = files![index]
        let image = imageProvider?.getImage(atFileURL: fileEntry.url)
        imageView.image = image
        return imageView
    }
}
