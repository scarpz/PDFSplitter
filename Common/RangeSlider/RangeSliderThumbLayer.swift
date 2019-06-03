//
//  RangeSliderThumbLayer.swift
//  PDFSplitter
//
//  Created by Felipe Scarpitta on 03/06/2019.
//  Copyright © 2019 Felipe Scarpitta. All rights reserved.
//

import UIKit

class RangeSliderThumbLayer: CALayer {
    
    weak var rangeSlider: RangeSlider?
    
    var highlighted: Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var strokeColor: UIColor = UIColor.gray {
        didSet {
            setNeedsDisplay()
        }
    }
    var lineWidth: CGFloat = 0.5 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(in ctx: CGContext) {
        guard let slider = rangeSlider else {
            return
        }
        
        let thumbFrame = bounds.insetBy(dx: 2.0, dy: 2.0)
        let cornerRadius = thumbFrame.height / 2.0
        let thumbPath = UIBezierPath(roundedRect: thumbFrame, cornerRadius: cornerRadius)
        
        // Fill
        ctx.setFillColor(slider.thumbTintColor.cgColor)
        ctx.addPath(thumbPath.cgPath)
        ctx.fillPath()
        
        // Outline
        ctx.setStrokeColor(strokeColor.cgColor)
        ctx.setLineWidth(lineWidth)
        ctx.addPath(thumbPath.cgPath)
        ctx.strokePath()
        
        shadowColor = UIColor.black.cgColor
        shadowOpacity = 0.15
        shadowOffset = CGSize(width: 0, height: 3)
        shadowRadius = 1.25
        
        // ORIGINAL
        //        if highlighted {
        //            ctx.setFillColor(UIColor(white: 0.0, alpha: 0.1).cgColor)
        //            ctx.addPath(thumbPath.cgPath)
        //            ctx.fillPath()
        //        }
    }
}
