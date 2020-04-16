/**
 * ----------------------------------------------------------------------------+
 * Created by: Nathaniel Primo
 * Filename: SmartUIViewController.swift
 * Project Name: Final Project : KidsTale
 * Program: Software Development and Network Engineering
 * Course: PROG31632 - Mobile iOS Application Development
 * Creation Date: 03-08-2020
 * Description: Contains the boilerplate for handling text field delegates
 * ----------------------------------------------------------------------------+
*/

import UIKit

public class SmartUIViewController: UIViewController, UITextFieldDelegate {

    /**
     * Store the button that handles resigning the TextField when the user touches the screen
    */
    private let disappearButton: UIButton = UIButton()

    /**
     * Stores the TextField that is currently being edited
    */
    private var currentTextField: UITextField?

    private var respondersIgnored: Bool = false

    /**
     * An event that is fired when the view is loaded into memory
    */
    override public func viewDidLoad() {
        super.viewDidLoad()

        // Creates the HitBox that the button will occupy
        disappearButton.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)

        // Enables the button to be clicked through
        disappearButton.backgroundColor = .clear

        // Adds the button to the screen
        self.view.addSubview(disappearButton)

        // Register the 'TouchUpInside' event
        disappearButton.addTarget(self, action: #selector(hideTextField), for: .touchUpInside)

        // Removes all focus from any text fields
        textFieldShouldReturn()
    }

    /**
     * A method created to handle the action of a 'TouchUpInside' event
    */
    @objc
    private func hideTextField() {

        resignFirstResponder(nil)
    }

    public func resignFirstResponder(_ textField: UITextField?) -> Bool {

        if (textField != nil) {

            return textField?.resignFirstResponder() ?? true
        } else if (currentTextField != nil) {

            textFieldShouldReturn(currentTextField!)
        }

        return false
    }

    /**
     * Ignores all future request to invoke a TextField keyboard
    */
    public func ignoreResponders() {

        respondersIgnored = true
    }

    /**
     * Acknowledge all future request to invoke a TextField keyboard
    */
    public func acknowledgeResponders() {

        respondersIgnored = false
    }

    /**
     * Handles the action that is to be performed when a TetField is scheduled to return
    */
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        textFieldShouldReturn()

        return resignFirstResponder(textField)
    }

    /**
     * Cleans up the screen after the TextField has been resigned
    */
    private func textFieldShouldReturn() {

        disappearButton.isHidden = true
    }

    /**
     * Revels all of the required elements to handle resigns
    */
    private func textFieldDidBeginEditing() {

        disappearButton.isHidden = false
    }

    /**
     * Handles the action that is to be performed when a TetField requested to be in focus
    */
    public func textFieldDidBeginEditing(_ textField: UITextField) {

        /**
         * If the responders have been set to be ignored prevent the keyboard
        */
        if (respondersIgnored) {

            resignFirstResponder(textField)
            return
        }

        currentTextField = textField
        textFieldDidBeginEditing()
    }
}
