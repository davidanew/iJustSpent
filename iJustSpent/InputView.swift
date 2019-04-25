//  Copyright © 2019 David New. All rights reserved.

import UIKit
import RxSwift
import RxCocoa

class InputView: UIViewController {
    
    let disposeBag = DisposeBag()
    //Label to show running total
    @IBOutlet weak var spentLabel: UILabel!
    //Collection view showing input spend options
    @IBOutlet weak var inputCollectionView: UICollectionView!
    
    let controller = InputController()
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        controller.spentLabelTextOutput.bind(to: spentLabel.rx.text).disposed(by: disposeBag)
        
        //controller.collectionViewInput.bind(to: self.inputCollectionView.rx.items(cellIdentifier: "cell" , cellType: InputCell.self)) { row, data, cell in cell.label.text = data }.disposed(by: disposeBag)
        controller.collectionViewArrayOutput.bind(to: self.inputCollectionView.rx.items(cellIdentifier: "cell" , cellType: InputCell.self), curriedArgument:  { row, data, cell in cell.label.text = data }).disposed(by: disposeBag)
        
        
        //Observable.just(["1"]).bind(to: self.inputCollectionView.rx.items(cellIdentifier: "cell" , cellType: InputCell.self), curriedArgument:  { row, data, cell in cell.label.text = data }).disposed(by: disposeBag)
        
        
        
        
        
        
        //Actions for if collection view cell is selected
        inputCollectionView.rx.itemSelected.subscribe(onNext: { (indexPath) in
            let cell = self.inputCollectionView.cellForItem(at: indexPath)
            //Flash cell to show selection
            //TODO: should go to main thread
            cell?.backgroundColor = UIColor.green
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                cell?.backgroundColor = UIColor.red
            }
            // Retieve the spend value associated with this cell
            //let thisSpend = self.spendValues[indexPath.item]
            // Add this spending. Result will propogate back through observables
            //self.dataStore.addspend(thisSpend: thisSpend)
        }).disposed(by: disposeBag)
        
        
        inputCollectionView.rx.itemSelected.map{indexPath -> Int in return indexPath.item}.bind(to: controller.spentLabelSelectedInput).disposed(by: disposeBag)
        
        
        
        //inputCollectionView.rx.itemSelected.map{(indexpath) -> UIColor in return UIColor.green}.bind(to: self.inputCollectionView.rx.item, curriedArgument: <#T##R1#>)
        //controller.collectionViewArrayOutput.subscribe(onNext: {print($0)})
        
        //Observable.just(UIColor.green).bind(to: self.inputCollectionView.rx.)
        
        controller.doBindings()
        

      
        
    }
}



