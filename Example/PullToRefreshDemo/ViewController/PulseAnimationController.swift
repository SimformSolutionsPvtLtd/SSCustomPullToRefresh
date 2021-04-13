//
//  PulseAnimationController.swift
//  PullToRefreshDemo
//
//  Created by Mansi Vadodariya on 24/03/21.
//

import UIKit
import SSPullToRefresh

class PulseAnimationController: UIViewController {
    
    // MARK: - Variables
    var pulseAnnimation: PulseAnimationView!
    
    // MARK: - Outlets
    @IBOutlet weak var tblViewAnimation: UITableView!
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpPulseAnimation()
    }
    
    // MARK: - SetUpRefreshControl
    func setUpPulseAnimation() {
        pulseAnnimation = PulseAnimationView(circleColor: .purple, pulseColor: .purple, pulseViewBackgroundColor: .brown)
        pulseAnnimation.delegate = self
        pulseAnnimation.parentView = self.tblViewAnimation
        pulseAnnimation.setupRefreshControl()
    }
    
}

// MARK: - UITableViewDataSource
extension PulseAnimationController: UITableViewDataSource {
    
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
        cell!.textLabel!.text = "Row \(indexPath.row + 1)"
        return cell!
    }
    
}

// MARK: - AnimationDelegate
extension PulseAnimationController: RefreshDelegate {
    
    func startRefresh() {
        print("start refreshing")
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.pulseAnnimation.endRefreshing()
        }
    }
    
    func endRefresh() {
        print("End Refreshing")
    }
    
}
