//
//  SpinnerAnimationView.swift
//  PullToRefreshDemo
//
//  Created by Mansi Vadodariya on 06/04/21.
//

import UIKit

public class SpinnerAnimationView: UIView , UIScrollViewDelegate {
    
    // MARK: - Variables
    var refreshControl: UIRefreshControl!
    private var refreshBaseView : UIView!
    private var backgroundColorView : UIView!
    private var imgSpinnerView : UIImageView!
    private var isRefreshAnimating = false
    public var parentView: UIScrollView!
    public var spinnerBackgroundColor: UIColor = .clear
    public var spinnerImage: UIImage = UIImage()
    private var spinnerImageResize: UIImage = UIImage()
    private var pullDistance: CGFloat = 0.0
    
    weak public var delegate: RefreshDelegate?
    
    public var isRefreshing: Bool {
        return self.refreshControl.isRefreshing
    }
    
    // MARK: - Init
    public convenience init(image: UIImage, backgroundColor: UIColor) {
        self.init()
        spinnerImage = image
        spinnerBackgroundColor = backgroundColor
    }
    
    // MARK: - SetUp
    public func setupRefreshControl() {
            
        // UIRefreshControl
        self.refreshControl = UIRefreshControl(frame: CGRect(x: 0, y: 0, width: parentView.frame.size.width, height: 60))

        // Setup the base view, which will hold the moving graphics
        self.refreshBaseView = UIView(frame: self.refreshControl.bounds)
        self.refreshBaseView.backgroundColor = spinnerBackgroundColor
        
        // Setup the color view, which will display the background color
        self.backgroundColorView = UIView(frame: self.refreshControl.bounds)
        self.backgroundColorView.backgroundColor = spinnerBackgroundColor
        self.backgroundColorView.alpha = 0.70

        // Create the graphic image views
        spinnerImageResize = spinnerImage.resizeImage(targetSize: CGSize(width: 60.0, height: 60.0))
        imgSpinnerView = UIImageView(image: spinnerImageResize)
        
        // Add the graphics to the base view
        self.refreshBaseView.addSubview(self.imgSpinnerView)
        
        // Clip so the graphics don't stick out
        self.refreshBaseView.clipsToBounds = true;
        
        // Hide the original spinner icon
        self.refreshControl.tintColor = UIColor.clear
        
        // Add the base and colors views to our refresh control
        self.refreshControl.addSubview(self.backgroundColorView)
        self.refreshControl.addSubview(self.refreshBaseView)
        
        // Initalize flags
        self.isRefreshAnimating = false;
        
        // When activated, invoke our refresh function
        self.refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        
        self.parentView.delegate = self
        
        self.parentView.refreshControl = refreshControl
        
    }
    
    @objc private func refresh(){
        // This is where you'll make requests to an API, reload data, or process information
        self.delegate?.startRefresh()
    }
    
    // MARK: - Animation
    private func animateRefreshView() {
        // Flag that we are animating
        self.isRefreshAnimating = true;
        
        UIView.animate(
            withDuration: Double(0.3),
            delay: Double(0.0),
            options: UIView.AnimationOptions.curveEaseInOut,
            animations: {
                // Rotate the spinner image by M_PI_2 = PI/2 = 90 degrees
                self.imgSpinnerView.transform = self.imgSpinnerView.transform.rotated(by: .pi/2)
                self.backgroundColorView.backgroundColor = self.spinnerBackgroundColor
            },
            completion: { finished in
                // If still refreshing, keep spinning, else reset
                if (self.refreshControl.isRefreshing) {
                    self.animateRefreshView()
                }else {
                    self.resetAnimation()
                }
            }
        )
    }
    
    private func resetAnimation() {
        // Reset our flags and }background color
        self.isRefreshAnimating = false;
        self.backgroundColorView.backgroundColor = UIColor.clear
    }
    
    // MARK: - UIScrollViewDelegate
    public func scrollDidImageAnimation() {
        // Get the current size of the refresh controller
        var refreshBounds = self.refreshControl.bounds
        
        // Half the width of the table
        let midX = parentView.frame.size.width / 2.0

        let spinnerHeight = self.imgSpinnerView.bounds.size.height
        let spinnerHeightHalf = spinnerHeight / 2.0
        
        let spinnerWidth = self.imgSpinnerView.bounds.size.width
        let spinnerWidthHalf = spinnerWidth / 2.0

        // Set the Y coord of the graphics, based on pull distance
        let spinnerY = pullDistance / 2.0 - spinnerHeightHalf

        var spinnerFrame = self.imgSpinnerView.frame
        spinnerFrame.origin.x = midX - spinnerWidthHalf
        spinnerFrame.origin.y = spinnerY
        
        self.imgSpinnerView.frame = spinnerFrame
        
        // Set the refreshBounds view's frames
        refreshBounds.size.height = pullDistance
        
        self.backgroundColorView.frame = refreshBounds
        self.refreshBaseView.frame = refreshBounds

        // If we're refreshing and the animation is not playing, then play the animation
        if (self.refreshControl.isRefreshing && !self.isRefreshAnimating) {
            self.animateRefreshView()
        }
        
    }
   
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Distance the table has been pulled >= 0
        pullDistance = max(0.0, -self.refreshControl.frame.origin.y)
        if pullDistance == 0.0 {
            return
        }
       scrollDidImageAnimation()
    }
    
    public func endRefreshing() {
        self.refreshControl.endRefreshing()
        self.delegate?.endRefresh()
    }
    
}

