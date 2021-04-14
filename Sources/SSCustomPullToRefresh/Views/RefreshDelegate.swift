//
//  refreshDelegate.swift
//  PullToRefreshDemo
//
//  Created by Mansi Vadodariya on 13/04/21.
//

import Foundation

public protocol RefreshDelegate: NSObject {
    func startRefresh()
    func endRefresh()
}
