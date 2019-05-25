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

class ActionViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var pdfView: PDFView!
    
    // MARK: - Properties
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadIncomingPDF()
    }
    
    // MARK: - Actions
    @IBAction func done() {
        // Return any edited content to the host app.
        // This template doesn't do anything, so we just echo the passed in items.
        self.extensionContext!.completeRequest(returningItems: self.extensionContext!.inputItems, completionHandler: nil)
    }
}

// MARK: - Private Methods
extension ActionViewController {
    
    private func loadIncomingPDF() {
        
        guard let context = self.extensionContext else { return }
        guard let fileItem = context.inputItems.first as? NSExtensionItem else { return }
        guard let itemProvider = fileItem.attachments?.first else { return }
        
        let identifier = kUTTypePDF as String
        
        if itemProvider.hasItemConformingToTypeIdentifier(identifier) {
            
            itemProvider.loadItem(forTypeIdentifier: identifier, options: nil) { pdfURL, error in
                
                if let pdfURL = pdfURL as? URL {
                    guard let pdf = PDFDocument(url: pdfURL) else { return }
                    DispatchQueue.main.async {
                        self.display(pdf: pdf)
                    }
                }
            }
        } else {
            self.done()
        }
        
    }
    
    private func display(pdf: PDFDocument) {
        self.pdfView.displayMode = .singlePageContinuous
        self.pdfView.autoScales = true
        self.pdfView.displayDirection = .vertical
        self.pdfView.document = pdf
    }
}
