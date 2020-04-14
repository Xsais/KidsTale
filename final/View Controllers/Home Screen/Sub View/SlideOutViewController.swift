//
//  SlideOutViewController.swift
//  final
//
//  Created by Nathaniel Primo on 2020-04-14.
//

import UIKit

class SlideOutViewController: UIViewController {

    /**
     * Stores a copy of the Text field that contains the query of the user
    */
    @IBOutlet
    private var sldNotificationVolume: UISlider?

    /**
     * Stores a copy of the label that stores the volume
    */
    @IBOutlet
    private var lblCurrentVolume: UILabel?

    /**
     * Stores a copy of the applications delegate
    */
    private let sharedDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()

        sldNotificationVolume?.value = sharedDelegate.applicationVolume

        sldNotificationVolume?.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / -2))

        updateNotificationVolume(sender: sldNotificationVolume!)

        // Do any additional setup after loading the view.
    }

    @IBAction
    private func updateNotificationVolume(sender: UISlider) {

        sharedDelegate.applicationVolume = sender.value

        lblCurrentVolume?.text = "\(String(format: "%.0f", sender.value))%"
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
