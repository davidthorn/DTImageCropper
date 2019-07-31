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
        let cl: CGPoint /// center left
        let tr: CGPoint
        let ct: CGPoint /// center top
        let br: CGPoint
        let cr: CGPoint /// center right
        let bl: CGPoint
        let cb: CGPoint /// center bottom
        
        func convert(using point: CGPoint) -> BoxCoordinates {
            let w = br.x - point.x
            let h = br.y - point.y
            let w2 = w / 2
            let h2 = h / 2
            
            let tl: CGPoint = point
            let cl: CGPoint = .init(x: tl.x, y: tl.y + h2)
            let tr: CGPoint = .init(x: tl.x + w, y: tl.y)
            let ct: CGPoint = .init(x: tl.x + w2, y: tl.y)
            let br: CGPoint = .init(x: tl.x + w, y: tl.y + h)
            let cr: CGPoint = .init(x: br.x, y: tr.y + h2)
            let bl: CGPoint = .init(x: tl.x, y: tl.y + h)
            let cb: CGPoint = .init(x: bl.x + w2, y: br.y)
            
            return BoxCoordinates.init(tl: tl, cl: cl, tr: tr, ct: ct, br: br, cr: cr, bl: bl, cb: cb)
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
    
    internal var selectionBorderWidth: CGFloat {
        let w = boxWidth / 10
        return w < 15 ? 15 : w
    }
    
    internal var selectionBorderVisibleWidth: CGFloat {
        let w = selectionBorderWidth / 10
        return w < 3 ? 3 : w
    }
    
    internal var selectionBorderHeight: CGFloat {
        let w = boxHeight / 10
        return w < 15 ? 15 : w
    }
    
    internal var selectionBorderVisibleHeight: CGFloat {
        let w = selectionBorderHeight / 10
        return w < 3 ? 3 : w
    }
    
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
        drawCenterTopMarker()
        drawCenterBottomMarker()
        drawTopLeftMarker()
        drawCenterLeftMarker()
        drawTopRightMarker()
        drawCenterRightMarker()
        drawBottomRightMarker()
        drawBottomLeftMarker()
        UIColor.clear.setFill()
        innerRect = CGRect.init(x: borderRect.origin.x + 2 , y: borderRect.origin.y + 2, width: boxWidth - 4 , height: boxHeight - 4)
        UIRectFill(innerRect)
    }
    
    func drawMarker(x: CGFloat , y: CGFloat , widthMultiplier: CGFloat = 1.0 , heightMultiplier: CGFloat = 1.0) {
        let marker = CGRect.init(x: x, y: y, width: selectionBorderWidth * widthMultiplier, height: selectionBorderHeight * heightMultiplier)
        borderColor.setFill()
        UIRectFill(marker)
    }
    
    func drawCenterTopMarker() {
        drawMarker(x: coords.ct.x - selectionBorderWidth, y: coords.ct.y - selectionBorderVisibleHeight , widthMultiplier: 1.4)
    }
    
    func drawCenterBottomMarker() {
        drawMarker(x: coords.cb.x - selectionBorderWidth, y: coords.cb.y - (selectionBorderHeight - selectionBorderVisibleHeight) , widthMultiplier: 1.4)
    }
    
    func drawTopLeftMarker() {
        drawMarker(x: coords.tl.x - selectionBorderVisibleWidth, y: coords.tl.y - selectionBorderVisibleHeight)
    }
    
    func drawCenterLeftMarker() {
        drawMarker(x: coords.cl.x - selectionBorderVisibleWidth, y: coords.cl.y - selectionBorderHeight , heightMultiplier: 1.4)
    }
    
    func drawTopRightMarker() {
        drawMarker(x: coords.tr.x - (selectionBorderWidth - selectionBorderVisibleWidth ), y: coords.tr.y - selectionBorderVisibleHeight)
    }
    
    func drawCenterRightMarker() {
        drawMarker(x: coords.cr.x - (selectionBorderWidth - selectionBorderVisibleWidth ), y: coords.cr.y - selectionBorderHeight , heightMultiplier: 1.4)
    }
    
    
    func drawBottomRightMarker() {
        drawMarker(x: coords.br.x - (selectionBorderWidth - selectionBorderVisibleWidth ), y: coords.br.y - (selectionBorderHeight - selectionBorderVisibleHeight ) )
    }
    
    func drawBottomLeftMarker() {
        drawMarker(x: coords.bl.x - selectionBorderVisibleWidth, y: coords.bl.y - (selectionBorderHeight - selectionBorderVisibleHeight ) )
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
        let h = w
        let w2 = w / 2
        let h2 = h / 2
        let point = CGPoint.init(x: ((_w - w) / 2) - 4, y: ((_h - w) / 2) - 4)
        
        let tl: CGPoint = point
        let cl: CGPoint = .init(x: tl.x, y: tl.y + h2)
        let tr: CGPoint = .init(x: tl.x + w, y: tl.y)
        let ct: CGPoint = .init(x: tl.x + w2, y: tl.y)
        let br: CGPoint = .init(x: tl.x + w, y: tl.y + h)
        let cr: CGPoint = .init(x: br.x, y: tr.y + h2)
        let bl: CGPoint = .init(x: tl.x, y: tl.y + h)
        let cb: CGPoint = .init(x: bl.x + w2, y: br.y)
        
        coords =  BoxCoordinates.init(tl: tl, cl: cl, tr: tr, ct: ct, br: br, cr: cr, bl: bl, cb: cb)
        
    }
    
}
