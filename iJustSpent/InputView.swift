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
    //
    let controller = InputController()

    override func viewDidLoad() {
        super.viewDidLoad()
        //
        controller.spentLabelTextOutput.bind(to: spentLabel.rx.text).disposed(by: disposeBag)
        //
        controller.collectionViewArrayOutput.bind(to: self.inputCollectionView.rx.items(cellIdentifier: "cell" , cellType: InputCell.self), curriedArgument:  { row, data, cell in cell.label.text = data }).disposed(by: disposeBag)
        //
        inputCollectionView.rx.itemSelected.subscribe(onNext: { (indexPath) in
            let cell = self.inputCollectionView.cellForItem(at: indexPath)
            //Flash cell to show selection
            //TODO: should go to main thread
            cell?.backgroundColor = UIColor.green
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                cell?.backgroundColor = UIColor.red
            }
        }).disposed(by: disposeBag)
        //
        inputCollectionView.rx.itemSelected.map{indexPath -> Int in return indexPath.item}.bind(to: controller.spentLabelSelectedInput).disposed(by: disposeBag)
        //
        controller.send()
    }
}



