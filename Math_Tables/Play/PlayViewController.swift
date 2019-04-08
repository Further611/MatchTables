//
//  PlayViewController.swift
//  Math_Tables
//
//  Created by Lê Trần Trọng Tín on 2/26/19.
//  Copyright © 2019 Lê Trần Trọng Tín. All rights reserved.
//

import UIKit
import AVFoundation
import SCLAlertView

class PlayViewController: UIViewController {
    
    @IBOutlet weak var lbQuestion: UILabel!
    @IBOutlet weak var lbScore: UILabel!
    @IBOutlet weak var lbWrong: UILabel!
    @IBOutlet weak var lbTrueResult: UILabel!
    @IBOutlet weak var lbMessage: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lbMultiplier: UILabel!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var questionView: UIView!
    fileprivate var panGestureForCV: UIPanGestureRecognizer!
    
    var bombSoundEffect: AVAudioPlayer!
    var number: Int!
    var randomNum =  Array(1...20)
    var multiplierArray = Array(1...10)
    var multi: Int!
    var resultList = [Int]()
    let cvCell = "cvCell"
    var rs: Int!
    var rightNumber = 0
    var wrongNumber = 0
    var numQues = 1
    
    var snapShotView: UIView?
    var selectingResult: String!
    var selectingCell: UIView?
//    let lbResultSize: CGSize

