//
//  RangeSlider.swift
//  PDFSplitter
//
//  Created by Felipe Scarpitta on 03/06/2019.
//  Copyright © 2019 Felipe Scarpitta. All rights reserved.
//

import UIKit

@IBDesignable
public class RangeSlider: UIControl {
    
    private enum HandleTracking { case none, left, right }
    private var handleTracking: HandleTracking = .none
    
    @IBInspectable public var minimumValue: CGFloat = 0.0 {
        willSet(newValue) {
            assert(newValue < maximumValue, "RangeSlider: minimumValue should be lower than maximumValue")
        }
        didSet {
            updateLayerFrames()
        }
    }
    
    @IBInspectable public var maximumValue: CGFloat = 1.0 {
        willSet(newValue) {
            assert(newValue > minimumValue, "RangeSlider: maximumValue should be greater than minimumValue")
        }
        didSet {
            updateLayerFrames()
        }
    }
    
    @IBInspectable public var lowerValue: CGFloat = 0.2 {
        didSet {
            if lowerValue < minimumValue {
                lowerValue = minimumValue
            }
            updateLayerFrames()
        }
    }
    
    @IBInspectable public var upperValue: CGFloat = 0.8 {
        didSet {
            if upperValue > maximumValue {
                upperValue = maximumValue
            }
            updateLayerFrames()
        }
    }
    
    var gapBetweenThumbs: CGFloat {
        return 0.5 * thumbWidth * (maximumValue - minimumValue) / bounds.width
    }
    
    // ORIGINAL
    //    @IBInspectable public var trackTintColor: UIColor(white: 0.95, alpha: 1.0) {
    //        didSet {
    //            trackLayer.setNeedsDisplay()
    //        }
    //    }
    
    @IBInspectable public var trackTintColor: UIColor = UIColor.lightGray {
        didSet {
            trackLayer.setNeedsDisplay()
        }
    }
    
    // ORIGINAL
    //    @IBInspectable public var trackHighlightTintColor: UIColor = UIColor(red: 0.0, green: 0.45, blue: 0.94, alpha: 1.0) {
    //        didSet {
    //            trackLayer.setNeedsDisplay()
    //        }
    //    }
    
    @IBInspectable public var trackHighlightTintColor: UIColor = UIColor(red: 21 / 255, green: 126 / 250, blue: 251 / 255, alpha: 1.0) {
        didSet {
            trackLayer.setNeedsDisplay()
        }
    }
    
    @IBInspectable public var thumbTintColor: UIColor = UIColor.white {
        didSet {
            lowerThumbLayer.setNeedsDisplay()
            upperThumbLayer.setNeedsDisplay()
        }
    }
    
    @IBInspectable public var thumbBorderColor: UIColor = UIColor.gray {
        didSet {
            lowerThumbLayer.strokeColor = thumbBorderColor
            upperThumbLayer.strokeColor = thumbBorderColor
        }
    }
    
    @IBInspectable public var thumbBorderWidth: CGFloat = 0.5 {
        didSet {
            lowerThumbLayer.lineWidth = thumbBorderWidth
            upperThumbLayer.lineWidth = thumbBorderWidth
        }
    }
    
    /// If true, the control will mimic a normal slider and have only one handle rather than a range.
    /// In this case, the selectedMinValue will be not functional anymore. Use selectedMaxValue instead to determine the value the user has selected.
    @IBInspectable open var disableRange: Bool = false {
        didSet {
            lowerThumbLayer.isHidden = disableRange
        }
    }
    
    /// The minimum distance the two selected slider values must be apart. Default is 0.
    @IBInspectable open var minDistance: CGFloat = 0.0 {
        didSet {
            if minDistance < 0.0 {
                minDistance = 0.0
            }
        }
    }
    
