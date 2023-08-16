//
//  DefaultLayoutViewController.swift
//  UXSDK Sample
//
//  MIT License
//
//  Copyright © 2018-2020 DJI
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:

//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//import UIKit
import DJIUXSDK

class DefaultLayoutViewController: DUXDefaultLayoutViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent;
    }
    
    @IBAction func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Override supported interface orientations
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape // Only support landscape orientation
    }
    
    // We are going to add focus adjustment to the default view.
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVideoPreviewer()
        
        // Hide the navigation bar for this view controller
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // Function to setup the video previewer
    func setupVideoPreviewer() {
        // Create a video preview view
        let videoPreviewView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        videoPreviewView.backgroundColor = .black
        view.addSubview(videoPreviewView)
        view.sendSubviewToBack(videoPreviewView)
        
        // Configure the video previewer
        DJIVideoPreviewer.instance()?.type = .autoAdapt
        DJIVideoPreviewer.instance()?.start()
        DJIVideoPreviewer.instance()?.reset()
        DJIVideoPreviewer.instance()?.setView(videoPreviewView)
        DJIVideoPreviewer.instance()?.enableHardwareDecode = true
        
        // Get the video feed from the primary video feed
        if let videoFeed = DJISDKManager.videoFeeder()?.primaryVideoFeed {
            let previewerAdapter = VideoPreviewerSDKAdapter(videoPreviewer: DJIVideoPreviewer.instance(), andVideoFeed: videoFeed)
            previewerAdapter?.start()
            previewerAdapter?.setupFrameControlHandler()
        }
    }
}
