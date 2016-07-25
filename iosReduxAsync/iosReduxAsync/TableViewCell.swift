//
//  TableViewCell.swift
//  reduxTest
//
//  Created by Freeman Man on 27/05/2016.
//  Copyright © 2016 LB OPERATIONS PTY LTD. All rights reserved.
//

import UIKit
import RxSwift

class TableViewCell: UITableViewCell {
    
    var dispose: DisposeBag? = DisposeBag()
    
    override func prepareForReuse() {
        dispose = DisposeBag()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
