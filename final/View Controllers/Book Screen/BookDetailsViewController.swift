/**
 * ----------------------------------------------------------------------------+
 * Created by: Sher Khan
 * Filename: BookDetailsViewController.swift
 * Project Name: Final Project : KidsTale
 * Program: Software Development and Network Engineering
 * Course: PROG31632 - Mobile iOS Application Development
 * Creation Date: 04-15-2020
 * Description: The backing view controller for the book screen
 * ----------------------------------------------------------------------------+
*/

import UIKit

class BookDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    /**
     * Stores a copy of the applications delegate
    */
    private let sharedDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate

    /**
     * Stores a copy of label that display the book title
    */
    @IBOutlet
    private var lblTitle: UILabel?

    /**
     * Stores a copy of of the stores that have the selected book in stock
    */
    private var availableStores: Array<Inventory>?

    /**
     * Stores a copy of label that display the book description
    */
    @IBOutlet
    private var txtDescription: UITextView?

    /**
     * An event that is fired when the view is loaded into memory
    */
    override func viewDidLoad() {
        super.viewDidLoad()

        let selectedBook: Book = sharedDelegate.selectedItem as! Book

        lblTitle?.text = selectedBook.name

        txtDescription?.text = selectedBook.description

        availableStores = (sharedDelegate.findAll(table: Inventory.self) as! Array<Inventory>)
                .filter({ (inventory: Inventory) in

            return selectedBook.id == inventory.id
        })

        // Do any additional setup after loading the view.
    }

    /**
     * Event that fires when a row is selected
     * - Parameters:
     *      - tableView: The object that initialized the event
     *      - didSelectRowAt: The indexpath of the selected row
    */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        sharedDelegate.selectedItem = availableStores![indexPath.row].store

        self.performSegue(withIdentifier: "storeDetailViewController", sender: self)
    }

    /**
     * determines the total amount of element in the table view
     * - Parameters:
     *      - tableView: The object that initialized the event
     *      - numberOfRowsInSection: The number of rows in the selection
    */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return availableStores!.count
    }

    /**
     * Determines the height of each cell in the table
     * - Parameters:
     *      - tableView: The object that initialized the event
     *      - heightForRowAt: The height of the cell in the tableview
    */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return DetailViewCell.CELL_HEIGHT
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var tableCell: DetailViewCell? = tableView.dequeueReusableCell(withIdentifier: HomeController.CELL_NAME) as? DetailViewCell

        if (tableCell == nil) {

            tableCell = DetailViewCell(style: .default,
                    reuseIdentifier: HomeController.CELL_NAME,
                    object: nil)
        }

        // Once the store actually has at least 1 book in its inventory
        if (availableStores![indexPath.row].stock! > 0) {

            tableCell?.object = availableStores![indexPath.row].store

            tableCell?.customResource = String(describing: Store.self)

            tableCell?.customAccessory = "eye"
        }

        return tableCell!
    }
}
