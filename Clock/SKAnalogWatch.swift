//
//  SKAnalogWatch.swift
//  Clock
//
//  Created by Sanjeev Kumar on 09/11/17.
//  Copyright © 2017 Sanjeev Kumar. All rights reserved.
//

import UIKit

class SKAnalogWatch: UIView {
    
    
    open var radius: CGFloat = 100.0
    open var fontSize: CGFloat = 16.0
    
    
    public var dialBackgroundColor : CGColor = UIColor.black.cgColor
    public var dialBorderColor: CGColor = UIColor.red.cgColor
    public var watchDigitsColor: CGColor = UIColor.white.cgColor
    
    private var WatchDialLayer  = CAShapeLayer()
    private var hourLayer       = CAShapeLayer()
    private var minuteLayer     = CAShapeLayer()
    private var secondLayer     = CAShapeLayer()
    
    private var clockCenter:CGPoint {
        get {
            return CGPoint(x:self.bounds.width/2, y:self.bounds.height/2)
        }
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    override func draw(_ rect: CGRect) {
        //            self.commonInit()
    }
    
    
    func commonInit(){
        
        // Set the radius as per size of uiview
        radius = frame.size.width >= frame.size.height ? frame.size.height/2 : frame.size.width/2
        self.drawCircle()
        self.drawTicks()
        
        let t = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(startAnimation), userInfo: nil, repeats: true)
        t.fire()
    }
    
    //Mark:- Draw Circle
    
    func drawCircle(){
        
        let shapeLayerPath = UIBezierPath()
        let circlePath = UIBezierPath(arcCenter: clockCenter, radius: self.radius + 5.0, startAngle: 0, endAngle: 360, clockwise: true)
        WatchDialLayer.lineWidth = 5.0
        shapeLayerPath.append(circlePath)
        
        
        
        
        // Draw Hours
        let hours = 12
        for i in 1 ... hours {
            print("Value of i is \(i)")
            
            let txt = CATextLayer()
            let angle = CGFloat(i) * .pi * 2 / CGFloat(hours) - .pi/2
            
            let x = round(cos(angle) * (radius - fontSize)) + clockCenter.x
            let y = round(sin(angle) * (radius - fontSize)) + clockCenter.y
            
            txt.frame = CGRect(x: x - fontSize/2 , y: y - fontSize/2 , width: fontSize, height: fontSize)
            txt.foregroundColor = watchDigitsColor
            txt.string = "\(i)"
            txt.fontSize = fontSize - 2.0
            txt.alignmentMode = kCAAlignmentCenter
            WatchDialLayer.addSublayer(txt)
        }
        
        WatchDialLayer.path = shapeLayerPath.cgPath
        WatchDialLayer.strokeColor = dialBorderColor
        WatchDialLayer.fillColor = dialBackgroundColor
        self.layer.addSublayer(WatchDialLayer)
        
        
        //Draw Center circle
        let centerCircleLayer = CAShapeLayer()
        let centerCircle = UIBezierPath(arcCenter: clockCenter, radius: 5.0, startAngle: 0, endAngle: 360, clockwise: true)
        centerCircleLayer.fillColor = UIColor.red.cgColor
        centerCircleLayer.path = centerCircle.cgPath
        self.layer.addSublayer(centerCircleLayer)
    }
    
    
    
    
    @objc func startAnimation(){
        
        let currentDate = Date()
        let calendar = Calendar.current
        
        var hour = calendar.component(.hour, from: currentDate)
        hour = hour > 12 ? hour % 12 : hour
        
        let minute = calendar.component(.minute, from: currentDate)
        let second = calendar.component(.second, from: currentDate)
        
        self.drawNiddles(layer: hourLayer, currentNiddleDigit: hour, totalCount: 12, radiusRatio: 0.40)
        self.drawNiddles(layer: minuteLayer, currentNiddleDigit: minute, totalCount: 60, radiusRatio: 0.60)
        self.drawNiddles(layer: secondLayer, currentNiddleDigit: second, totalCount: 60, radiusRatio: 0.70)
    }
    
    func drawNiddles(layer: CAShapeLayer, currentNiddleDigit: Int, totalCount: Int, radiusRatio: CGFloat){
        
        layer.removeFromSuperlayer()
        
        let tmpBeizerPath = UIBezierPath()
        let angle = CGFloat(currentNiddleDigit) * .pi * 2 / CGFloat(totalCount) - .pi/2
        
        let x = round(cos(angle) * (radius * radiusRatio)) + clockCenter.x
        let y = round(sin(angle) * (radius * radiusRatio)) + clockCenter.y
        
        tmpBeizerPath.move(to: clockCenter)
        tmpBeizerPath.addLine(to: CGPoint(x: x, y: y))
        
        
        layer.path = tmpBeizerPath.cgPath
        layer.strokeColor = UIColor.white.cgColor
        layer.lineWidth = 2.0
        self.layer.addSublayer(layer)
    }
    
    
    
    func drawTicks(){
        
        // Draw Seconds
        
        for i in 1 ... 60 {
            let shapeLIneLayer = CAShapeLayer()
            let linePath = UIBezierPath()
            
            let angle = CGFloat(i) * .pi * 2 / CGFloat(60) - .pi/2
            
            let x = round(cos(angle) * (radius)) + clockCenter.x
            let y = round(sin(angle) * (radius)) + clockCenter.y
            
            
            
            let x1 =  round(cos(angle) * (radius - fontSize/2 )) + clockCenter.x
            let y1 = round(sin(angle) * (radius - fontSize/2 )) + clockCenter.y
            
            linePath.move(to: CGPoint(x: x, y: y))
            linePath.addLine(to: CGPoint(x: x1, y: y1))
            
            shapeLIneLayer.strokeColor = (i % 5) == 0 ? UIColor.red.cgColor : UIColor.white.cgColor
            shapeLIneLayer.path = linePath.cgPath
            self.layer.addSublayer(shapeLIneLayer)
        }
        
    }
    
    
}