    /// The maximum distance the two selected slider values must be apart. Default is CGFloat.greatestFiniteMagnitude.
    @IBInspectable open var maxDistance: CGFloat = .greatestFiniteMagnitude {
        didSet {
            if maxDistance < 0.0 {
                maxDistance = .greatestFiniteMagnitude
            }
        }
    }
    
    // ORIGINAL
    //    @IBInspectable public var curvaceousness: CGFloat = 1.0 {
    //        didSet {
    //            if curvaceousness < 0.0 {
    //                curvaceousness = 0.0
    //            }
    //
    //            if curvaceousness > 1.0 {
    //                curvaceousness = 1.0
    //            }
    //
    //            trackLayer.setNeedsDisplay()
    //            lowerThumbLayer.setNeedsDisplay()
    //            upperThumbLayer.setNeedsDisplay()
    //        }
    //    }
    
    fileprivate var previousLocation = CGPoint()
    
    fileprivate let trackLayer = RangeSliderTrackLayer()
    fileprivate let lowerThumbLayer = RangeSliderThumbLayer()
    fileprivate let upperThumbLayer = RangeSliderThumbLayer()
    
    // ORIGINAL
    //    fileprivate var thumbWidth: CGFloat {
    //        return CGFloat(bounds.height)
    //    }
    
    fileprivate var thumbWidth: CGFloat {
        return 32
    }
    
    fileprivate var trackHeight: CGFloat {
        return 2
    }
    
    override public var frame: CGRect {
        didSet {
            updateLayerFrames()
        }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        initializeLayers()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        initializeLayers()
    }
    
    override public func layoutSublayers(of: CALayer) {
        super.layoutSublayers(of:layer)
        updateLayerFrames()
    }
    
    fileprivate func initializeLayers() {
        layer.backgroundColor = UIColor.clear.cgColor
        
        trackLayer.rangeSlider = self
        trackLayer.contentsScale = UIScreen.main.scale
        layer.addSublayer(trackLayer)
        
        lowerThumbLayer.rangeSlider = self
        lowerThumbLayer.contentsScale = UIScreen.main.scale
        layer.addSublayer(lowerThumbLayer)
        
        upperThumbLayer.rangeSlider = self
        upperThumbLayer.contentsScale = UIScreen.main.scale
        layer.addSublayer(upperThumbLayer)
    }
    
    func updateLayerFrames() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        trackLayer.frame = CGRect(x: 0, y: (thumbWidth / 2) - (trackHeight / 2) - 1, width: bounds.width, height: trackHeight)
        
        // ORIGINAL
        //        trackLayer.frame = bounds.insetBy(dx: 0.0, dy: bounds.height/3)
        
        trackLayer.setNeedsDisplay()
        
        let lowerThumbCenter = CGFloat(positionForValue(lowerValue))
        lowerThumbLayer.frame = CGRect(x: lowerThumbCenter - thumbWidth / 1.7, y: -1.0, width: thumbWidth, height: thumbWidth)
        lowerThumbLayer.setNeedsDisplay()
        
        let upperThumbCenter = CGFloat(positionForValue(upperValue))
        upperThumbLayer.frame = CGRect(x: upperThumbCenter - thumbWidth / 2.4, y: -1.0, width: thumbWidth, height: thumbWidth)
        upperThumbLayer.setNeedsDisplay()
        
