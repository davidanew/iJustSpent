//
//  ViewController.swift
//  iJustSpent
//
//  Created by David New on 18/04/2019.
//  Copyright © 2019 David New. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class HistoryView: UIViewController {
    
    @IBOutlet weak var historyTableView: UITableView!
    private let disposeBag = DisposeBag()
    let controller = HistoryController()


    override func viewDidLoad() {
        super.viewDidLoad()
        controller.historyDataOutput.bind(to: historyTableView.rx.items(cellIdentifier: "Cell")) { row, model, cell in
            cell.textLabel?.text = "\(model.date)"
            cell.detailTextLabel?.text = "\(model.total)"
            }.disposed(by: disposeBag)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        controller.send()
    }
  

   

}
