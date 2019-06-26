//
//  ViewControllerExtension.swift
//  PDFSplitter
//
//  Created by Felipe Scarpitta on 26/06/2019.
//  Copyright © 2019 Felipe Scarpitta. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func createAlert(style: UIAlertController.Style, title: String, message: String? = nil, actionTitle1: String, action1: ((UIAlertAction) -> Void)?, action1Style: UIAlertAction.Style = .default, actionTitle2: String? = nil, action2: ((UIAlertAction) -> Void)? = nil, action2Style: UIAlertAction.Style = .default, cancelTitle: String? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        
        let action1 = UIAlertAction(title: actionTitle1, style: action1Style, handler: action1)
        alert.addAction(action1)
        
        if actionTitle2 != nil {
            let action2 = UIAlertAction(title: actionTitle2, style: action2Style, handler: action2)
            alert.addAction(action2)
        }
        
        if cancelTitle != nil {
            let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: nil)
            alert.addAction(cancelAction)
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func createGenericErrorAlert(completion: ((UIAlertAction) -> Void)?) {
        self.createAlert(style: .alert, title: "Oops...", message: "An error has occurred. Please try again or contact the development team", actionTitle1: "Ok", action1: completion)
    }
}
