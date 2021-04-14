//
//  PulseAnimationView.swift
//  PullToRefreshDemo
//
//  Created by Mansi Vadodariya on 08/04/21.
//

import UIKit

public class PulseAnimationView: UIView, UIScrollViewDelegate {
    
    // MARK: - Variables
    var refreshControl: UIRefreshControl!
    private var refreshBaseView : UIView!
    private var pulseLoadingView : UIView!
    private var imgBg : UIImageView!
    private var isRefreshAnimating = false
    public var parentView: UIScrollView!
    var pulseLayers = [CAShapeLayer]()
    public var pulseViewBackgroundColor: UIColor = .clear
    public var circleColor: UIColor = .clear
    public var pulseColor: UIColor = .clear
    private var pullDistance: CGFloat = 0.0
    
    weak public var delegate: RefreshDelegate?
    
    public var isRefreshing: Bool {
        return self.refreshControl.isRefreshing
    }
    
    // MARK: - Init
    public convenience init(circleColor: UIColor, pulseColor: UIColor, pulseViewBackgroundColor: UIColor) {
        self.init()
        self.circleColor = circleColor
        self.pulseColor = pulseColor
        self.pulseViewBackgroundColor = pulseViewBackgroundColor
    }
    
    // MARK: - SetUp
    public func setupRefreshControl() {
        
        // UIRefreshControl
        self.refreshControl = UIRefreshControl(frame: CGRect(x: 0, y: 0, width: parentView.frame.size.width, height: 60))

        // Setup the base view, which will hold the moving graphics
        self.refreshBaseView = UIView(frame: self.refreshControl.bounds)
        self.refreshBaseView.backgroundColor = .clear
        
        // Setup the color view, which will display the background color
        self.pulseLoadingView = UIView(frame: self.refreshControl.bounds)
        self.pulseLoadingView.backgroundColor = pulseViewBackgroundColor
        self.pulseLoadingView.alpha = 0.30

        // Create the graphic image views
        imgBg = UIImageView(image: UIImage(named: "fullCircle"))
        imgBg.setImageColor(color: circleColor)
        imgBg.layer.cornerRadius = imgBg.frame.size.width / 2.0
        createPulse()
        
        // Add the graphics to the loading view
        self.refreshBaseView.addSubview(self.imgBg)

        // Clip so the graphics don't stick out
        self.refreshBaseView.clipsToBounds = true
        
        // Hide the original spinner icon
        self.refreshControl.tintColor = UIColor.clear
        
        // Add the base and colors views to our refresh control
        self.refreshControl.addSubview(self.refreshBaseView)
        self.refreshControl.addSubview(self.pulseLoadingView)

        // Initalize flags
        self.isRefreshAnimating = false;
        
        // When activated, invoke our refresh function
        self.refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        
        self.parentView.delegate = self
        
        self.parentView.refreshControl = refreshControl

    }
    
    @objc private func refresh() {
        // This is where you'll make requests to an API, reload data, or process information
        self.delegate?.startRefresh()
    }
    
    // MARK: - Animation
    func createPulse() {
        for _ in 0...2 {
            let circularPath = UIBezierPath(arcCenter: .zero, radius: self.pulseLoadingView.frame.width / 2.0 , startAngle: 0, endAngle: 2 * .pi, clockwise: true)
            let pulseLayer = CAShapeLayer()
            pulseLayer.path = circularPath.cgPath
            pulseLayer.lineWidth = 2.0
            pulseLayer.fillColor = UIColor.clear.cgColor
            pulseLayer.strokeColor = pulseColor.cgColor
            pulseLayer.lineCap = CAShapeLayerLineCap.round
            pulseLayer.position = CGPoint(x: imgBg.frame.size.width / 2, y: imgBg.frame.size.width / 2)
            imgBg.layer.addSublayer(pulseLayer)
            pulseLayers.append(pulseLayer)
        }
    
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.animatePulse(index: 0)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                self.animatePulse(index: 1)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    self.animatePulse(index: 2)
                }
            }
        }
    }
    
    func animatePulse(index: Int) {
        let scaleAniomation = CABasicAnimation(keyPath: "transform.scale")
        scaleAniomation.duration = 2.0
        scaleAniomation.fromValue = 0.0
        scaleAniomation.toValue = 0.9
        scaleAniomation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        scaleAniomation.repeatCount = .greatestFiniteMagnitude
        pulseLayers[index].add(scaleAniomation, forKey: "scale")
        
        let opacityAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
        opacityAnimation.duration = 2.0
        opacityAnimation.fromValue = 0.9
        opacityAnimation.toValue = 0.0
        opacityAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        opacityAnimation.repeatCount = .greatestFiniteMagnitude
        pulseLayers[index].add(opacityAnimation, forKey: "opacity")
    }
    
    // MARK: - UIScrollViewDelegate
    public func scrollDidAnimation() {
        // Get the current size of the refresh controller
        var refreshBounds = self.refreshControl.bounds
        // Half the width of the table
        let midX = parentView.frame.size.width / 2.0

        // Calculate the width and height of our graphics
        let imageHeight = self.imgBg.bounds.size.height
        let imageHeightHalf = imageHeight / 2.0
        let imageWidth = self.imgBg.bounds.size.width
        let imageWidthHalf = imageWidth / 2.0

        // Set the Y coord of the graphics, based on pull distance
        let imageY = pullDistance / 2.0 - imageHeightHalf

        // Set the graphic's frames
        var imageFrame = self.imgBg.frame
        imageFrame.origin.x = midX - imageWidthHalf
        imageFrame.origin.y = imageY

        self.imgBg.frame = imageFrame
        
        // Set the refreshBounds view's frames
        refreshBounds.size.height = pullDistance
        
        self.pulseLoadingView.frame = refreshBounds
        self.refreshBaseView.frame = refreshBounds

    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Distance the table has been pulled >= 0
        pullDistance = max(0.0, -self.refreshControl.frame.origin.y)
        if pullDistance == 0.0 {
            return
        }
        scrollDidAnimation()
    }
   
    public func endRefreshing() {
        self.refreshControl.endRefreshing()
        self.delegate?.endRefresh()
    }
    
}
