//
//  BaseViewController.swift
//  FruitsApp
//
//  Created by James Robinson on 15/01/2024.
//

import UIKit

class BaseViewController: UIViewController {
    
    private let startTime: DispatchTime
    
    init() {
        self.startTime = DispatchTime.now()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let endTime = DispatchTime.now()
        let elapsedTime = endTime.uptimeNanoseconds - self.startTime.uptimeNanoseconds
        let elapsedTimeInMilliSeconds = Double(elapsedTime) / 1_000_000.0
        Task {
            try? await NetworkClient.shared.recordUsage(event: "display", data: "\(elapsedTimeInMilliSeconds)")
        }
    }
}
