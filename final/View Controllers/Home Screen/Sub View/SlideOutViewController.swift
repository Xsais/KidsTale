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
     * Stores a copy of the slider that holds the volume percentage
    */
    @IBOutlet
    private var sldNotificationVolume: UISlider?

    /**
     * Stores a copy of the label that stores the volume text
    */
    @IBOutlet
    private var lblCurrentVolume: UILabel?

    /**
     * Stores a copy of the applications delegate
    */
    private let sharedDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate

    /**
     * An event that is fired when the view is loaded into memory
    */
    override func viewDidLoad() {
        super.viewDidLoad()

        sldNotificationVolume?.value = sharedDelegate.applicationVolume

        // Turns the slider vertically
        sldNotificationVolume?.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / -2))

        updateNotificationVolume(sender: sldNotificationVolume!)
    }

    /**
     * The handler for updating the visual percentage of the slider
     * - Parameters:
     *      - sender: The sending UISlider the initialized the event
    */
    @IBAction
    private func updateNotificationVolume(sender: UISlider) {

        sharedDelegate.applicationVolume = sender.value

        lblCurrentVolume?.text = "\(String(format: "%.0f", sender.value))%"
    }

    /**
     * The callback handler for a item in the picker being selected
     * - Parameters:
     *      - pickerView: The sending Picker
     *      - row: The row that is selected
     *      - component: The component that called the event
    */
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        sharedDelegate.appliedAnimation = AppDelegate.validAnimations[Array(AppDelegate.validAnimations.keys)[pickerView.selectedRow(inComponent: component)]]!
    }

    /**
     * The callback handler that set the title for the row
     * - Parameters:
     *      - pickerView: The sending Picker
     *      - row: The row that is selected
     *      - component: The component that called the event
    */
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        return Array(AppDelegate.validAnimations.keys)[row]
    }

    /**
     * The callback handler that set the amount of component in the view
     * - Parameters:
     *      - pickerView: The sending Picker
    */
    func numberOfComponents(in pickerView: UIPickerView) -> Int {

        return 1
    }

    /**
     * The callback handler that set the amount of rows in each component
     * - Parameters:
     *      - pickerView: The sending Picker
     *      - component: The component that called the event
    */
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

        return AppDelegate.validAnimations.count
    }
}
