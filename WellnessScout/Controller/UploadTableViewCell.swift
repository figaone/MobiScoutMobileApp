//
//  UploadTableViewCell.swift
//  WellnessScout
//
//  Created by Sharma, Anuj [CCE E] on 10/24/21.
//

import UIKit

import UIKit

class UploadTableViewCell: UITableViewCell {
    
//    @IBOutlet weak var videoNameLabel: UILabel!
//    @IBOutlet weak var progressBar: UIProgressView!
    
//    @IBOutlet weak var uploadButtonOutlet: UIButton!
//    @IBOutlet weak var cancelButtonOutlet: UIButton!
    //    @IBOutlet weak var uploadButton: UIButton!
//    @IBOutlet weak var cancelButton: UIButton!
//    @IBOutlet weak var transferedBytesLabel: UIProgressView!
    //cell variables
    @IBOutlet weak var videoNameLabel: UILabel!
    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var uploadButtonOutlet: UIButton!
    @IBOutlet weak var cancelButtonOutlet: UIButton!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var transferedBytesLabel: UILabel!
    
    //variable used to control the pause and resume
    var pausedEnabled = false
    
    
    //used to control the pause and resume button
    
    
    @IBAction func uploadButtonPressed(_ sender: Any) {
        
        
    }
    
    //used to cancel the button
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        
        
        
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

