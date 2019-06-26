//
//  ViewController.swift
//  PDFSplitter
//
//  Created by Felipe Scarpitta on 22/05/2019.
//  Copyright © 2019 Felipe Scarpitta. All rights reserved.
//

import UIKit
import PDFKit

class ViewController: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var pdfInfoView: UIView!
    @IBOutlet weak var textFieldSeparator: UIView!
    @IBOutlet weak var actionsStack: UIStackView!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupVC()
    }
    
    // MARK: - Actions
    @IBAction func validateButton(_ sender: UIButton) {
        
        self.loading.startAnimating()
        
        self.downloadPDF(text: self.urlTextField.text) { pdfData in
            
            DispatchQueue.main.async {
                
                self.loading.stopAnimating()
                
                if let data = pdfData, let pdf = PDFDocument(data: data) {
                    self.textFieldSeparator.backgroundColor = UIColor.green
                    self.pdfInfoView.isHidden = false
                    self.actionsStack.isHidden = false
                    self.display(pdf: pdf)
                    self.setupSliders()
                } else {
                    self.textFieldSeparator.backgroundColor = UIColor.red
                    self.pdfInfoView.isHidden = true
                    self.actionsStack.isHidden = true
                }
            }
        }
    }
}

// MARK: - Private Methods
extension ViewController {
    
    private func setupVC() {
        
        self.loading.stopAnimating()
        self.pdfInfoView.isHidden = true
        self.actionsStack.isHidden = true
    }
    
    private func downloadPDF(text: String?, completion: @escaping (Data?) -> Void) {
        
        guard let stringURL = text else {
            completion(nil)
            return
        }
        
        guard let url = URL(string: stringURL) else {
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                completion(data)
            } else {
                completion(nil)
            }
        }.resume()
    }

}
