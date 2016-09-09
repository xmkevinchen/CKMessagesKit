//
//  CKMessagesIndicatorView.swift
//  CKMessagesKit
//
//  Created by Kevin Chen on 9/4/16.
//  Copyright © 2016 Kevin Chen. All rights reserved.
//

import UIKit
import QuartzCore

@IBDesignable
public class CKMessagesIndicatorView: UIView {
    
    @IBInspectable
    public override var backgroundColor: UIColor? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    public var animationDuration: Double = 1.33 {
        didSet {
            
            if isAnimating {
                stopAnimation()
                startAnimation()
            }
            
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    public var dotsColor: UIColor = UIColor.lightGray {
        didSet {
            if isAnimating {
                stopAnimation()
                startAnimation()
            }
            
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    public var animateToColor: UIColor = UIColor.darkGray {
        didSet {
            if isAnimating {
                stopAnimation()
                startAnimation()
            }
            
            setNeedsDisplay()
        }
    }
    
    public private(set) var isAnimating: Bool = false
    
    private weak var dotsLayer: CAShapeLayer?
    private weak var containerLayer: CAReplicatorLayer?
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    public func startAnimation() {
        guard !isAnimating else {
            return
        }
        
        dotsLayer?.add(fillColorAnimation(), forKey: "darkening")
        isAnimating = true
    }
    
    public func stopAnimation() {
        guard isAnimating else {
            return
        }
        
        dotsLayer?.removeAnimation(forKey: "darkening")
        isAnimating = false
    }
        
    private func setup() {
                
        let dotDimension = frame.width / 7.125
        let firstDotCenterX = 2 * frame.width / 7
        let intervalBetweenDotsOnXAxis = 3.0 * frame.width / 14.0
        
        let container = CAReplicatorLayer()
        container.instanceTransform = CATransform3DMakeTranslation(intervalBetweenDotsOnXAxis, 0.0, 0.0)
        container.position = CGPoint(x: layer.bounds.width / 2.0, y: layer.bounds.height / 2.0)
        container.bounds = bounds
        container.instanceCount = 3
        container.instanceDelay = animationDuration / 7.0
        
        let dots = CAShapeLayer()
        dots.position = CGPoint(x: firstDotCenterX, y: container.bounds.height / 2.0)
        dots.bounds = CGRect(x: 0, y: 0, width: dotDimension, height: dotDimension)
        dots.path = UIBezierPath(ovalIn: dots.bounds).cgPath
        dots.fillColor = dotsColor.cgColor
        container.backgroundColor = UIColor.clear.cgColor
        
        container.addSublayer(dots)
        layer.addSublayer(container)
        
        containerLayer = container
        dotsLayer = dots
        
        
    }
        
    public override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
        startAnimation()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        if containerLayer?.bounds != bounds {
            if isAnimating { stopAnimation() }
            layer.sublayers?.forEach { $0.removeFromSuperlayer() }
            setup()
            
            startAnimation()
            
        }
    }
    
    
    private func fillColorAnimation() -> CAKeyframeAnimation {
        let animation = CAKeyframeAnimation(keyPath: "fillColor")
        animation.values = [
            dotsColor.cgColor,
            dotsColor.cgColor,
            animateToColor.cgColor,
            dotsColor.cgColor,
            dotsColor.cgColor
        ]
        animation.keyTimes = [0.0, NSNumber(value: 2.0/7.0), NSNumber(value: 1.0/2.0), NSNumber(value: 5.0/7.0), 1.0]
        animation.duration = animationDuration
        animation.repeatCount = Float.greatestFiniteMagnitude
        animation.autoreverses = true
        return animation
    }
    
}
