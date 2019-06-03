//
//  RectExtension.swift
//  PDFSplitter
//
//  Created by Felipe Scarpitta on 03/06/2019.
//  Copyright © 2019 Felipe Scarpitta. All rights reserved.
//

import UIKit

extension CGRect {
    var center: CGPoint {
        return CGPoint(x: midX, y: midY)
    }
}
