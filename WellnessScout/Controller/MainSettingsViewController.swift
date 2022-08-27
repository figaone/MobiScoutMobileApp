//
//  MainSettingsViewController.swift
//  WellnessScout
//
//  Created by Sharma, Anuj [CCE E] on 3/21/22.
//

import UIKit
import SwiftUI




struct Section {
    let title: String
    let options: [SettingsOptionType]
}

enum SettingsOptionType {
    case staticCell(model: SettingsOption)
    case currentVidFrameLabelCell(model: CurrentVidFrameSettingsOption)
    case currentUploadLabelCell(model: CurrentUploadSettingsOption)
    case sliderCell(model: SettingsSliderOption)
    case sliderVideoFrameCell(model: VideoFrameSettingsSliderOption)
    case switchCell(model: SettingsSwitchOption)
    case buttonCell(model: SettingsButtonOption)
}



struct SettingsSliderOption {
    let title: String
    let icon: UIImage?
    let iconBackgroundColor: UIColor
    let handler: (() -> Void)
}
struct VideoFrameSettingsSliderOption {
    let title: String
    let icon: UIImage?
    let iconBackgroundColor: UIColor
    let handler: (() -> Void)
}

struct SettingsSwitchOption {
    let title: String
    let icon: UIImage?
    let iconBackgroundColor: UIColor
    let handler: (() -> Void)
}

struct SettingsButtonOption {
    let title: String
    let icon: UIImage?
    let iconBackgroundColor: UIColor
    let handler: (() -> Void)
    var enabled: Bool
}
struct SettingsOption {
    let title: String
    let icon: UIImage?
    let iconBackgroundColor: UIColor
    let handler: (() -> Void)
}
struct CurrentVidFrameSettingsOption {
    let title: String
    let icon: UIImage?
    let iconBackgroundColor: UIColor
    let handler: (() -> Void)
}
struct CurrentUploadSettingsOption {
    let title: String
    let icon: UIImage?
    let iconBackgroundColor: UIColor
    let handler: (() -> Void)
}


class MainSettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
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
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(MainSettingsTableViewCell.self, forCellReuseIdentifier: MainSettingsTableViewCell.identifier)
        table.register(CurrentVideoFrameTableViewCell.self, forCellReuseIdentifier: CurrentVideoFrameTableViewCell.identifier)
        table.register(CurrentUploadLabelTableViewCell.self, forCellReuseIdentifier: CurrentUploadLabelTableViewCell.identifier)
        table.register(MainSettingsSwitchTableViewCell.self, forCellReuseIdentifier: MainSettingsSwitchTableViewCell.identifier)
        table.register(MainSettingsSliderTableViewCell.self, forCellReuseIdentifier: MainSettingsSliderTableViewCell.identifier)
        table.register(MainsettingsVideoFrameTableViewCell.self, forCellReuseIdentifier: MainsettingsVideoFrameTableViewCell.identifier)
        table.register(MainSettingsButtonTableViewCell.self, forCellReuseIdentifier: MainSettingsButtonTableViewCell.identifier)
        return table
    }()

    var models = [Section]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //configure the models
        configure()
        
        //initial table setup
        title = "Settings"
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //set if view should rotate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.shouldRotate = true // or false to disable rotation
        
        //reload the table view current values
        DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }

    }
    
    
    
    
    func configure(){
        userData = defaultManager.getUserDefaults()

        models.append(Section(title: "Current Values", options: [
            .staticCell(model: SettingsOption(title: "Sensor Frequency", icon: UIImage(systemName: "gyroscope"), iconBackgroundColor: .systemPink) {
                print("touched")
                
            }),
            .currentVidFrameLabelCell(model: CurrentVidFrameSettingsOption(title: "Video Frame Rate", icon: UIImage(systemName: "video"), iconBackgroundColor: .systemGreen) {
                
            }),
            .currentUploadLabelCell(model: CurrentUploadSettingsOption(title: "Upload", icon: UIImage(systemName: "square.and.arrow.up"), iconBackgroundColor: .systemOrange) {
                
            })
        ]))
        models.append(Section(title: "Sensor Frequency Value Change", options: [
            .sliderCell(model:  SettingsSliderOption(title: "Sensor Frequency Slider", icon: UIImage(systemName: "gyroscope"), iconBackgroundColor: .systemGreen, handler: {
                
            })),
        ]))
        models.append(Section(title: "Video Frame per sec Value Change", options: [
            .sliderVideoFrameCell(model: VideoFrameSettingsSliderOption(title: "Video Frame Rate Slider", icon: UIImage(systemName: "video"), iconBackgroundColor: .systemGreen, handler: {
                
            }))
        ]))
        models.append(Section(title: "Upload Settings", options: [
            .switchCell(model:  SettingsSwitchOption(title: "Automatic Upload", icon: UIImage(systemName: "square.and.arrow.up"), iconBackgroundColor: .systemGreen, handler: {
                
            })),
            .buttonCell(model: SettingsButtonOption(title: "Save Settings", icon: UIImage(systemName: "tray.and.arrow.down"), iconBackgroundColor: .systemPink, handler: {
            }, enabled: true))
        ]))

    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = models[section]
        return section.title
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models[section].options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("table view reloaded ")
        let model = models[indexPath.section].options[indexPath.row]
        userData = defaultManager.getUserDefaults()
        switch model.self {
        case .staticCell(let model):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MainSettingsTableViewCell.identifier, for: indexPath) as? MainSettingsTableViewCell else{
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            cell.configure(with: model)
            return cell
        case .currentVidFrameLabelCell(model: let model):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CurrentVideoFrameTableViewCell.identifier, for: indexPath) as? CurrentVideoFrameTableViewCell else{
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            cell.configure(with: model)
            return cell
        case .currentUploadLabelCell(model: let model):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CurrentUploadLabelTableViewCell.identifier, for: indexPath) as? CurrentUploadLabelTableViewCell else{
                return UITableViewCell()
            }
            
            cell.selectionStyle = .none
            cell.configure(with: model)
            return cell
        case .switchCell(let model):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MainSettingsSwitchTableViewCell.identifier, for: indexPath) as? MainSettingsSwitchTableViewCell else{
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            cell.configure(with: model)
            cell.mySwitch.addTarget(self, action: #selector(switchStateDidChange(sender:)), for: .valueChanged)
            return cell
        
        case .sliderCell(model: let model):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MainSettingsSliderTableViewCell.identifier, for: indexPath) as? MainSettingsSliderTableViewCell else{
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            cell.configure(with: model)
            cell.mySlider.addTarget(self, action: #selector(frequencySliderValue(sender:)), for: .valueChanged)
            return cell
        case .sliderVideoFrameCell(model: let model):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MainsettingsVideoFrameTableViewCell.identifier, for: indexPath) as? MainsettingsVideoFrameTableViewCell else{
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            cell.configure(with: model)
            cell.mySlider.addTarget(self, action: #selector(videoFrameSliderValue(sender:)), for: .valueChanged)
            return cell
        case .buttonCell(model: let model):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MainSettingsButtonTableViewCell.identifier, for: indexPath) as? MainSettingsButtonTableViewCell else{
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            cell.configure(with: model)
            cell.myButton.addTarget(self, action: #selector(saveButtonPressed(sender:)), for: UIControl.Event.touchUpInside)
            return cell
        
        }
        
    }
    
    
    @objc func switchStateDidChange(sender:UISwitch)
        {
//            let userData = UserDefaultsData()
            if (sender.isOn == true){
                print("UISwitch state is now ON")
//                userData.automaticUpload = true
//                print(userData.automaticUpload)
//                defaultManager.setUserDefaults(userData: userData)
            }
            else{
                print("UISwitch state is now Off")
//                userData.automaticUpload = false
//                print(userData.automaticUpload)
//                defaultManager.setUserDefaults(userData: userData)
            }
        }
    
    @objc func frequencySliderValue(sender:UISlider){
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: 0, section: 1)
            
            if let cell = self.tableView.cellForRow(at: indexPath) as? MainSettingsSliderTableViewCell {
                cell.valuelabel.text = String(Int(sender.value)) + "hz"
            }
        }
    }
    
    @objc func videoFrameSliderValue(sender:UISlider){
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: 0, section: 2)
            
            if let cell = self.tableView.cellForRow(at: indexPath) as? MainsettingsVideoFrameTableViewCell {
                cell.valuelabel.text = String(Int(sender.value)) + "fps"
            }
        }
    }
    
    @objc func saveButtonPressed(sender: UIButton!){
    
     //initialize the section and indexpaths of the buttons
     let freqSliderindexPath = IndexPath(row: 0, section: 1)
     let vidFrameSliderindexPath = IndexPath(row: 0, section: 2)
     let switchButtonindexPath = IndexPath(row: 0, section: 3)

        //checks to make sure that we aren't already recording before we switch settings
        if AllData.shared.movieOutput.isRecording == false{
            
            if let cell = self.tableView.cellForRow(at: freqSliderindexPath) as? MainSettingsSliderTableViewCell, let cell2 = self.tableView.cellForRow(at: vidFrameSliderindexPath) as? MainsettingsVideoFrameTableViewCell ,let cell3 = self.tableView.cellForRow(at: switchButtonindexPath) as? MainSettingsSwitchTableViewCell  {
                
                //set the new default values
                let userData = UserDefaultsData()
                
                //set the frequency
                sensorManager.setTimeInterval(motionManager: AllData.shared.motionManager, updateInterval: TimeInterval(1/cell.mySlider.value))
                //let data update interval equal to 80 percent the sensor frequency
                AllData.shared.sensorFrequency = Double((1/cell.mySlider.value) * 0.80)
                userData.frequency =  Double(cell.mySlider.value)
                
                //set the frames
                vidManager.setFrameRate(frameRate: Double(Int(cell2.mySlider.value)))
                userData.frameRate = Double(Int(cell2.mySlider.value))
                
                //set the automatic upload switch
                userData.automaticUpload = cell3.mySwitch.isOn
                
                //set the default values and save them
                defaultManager.setUserDefaults(userData: userData)
                
                //reload the the tableview
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }

            }else{
                presentAlert(withTitle: "Settings Alert", message: "Settings could not be saved please restart app!", actions: [ "OK": UIAlertAction.Style.cancel])
            }


            //MARK:CHANGE LATER LEAVE FOR NOW
            presentAlert(withTitle: "Multi-Camera Alert", message: "Restart the app to apply camera changes!", actions: [ "OK": UIAlertAction.Style.cancel])
        }else{
            //the user was already recording data and tried to change settings, this isn't allowed
            presentAlert(withTitle: "Error", message: "You can't change user settings while recording, finish recording and try again.", actions: [ "OK": UIAlertAction.Style.cancel])
        }

    }
    
