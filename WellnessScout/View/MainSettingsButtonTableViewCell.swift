//
//  MainSettingsButtonTableViewCell.swift
//  WellnessScout
//
//  Created by Sharma, Anuj [CCE E] on 3/21/22.
//

import UIKit

class MainSettingsButtonTableViewCell: UITableViewCell {
    
    let mainSettingsView = MainSettingsViewController()
    //MARK:Helper classes
    let vidManager = ViewController()
    //instance to the helper class that controls sensor data
    let sensorManager = SensorManager()
    //instance to helper class to control the video
    let videoManager = VideoManager()
    //instance to helper class that managers the default values
    let defaultManager = DefaultsManager()
    
    //MARK: Local Variables
    var userData : UserDefaultsData!

    static let identifier = "MainSettingsButtonTableViewCell"
    
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
    
    public let myButton: UIButton = {
       let buttonView = UIButton()
       buttonView.tintColor = .systemPink
        buttonView.backgroundColor = .systemRed
        buttonView.setTitle("Save Settings", for: .normal)
        buttonView.clipsToBounds = true
        buttonView.layer.cornerRadius = 8
       return buttonView
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        contentView.addSubview(label)
        contentView.addSubview(iconContainer)
        contentView.addSubview(myButton)
//        contentView.addSubview(mySwitch)
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
        myButton.sizeToFit()
//        mySwitch.sizeToFit()
//        mySwitch.frame = CGRect(x: (contentView.frame.size.width - mySwitch.frame.size.width - 20),
//                                y: (contentView.frame.size.height - mySwitch.frame.size.height)/2,
//                                width: mySwitch.frame.size.width,
//                                height: mySwitch.frame.size.height)
        
//        label.frame = CGRect(x: 25 + iconContainer.frame.size.width
//                             , y: 0,
//                             width: contentView.frame.size.width - 25 - iconContainer.frame.size.width
//                             , height: contentView.frame.size.height)
        
        myButton.frame = CGRect(x: 25 + iconContainer.frame.size.width
                                , y: 7,
                                width: contentView.frame.size.width/1.2
                                , height: contentView.frame.size.height - myButton.frame.size.height + 20)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        label.text = nil
        iconContainer.backgroundColor = nil
//        mySwitch.isOn = false
        myButton.isEnabled = false
        
    }
    
    public func configure(with model: SettingsButtonOption){
        iconImageView.image = model.icon
        iconContainer.backgroundColor = model.iconBackgroundColor
//        label.text = model.title
        myButton.isEnabled = model.enabled
    }



}

extension UITableViewCell {
//    //presents an alert controller
//    func presentAlert(withTitle title: String, message : String, actions : [String: UIAlertAction.Style], completionHandler: ((UIAlertAction) -> ())? = nil) {
//        //create the alert controller
//        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        //loop through actions passed into alert controller
//        for action in actions {
//            //generate the action
//            let action = UIAlertAction(title: action.key, style: action.value) { action in
//                //create the completion handler
//                if completionHandler != nil {
//                    completionHandler!(action)
//                }
//            }
//            //add the actions to the controller
//            alertController.addAction(action)
//        }
//        //present to the user
//        self.present(alertController, animated: true, completion: nil)
//    }
}
