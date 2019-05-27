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
    @IBOutlet private weak var pdfNameLabel: UILabel!
    
    // MARK: - Properties
    private weak var pdf: PDFDocument!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadIncomingPDF()
    }
    
    // MARK: - Actions
    @IBAction func done() {
        self.extensionContext!.completeRequest(returningItems: self.extensionContext!.inputItems, completionHandler: nil)
    }
    
    @IBAction func pdfSplitter(_ sender: UIBarButtonItem) {
        self.createPDFSplitterAlert()
    }
}

// MARK: - Private Methods
extension ActionViewController {
    
    private func loadIncomingPDF() {
        
        guard let context = self.extensionContext else {
            self.done()
            return
        }
        guard let fileItem = context.inputItems.first as? NSExtensionItem else {
            self.done()
            return
        }
        guard let itemProvider = fileItem.attachments?.first else {
            self.done()
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
                    }
                } else {
                    self.done()
                }
            }
        } else {
            self.done()
        }
    }
    
    private func display(pdf: PDFDocument) {
        self.pdfView.displayMode = .singlePage
        self.pdfView.autoScales = true
        self.pdfView.displayDirection = .vertical
        self.pdfView.document = pdf
        self.pdfNameLabel.text = PDFServices.getURLFileName(for: pdf)
    }
    
    private func createPDFSplitterAlert() {
        let outterAlert = UIAlertController(title: "PDF Splitter", message: "What do you want to do with this PDF?", preferredStyle: .actionSheet)
        outterAlert.addAction(UIAlertAction(title: "Split all pages", style: .default, handler: { _ in
            let allPages = PDFServices.splitPages(from: self.pdf).map({ $0.dataRepresentation! })
            self.shareAlert(content: allPages)
        }))
        outterAlert.addAction(UIAlertAction(title: "Extract PDF between pages", style: .default, handler: { _ in
            self.createPageRangePDFAlert()
        }))
        outterAlert.addAction(UIAlertAction(title: "Change PDF filename", style: .default, handler: { _ in
            let newPDF = PDFServices.change(pdfTitle: "Tchenefleners", for: self.pdf)
            self.shareAlert(content: [newPDF.dataRepresentation()!])
        }))
        outterAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(outterAlert, animated: true, completion: nil)
    }
    
    private func createPageRangePDFAlert() {
        let innerAlert = UIAlertController(title: "Which page range you want to extract the new PDF", message: nil, preferredStyle: .alert)
        innerAlert.addTextField(configurationHandler: { beginPageTextField in
            beginPageTextField.keyboardType = .numberPad
            beginPageTextField.placeholder = "Begin page"
        })
        innerAlert.addTextField(configurationHandler: { endPageTextField in
            endPageTextField.keyboardType = .numberPad
            endPageTextField.placeholder = "End page"
        })
        innerAlert.addAction(UIAlertAction(title: "Extract PDF", style: .default, handler: { _ in
            guard let beginPageText = innerAlert.textFields?[0].text,
                  let beginPage = Int(beginPageText),
                  let endPageText = innerAlert.textFields?[1].text,
                  let endPage = Int(endPageText) else {
                    self.done()
                    return
            }

            if beginPage > 1 && (endPage <= self.pdf.pageCount && endPage > beginPage) {
                let newPDF = PDFServices.createNewPDF(from: self.pdf, firstPage: beginPage, lastPage: endPage)
                self.shareAlert(content: [newPDF.dataRepresentation()!])
            } else {
                self.done()
            }
        }))
        innerAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            self.done()
        }))
        self.present(innerAlert, animated: true, completion: nil)
    }
    
    private func shareAlert(content: [Any]) {
        let shareAlert = UIActivityViewController(activityItems: content, applicationActivities: nil)
        self.present(shareAlert, animated: true, completion: nil)
    }
}
