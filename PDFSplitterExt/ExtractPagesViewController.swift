//
//  ExtractPagesViewController.swift
//  PDFSplitterExt
//
//  Created by Scarpz on 25/06/19.
//  Copyright © 2019 Felipe Scarpitta. All rights reserved.
//

import UIKit
import PDFKit

class ExtractPagesViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var collectionView: UICollectionView!
    
    // MARK: - Properties
    var pdf: PDFDocument!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupExtractPagesView()
    }
    
    // MARK: - Actions
    @IBAction func extractPages(_ sender: UIBarButtonItem) {
        
        let newPDF = PDFDocument()
        
        for index in 0..<self.pdf.pageCount {
            
            let cell = self.collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as! PageCell
            
            if cell.isPageSelected {
                newPDF.insert(self.pdf.page(at: index)!, at: newPDF.pageCount)
            }
        }
        
        if newPDF.pageCount == 0 {
            print("None page selected")
        } else {
            let shareAlert = UIActivityViewController(activityItems: [newPDF.dataRepresentation()!], applicationActivities: nil)
            self.present(shareAlert, animated: true, completion: nil)
        }
    }
}

// MARK: - Private Methods
extension ExtractPagesViewController {
    
    private func setupExtractPagesView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.collectionView.allowsMultipleSelection = true
    }
}

// MARK: - Collection View Methods
extension ExtractPagesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.pdf.pageCount
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.view.frame.width / 3) - 15
        let height = width * 1.3
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PageCell", for: indexPath) as! PageCell
        cell.setup(pdfPage: self.pdf.page(at: indexPath.row)!)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)!
        cell.isSelected = !cell.isSelected
        
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
