//
//  DetailViewCell.swift
//  final
//
//  Created by Nathaniel Primo on 2020-04-08.
//

import UIKit

class DetailViewCell: UITableViewCell {

    private var _object: DatabaseItem?

    private var picture: UIImageView = UIImageView()

    private var _resourceType: ResourceType = .book

    public var resourceType: ResourceType { set {

        picture.image = UIImage(named: newValue.rawValue)

        picture.frame = CGRect(x: DetailViewCell.SPACING / 2, y: DetailViewCell.SPACING / 2, width: DetailViewCell.CELL_HEIGHT - DetailViewCell.SPACING, height: DetailViewCell.CELL_HEIGHT - DetailViewCell.SPACING)

        _resourceType = newValue
    } get { return _resourceType} }

    private var imageMore: UIImageView = UIImageView()

    private var name: UILabel = UILabel()

    private var detail: UILabel = UILabel()

    private static let SPACING: CGFloat = 20

    public static let CELL_HEIGHT: CGFloat = DetailViewCell.SPACING + 44

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

    init(style: UITableViewCell.CellStyle, reuseIdentifier: String?, object: DatabaseItem?) {

        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(picture)
        contentView.addSubview(name)
        contentView.addSubview(detail)
        contentView.addSubview(imageMore)

        resourceType = .book

        picture.frame = CGRect(x: DetailViewCell.SPACING / 2, y: DetailViewCell.SPACING / 2, width: DetailViewCell.CELL_HEIGHT - DetailViewCell.SPACING, height: DetailViewCell.CELL_HEIGHT - DetailViewCell.SPACING)

        let halfHeight = picture.frame.height / 2;

        imageMore.image = UIImage(named: "eye")

        imageMore.frame = CGRect(x: frame.width, y: frame.height / 2, width: halfHeight, height: halfHeight / 1.45)

        name.frame = CGRect(x: picture.frame.width + DetailViewCell.SPACING, y: halfHeight - DetailViewCell.SPACING / 1.45, width: frame.width - picture.frame.width * 2.5, height: 20)

        detail.frame = CGRect(x: picture.frame.width + DetailViewCell.SPACING, y: halfHeight + DetailViewCell.SPACING / 1.45, width: frame.width - picture.frame.width * 2, height: 20)

        self.object = object
    }

    required init?(coder: NSCoder) {

        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}