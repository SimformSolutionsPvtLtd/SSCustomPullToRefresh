//
//  SpinnerAnimationController.swift
//  PullToRefreshDemo
//
//  Created by Mansi Vadodariya on 22/03/21.
//

import UIKit
import SSPullToRefresh

class SpinnerAnimationController: UIViewController {
    
    // MARK: - Variables
    var spinnerAnnimation: SpinnerAnimationView!
    
    // MARK: - Outlets
    @IBOutlet weak var tableViewRefersh: UITableView!
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSpinnerAnimation()
    }
    
    // MARK: - SetUpRefreshControl
    func setUpSpinnerAnimation() {
        spinnerAnnimation = SpinnerAnimationView(image: UIImage(named: "spinner")!, backgroundColor: .purple)
        spinnerAnnimation.delegate = self
        spinnerAnnimation.parentView = self.tableViewRefersh
        spinnerAnnimation.setupRefreshControl()
    }
    
    // MARK: - Action
    @IBAction func onClickWaveAnimation(_ sender: Any) {
        let waveAnimationController = self.storyboard?.instantiateViewController(withIdentifier: "WaveAnimationController") as! WaveAnimationController
        self.navigationController?.pushViewController(waveAnimationController, animated: true)
    }
    
}

// MARK: - UITableViewDataSource
extension SpinnerAnimationController: UITableViewDataSource {
    
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
extension SpinnerAnimationController: RefreshDelegate {
 
    func startRefresh() {
        // API Call
        print("start refreshing")
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.spinnerAnnimation.endRefreshing()
        }
    }
    
    func endRefresh() {
        print("End Refreshing")
    }
    
}
