//
//  DTOverlayView.swift
//  DTImageCropper
//
//  Created by David Thorn on 29.07.19.
//  Copyright © 2019 David Thorn. All rights reserved.
//

import UIKit

open class DTOverlayView: UIView {
    
    struct BoxCoordinates {
        let tl: CGPoint
        let tr: CGPoint
        let br: CGPoint
        let bl: CGPoint
        
        func convert(using point: CGPoint) -> BoxCoordinates {
            let w = br.x - point.x
            let h = br.y - point.y
            
            let tl: CGPoint = point
            let tr: CGPoint = .init(x: tl.x + w, y: tl.y)
            let br: CGPoint = .init(x: tl.x + w, y: tl.y + h)
            let bl: CGPoint = .init(x: tl.x, y: tl.y + h)
            
            return BoxCoordinates.init(tl: tl, tr: tr, br: br, bl: bl)
        }
        
    }
    
    var coords: BoxCoordinates!
    
    // indicates of the cropping box is permitted to be resized
    internal var allowResizing: Bool = false
    
    internal let minimumBoxWidth: CGFloat = 50 /// to be used later
    internal let minimumBoxHeight: CGFloat = 50 /// to be uses later
    
    /// The clear inner rectantangle that sits within the border rectangle
    internal var innerRect: CGRect!
    
    /// The rectangle of the border
    internal var borderRect: CGRect!
    
    /// The used used to fill the border on draw
    internal var borderColor: UIColor = UIColor.white
    
    internal func setup() {
        self.backgroundColor = .clear
        self.isUserInteractionEnabled = false
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
       setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    /// The width of this view itself
    internal var width: CGFloat {
        return bounds.width
    }
    
    /// The height of this view itself
    internal var height: CGFloat {
        return bounds.height
    }
    
    /// The width of the cropping box
    internal var boxWidth: CGFloat {
        return coords.br.x - coords.bl.x
    }
    
    /// The width of the cropping box
    internal var boxHeight: CGFloat {
        return coords.br.y - coords.tr.y
    }
    
    internal var mainRect: CGRect {
        return CGRect.init(x: 0, y: 0, width: bounds.width, height: bounds.height)
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override open func draw(_ rect: CGRect) {
        // Drawing code
        
        UIColor.black.withAlphaComponent(0.4).setFill()
        UIRectFill(mainRect)
        
        borderColor.setFill()
        
        borderRect = CGRect.init(x: coords.tl.x , y: coords.tl.y , width: boxWidth , height: boxHeight)
        UIRectFill(borderRect)
        
        UIColor.clear.setFill()
        innerRect = CGRect.init(x: borderRect.origin.x + 2 , y: borderRect.origin.y + 2, width: boxWidth - 4 , height: boxHeight - 4)
        UIRectFill(innerRect)
        
    }
    
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let o = super.hitTest(point, with: event)
        
        if borderRect.insetBy(dx: -10, dy: -10).contains(point) {
            if !innerRect.insetBy(dx: 10, dy: 10).contains(point) {
                hitBorder(result: true)
            } else {
                hitBorder(result: false)
            }
        } else {
            if self.borderColor != .white {
                hitBorder(result: false)
            }
        }
        
        return o
    }
    
    internal func hitBorder(result: Bool) {
        self.borderColor = result ? .red : .white
        self.isUserInteractionEnabled = result
        self.allowResizing = result
        self.setNeedsDisplay()
    }
    
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) , allowResizing else { return }
        coords = coords.convert(using: point)
        self.setNeedsDisplay()
        print(point)
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.allowResizing = false
        self.isUserInteractionEnabled = false
        self.borderColor = .white
        self.setNeedsDisplay()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        guard self.coords == nil else { return }
        let _w = width
        let _h = height
        let w = _w * 0.8
        let point = CGPoint.init(x: ((_w - w) / 2) - 4, y: ((_h - w) / 2) - 4)
        
        let tl: CGPoint = point
        let tr: CGPoint = .init(x: tl.x + w, y: tl.y)
        let br: CGPoint = .init(x: tl.x + w, y: tl.y + w)
        let bl: CGPoint = .init(x: tl.x, y: tl.y + w)
        
        coords = BoxCoordinates.init(tl: tl, tr: tr, br: br, bl: bl)
        
    }
    
}
