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
    
    var pdf: PDFDocument!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = Bundle.main.url(forResource: "Document", withExtension: "pdf")!
        
        self.pdf = PDFServices.loadPDF(from: url)
    }
    
    @IBAction func splitPDF(_ sender: UIButton) {
        PDFServices.splitPages(from: self.pdf)
    }
    
    @IBAction func createPDFFromRange(_ sender: UIButton) {
        PDFServices.createNewPDF(from: self.pdf, firstPage: 10, lastPage: 20)
    }
    
    @IBAction func loadPDF(_ sender: UIButton) {
        
    }
    
    @IBAction func shareAllPages(_ sender: UIBarButtonItem) {
//        let share = UIActivityViewController(activityItems: self.allPages, applicationActivities: nil)
//
//        self.present(share, animated: true, completion: nil)
    }
}
