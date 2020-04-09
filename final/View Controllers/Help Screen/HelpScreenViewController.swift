/**
 * ----------------------------------------------------------------------------+
 * Created by: Nathaniel Primo
 * Filename: HelpScreenViewController.swift
 * Project Name: Final Project : KidsTale
 * Program: Software Development and Network Engineering
 * Course: PROG31632 - Mobile iOS Application Development
 * Creation Date: 04-09-2020
 * Description: Handles the activities that occurs on the Home page
 * ----------------------------------------------------------------------------+
*/

import UIKit

class HelpScreenViewController: UIViewController {

    /**
     * Stores the numbering label for step number one
    */
    @IBOutlet
    var txtOne: UILabel?

    /**
     * Stores the numbering label for step number two
    */
    @IBOutlet
    var txtTwo: UILabel?

    /**
     * Stores the numbering label for step number three
    */
    @IBOutlet
    var txtThree: UILabel?

    /**
     * Stores the numbering label for step number four
    */
    @IBOutlet
    var txtFour: UILabel?

    /**
     * An event that is fired when the view is loaded into memory
    */
    override func viewDidLoad() {
        super.viewDidLoad()

        makeCircle(sender: txtOne!)

        makeCircle(sender: txtTwo!)

        makeCircle(sender: txtThree!)

        makeCircle(sender: txtFour!)
    }

    /**
     * Adds corner radius's to a UIElement making, it a circle
     * - Parameters:
     *      - sender: The UIElement that desired to be a circle
    */
    private func makeCircle(sender: UIView) {

        sender.layer.cornerRadius = sender.frame.height / 2.0

        sender.layer.masksToBounds = true
    }

}
