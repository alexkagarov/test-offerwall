
//
//  GameViewController.swift
//  test-offerwall
//
//  Created by Alex Kagarov on 6/11/19.
//  Copyright © 2019 Alex Kagarov. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    @IBAction func onRestoreDefaults(_ sender: UIButton) {
        let defaults = UserDefaults.standard
        defaults.set(0, forKey: "ResponseState")
        navigationController?.popToRootViewController(animated: true)
    }
    
    private let wheelItems = ["0","1","2","3","4","5","6","7","8","9"]
    let pickerDataSize = 10_000
    private var current = 0
    private var top = 0
    
    private var timer = Timer()
    
    @IBOutlet weak var wheel1: UIPickerView!
    @IBOutlet weak var wheel2: UIPickerView!
    @IBOutlet weak var wheel3: UIPickerView!
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var topScore: UILabel!
    
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var stopBtn: UIButton!
    
    func setCurrentScore() {
        current = 100 * (wheel1.selectedRow(inComponent: 0) % 10)
            + 10 * (wheel2.selectedRow(inComponent: 0) % 10)
            + 1 * (wheel3.selectedRow(inComponent:0) % 10)
        score.text = ("Your score: \(current)")
    }
    
    func checkTopScore(cur: Int) {
        if topScore.text == " " {
            top = cur
            topScore.text = "Top score: \(String(top))"
        } else {
            if top < cur {
                top = cur
                topScore.text = "Top score: \(String(top))"
            }
        }
    }
    
    func spinTheWheel() {
        timer = Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(GameViewController.movePicker), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        timer.invalidate()
        //timer = Timer.scheduledTimer(timeInterval: 0, target: self, selector: #selector(GameViewController.movePicker), userInfo: nil, repeats: false)
    }
    
    func setupPicker(picker: UIPickerView) {
        picker.delegate = self
        picker.dataSource = self
        picker.selectRow(pickerDataSize/2, inComponent: 0, animated: false)
    }
    
    @IBAction func playGame(_ sender: UIButton) {
        spinTheWheel()
        startBtn.isHidden.toggle()
        stopBtn.isHidden.toggle()
    }
    
    @IBAction func stopBtn(_ sender: UIButton) {
        startBtn.isHidden.toggle()
        stopBtn.isHidden.toggle()
        stopGame()
    }
    
    @objc func setScore() {
        setCurrentScore()
        checkTopScore(cur: current)
    }
    
    func stopGame() {
        stopTimer()
        perform(#selector(setScore), with: nil, afterDelay: 0.5)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
        setupPicker(picker: wheel1)
        setupPicker(picker: wheel2)
        setupPicker(picker: wheel3)
        
        // Do any additional setup after loading the view.
    }
}

extension GameViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSize
    }
}

extension GameViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(row % 10)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let position = pickerDataSize/2 + row
        pickerView.selectRow(position, inComponent: 0, animated: false)
    }
}

extension GameViewController {
    @objc func movePicker() {
        var position = Int.random(in: (pickerDataSize/2 - 5)...(pickerDataSize/2) + 4)
        
        wheel1.selectRow(position, inComponent: 0, animated: true)
        wheel1.showsSelectionIndicator = true
        
        position = Int.random(in: (pickerDataSize/2 - 5)...(pickerDataSize/2) + 4)
        
        wheel2.selectRow(position, inComponent: 0, animated: true)
        wheel2.showsSelectionIndicator = true
        
        position = Int.random(in: (pickerDataSize/2 - 5)...(pickerDataSize/2) + 4)
        
        wheel3.selectRow(position, inComponent: 0, animated: true)
        wheel3.showsSelectionIndicator = true
    }
}
