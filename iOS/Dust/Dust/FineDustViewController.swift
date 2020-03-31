//
//  FineDustViewController.swift
//  Dust
//
//  Created by TTOzzi on 2020/03/30.
//  Copyright © 2020 TTOzzi. All rights reserved.
//

import UIKit

class FineDustViewController: UIViewController, UITableViewDelegate {
    @IBOutlet weak var statusView: StatusView!
    @IBOutlet weak var statusEmoji: StatusEmoji!
    @IBOutlet weak var statusLabel: StatusLabel!
    @IBOutlet weak var densityLabel: DensityLabel!
    @IBOutlet weak var timeLabel: MeasurementTimeLabel!
    @IBOutlet weak var stationLabel: StationLabel!
    @IBOutlet weak var dustDensityTableView: DustDensityTableView!
    
    var dataManager = DataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dustDensityTableView.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(updateTimeLabel(_:)), name: NSNotification.Name.init("timeChanged"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(gradeDidChanged(_:)), name: NSNotification.Name.init("gradeChanged"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(valueDidChanged(_:)), name: NSNotification.Name.init("valueChanged"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateStaion(_:)), name: NSNotification.Name.init("station"), object: nil)
        loadData()
    }
    
    func loadData() {
        dataManager.loadStation()
        dataManager.reloadData(with: 0)
    }
    
    @objc func updateStaion(_ notification: NSNotification) {
        stationLabel.setStation(notification.userInfo!["station"] as! String)
    }
    
    @objc func updateTimeLabel(_ notification: NSNotification) {
        timeLabel.setTime(time: notification.userInfo!["timeChanged"] as! String)
    }
    
    @objc func gradeDidChanged(_ notification: NSNotification) {
        let grade = notification.userInfo!["gradeChanged"] as! Int
        statusView.setStatusView(with: grade)
        statusEmoji.setEmoji(with: grade)
        statusLabel.setStatusLabel(with: grade)
    }
    
    @objc func valueDidChanged(_ notification: NSNotification) {
        densityLabel.setDensity(with: notification.userInfo!["valueChanged"] as! Int)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let index = dustDensityTableView.indexPathsForVisibleRows?.first else { return }
        dataManager.reloadData(with: index.row)
    }
}
