//
//  CurrentUploadLabelTableViewCell.swift
//  WellnessScout
//
//  Created by Sharma, Anuj [CCE E] on 3/23/22.
//

import UIKit

class CurrentUploadLabelTableViewCell: UITableViewCell {

    static let identifier = "CurrentUploadLabelTableViewCell"
    let defaultManager = DefaultsManager()
    var userData : UserDefaultsData!
    
    private let iconContainer: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    public let valuelabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        contentView.addSubview(valuelabel)
        contentView.addSubview(iconContainer)
        iconContainer.addSubview(iconImageView)
        contentView.clipsToBounds = true
//        accessoryType = .none
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let size: CGFloat = contentView.frame.size.height - 12
        iconContainer.frame = CGRect(x: 15, y: 6, width: size, height: size)
        
        let imageSize = size/1.5
        iconImageView.frame = CGRect(x: (size - imageSize)/2, y: (size - imageSize)/2, width: imageSize, height: imageSize)
        
        
        label.frame = CGRect(x: 25 + iconContainer.frame.size.width
                             , y: 0,
                             width: contentView.frame.size.width - 25 - iconContainer.frame.size.width
                             , height: contentView.frame.size.height)
        valuelabel.frame = CGRect(x: (-25 + label.frame.size.width),
                             y: 0,
                             width: contentView.frame.size.width - 25 - iconContainer.frame.size.width
                             , height: contentView.frame.size.height)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        label.text = nil
        valuelabel.text = nil
        iconContainer.backgroundColor = nil
    }
    
    public func configure(with model: CurrentUploadSettingsOption){
        userData = defaultManager.getUserDefaults()
        print(userData.frequency as Any)
        label.text = model.title
        if userData.automaticUpload == true {
            valuelabel.text = "Automatic"
        } else{
            valuelabel.text = "Manual"
        }
        iconImageView.image = model.icon
        iconContainer.backgroundColor = model.iconBackgroundColor
    }

}
