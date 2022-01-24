//
//  CSVViewer.swift
//  WellnessScout
//
//  Created by Sharma, Anuj [CCE E] on 12/21/21.
//

import Foundation
import UIKit
import QuickLook

class CSVViewer: UIViewController,UIDocumentInteractionControllerDelegate, QLPreviewControllerDelegate, QLPreviewControllerDataSource {
    
    
    @IBOutlet weak var csvView: UIView!
    var fileURL : URL?
    
        override func viewDidLoad() {
        super.viewDidLoad()
//            let dc = UIDocumentInteractionController(url: fileURL!)
//            dc.delegate = self
//            dc.presentPreview(animated: true)
            let preview = QLPreviewController()
            preview.dataSource = self
            self.present(preview, animated: true, completion: nil)

    }
    
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        let url = fileURL
        return url! as QLPreviewItem
    }
    //let path =  Bundle.main.path(forResource: "Guide", ofType: ".pdf")!
        
}
