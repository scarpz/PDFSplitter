//
//  PDFServices.swift
//  PDFSplitter
//
//  Created by Scarpz on 22/05/19.
//  Copyright © 2019 Felipe Scarpitta. All rights reserved.
//

import PDFKit

class PDFServices {
    
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
    
    static func combine(pdfs: [PDFDocument]) -> PDFDocument {
        let finalPDF = PDFDocument()
        
        for pdf in pdfs {
            for page in PDFServices.splitPages(from: pdf) {
                finalPDF.insert(page, at: finalPDF.pageCount)
            }
        }
        return finalPDF
    }
    
    static func createNewPDF(from pdf: PDFDocument, firstPage: Int, lastPage: Int) -> PDFDocument {
        let newPDF = PDFDocument()
        newPDF.documentAttributes = pdf.documentAttributes
        for index in firstPage...lastPage {
            if let page = pdf.page(at: index) {
                newPDF.insert(page, at: newPDF.pageCount)
            }
        }
        return newPDF
    }
    
    static func change(pdfTitle title: String, for pdf: PDFDocument) throws {
        let temporaryFolder = FileManager.default.temporaryDirectory
        let fileName = "\(title).pdf"
        let temporaryFileURL = temporaryFolder.appendingPathComponent(fileName)

        do {
            let pdfData = pdf.dataRepresentation()!
            
            try pdfData.write(to: temporaryFileURL)
            
            if var attributes = pdf.documentAttributes {
                attributes["Title"] = title
            } else {
                pdf.documentAttributes = [AnyHashable : Any]()
                pdf.documentAttributes!["Title"] = title
            }
        } catch let error {
            print(error)
        }
    }
}
