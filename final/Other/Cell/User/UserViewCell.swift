/*
 
 Heon Lee
 991280638
 
 UserViewCell.swift
 2020-04-19
 */

import UIKit

class UserViewCell: UITableViewCell {

    let primaryLabel = UILabel()
    let secondaryLabel = UILabel()
    let myImageView = UIImageView()


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

    override func layoutSubviews() {
        primaryLabel.frame = CGRect(x: 100, y: 5, width: 460, height: 30)
        secondaryLabel.frame = CGRect(x: 100, y: 40, width: 460, height: 30)

        myImageView.frame = CGRect(x: 5, y: 5, width: 80, height: 50)
    }


    required init?(coder aDecoder: NSCoder) {
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
