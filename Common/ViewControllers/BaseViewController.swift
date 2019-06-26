//
//  BaseViewController.swift
//  PDFSplitter
//
//  Created by Felipe Scarpitta on 26/06/2019.
//  Copyright © 2019 Felipe Scarpitta. All rights reserved.
//

import UIKit
import PDFKit

class BaseViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var singlePageLabel: UILabel!
    @IBOutlet private weak var singlePageSlider: UISlider!
    @IBOutlet private weak var rangePagesLabel: UILabel!
    @IBOutlet private weak var rangePageSlider: RangeSlider!
    
    // MARK: - Properties
    var pdf: PDFDocument!

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Actions
    @IBAction func splitAllPages(_ sender: UIButton) {
        let allPages = PDFServices.splitPages(from: self.pdf).map({ $0.dataRepresentation! })
        self.shareAlert(content: allPages)
    }
    
    @IBAction func extractPage(_ sender: UIButton) {
        if let page = pdf.page(at: Int(self.singlePageSlider.value) - 1) {
            self.shareAlert(content: [page.dataRepresentation!])
        }
    }
    
    @IBAction func newPDFFromRange(_ sender: UIButton) {
        
        let firstPage = Int(self.rangePageSlider.lowerValue)
        let lastPage = Int(self.rangePageSlider.upperValue)
        
        if firstPage >= 1 && lastPage <= self.pdf.pageCount && lastPage >= firstPage {
            let newPDF = PDFServices.createNewPDF(from: self.pdf, firstPage: firstPage, lastPage: lastPage)
            self.shareAlert(content: [newPDF.dataRepresentation()!])
        } else {
            self.createAlert(style: .alert, title: "Oops...", message: "Your range of pages is not right. Please check it and try again", actionTitle1: "Ok", action1: nil)
        }
    }
    
    @IBAction func singlePageSliderChanged(_ sender: UISlider) {
        self.singlePageLabel.text = "Selected page: \(Int(sender.value))"
    }
    
    @IBAction func rangePageSliderChanged(_ sender: RangeSlider) {
        self.rangePagesLabel.text = "Selected pages: \(Int(self.rangePageSlider.lowerValue)) - \(Int(self.rangePageSlider.upperValue))"
    }
}

// MARK: - Public Methods
extension BaseViewController {
    
    func setupSliders() {
        
        self.singlePageSlider.minimumValue = 1
        self.singlePageSlider.maximumValue = Float(self.pdf.pageCount)
        self.singlePageSlider.value = 1
        self.singlePageLabel.text = "Selected page: 1"
        
        self.rangePageSlider.maximumValue = CGFloat(self.pdf.pageCount)
        self.rangePageSlider.minimumValue = 1
        self.rangePageSlider.lowerValue = 1
        self.rangePageSlider.upperValue = CGFloat(self.pdf.pageCount)
        self.rangePagesLabel.text = "Selected pages: 1 - \(Int(self.rangePageSlider.upperValue))"
    }
    
    func shareAlert(content: [Any]) {
        let shareAlert = UIActivityViewController(activityItems: content, applicationActivities: nil)
        self.present(shareAlert, animated: true, completion: nil)
    }
}
