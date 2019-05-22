//
//  ViewController.swift
//  PDFSplitter
//
//  Created by Felipe Scarpitta on 22/05/2019.
//  Copyright © 2019 Felipe Scarpitta. All rights reserved.
//

import UIKit
import PDFKit

class ViewController: UIViewController {

    @IBOutlet weak var pdfFileName: UILabel!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    var pdf: PDFDocument!
    var allPages = [Data]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func loadPDF(_ sender: UIButton) {
//        guard let url = Bundle.main.url(forResource: "Document", withExtension: "pdf") else {
//            print("Error getting PDF")
//            return
//        }
        
        guard let url = URL(string: "https://www.adobe.com/content/dam/acom/en/devnet/pdf/pdfs/PDF32000_2008.pdf") else {
            return
        }
        
        if let pdf = PDFDocument(url: url) {
            self.pdf = pdf
            self.pdfFileName.text = "File ok!"
            self.message.text = "PDF with \(pdf.pageCount) pages"
        }
    }
    
    
    @IBAction func splitPDF(_ sender: Any) {
        
        for index in 0..<self.pdf.pageCount {
            
            if let page = self.pdf.page(at: index), let pageData = page.dataRepresentation {
                
                let progress = Float(index) / Float(self.pdf.pageCount)
                
                self.progressView.setProgress(progress, animated: true)
                
                self.allPages.append(pageData)
            }
        }
        
        if self.allPages.count == self.pdf.pageCount {
            self.progressView.setProgress(1, animated: true)
        }
    }
    
    @IBAction func shareAllPages(_ sender: UIBarButtonItem) {
        let share = UIActivityViewController(activityItems: self.allPages, applicationActivities: nil)
        
        self.present(share, animated: true, completion: nil)
    }
}

