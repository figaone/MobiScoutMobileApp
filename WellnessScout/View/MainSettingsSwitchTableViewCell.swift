//
//  MainSettingsSwitchTableViewCell.swift
//  WellnessScout
//
//  Created by Sharma, Anuj [CCE E] on 3/21/22.
//

import UIKit

var userAutomaticUpload : Bool = true

class MainSettingsSwitchTableViewCell: UITableViewCell {

    static let identifier = "MainSettingsSwitchTableViewCell"
    
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
    
    public let mySwitch: UISwitch = {
       let mySwicth = UISwitch()
        mySwicth.onTintColor = .systemBlue
        return mySwicth
    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        contentView.addSubview(iconContainer)
        contentView.addSubview(mySwitch)
        iconContainer.addSubview(iconImageView)
        contentView.clipsToBounds = true
        accessoryType = .none
        
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
        
        mySwitch.sizeToFit()
        mySwitch.frame = CGRect(x: (contentView.frame.size.width - mySwitch.frame.size.width - 20),
                                y: (contentView.frame.size.height - mySwitch.frame.size.height)/2,
                                width: mySwitch.frame.size.width,
                                height: mySwitch.frame.size.height)
        
        label.frame = CGRect(x: 25 + iconContainer.frame.size.width
                             , y: 0,
                             width: contentView.frame.size.width - 25 - iconContainer.frame.size.width
                             , height: contentView.frame.size.height)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        label.text = nil
        iconContainer.backgroundColor = nil
        mySwitch.isOn = false
    }
    
    public func configure(with model: SettingsSwitchOption){
        userData = defaultManager.getUserDefaults()
        label.text = model.title
        iconImageView.image = model.icon
        iconContainer.backgroundColor = model.iconBackgroundColor
        if userData.automaticUpload == true {
            mySwitch.isOn = true
        } else{
            mySwitch.isOn = false
        }
        
    }


}
