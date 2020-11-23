//
//  AutomataRefreshConfigViewController.swift
//  Rule30
//
//  Created by Brandon G. Smith on 11/23/20.
//

import UIKit

class AutomataRefreshConfigViewController: UIViewController {

    /// Switch to turn on and off animation
    @IBOutlet weak var animationSwitch: UISwitch!
    /// View containing delay time details
    @IBOutlet weak var animationDelayView: UIView!
    /// Slider for delay time
    @IBOutlet weak var delaySlider: UISlider!
    /// Label to display currently selected delay
    @IBOutlet weak var delaySecondsLabel: UILabel!
    
    var delayTime: Float = 0.1
    var animateRefresh = true
    
    @IBAction func delaySliderValueChanged(_ sender: UISlider) {
        delayTime = (delaySlider.value*10).rounded()/10
        updateDelayTimeLabel()
    }
    
    @IBAction func animatedSwitchValueChanged(_ sender: UISwitch) {
        animateRefresh = sender.isOn
        animationDelayView.isHidden = !animateRefresh
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animationSwitch.isOn = animateRefresh
        animationDelayView.isHidden = !animateRefresh

        delaySlider.value = delayTime
        updateDelayTimeLabel()
    }
    
    func updateDelayTimeLabel() {
        delaySecondsLabel.text = "\(delayTime) Seconds"
    }
}