//    //function used to update the view when values are changed
//    func reloadValues(){
//        //initialize the section and indexpaths of the buttons
//        let freqCurrentValue = IndexPath(row: 0, section: 0)
//        let frameCurrentValue = IndexPath(row: 1, section: 0)
//        let uploadCurrentValue = IndexPath(row: 2, section: 0)
//        let freqSliderindexPath = IndexPath(row: 0, section: 1)
//        let vidFrameSliderindexPath = IndexPath(row: 0, section: 2)
//        let switchButtonindexPath = IndexPath(row: 0, section: 3)
//
//        DispatchQueue.main.async {
//                        self.tableView.reloadData()
//                    }
        
//        if let cell1 = self.tableView.cellForRow(at: freqCurrentValue) as? MainSettingsTableViewCell,let cell2 = self.tableView.cellForRow(at: frameCurrentValue) as? CurrentVideoFrameTableViewCell,let cell3 = self.tableView.cellForRow(at: uploadCurrentValue) as? CurrentUploadLabelTableViewCell,let cell4 = self.tableView.cellForRow(at: freqSliderindexPath) as? MainSettingsSliderTableViewCell, let cell5 = self.tableView.cellForRow(at: vidFrameSliderindexPath) as? MainsettingsVideoFrameTableViewCell ,let cell6 = self.tableView.cellForRow(at: switchButtonindexPath) as? MainSettingsSwitchTableViewCell  {
//
//            //set the new default values
//            let userData = UserDefaultsData()
//
//            //set the frequency
//            cell1.valuelabel.text = "\(Int(userData.frequency ?? (1 / sensorManager.getSensorRate(motionManager: AllData.shared.motionManager))))hz"
//            cell4.mySlider.value = Float(userData.frequency ?? (1 / sensorManager.getSensorRate(motionManager: AllData.shared.motionManager)))
//            cell4.valuelabel.text = "\(Int(userData.frequency ?? (1 / sensorManager.getSensorRate(motionManager: AllData.shared.motionManager))))hz"
//
//            //set the frames
//            cell2.valuelabel.text = "\(Int(userData.frameRate ?? vidManager.getMaxFrameRateValue()))fps"
//            cell5.mySlider.value = Float(userData.frameRate ??  vidManager.getMaxFrameRateValue())
//            cell5.valuelabel.text = "\(Int(userData.frameRate ?? vidManager.getMaxFrameRateValue()))fps"
//
//            //set the automatic upload switch
//            cell6.mySwitch.isOn = userData.automaticUpload
//            if userData.automaticUpload == true {
//                cell3.valuelabel.text = "Automatic"
//            } else{
//                cell3.valuelabel.text = "Manual"
//            }
//
//            //set the default values and save them
//            defaultManager.setUserDefaults(userData: userData)
//
//            //reload the the tableview
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
//
//        }else{
//            print("this is the reload")
//        }
        
//    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let type = models[indexPath.section].options[indexPath.row]
        switch type.self {
        case .staticCell(let model):
            model.handler()
        case .switchCell(let model):
            model.handler()
        case .sliderCell(model: let model):
            model.handler()
        case .sliderVideoFrameCell(model: let model):
            model.handler()
        case .buttonCell(model: let model):
            model.handler()
        case .currentVidFrameLabelCell(model: let model):
            model.handler()
        case .currentUploadLabelCell(model: let model):
            model.handler()
        }
    }
    
    
    
   

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
