/**
 * ----------------------------------------------------------------------------+
 * Created by: Heon Lee
 * Filename: UserViewCell.swift
 * Project Name: Final Project : KidsTale
 * Program: Software Development and Network Engineering
 * Course: PROG31632 - Mobile iOS Application Development
 * Creation Date: 04-12-2020
 * Description: A custom cell that displays the users info
 * ----------------------------------------------------------------------------+
*/


import UIKit

class UserViewCell: UITableViewCell {

    /**
     * The label the will visually display the main information the the user
    */
    let primaryLabel = UILabel()

    /**
     * The label the will visually display the secondary information the the user
    */
    let secondaryLabel = UILabel()

    /**
     * The ImageView that will display the picture to the user
    */
    let myImageView = UIImageView()

    /**
     * Adds corner radius's to a UIElement making, it a circle
     * - Parameters:
     *      - style: The desired style of the current cell
     *      - reuseIdentifier: The identifier that will be used to identify the cell
    */
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {

        primaryLabel.textAlignment = .left
        primaryLabel.font = UIFont.boldSystemFont(ofSize: 30)
        primaryLabel.backgroundColor = .clear
        primaryLabel.textColor = .black


        secondaryLabel.textAlignment = .left
        secondaryLabel.font = UIFont.boldSystemFont(ofSize: 16)
        secondaryLabel.backgroundColor = .clear
        secondaryLabel.textColor = .black

        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(primaryLabel)

        contentView.addSubview(secondaryLabel)

        contentView.addSubview(myImageView)
    }

    /**
     * Creates the bounds for all UIElements
    */
    override func layoutSubviews() {
        primaryLabel.frame = CGRect(x: 100, y: 5, width: 460, height: 30)
        secondaryLabel.frame = CGRect(x: 100, y: 40, width: 460, height: 30)

        myImageView.frame = CGRect(x: 5, y: 5, width: 80, height: 50)
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
