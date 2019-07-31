//
//  DTOverlayView.swift
//  DTImageCropper
//
//  Created by David Thorn on 29.07.19.
//  Copyright © 2019 David Thorn. All rights reserved.
//

import UIKit

enum Movement {
    case horizontal
    case vertical
    case both
}

struct Marker {
    let movement: Movement
    let rect: CGRect
    let box: Box
    
    enum Box {
        case tl
        case ct
        case tr
        case cr
        case br
        case cb
        case bl
        case cl
        case inner
    }
    
    func contains(point: CGPoint) -> Bool {
        
        let bgLeft = rect.insetBy(dx: -20, dy: -20)
        let bgRight = rect.insetBy(dx: 20, dy: 20)
        
        return bgLeft.contains(point) || bgRight.contains(point)
    }
}

open class DTOverlayView: UIView {
    
    var activeMarker: Marker?
    
    var markers: [Marker] = []
    
    struct BoxCoordinates {
        let tl: CGPoint
        let cl: CGPoint /// center left
        let tr: CGPoint
        let ct: CGPoint /// center top
        let br: CGPoint
        let cr: CGPoint /// center right
        let bl: CGPoint
        let cb: CGPoint /// center bottom
        
        func convert(using origin: CGPoint, width: CGFloat , height: CGFloat) -> BoxCoordinates {
            
            if min(width , height) < 40 {
                return self
            }
            
            let w = width
            let h = height
            let w2 = w / 2
            let h2 = h / 2
            
            let tl: CGPoint = origin
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
        markers.removeAll()
        
        /// draw the dark shawdow that sits over the image
        UIColor.black.withAlphaComponent(0.4).setFill()
        UIRectFill(mainRect)
        
        /// draw the outer border
        borderColor.setFill()
        borderRect = CGRect.init(x: coords.tl.x , y: coords.tl.y , width: boxWidth , height: boxHeight)
        UIRectFill(borderRect)
        
        /// draw the movement markers first so that their inner fill will be removed in the next step
        addMovementMarkers()
        
        /// draw the inner rect that will display the cropping area of the image
        UIColor.clear.setFill()
        innerRect = CGRect.init(x: borderRect.origin.x + 2 , y: borderRect.origin.y + 2, width: boxWidth - 4 , height: boxHeight - 4)
        UIRectFill(innerRect)
        
        /// add the inner marker to the markers for touch and movement detection
        self.markers.append(.init(movement: .both, rect: innerRect, box: .inner))
    }
    
    func drawMarker(x: CGFloat , y: CGFloat , box: Marker.Box , widthMultiplier: CGFloat = 1.0 , heightMultiplier: CGFloat = 1.0) {
        let marker = CGRect.init(x: x, y: y, width: selectionBorderWidth * widthMultiplier, height: selectionBorderHeight * heightMultiplier)
        borderColor.setFill()
        UIRectFill(marker)
        switch box {
        case .bl, .br , .tl, .tr:
            markers.append(.init(movement: .both, rect: marker, box: box))
        case .cb , .ct:
            markers.append(.init(movement: .vertical, rect: marker, box: box))
        case .cl , .cr:
             markers.append(.init(movement: .horizontal, rect: marker, box: box))
        default:
            fatalError("This method should not deal with other markers")
        }
    }
    
    func addMovementMarkers() {
        drawCenterTopMarker()
        drawCenterBottomMarker()
        drawTopLeftMarker()
        drawCenterLeftMarker()
        drawTopRightMarker()
        drawCenterRightMarker()
        drawBottomRightMarker()
        drawBottomLeftMarker()
    }
    
    func drawCenterTopMarker() {
        drawMarker(x: coords.ct.x - selectionBorderWidth, y: coords.ct.y - selectionBorderVisibleHeight , box: .ct , widthMultiplier: 1.4)
    }
    
    func drawCenterBottomMarker() {
        drawMarker(x: coords.cb.x - selectionBorderWidth, y: coords.cb.y - (selectionBorderHeight - selectionBorderVisibleHeight) , box: .cb , widthMultiplier: 1.4)
    }
    
    func drawTopLeftMarker() {
        drawMarker(x: coords.tl.x - selectionBorderVisibleWidth, y: coords.tl.y - selectionBorderVisibleHeight , box: .tl)
    }
    
    func drawCenterLeftMarker() {
        drawMarker(x: coords.cl.x - selectionBorderVisibleWidth, y: coords.cl.y - selectionBorderHeight , box: .cl , heightMultiplier: 1.4)
    }
    
