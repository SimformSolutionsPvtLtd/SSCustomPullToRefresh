//
//  WaveAnimationController.swift
//  PullToRefreshDemo
//
//  Created by Mansi Vadodariya on 23/03/21.
//

import UIKit
import SSPullToRefresh

class WaveAnimationController: UIViewController {
    
    // MARK: - Variables
    var sineAnnimation: SineWaveAnimationView!
    
    // MARK: - Outlets
    @IBOutlet weak var tblWaveAnimation: UITableView!
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSineAnimation()
    }
    
    // MARK: - SetUpRefreshControl
    func setUpSineAnimation() {
        sineAnnimation = SineWaveAnimationView(color: .purple)
        sineAnnimation.delegate = self
        sineAnnimation.parentView = self.tblWaveAnimation
        sineAnnimation.setupRefreshControl()
    }
    
    // MARK: - Action
    @IBAction func onClickTextAnimation(_ sender: Any) {
        let pulseAnimationController = self.storyboard?.instantiateViewController(withIdentifier: "PulseAnimationController") as! PulseAnimationController
        self.navigationController?.pushViewController(pulseAnimationController, animated: true)
    }
    
}

// MARK: - UITableViewDataSource
extension WaveAnimationController: UITableViewDataSource {
    
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
extension WaveAnimationController: RefreshDelegate {
 
    func startRefresh() {
        // API Call
        print("start refreshing")
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.sineAnnimation.endRefreshing()
        }
    }
    
    func endRefresh() {
        print("End Refreshing")
    }
    
}
