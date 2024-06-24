//
//  WLNoteController.swift
//  DuKu
//
//  Created by 李伟 on 2024/6/24.
//

import UIKit

class WLNoteController: WLReadBaseController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }

    override func addChildViews() {
        super.addChildViews()
    }
    
}
