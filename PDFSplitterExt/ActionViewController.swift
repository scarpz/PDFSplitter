//
//  ActionViewController.swift
//  PDFSplitterExt
//
//  Created by Scarpz on 23/05/19.
//  Copyright © 2019 Felipe Scarpitta. All rights reserved.
//

import UIKit
import MobileCoreServices
import PDFKit

class ActionViewController: BaseViewController {
 
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadIncomingPDF()
    }
    
    // MARK: - Actions
    @IBAction func done() {
        self.extensionContext!.completeRequest(returningItems: self.extensionContext!.inputItems, completionHandler: nil)
    }
}

// MARK: - Private Methods
extension ActionViewController {
    
    private func loadIncomingPDF() {
        
        guard let context = self.extensionContext else {
            self.createGenericErrorAlert(completion: { _ in
                self.done()
            })
            return
        }
        guard let fileItem = context.inputItems.first as? NSExtensionItem else {
            self.createGenericErrorAlert(completion: { _ in
                self.done()
            })
            return
        }
        guard let itemProvider = fileItem.attachments?.first else {
            self.createGenericErrorAlert(completion: { _ in
                self.done()
            })
            return
        }
        
        let identifier = kUTTypePDF as String
        
        if itemProvider.hasItemConformingToTypeIdentifier(identifier) {
            
            itemProvider.loadItem(forTypeIdentifier: identifier, options: nil) { pdfURL, error in
                
                if let pdfURL = pdfURL as? URL {
                    guard let pdf = PDFDocument(url: pdfURL) else { return }
                    DispatchQueue.main.async {
                        self.display(pdf: pdf)
                        self.setupSliders()
                    }
                } else {
                    self.createGenericErrorAlert(completion: { _ in
                        self.done()
                    })
                }
            }
        } else {
            self.createGenericErrorAlert(completion: { _ in
                self.done()
            })
        }
    }

}
