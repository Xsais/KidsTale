/**
 * ----------------------------------------------------------------------------+
 * Created by: Nathaniel Primo
 * Filename: DetailView.swift
 * Project Name: Final Project : KidsTale
 * Program: Software Development and Network Engineering
 * Course: PROG31632 - Mobile iOS Application Development
 * Creation Date: 04-12-2020
 * Description: A custom cell to display details to the user
 * ----------------------------------------------------------------------------+
*/

import UIKit

class DetailViewCell: UITableViewCell {

    /**
     * Stores the object in which the UIElements text are pulled from
    */
    private var _object: DatabaseItem?

    /**
     * Stores the UIImageView that will be displayed next to the data
    */
    private var picture: UIImageView = UIImageView()

    /**
     * Stores the name of the image that will be displayed next to the data
    */
    private var _customResource: String?

    /**
     * Stores the name of the image that will be displayed as the accessory
    */
    private var _customAccessory: String?

    /**
     * Allows the user to modify and receive the image that will be displayed as the accessory
    */
    public var customAccessory: String? {

        get {
            return _customResource
        }
        set {

            _customAccessory = newValue

            if (newValue == nil) {

                self.accessoryView = nil
                return
            }

            imageMore.image = UIImage(named: _customAccessory!)
            self.accessoryView = imageMore
        }
    }

    /**
     * Allows the user to modify and receive the name of the image that will be displayed next to the data
    */
    public var customResource: String? {

        get {
            return _customResource
        }
        set {

            _customResource = newValue

            if (newValue == nil) {

                picture.isHidden = true
                return
            }

            picture.image = UIImage(named: _customResource!)
            picture.isHidden = false
        }
    }

    /**
     * Stores the indicator image that will be used for this Cell
    */
    private var imageMore: UIImageView = UIImageView()

    /**
     * The UI element that stores the name that is visually displayed displayed to the user
    */
    private var name: UILabel = UILabel()

    /**
     * The UI element that displays the extra data to display to the user
    */
    private var detail: UILabel = UILabel()

    /**
     * The spacing that is to be placed between each UIElement
    */
    private static let SPACING: CGFloat = 20

    /**
     * The height of each cell
    */
    public static let CELL_HEIGHT: CGFloat = DetailViewCell.SPACING + 44

    /**
     * Allows the user to modify and receive the object in which the UIElements text are pulled from
    */
    var object: DatabaseItem? {
        set {

            if (newValue != nil) {

                name.text = newValue!.name
                detail.text = String(newValue!.description)
            } else {

                name.text = ""
                detail.text = ""
            }

            _object = newValue
        }
        get {
            return _object
        }
    }

    /**
     * Initializes the TableCell with the recommended parameters
     * - Parameters:
     *      - style: The style of the cell that will be displayed to the user
     *      - reuseIdentifier: The identifier that will be assigned to the cell
     *      - object: The {@See DatabaseItem} in which the UIElements text are pulled from
    */
    init(style: UITableViewCell.CellStyle, reuseIdentifier: String?, object: DatabaseItem?) {

        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(picture)
        contentView.addSubview(name)
        contentView.addSubview(detail)

        customAccessory = nil
        customResource = nil

        picture.frame = CGRect(x: DetailViewCell.SPACING / 2, y: DetailViewCell.SPACING / 2, width: DetailViewCell.CELL_HEIGHT - DetailViewCell.SPACING, height: DetailViewCell.CELL_HEIGHT - DetailViewCell.SPACING)

        let halfHeight = picture.frame.height / 2;

        imageMore.frame = CGRect(x: frame.width, y: frame.height / 2, width: halfHeight, height: halfHeight / 1.45)

        name.frame = CGRect(x: picture.frame.width + DetailViewCell.SPACING, y: halfHeight - DetailViewCell.SPACING / 1.45, width: frame.width - DetailViewCell.SPACING * 2, height: 20)

        detail.frame = CGRect(x: picture.frame.width + DetailViewCell.SPACING, y: halfHeight + DetailViewCell.SPACING / 1.45, width: frame.width - DetailViewCell.SPACING, height: 20)

        self.object = object
    }

    /**
     * Initializes the TableCell with a NSCoder object
     * - Parameters:
     *      - coder: The NSCoder object
    */
    required init?(coder: NSCoder) {

        fatalError("init(coder:) has not been implemented")
    }

    /**
     * Callback to when the element is awaken from a nib
    */
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    /**
     * Retrieves a single item from the table, either from the cache or directly from the database
     * - Parameters:
     *      - selected: Should the cell appear to be in the selected state
     *      - animated: Will the transformation be animated
    */
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}