    func drawTopRightMarker() {
        drawMarker(x: coords.tr.x - (selectionBorderWidth - selectionBorderVisibleWidth ), y: coords.tr.y - selectionBorderVisibleHeight , box: .tr )
    }
    
    func drawCenterRightMarker() {
        drawMarker(x: coords.cr.x - (selectionBorderWidth - selectionBorderVisibleWidth ), y: coords.cr.y - selectionBorderHeight , box: .cr , heightMultiplier: 1.4)
    }
    
    func drawBottomRightMarker() {
        drawMarker(x: coords.br.x - (selectionBorderWidth - selectionBorderVisibleWidth ), y: coords.br.y - (selectionBorderHeight - selectionBorderVisibleHeight ) , box: .br )
    }
    
    func drawBottomLeftMarker() {
        drawMarker(x: coords.bl.x - selectionBorderVisibleWidth, y: coords.bl.y - (selectionBorderHeight - selectionBorderVisibleHeight ) , box: .bl )
    }
    
    internal var hitPoint: CGPoint?
    
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let o = super.hitTest(point, with: event)
        
        guard let touchedMarker = self.markers.first(where: { $0.contains(point: point) }) else {
            if self.borderColor != .white {
                hitBorder(result: false)
            }
            return o
        }
        
        self.hitPoint = point
        self.activeMarker = touchedMarker
        hitBorder(result: true)
        return o
    }
    
    internal func hitBorder(result: Bool) {
        self.borderColor = result ? UIColor.white.withAlphaComponent(0.9) : .white
        self.isUserInteractionEnabled = result
        self.allowResizing = result
        self.setNeedsDisplay()
    }
    
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) , allowResizing else { return }
        guard let active = self.activeMarker else { return }

        switch active.box {
        case .tl:
            coords = coords.convert(using: point, width: coords.tr.x - point.x, height: coords.br.y - point.y)
        case .bl:
            let tl = CGPoint.init(x: point.x, y:  point.y - (point.y - coords.tr.y) )
            coords = coords.convert(using: tl, width: coords.br.x - point.x, height: point.y - coords.tr.y)
        case .br:
            let w = point.x  - coords.tl.x
            let h = point.y - coords.tl.y
            let tl = CGPoint.init(x: point.x - w, y:  point.y - h )
            coords = coords.convert(using: tl, width: w, height: h)
        case .tr:
            let w = point.x  - coords.bl.x
            let h = coords.bl.y - point.y
            let tl = CGPoint.init(x: point.x - w, y:  point.y )
            coords = coords.convert(using: tl, width: w, height: h)
        case .ct:
            let w = coords.tr.x - coords.tl.x
            let h = coords.br.y - point.y
            let tl = CGPoint.init(x: coords.tl.x, y: point.y)
            coords = coords.convert(using: tl, width: w, height: h)
        case .cb:
            let w = coords.tr.x - coords.tl.x
            let h = point.y - coords.tl.y
            let tl = CGPoint.init(x: coords.tl.x, y: point.y - h)
            coords = coords.convert(using: tl, width: w, height: h)
        case .cl:
            let w = coords.tr.x - point.x
            let h = coords.br.y - coords.tr.y
            let tl = CGPoint.init(x: point.x, y: coords.tl.y)
            coords = coords.convert(using: tl, width: w, height: h)
        case .cr:
            let w = point.x - coords.tl.x
            let h = coords.br.y - coords.tr.y
            let tl = CGPoint.init(x: coords.tl.x, y: coords.tl.y)
            coords = coords.convert(using: tl, width: w, height: h)
        case .inner:
            let w = coords.tr.x - coords.tl.x
            let h = coords.br.y - coords.tr.y
            let x_ = point.x - hitPoint!.x
            let y_ = point.y - hitPoint!.y
            let tl = CGPoint.init(x: coords.tl.x + x_, y: coords.tl.y + y_)
            let new_coords = coords.convert(using: tl, width: w, height: h)
            if bounds.contains(new_coords.tr) && bounds.contains(new_coords.tl) && bounds.contains(new_coords.bl) && bounds.contains(new_coords.br) {
                coords = new_coords
                hitPoint = point
            }
            
        }
        self.setNeedsDisplay()
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.allowResizing = false
        self.isUserInteractionEnabled = false
        self.borderColor = .white
        self.activeMarker = nil
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
