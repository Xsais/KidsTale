/**
 * ----------------------------------------------------------------------------+
 * Created by: Nathaniel Primo
 * Filename: EUIView.swift
 * Project Name: Final Project : KidsTale
 * Program: Software Development and Network Engineering
 * Course: PROG31632 - Mobile iOS Application Development
 * Creation Date: 04-11-2020
 * Description: Handles the activities that occurs on the Home page
 * ----------------------------------------------------------------------------+
*/

import UIKit

extension UIView {

    /**
     * Adds corner radius's to a UIElement making, it a circle
     * - Parameters:
     *      - sender: The UIElement that desired to be a circle
    */
    public func makeCircle() {

        self.layer.cornerRadius = self.frame.height / 2.0

        self.layer.masksToBounds = true
    }
}
