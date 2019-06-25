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
    @IBOutlet private weak var pagesLabel: UILabel!
    @IBOutlet private weak var rangePagesLabel: UILabel!
    @IBOutlet private weak var rangePageSlider: RangeSlider!
    @IBOutlet private weak var singlePageLabel: UILabel!
    @IBOutlet private weak var singlePageSlider: UISlider!
    
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
    
    @IBAction func splitAllPages(_ sender: UIButton) {
        let allPages = PDFServices.splitPages(from: self.pdf).map({ $0.dataRepresentation! })
        self.shareAlert(content: allPages)
    }
    
    @IBAction func newPDFFromRange(_ sender: UIButton) {
        
        let firstPage = Int(self.rangePageSlider.lowerValue)
        let lastPage = Int(self.rangePageSlider.upperValue)
        
        if firstPage >= 1 && lastPage <= self.pdf.pageCount && lastPage >= firstPage {
            let newPDF = PDFServices.createNewPDF(from: self.pdf, firstPage: firstPage, lastPage: lastPage)
            self.shareAlert(content: [newPDF.dataRepresentation()!])
        } else {
            // Alert with error
        }
    }
    
    @IBAction func rangePageSliderChanged(_ sender: RangeSlider) {
        self.rangePagesLabel.text = "Selected pages: \(Int(self.rangePageSlider.lowerValue)) - \(Int(self.rangePageSlider.upperValue))"
    }
    
    @IBAction func singlePageSliderChanged(_ sender: UISlider) {
        self.singlePageLabel.text = "Selected page: \(Int(sender.value))"
    }
    
    @IBAction func extractPage(_ sender: UIButton) {
        if let page = pdf.page(at: Int(self.singlePageSlider.value) - 1) {
            self.shareAlert(content: [page.dataRepresentation!])
        }
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
                        self.setupSliders()
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
        self.pagesLabel.text = "\(pdf.pageCount) \(pdf.pageCount == 1 ? "page" : "pages")"
    }
    
    private func setupSliders() {
        
        self.singlePageSlider.minimumValue = 1
        self.singlePageSlider.maximumValue = Float(self.pdf.pageCount)
        self.singlePageSlider.value = 1
        self.singlePageLabel.text = "Selected page: 1"
        
        self.rangePageSlider.maximumValue = CGFloat(self.pdf.pageCount)
        self.rangePageSlider.minimumValue = 1
        self.rangePageSlider.lowerValue = 1
        self.rangePageSlider.upperValue = CGFloat(self.pdf.pageCount)
//        self.rangePageSlider.
        self.rangePagesLabel.text = "Selected pages: 1 - \(Int(self.rangePageSlider.upperValue))"
    }

    private func shareAlert(content: [Any]) {
        let shareAlert = UIActivityViewController(activityItems: content, applicationActivities: nil)
        self.present(shareAlert, animated: true, completion: nil)
    }
}
