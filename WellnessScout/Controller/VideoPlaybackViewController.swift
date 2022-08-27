//
//  VideoPlaybackViewController.swift
//  WellnessScout
//
//  Created by Sharma, Anuj [CCE E] on 10/23/21.
//

import UIKit
import AVFoundation

class VideoPlaybackViewController: UIViewController{

    //MARK:Objects
    let avPlayer = AVPlayer()
    var avPlayerLayer: AVPlayerLayer!
    
    var videoURL: URL!
    var frontVideoURL : URL!
    var initialVehicleDataURL : URL!
    var sensorDataURL : URL!
    var initialHealthDataURL : URL!
    //connect this to your uiview in storyboard
    
//    @IBOutlet weak var videoView: UIView!
    

    @IBOutlet weak var videoView: UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        print(videoURL as Any)
        //gets an av player and sets it
        avPlayerLayer = AVPlayerLayer(player: avPlayer)
        //set the bounds of the player
        avPlayerLayer.frame = view.bounds
        //set the aspect ratio
        avPlayerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        //adds the view
        videoView.layer.insertSublayer(avPlayerLayer, at: 0)
        //refresh as needed
        view.layoutIfNeeded()
        //set the item to play
        let playerItem = AVPlayerItem(url: videoURL as URL)
        avPlayer.replaceCurrentItem(with: playerItem)
        //play the item
        avPlayer.play()
    }
    
    
    
    
    
    

    
}

