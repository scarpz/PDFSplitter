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
    
    // MARK: - Outlets
    @IBOutlet private weak var pdfView: PDFView!
    @IBOutlet private weak var pdfNameLabel: UILabel!
    @IBOutlet private weak var pagesLabel: UILabel!

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadIncomingPDF()
    }
    
    // MARK: - Actions
    @IBAction func done() {
        self.extensionContext!.completeRequest(returningItems: self.extensionContext!.inputItems, completionHandler: nil)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ExtractPagesSegue" {
            let destination = segue.destination as! ExtractPagesViewController
            destination.pdf = self.pdf
        }
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
                        self.pdf = pdf
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
    
    private func display(pdf: PDFDocument) {
        self.pdfView.displayMode = .singlePage
        self.pdfView.autoScales = true
        self.pdfView.displayDirection = .vertical
        self.pdfView.document = pdf
        self.pdfNameLabel.text = PDFServices.getURLFileName(for: pdf)
        self.pagesLabel.text = "\(pdf.pageCount) \(pdf.pageCount == 1 ? "page" : "pages")"
    }

}
