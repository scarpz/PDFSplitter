//
//  PDFServices.swift
//  PDFSplitter
//
//  Created by Scarpz on 22/05/19.
//  Copyright © 2019 Felipe Scarpitta. All rights reserved.
//

import PDFKit

class PDFServices {
    
    static func loadPDF(from url: URL) -> PDFDocument? {
        if let pdf = PDFDocument(url: url) {
            return pdf
        } else {
            return nil
        }
    }
    
    static func splitPages(from pdf: PDFDocument) -> [PDFPage] {
        var allPages = [PDFPage]()
        for index in 0..<pdf.pageCount {
            if let page = pdf.page(at: index) {
                allPages.append(page)
            }
        }
        return allPages
    }
    
    static func transformIntoData(pages: [PDFPage]) -> [Data] {
        var allPageData = [Data]()
        pages.forEach({ allPageData.append($0.dataRepresentation!) })
        return allPageData
    }
    
    static func combine(pdfPages: [PDFPage]) -> PDFDocument {
        let pdf = PDFDocument()
        pdfPages.forEach({ pdf.insert($0, at: pdf.pageCount) })
        return pdf
    }
    
    static func createNewPDF(from pdf: PDFDocument, firstPage: Int, lastPage: Int) -> PDFDocument {
        let newPDF = PDFDocument()
        for index in firstPage...lastPage {
            if let page = pdf.page(at: index) {
                newPDF.insert(page, at: newPDF.pageCount)
            }
        }
        return newPDF
    }
    
    static func changePDFTitle(pdf: PDFDocument, title: String) {
        if var attributes = pdf.documentAttributes {
            attributes["Title"] = title
        } else {
            pdf.documentAttributes = [AnyHashable : Any]()
            pdf.documentAttributes!["Title"] = title
        }
    }
    
}
