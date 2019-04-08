//
//  ScoreViewController.swift
//  Math_Tables
//
//  Created by Lê Trần Trọng Tín on 3/20/19.
//  Copyright © 2019 Lê Trần Trọng Tín. All rights reserved.
//

import UIKit

class ScoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var goldView: UIView!
    @IBOutlet weak var silverView: UIView!
    @IBOutlet weak var bronzeView: UIView!
    @IBOutlet weak var lbGold: UILabel!
    @IBOutlet weak var lbSilver: UILabel!
    @IBOutlet weak var lbBronze: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    let scoreSheet = UserDefaults.standard
    var scoreDict: [String : Int] = [:]
    var dateStringList: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        goldView.layer.cornerRadius = 20
        silverView.layer.cornerRadius = 20
        bronzeView.layer.cornerRadius = 20
        
        tableView.delegate = self
        tableView.dataSource = self
        let nib = UINib(nibName: "ScoreTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        
        self.configData()
    }
    
    private func configData() {
        
        let goldCount = scoreSheet.integer(forKey: Constant.KeyUserDefaults.goldCount)
        let silverCount = scoreSheet.integer(forKey: Constant.KeyUserDefaults.silverCount)
        let bronzeCount = scoreSheet.integer(forKey: Constant.KeyUserDefaults.bronzeCount)
        
        self.lbGold.text = "\(goldCount)"
        self.lbSilver.text = "\(silverCount)"
        self.lbBronze.text = "\(bronzeCount)"
        
        self.scoreDict = scoreSheet.value(forKey: Constant.KeyUserDefaults.highScore) as! [String : Int]
        for (dateString, _) in scoreDict {
            self.dateStringList.append(dateString)
        }
    }

    @IBAction func btnHome(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dateStringList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ScoreTableViewCell
        cell.dateLabel.text = self.dateStringList[indexPath.row]
        cell.scoreLabel.text = "\(self.scoreDict[self.dateStringList[indexPath.row]]!)"
        return cell
    }
}
