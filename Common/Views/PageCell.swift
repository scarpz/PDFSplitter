//
//  PageCell.swift
//  PDFSplitterExt
//
//  Created by Scarpz on 25/06/19.
//  Copyright © 2019 Felipe Scarpitta. All rights reserved.
//

import UIKit
import PDFKit

class PageCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet private weak var pdfView: PDFView!
    @IBOutlet private weak var checkbox: UIImageView!
    
    
    // MARK: - Properties
    var isPageSelected = false
    
    // MARK: - Methods
    func setup(pdfPage: PDFPage) {
        
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGray.cgColor
        
        let pdf = PDFDocument()
        pdf.insert(pdfPage, at: 0)
    
        self.pdfView.displayMode = .singlePage
        self.pdfView.autoScales = true
        self.pdfView.isUserInteractionEnabled = false
        self.pdfView.displayDirection = .vertical
        self.pdfView.document = pdf
    }
    
    // MARK: - Actions
    @IBAction func selectPage(_ sender: UIButton) {
        self.isPageSelected = !self.isPageSelected
        self.checkbox.image = self.isPageSelected ? UIImage(named: "checkbox") : UIImage(named: "uncheckbox")
    }
}
