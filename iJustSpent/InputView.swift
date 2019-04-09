//
//  ViewController.swift
//  iJustSpent
//
//  Created by David New on 09/04/2019.
//  Copyright © 2019 David New. All rights reserved.
//

import UIKit

class InputView: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var spentLabel: UILabel!
    var totalSpending : Int = 0
    var lastSpend : Int = 0
    let spendValuesBase : [Int] = [1,2,3,4,5,6,7,8,9,10,15,20,25,30,40,50,60,70,80,90,100]
    let multiplier : Int = 1
    let currencySymbol : String = "£"
    var spendValues : [Int] {
        get {
            return spendValuesBase.map {$0 * multiplier}
        }
    }
    var spendLabels : [String] {
        get {
            return spendValues.map {String("\(currencySymbol)\($0)")}
        }
    }
    var spendLabelText : String {
        get {
            return ("Today I spent about: \(currencySymbol)\(totalSpending)")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return spendLabels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //TODO: !
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! InputCell
        cell.label.text = spendLabels[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //    let cell = collectionView.cellForItemAtIndexPath(indexPath) as! MyCell
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = UIColor.green
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            cell?.backgroundColor = UIColor.red

        }
        let thisSpend = spendValues[indexPath.item]
        totalSpending += thisSpend
        lastSpend = thisSpend
        //print(totalSpending)
        spentLabel.text = spendLabelText
    }
}