        CATransaction.commit()
    }
    
    func positionForValue(_ value: CGFloat) -> CGFloat {
        return (bounds.width - thumbWidth) * (value - minimumValue) /
            (maximumValue - minimumValue) + (thumbWidth / 2.0)
    }
    
    func boundValue(_ value: Double, toLowerValue lowerValue: Double, upperValue: Double) -> Double {
        return min(max(value, lowerValue), upperValue)
    }
    
    
    // MARK: - Touches
    override public func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        previousLocation = touch.location(in: self)
        
        let insetExpansion: CGFloat = -30.0
        let isTouchingLeftHandle: Bool = lowerThumbLayer.frame.insetBy(dx: insetExpansion, dy: insetExpansion).contains(previousLocation)
        let isTouchingRightHandle: Bool = upperThumbLayer.frame.insetBy(dx: insetExpansion, dy: insetExpansion).contains(previousLocation)
        
        guard isTouchingLeftHandle || isTouchingRightHandle else { return false }
        
        // the touch was inside one of the handles so we're definitely going to start movign one of them. But the handles might be quite close to each other, so now we need to find out which handle the touch was closest too, and activate that one.
        let distanceFromLeftHandle: CGFloat = previousLocation.distance(to: lowerThumbLayer.frame.center)
        let distanceFromRightHandle: CGFloat = previousLocation.distance(to: upperThumbLayer.frame.center)
        
        if distanceFromLeftHandle < distanceFromRightHandle && !disableRange {
            handleTracking = .left
        } else if upperValue == self.maximumValue && lowerThumbLayer.frame.midX == upperThumbLayer.frame.midX {
            handleTracking = .left
        } else {
            handleTracking = .right
        }
        
        sendActions(for: .editingDidBegin)
        
        return true
    }
    
    override public func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        
        guard handleTracking != .none else { return false }
        
        let location: CGPoint = touch.location(in: self)
        
        // find out the percentage along the line we are in x coordinate terms (subtracting half the frames width to account for moving the middle of the handle, not the left hand side)
        let percentage: CGFloat = (location.x - trackLayer.frame.minX - thumbWidth / 2.0) / (trackLayer.frame.maxX - trackLayer.frame.minX)
        
        // multiply that percentage by self.maxValue to get the new selected minimum value
        let selectedValue: CGFloat = percentage * (maximumValue - minimumValue) + minimumValue
        
        switch handleTracking {
        case .left:
            lowerValue = min(selectedValue, upperValue)
        case .right:
            // don't let the dots cross over, (unless range is disabled, in which case just dont let the dot fall off the end of the screen)
            if disableRange && selectedValue >= minimumValue {
                upperValue = selectedValue
            } else {
                upperValue = max(selectedValue, lowerValue)
            }
        case .none:
            // no need to refresh the view because it is done as a side-effect of setting the property
            break
        }
        
        refresh()
        
        return true
    }
    
    override public func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        lowerThumbLayer.highlighted = false
        upperThumbLayer.highlighted = false
        
        handleTracking = .none
        
        sendActions(for: .editingDidEnd)
    }
    
    // UIFeedbackGenerator
    private var previousStepMinValue: CGFloat?
    private var previousStepMaxValue: CGFloat?
    
    fileprivate func refresh() {
        if let previousStepMinValue = previousStepMinValue, previousStepMinValue != lowerValue {
            TapticEngine.selection.feedback()
        }
        previousStepMinValue = lowerValue
        
        if let previousStepMaxValue = previousStepMaxValue, previousStepMaxValue != upperValue {
            TapticEngine.selection.feedback()
        }
        previousStepMaxValue = upperValue
        
        let diff: CGFloat = upperValue - lowerValue
        
        if diff < minDistance {
            switch handleTracking {
            case .left:
                lowerValue = upperValue - minDistance
            case .right:
                upperValue = lowerValue + minDistance
            case .none:
                break
            }
        } else if diff > maxDistance {
            switch handleTracking {
            case .left:
                lowerValue = upperValue - maxDistance
            case .right:
                upperValue = lowerValue + maxDistance
            case .none:
                break
            }
        }
        
        // ensure the minimum and maximum selected values are within range. Access the values directly so we don't cause this refresh method to be called again (otherwise changing the properties causes a refresh)
        if lowerValue < minimumValue {
            lowerValue = minimumValue
        }
        if upperValue > maximumValue {
            upperValue = maximumValue
        }
        
        // update the frames in a transaction so that the tracking doesn't continue until the frame has moved.
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        CATransaction.commit()
        
        if handleTracking != .none {
            sendActions(for: .valueChanged)
        }
    }
}
