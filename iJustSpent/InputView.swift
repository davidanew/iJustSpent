
//  Copyright © 2019 David New. All rights reserved.

import UIKit
import RxSwift
import RxCocoa

class InputView: UIViewController {
    
    //Label to show running total
    @IBOutlet weak var spentLabel: UILabel!
    //Collection view showing input spend options
    @IBOutlet weak var inputCollectionView: UICollectionView!
    //The options for spending that are displayed and are clickable
    let spendValuesBase : [Int64] = [1,2,3,4,5,6,7,8,9,10,15,20,25,30,40,50,60,70,80,90,100]
    //TODO: Put these values in user defaults
    //Multiply spend options for different currency
    //Only Int supported at the moment
    let multiplier : Int64 = 1
    let currencySymbol : String = "£"
    //Handles storing and upadating of the spending
    let dataStore = DataStore()
    //Calculate spend options as a number
    var spendValues : [Int64] {
        get {
            return spendValuesBase.map {$0 * multiplier}
        }
    }
    //FIXME: remove intermediate calculation
    var spendLabels : [String] {
        get {
            let spendValues = spendValuesBase.map {$0 * multiplier}
            return spendValues.map {String("\(currencySymbol)\($0)")}
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //Bind changes in totalspending to update spentLabel
        _ = dataStore.totalSpending.map{"Today I spent about: \(self.currencySymbol)\($0)"}.bind(to: spentLabel.rx.text)
        let spendLablesObs = Observable.just(spendLabels)
        //Display collection view of the spend options
        _ = spendLablesObs.asObservable().bind(to: self.inputCollectionView.rx.items(cellIdentifier: "cell" , cellType: InputCell.self)) { row, data, cell in
            cell.label.text = data
        }
        //Actions for if collection view cell is selected
        _ = inputCollectionView.rx.itemSelected.subscribe(onNext: { (indexPath) in
            let cell = self.inputCollectionView.cellForItem(at: indexPath)
            //Flash cell to show selection
            cell?.backgroundColor = UIColor.green
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                cell?.backgroundColor = UIColor.red
            }
            // Retieve the spend value associated with this cell
            let thisSpend = self.spendValues[indexPath.item]
            // Add this spending. Result will propogate back through observables
            self.dataStore.addspend(thisSpend: thisSpend)
        })
    }
}



