//
//  PointExtension.swift
//  PDFSplitter
//
//  Created by Felipe Scarpitta on 03/06/2019.
//  Copyright © 2019 Felipe Scarpitta. All rights reserved.
//

import UIKit

extension CGPoint {
    func distance(to: CGPoint) -> CGFloat {
        let distX: CGFloat = to.x - x
        let distY: CGFloat = to.y - y
        return sqrt(distX * distX + distY * distY)
    }
}
