//
//  SineWaveAnimationView.swift
//  PullToRefreshDemo
//
//  Created by Mansi Vadodariya on 07/04/21.
//

import UIKit

public class SineWaveAnimationView: UIView {
    
    // MARK: - Variables
    public var refreshControl: UIRefreshControl!
    private var refreshBaseView : UIView!
    private var backgroundColorView : WavesView!
    private var isRefreshAnimating = false
    public var parentView: UIScrollView!
    public var waveColor: UIColor = .clear
    public var frontColor: UIColor = .clear
    public var backColor: UIColor = .clear
    public var waveHeight: CGFloat = 10.0
    
    weak public var delegate: RefreshDelegate?
    
    public var isRefreshing: Bool {
        return self.refreshControl.isRefreshing
    }
    
    // MARK: - Init
    public convenience init(color: UIColor) {
        self.init()
        frontColor = color
        backColor = color
        waveHeight = 10.0
    }
    
    public convenience init(frontColor: UIColor, backColor: UIColor, waveHeight: CGFloat) {
        self.init()
        self.frontColor = frontColor
        self.backColor = backColor
        if waveHeight < 5.0 {
            self.waveHeight = 5.0
        }
        self.waveHeight = waveHeight
    }
    
    // MARK: - SetUp
    public func setupRefreshControl() {
        // UIRefreshControl
        self.refreshControl = UIRefreshControl(frame: CGRect(x: 0, y: 0, width: parentView.frame.size.width, height: 60))
        
        // Setup the base view, which will hold the moving graphics
        self.refreshBaseView = UIView(frame: self.refreshControl!.bounds)
        self.refreshBaseView.backgroundColor = .clear
        
        // Setup the wave view
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: self.refreshControl.bounds.size.height)
        self.backgroundColorView = WavesView(frame: frame, frontColor: frontColor.withAlphaComponent(0.5), backColor: backColor.withAlphaComponent(0.5), waveHeight: waveHeight)
        self.backgroundColorView.startAnimation()
        
        // Clip so the graphics don't stick out
        self.refreshBaseView.clipsToBounds = true
        
        // Hide the original spinner icon
        self.refreshControl!.tintColor = UIColor.clear
        
        // Add the base and colors views to our refresh control
        self.refreshControl!.addSubview(self.refreshBaseView)
        self.refreshControl!.addSubview(self.backgroundColorView)
        
        // Initalize flags
        self.isRefreshAnimating = false;
        
        // When activated, invoke our refresh function
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        
        self.parentView.refreshControl = refreshControl
    }
    
    @objc private func refresh() {
        // This is where you'll make requests to an API, reload data, or process information
        self.delegate?.startRefresh()
        let delayInSeconds = 3.0;
        DispatchQueue.main.asyncAfter(deadline: .now() + delayInSeconds) {
            self.refreshControl!.endRefreshing()
            self.delegate?.endRefresh()
        }
    }
   
    public func endRefreshing() {
        self.refreshControl.endRefreshing()
        self.delegate?.endRefresh()
    }
    
}
