/**
 * ----------------------------------------------------------------------------+
 * Created by: <System>
 * Filename: AppDelegate.swift
 * Project Name: Final Project : KidsTale
 * Program: Software Development and Network Engineering
 * Course: PROG31632 - Mobile iOS Application Development
 * Creation Date: 04-14-2020
 * Description: The view of the homescreen pull out menu
 * ----------------------------------------------------------------------------+
*/

import UIKit

class SlideOutViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

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
    }

    @IBAction
    private func updateNotificationVolume(sender: UISlider) {

        sharedDelegate.applicationVolume = sender.value

        lblCurrentVolume?.text = "\(String(format: "%.0f", sender.value))%"
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        sharedDelegate.appliedAnimation = AppDelegate.validAnimations[Array(AppDelegate.validAnimations.keys)[pickerView.selectedRow(inComponent: component)]]!
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        return Array(AppDelegate.validAnimations.keys)[row]
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {

        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

        return AppDelegate.validAnimations.count
    }
}
