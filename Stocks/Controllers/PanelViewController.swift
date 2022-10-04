//
//  PanelViewController.swift
//  Stocks
//
//  Created by Joseph Estanislao Calla Moreyra on 4/10/22.
//

import UIKit

class PanelViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let grabberView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 10))
        grabberView.backgroundColor = .label
        view.addSubview(grabberView)
        grabberView.center = CGPoint(x: view.center.x, y: 5)
        view.backgroundColor = .secondarySystemBackground
    }

}