    let spacing = 15
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.clipsToBounds = false
        let nib = UINib(nibName: "ResultCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: cvCell)
        
        panGestureForCV = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(gesture:)))
        collectionView.addGestureRecognizer(panGestureForCV)
        collectionView.dragInteractionEnabled = true
        
        getData()
    }
    
    @objc func handlePanGesture(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            onTouchBegan(gesture: gesture)
        case .changed:
            onTouchChanged(gesture: gesture)
        case .ended:
            onTouchEnded(gesture: gesture)
        default:
            break
        }
    }
    
    func onTouchBegan(gesture: UIPanGestureRecognizer) {
        let panLocation = gesture.location(in: collectionView)
        guard
            let indexPath = collectionView.indexPathForItem(at: panLocation),
            let attr = collectionView.layoutAttributesForItem(at: indexPath),
            let cell = collectionView.cellForItem(at: indexPath) as? ResultCollectionViewCell
            else { return }
        
        let cellSnapShot = cell.makeSnapshot()
        cellSnapShot.frame = collectionView.convert(attr.frame, to: view)
        self.snapShotView = cellSnapShot
        view.addSubview(cellSnapShot)
        
        
        self.selectingResult = cell.lbResult.text
        self.selectingCell = cell
        cell.isHidden = true
    }
    
    func onTouchChanged(gesture: UIPanGestureRecognizer) {
        let panLocation = gesture.location(in: collectionView)
        let panLocationInQuestionView = gesture.location(in: questionView)
        guard
            let snapShotView = snapShotView
            else { return }
        
        let locationInSuperView = collectionView.convert(panLocation, to: view)
        let isInView = questionView.bounds.contains(panLocationInQuestionView)
        snapShotView.center = locationInSuperView
        if isInView {
            questionView.backgroundColor = UIColor.white.withAlphaComponent(0.2)
            questionView.layer.borderWidth = 2
            questionView.layer.borderColor = UIColor.lightGray.cgColor
        } else {
            questionView.backgroundColor = .clear
            questionView.layer.borderWidth = 0
        }
    }
    
    func onTouchEnded(gesture: UIPanGestureRecognizer) {
        let panLocationInQuestionView = gesture.location(in: questionView)
        let isInView = questionView.bounds.contains(panLocationInQuestionView)
        
        guard let snapShotView = self.snapShotView else { return }
        
        if isInView {
            lbTrueResult.text = self.selectingResult
            checkAnswer()
        } else {
            selectingCell?.isHidden = false
        }
        snapShotView.removeFromSuperview()
        self.snapShotView = nil
        self.selectingResult = nil
    }
    
    func getData() {
        questionView.backgroundColor = .clear
        questionView.layer.borderWidth = 0
        
        questionView.layer.cornerRadius = 15
        lbMultiplier.layer.cornerRadius = 15
        lbTrueResult.layer.cornerRadius = 15
        
        lbMessage.layer.cornerRadius = 10
        lbMessage.isHidden = true
        
        btnNext.isHidden = true
        lbTrueResult.text = "???"
        lbQuestion.text = "Q.\(numQues) Guess value"
        lbScore.text = "Score: \(rightNumber)"
        lbWrong.text = "Wrong: \(wrongNumber)"
        
        resultList.removeAll()
        
        let randomIndex = Int.random(in: 0 ..< randomNum.count)
        number = randomNum[randomIndex]
        randomNum.remove(at: randomIndex)
        
        let multiIndex = Int.random(in: 0 ..< multiplierArray.count)
        multi = multiplierArray[multiIndex]
        
        lbMultiplier.text = "\(number!) x \(multi!)"
        
        rs = number * multi
        
        resultList = [rs, rs + 1, rs + 2, rs + number, rs + multi, rs - number ]
        
        resultList.shuffle()
        
        let cells = collectionView.visibleCells as! [ResultCollectionViewCell]
        for cell in cells {
            if cell.isHidden {
                cell.isHidden = false
            }
        }
        collectionView.reloadData()
        collectionView.isUserInteractionEnabled = true
    }
    
    
    
    @IBAction func btnNext(_ sender: Any) {
        numQues += 1
        getData()
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func checkAnswer() {
        if selectingResult == String(rs) {
            rightNumber += 1
            
            
            lbMessage.text = "Correct"
            lbMessage.textColor = #colorLiteral(red: 0, green: 0.9666637778, blue: 0, alpha: 1)
            
            lbScore.text = "Score: \(rightNumber)"
            
            let utterance = AVSpeechUtterance(string: lbTrueResult.text!)
            utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
            
            let synthesizer = AVSpeechSynthesizer()
            synthesizer.speak(utterance)
        } else {
            playSound(soundName: "incorrect", type: "mp3")
            
            wrongNumber += 1
        
            lbMessage.text = "Wrong"
            lbMessage.textColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
            
            lbWrong.text = "Wrong: \(wrongNumber)"
        }
        collectionView.isUserInteractionEnabled = false
        btnNext.isHidden = false
        lbMessage.isHidden = false
        checkEndOfQues()
    }
    
    func checkEndOfQues() {
        if numQues == 10 {
            customAlert(score: self.rightNumber)
            saveScoreData(score: self.rightNumber)
        }
    }
    
    func playSound(soundName: String, type: String) {
        guard let url = Bundle.main.url(forResource: soundName, withExtension: type) else { return }
        bombSoundEffect = try! AVAudioPlayer(contentsOf: url)
        bombSoundEffect.play()
    }
    
    func customAlert(score: Int) {
        var status: String!
        let imgMedalName: String!
        
        switch score {
        case 9...10:
            status = "Great"
            imgMedalName = "gold_ic"
        case 6...8:
            status = "Good"
            imgMedalName = "silver_ic"
        case 3...5:
            status = "Cool"
            imgMedalName = "bronze_ic"
        default:
            status = "Fail"
            imgMedalName = "fail_ic"
        }

        var alertView = SCLAlertView()
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false,
            showCircularIcon: true
        )
        alertView = SCLAlertView(appearance: appearance)
        
        let alertViewIcon = UIImage(named: imgMedalName)
        let subInfo = "Your completed 10 question." + "\nCorrect answer \(score)"
        
        alertView.addButton("Continue", target:self, selector:#selector(handleContinue))
        alertView.addButton("Quit", target:self, selector:#selector(handleQuit))
        alertView.showWarning(status, subTitle: subInfo, circleIconImage: alertViewIcon)
    }
    
    @objc func handleContinue() {
        numQues = 1
        wrongNumber = 0
        rightNumber = 0
        getData()
    }
    
    @objc func handleQuit() {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func saveScoreData(score: Int) {
        let scoreSheet = UserDefaults.standard
        switch score {
        case 9...10:
            if var goldCount = scoreSheet.object(forKey: Constant.KeyUserDefaults.goldCount) as? Int {
                goldCount += 1
                scoreSheet.set(goldCount, forKey: Constant.KeyUserDefaults.goldCount)
            }
            break
            
        case 6...8:
            if var silverCount = scoreSheet.object(forKey: Constant.KeyUserDefaults.silverCount) as? Int {
                silverCount += 1
                scoreSheet.set(silverCount, forKey: Constant.KeyUserDefaults.silverCount)
            }
            break
        case 3...5:
            if var bronzeCount = scoreSheet.object(forKey: Constant.KeyUserDefaults.bronzeCount) as? Int {
                bronzeCount += 1
                scoreSheet.set(bronzeCount, forKey: Constant.KeyUserDefaults.bronzeCount)
            }
            break
        default:
            break
        }
        
        var array = scoreSheet.value(forKey: Constant.KeyUserDefaults.highScore) as? [String : Int]
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let playedDate = formatter.string(from: date)
        
        array![playedDate] = score
        let sortedByValueDictionary = array!.sorted { $0.1 < $1.1 }
        
        array?.removeAll()
        for (key, value) in sortedByValueDictionary {
            array![key] = value
        }
        
        scoreSheet.set(array, forKey: Constant.KeyUserDefaults.highScore)
    }
}

extension PlayViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return resultList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cvCell", for: indexPath) as! ResultCollectionViewCell
        cell.lbResult.backgroundColor = #colorLiteral(red: 1, green: 0.4782996774, blue: 0, alpha: 1)
        cell.lbResult.layer.cornerRadius = 15
        cell.lbResult.text = String(resultList[indexPath.item])
        cell.lbResult.font = UIFont(name: "ChangaOne", size: 40.0)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: lbTrueResult.frame.width, height: lbTrueResult.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(spacing)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(spacing)
    }
}
