/**
 * ----------------------------------------------------------------------------+
 * Created by: Nathaniel Primo
 * Filename: Homeontroller.swift
 * Project Name: Final Project : KidsTale
 * Program: Software Development and Network Engineering
 * Course: PROG31632 - Mobile iOS Application Development
 * Creation Date: 04-09-2020
 * Description: Handles the activities that occurs on the Home page
 * ----------------------------------------------------------------------------+
*/

import UIKit

public class HomeController: SmartUIViewController, UITableViewDelegate, UITableViewDataSource {

    /**
     * An event that is fired when the view is loaded into memory
    */
    override public func viewDidLoad() {
        super.viewDidLoad()
    }

    /**
     * Stores a copy of the applications delegate
    */
    private let sharedDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate

    /**
     * Stores a cached copy of all the items that are currently bieng displayed to the user
    */
    private var searchCache: Array<DatabaseItem>? = nil

    /**
     * Stores the current type the user is currently viewing
    */
    public var viewing: DatabaseItem.Type = Book.self

    /**
     * Stores the filter that is to used to filter the category to the user entered query
    */
    public var searchFilter: ((DatabaseItem) -> Bool)? = nil

    /**
     * Stores the releasable name for the table cell
    */
    private static let CELL_NAME: String = "resource"

    /**
     * Stores a copy of the Table view that displays all chosen resources
    */
    @IBOutlet
    private var tableResources: UITableView?

    /**
     * Fills the TableView with UITableViewCells
     * - Parameters:
     *      - tableView: The object that initialized the event
     *      - cellForRowAt: The object that initialized the event
    */
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var tableCell: DetailViewCell? = tableView.dequeueReusableCell(withIdentifier: HomeController.CELL_NAME) as? DetailViewCell

        if (tableCell == nil) {

            tableCell = DetailViewCell(style: .default,
                    reuseIdentifier: HomeController.CELL_NAME,
                    object: nil)
        }

        tableCell?.object = searchCache![indexPath.row]

        tableCell?.resourceType = ResourceType(rawValue: String(describing: viewing))!

        return tableCell!
    }

    /**
     * Reloads the table and all of its cells
    */
    public func invalidaateTable() {

        tableResources?.reloadData()
    }

    /**
     * Allows ViewController to perform an unwind segue
     * - Parameters:
     *      - tableView: The object that initialized the event
     *      - numberOfRowsInSection: The number of rows in the selection
    */
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        // Retrieves the count after applying the search filter
        if (searchFilter != nil) {

            searchCache = sharedDelegate.findAll(table: viewing, filter: searchFilter!)

            return searchCache!.count
        } else {

            searchCache = sharedDelegate.findAll(table: viewing)

            return searchCache!.count
        }
    }

    /**
     * Determines the height of each cell in the table
     * - Parameters:
     *      - tableView: The object that initialized the event
     *      - heightForRowAt: The height of the cell in the tableview
    */
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return DetailViewCell.CELL_HEIGHT
    }

    /**
     * Event that fires when a row is selected
     * - Parameters:
     *      - tableView: The object that initialized the event
     *      - didSelectRowAt: The indexpath of the selected row
    */
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let selectedItem: DatabaseItem? = searchCache![indexPath.row]

        if (selectedItem == nil) {

            return
        }

        sharedDelegate.selectedItem = selectedItem

        if (viewing == Book.self) {

            // TODO: present() additional information for the specific book
        } else if (viewing == Store.self) {

            // TODO: present() additional information for the specific store
        }
    }

}
