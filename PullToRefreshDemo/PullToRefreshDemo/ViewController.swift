//
//  ViewController.swift
//  PullToRefreshDemo
//
//  Created by Mansi Vadodariya on 22/03/21.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Variables
    var refreshControl: UIRefreshControl!
    var refreshLoadingView : UIView!
    var refreshColorView : UIView!
    var compass_background : UIImageView!
    var compass_spinner : UIImageView!
    var isRefreshIconsOverlap = false
    var isRefreshAnimating = false
    
    // MARK: - Variables
    @IBOutlet weak var tableViewRefersh: UITableView!


    // MARK: - UIviewController
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Set up the refresh control
        self.setupRefreshControl()
    }
    
    // MARK: - Setup
    func setupRefreshControl() {
    
        // Programmatically inserting a UIRefreshControl
        self.refreshControl = UIRefreshControl()

        // Setup the loading view, which will hold the moving graphics
        self.refreshLoadingView = UIView(frame: self.refreshControl!.bounds)
        self.refreshLoadingView.backgroundColor = UIColor.clear
        
        // Setup the color view, which will display the rainbowed background
        self.refreshColorView = UIView(frame: self.refreshControl!.bounds)
        self.refreshColorView.backgroundColor = UIColor.clear
        self.refreshColorView.alpha = 0.30
       // self.refreshColorView.layer.cornerRadius = 100
       // self.refreshColorView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        // Create the graphic image views
        compass_background = UIImageView(image: UIImage(named: "fullCircle.png"))
        self.compass_spinner = UIImageView(image: UIImage(named: "compass.png"))
        
        // Add the graphics to the loading view
        self.refreshLoadingView.addSubview(self.compass_background)
        self.refreshLoadingView.addSubview(self.compass_spinner)
       // self.refreshLoadingView.addSubview(self.titleText)
        
        // Clip so the graphics don't stick out
        self.refreshLoadingView.clipsToBounds = true;
        
        // Hide the original spinner icon
        self.refreshControl!.tintColor = UIColor.clear
        
        // Add the loading and colors views to our refresh control
        self.refreshControl!.addSubview(self.refreshColorView)
        self.refreshControl!.addSubview(self.refreshLoadingView)
        
        // Initalize flags
        self.isRefreshIconsOverlap = false;
        self.isRefreshAnimating = false;
        
        // When activated, invoke our refresh function
       // self.refreshControl?.addTarget(self, action: Selector(("refresh")), for: UIControl.Event.valueChanged)
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)

        self.tableViewRefersh.addSubview(self.refreshControl)
       // self.tableViewRefersh.refreshControl = self.refreshControl
    }
    
    @objc func refresh(){

        // This is where you'll make requests to an API, reload data, or process information
        let delayInSeconds = 3.0;
        DispatchQueue.main.asyncAfter(deadline: .now() + delayInSeconds) {
            self.refreshControl!.endRefreshing()
        }
    }
    
    func animateRefreshView() {
        // Background color to loop through for our color view
        let colorArray = [UIColor.red, UIColor.blue, UIColor.purple, UIColor.cyan, UIColor.orange, UIColor.magenta]
        
        // In Swift, static variables must be members of a struct or class
        struct ColorIndex {
            static var colorIndex = 0
        }
        
        // Flag that we are animating
        self.isRefreshAnimating = true;
        
        UIView.animate(
            withDuration: Double(0.3),
            delay: Double(0.0),
            options: UIView.AnimationOptions.curveLinear,
            animations: {
                // Rotate the spinner by M_PI_2 = PI/2 = 90 degrees
                self.compass_spinner.transform = self.compass_spinner.transform.rotated(by: .pi/2)
                // Change the background color
                self.refreshColorView!.backgroundColor = colorArray[ColorIndex.colorIndex]
                ColorIndex.colorIndex = (ColorIndex.colorIndex + 1) % colorArray.count
            },
            completion: { finished in
                // If still refreshing, keep spinning, else reset
                if (self.refreshControl!.isRefreshing) {
                    self.animateRefreshView()
                }else {
                    self.resetAnimation()
                }
            }
        )
    }
    
    func resetAnimation() {
        // Reset our flags and }background color
        self.isRefreshAnimating = false;
        self.isRefreshIconsOverlap = false;
        self.refreshColorView.backgroundColor = UIColor.clear
    }
  
}

// MARK: - UIScrollViewDelegate
extension ViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // Get the current size of the refresh controller
        var refreshBounds = self.refreshControl!.bounds
        
        // Distance the table has been pulled >= 0
        let pullDistance = max(0.0, -self.refreshControl!.frame.origin.y)
        
        // Half the width of the table
        let midX = self.tableViewRefersh.frame.size.width / 2.0
        
        // Calculate the width and height of our graphics
        let compassHeight = self.compass_background.bounds.size.height
        let compassHeightHalf = compassHeight / 2.0
        
        let compassWidth = self.compass_background.bounds.size.width
        let compassWidthHalf = compassWidth / 2.0
        
        let spinnerHeight = self.compass_spinner.bounds.size.height
        let spinnerHeightHalf = spinnerHeight / 2.0
        
        let spinnerWidth = self.compass_spinner.bounds.size.width
        let spinnerWidthHalf = spinnerWidth / 2.0
        
        // Calculate the pull ratio, between 0.0-1.0
        let pullRatio = min( max(pullDistance, 0.0), 100.0) / 100.0
        
        // Set the Y coord of the graphics, based on pull distance
        let compassY = pullDistance / 2.0 - compassHeightHalf
        let spinnerY = pullDistance / 2.0 - spinnerHeightHalf
        
        // Calculate the X coord of the graphics, adjust based on pull ratio
        var compassX = (midX + compassWidthHalf) - (compassWidth * pullRatio)
        var spinnerX = (midX - spinnerWidth - spinnerWidthHalf) + (spinnerWidth * pullRatio)
        
        // When the compass and spinner overlap, keep them together
        if (fabsf(Float(compassX - spinnerX)) < 1.0) {
            self.isRefreshIconsOverlap = true
        }
        
        // If the graphics have overlapped or we are refreshing, keep them together
        if (self.isRefreshIconsOverlap || self.refreshControl!.isRefreshing) {
            compassX = midX - compassWidthHalf
            spinnerX = midX - spinnerWidthHalf
        }
        
        // Set the graphic's frames
        var compassFrame = self.compass_background.frame
        compassFrame.origin.x = compassX
        compassFrame.origin.y = compassY
        
        var spinnerFrame = self.compass_spinner.frame
        spinnerFrame.origin.x = spinnerX
        spinnerFrame.origin.y = spinnerY
        
        self.compass_background.frame = compassFrame
        self.compass_spinner.frame = spinnerFrame
        
        // Set the encompassing view's frames
        refreshBounds.size.height = pullDistance
        
        self.refreshColorView.frame = refreshBounds
        // self.refreshColorView.layer.cornerRadius = 100
        //  self.refreshColorView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        self.refreshLoadingView.frame = refreshBounds
        
        // If we're refreshing and the animation is not playing, then play the animation
        if (self.refreshControl!.isRefreshing && !self.isRefreshAnimating) {
            self.animateRefreshView()
        }
        
        print("pullDistance \(pullDistance), pullRatio: \(pullRatio), midX: \(midX), refreshing: \(self.refreshControl!.isRefreshing)")
    }
    
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let CellIdentifier = "Cell";
        var cell : UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: CellIdentifier)
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: CellIdentifier)
        }
        // Configure the cell...
        cell!.textLabel!.text = "Row \(indexPath.row)"
        return cell!
    }
    
}
