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
    //Controller
    let controller = InputController()

    override func viewDidLoad() {
        super.viewDidLoad()
        //output from controller to the label showing how much was spent
        controller.spentLabelTextOutput.bind(to: spentLabel.rx.text).disposed(by: disposeBag)
        //output from contoller to show the input buttons as collection view
        controller.collectionViewArrayOutput.bind(to: self.inputCollectionView.rx.items(cellIdentifier: "cell" , cellType: InputCell.self), curriedArgument:  { row, data, cell in cell.label.text = data }).disposed(by: disposeBag)
        //Flash cell to show selection
        inputCollectionView.rx.itemSelected.subscribe(onNext: { (indexPath) in
            let cell = self.inputCollectionView.cellForItem(at: indexPath)
            DispatchQueue.main.async {
                cell?.backgroundColor = UIColor.green
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    cell?.backgroundColor = UIColor.red
                }
            }
        }).disposed(by: disposeBag)
        //send clicks on collection view to the contoller
        inputCollectionView.rx.itemSelected.map{indexPath -> Int in return indexPath.item}.bind(to: controller.spentLabelSelectedInput).disposed(by: disposeBag)
        //request contoller to send current data
        controller.send()
    }
}



