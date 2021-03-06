/**
 * ----------------------------------------------------------------------------+
 * Created by: Heon Lee
 * Filename: EColor.swift
 * Project Name: Final Project : KidsTale
 * Program: Software Development and Network Engineering
 * Course: PROG31632 - Mobile iOS Application Development
 * Creation Date: 04-12-2020
 * Description: Color extensions, Generate random red, green, and blue values
 * ----------------------------------------------------------------------------+
*/

import Foundation
import UIKit

extension UIColor {

    /**
     * Generates random hex color
     * - Parameters:
     *      - sender: The UIElement that desired to be a circle
    */
    public static var random: UIColor {
        return UIColor(
                red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1)
    }

    /**
     * Derives a color from its hex value
     * - Parameters:
     *      - hex: The desired hex color
    */
    convenience init(hex: String) {
        var hex = hex
        if hex.hasPrefix("#") {
            hex.remove(at: hex.startIndex)
        }

        var rgb: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&rgb)

        let r = (rgb & 0xff0000) >> 16
        let g = (rgb & 0xff00) >> 8
        let b = rgb & 0xff

        self.init(
                red: CGFloat(r) / 0xff,
                green: CGFloat(g) / 0xff,
                blue: CGFloat(b) / 0xff,
                alpha: 1)
    }

    /**
     * Retrieves the hex String for the current color
    */
    var hexString: String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0

        self.getRed(&r, green: &g, blue: &b, alpha: &a)

        return String(
                format: "#%02X%02X%02X", Int(r * 0xff), Int(g * 0xff), Int(b * 0xff))
    }
}
