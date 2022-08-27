//
//  MainSettingsSliderTableViewCell.swift
//  WellnessScout
//
//  Created by Sharma, Anuj [CCE E] on 3/21/22.
//

import UIKit



class MainSettingsSliderTableViewCell: UITableViewCell {
    
    let defaultManager = DefaultsManager()
    let sensorManager = SensorManager()
    
    static let identifier = "MainSettingsSliderTableViewCell"
    
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
    
    private let mySwitch: UISwitch = {
       let mySwicth = UISwitch()
        mySwicth.onTintColor = .systemBlue
        return mySwicth
    }()
    
    public let valuelabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    public let mySlider: UISlider = {
        let mySlider = UISlider()
        mySlider.value = 30
        mySlider.minimumValue = 1
        mySlider.maximumValue = 90
        return mySlider
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        contentView.addSubview(label)
        contentView.addSubview(iconContainer)
        contentView.addSubview(valuelabel)
//        contentView.addSubview(mySwitch)
        contentView.addSubview(mySlider)
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
        
//        mySwitch.sizeToFit()
//        mySwitch.frame = CGRect(x: (contentView.frame.size.width - mySwitch.frame.size.width - 20),
//                                y: (contentView.frame.size.height - mySwitch.frame.size.height)/2,
//                                width: mySwitch.frame.size.width,
//                                height: mySwitch.frame.size.height)
        mySlider.frame = CGRect(x: 25 + iconContainer.frame.size.width
                                 , y: 0,
                                width: contentView.frame.size.width/1.7
                                 , height: contentView.frame.size.height)
        valuelabel.frame = CGRect(x: (contentView.frame.size.width - mySlider.frame.size.width + 160),
                             y: 0,
                             width: contentView.frame.size.width - 25 - iconContainer.frame.size.width
                             , height: contentView.frame.size.height)
        
//        label.frame = CGRect(x: 25 + iconContainer.frame.size.width
//                             , y: 0,
//                             width: contentView.frame.size.width - 25 - iconContainer.frame.size.width
//                             , height: contentView.frame.size.height)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        iconContainer.backgroundColor = nil
        mySlider.value = 0
        valuelabel.text = nil
    }
    
    public func configure(with model: SettingsSliderOption){
        userData = defaultManager.getUserDefaults()
        label.text = model.title
//        valuelabel.text = String(model.value)
        iconImageView.image = model.icon
        iconContainer.backgroundColor = model.iconBackgroundColor
//        mySwitch.isOn = model.isOn
        mySlider.value = Float(userData.frequency ?? (1 / sensorManager.getSensorRate(motionManager: AllData.shared.motionManager)))
        print("this is the sensor rate: \((1 / sensorManager.getSensorRate(motionManager: AllData.shared.motionManager)))")
        valuelabel.text = "\(Int(userData.frequency ?? (1 / sensorManager.getSensorRate(motionManager: AllData.shared.motionManager))))hz"
    }


}
