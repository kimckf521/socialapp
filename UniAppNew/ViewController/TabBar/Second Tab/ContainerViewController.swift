//
//  ContainerViewController.swift
//  UniAppNew
//
//  Created by Kim on 21/1/21.
//

import UIKit
import Firebase

class ContainerViewController: UIViewController {
    
    @IBOutlet weak var containerViewA: UIView!
    @IBOutlet weak var containerViewB: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    let db = Firestore.firestore().collection("products")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.containerViewA.alpha = 1
        self.containerViewB.alpha = 0
        //self.segmentedControl.alpha = 0
        
    }

    @IBAction func showView(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            self.containerViewA.alpha = 1
            self.containerViewB.alpha = 0
        case 1:
            self.containerViewB.alpha = 1
            self.containerViewA.alpha = 0
        default:
            break
        }
        
    }
    
    
}
