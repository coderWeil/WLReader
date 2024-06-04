//
//  ViewController.swift
//  WLReaderDemo
//
//  Created by 李伟 on 2024/6/2.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    var btn:UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        btn = UIButton(type: .custom)
        btn.setTitle("阅读", for: .normal)
        btn.setTitleColor(.red, for: .normal)
        btn.addTarget(self, action: #selector(read), for: .touchUpInside)
        view.addSubview(btn)
        btn.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalTo(100)
        }
    }
    
    @objc private func read() {
        let path = Bundle.main.path(forResource: "张学良传", ofType: "epub")
        let read = WLReadContainer()
        read.bookPath = path
        self.navigationController?.pushViewController(read, animated: true)
    }


}

