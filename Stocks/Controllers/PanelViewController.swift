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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
