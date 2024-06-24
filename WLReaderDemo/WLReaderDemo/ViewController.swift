//
//  ViewController.swift
//  WLReaderDemo
//
//  Created by 李伟 on 2024/6/2.
//

import UIKit
import SnapKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    private var listView:UITableView!
    private var files:[String]!
//    private var listData:[DKBookListItem]! = [DKBookListItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let extensions = ["epub", "txt"]
        files = getResourceFiles(withExtensions: extensions)
        
        listView = UITableView(frame: self.view.bounds, style: .plain)
        listView.delegate = self
        listView.dataSource = self
        view.addSubview(listView)
        
        setupViewModel()
    }
    private func setupViewModel() {
//        viewModel.requestBookList(page: 1, 10) { [weak self] model in
//            if let items = model?.list {
//                self?.listData.append(contentsOf: items)
//                self?.listView.reloadData()
//            }
//        }
//        viewModel.requestBookDetail(bookId: "819634022467506176") { detailModel in
//            print(detailModel)
//        }
    }
    // 获取应用程序包中的资源文件列表
    func getResourceFiles(withExtensions extensions: [String]) -> [String] {
        var resourceFiles: [String] = []
        // 获取应用程序包的资源路径
        if let resourcePath = Bundle.main.resourcePath {
            let fileManager = FileManager.default
            do {
                // 遍历资源目录中的所有文件
                let files = try fileManager.contentsOfDirectory(atPath: resourcePath)
                for file in files {
                    // 检查文件扩展名是否在指定范围内
                    let fileExtension = (file as NSString).pathExtension.lowercased()
                    if extensions.contains(fileExtension) {
                        resourceFiles.append(file)
                    }
                }
            } catch {
                print("Error reading contents of directory: \(error.localizedDescription)")
            }
        }
        
        return resourceFiles
    }
    
    @objc private func fastRead() {
        let path = Bundle.main.path(forResource: "APP-202402-母亲和我-0902", ofType: "epub")
        let read = WLReadContainer()
        read.bookPath = path
//        let url = "https://sanguo.5000yan.com/xiazai/%E4%B8%89%E5%9B%BD%E6%BC%94%E4%B9%89.epub"
//        read.bookPath = url
        self.navigationController?.pushViewController(read, animated: true)
        
    }
}

extension ViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return files.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "")
        }
        cell?.textLabel?.text = files[indexPath.row]
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        viewModel.requestBookDetail(bookId: "819634022467506176") { [weak self] detailModel in
//            guard let s = self else {return}
//            let read = WLReadContainer()
//            read.bookPath = detailModel?.fileLink
//            s.navigationController?.pushViewController(read, animated: true)
//        }
        let file = files[indexPath.row]
        let path = Bundle.main.path(forResource: file, ofType: nil)
        let read = WLReadContainer()
        read.bookPath = path
//        let url = "https://sanguo.5000yan.com/xiazai/%E4%B8%89%E5%9B%BD%E6%BC%94%E4%B9%89.epub"
//        read.bookPath = url
        self.navigationController?.pushViewController(read, animated: true)
    }
}
