//
//  JMRecordingVC.swift
//  MEMELogger-iOS-beta
//
//  Created by Shoya Ishimaru on 2015/11/12.
//  Copyright © 2015年 shoya140. All rights reserved.
//

import UIKit
import SVProgressHUD

class JMRecordingVC: UIViewController, MEMELibDelegate{

    @IBOutlet weak var recordSwitchButton: SIFlatButton!
    @IBOutlet weak var lastTimestampLabel: UILabel!
    @IBOutlet weak var segmentSwitch: UISegmentedControl!
    
    private var label:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        MEMELib.sharedInstance().delegate = self
    }
    
    @IBAction func switchRecording(sender: AnyObject) {
        if FileWriter.sharedWriter.isRecording {
            FileWriter.sharedWriter.stopRecording()
            self.recordSwitchButton.setTitle("Start Recording", forState: UIControlState.Normal)
            self.recordSwitchButton.inverse = false
            SVProgressHUD.showSuccessWithStatus("Finished")
        } else {
            FileWriter.sharedWriter.startRecording()
            self.recordSwitchButton.setTitle("Stop Recording", forState: UIControlState.Normal)
            self.recordSwitchButton.inverse = true
            self.segmentSwitch.selectedSegmentIndex = 0
            SVProgressHUD.showImage(UIImage(named: "icon-recording"), status: "Started")
        }
    }
    
    @IBAction func eventLavelButtonTapped(sender: UIButton) {
        FileWriter.sharedWriter.eventLabel = 1
    }
    
    @IBAction func segmentLabelChanged(sender: UISegmentedControl) {
        FileWriter.sharedWriter.segmentLabel = sender.selectedSegmentIndex
    }
    
    @IBAction func uploadData(sender: UIButton) {
        FileUploader().uploadFiles()
    }
    
    // MARK: - MEMELib delegate
    
    func memeRealTimeModeDataReceived(data: MEMERealTimeData!) {
        if FileWriter.sharedWriter.isRecording{
            FileWriter.sharedWriter.writeData(data)
            lastTimestampLabel.text = NSString(format: "%10.5f", NSDate().timeIntervalSince1970 ) as String
        }
    }
}
