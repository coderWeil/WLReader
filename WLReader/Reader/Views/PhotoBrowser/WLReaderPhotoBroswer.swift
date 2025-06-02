//
//  WLReaderPhotoBroswer.swift
//  DuKu
//
//  Created by 李伟 on 2024/6/5.
//  阅读器大图查看

import UIKit

class WLReaderPhotoBroswer: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, WLReaderPhotoCellDelegate {
    public var animationTransition:WLReaderPhotoInteractive?
    public var photos:[WLReaderPhotoModel]?
    public var showPageIndicator:Bool = false
    private var collectionView:UICollectionView?
    private var transitionImageViewCenter:CGPoint?
    private var imageView:UIImageView?
    private var pageIndicator:UILabel?
    private var currentIndex:Int = 0
    private var responsePan:Bool = false
    
//    override var prefersStatusBarHidden: Bool {
//        return true
//    }
    override func loadView() {
        super.loadView()
        imageView = UIImageView()
        imageView!.contentMode = .scaleAspectFill
        self.view.addSubview(imageView!)
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets.zero
        layout.minimumInteritemSpacing = 0
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView!.delegate = self
        collectionView!.dataSource = self
        collectionView!.isPagingEnabled = true
        collectionView!.showsHorizontalScrollIndicator = false
        collectionView!.backgroundView = nil
        collectionView?.register(WLReaderPhotoCell.self, forCellWithReuseIdentifier: "WLReaderPhotoCell")
        view.addSubview(collectionView!)
        pageIndicator = UILabel()
        pageIndicator!.textColor = .white
        pageIndicator!.font = UIFont.systemFont(ofSize: 15)
        pageIndicator!.textAlignment = .center
        view.addSubview(pageIndicator!)
        currentIndex = 0
        let pan = UIPanGestureRecognizer(target: self, action: #selector(onPan(pan:)))
        view.addGestureRecognizer(pan)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        collectionView?.contentInsetAdjustmentBehavior = .never
        collectionView?.frame = CGRect(x: 0, y: 0, width: WL_SCREEN_WIDTH, height: WL_SCREEN_HEIGHT)
        pageIndicator?.frame = CGRectMake(0, view.bounds.height - 30 - 40, view.frame.width, 30)
        pageIndicator?.isHidden = !self.showPageIndicator
        currentIndex = (animationTransition?.transition.transitionIndex)!
        collectionView?.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: .centeredHorizontally, animated: false)
    }
    
    public func reload() {
        collectionView?.reloadData()
        let cur = currentIndex + 1
        pageIndicator?.text = "\(cur) / \(photos!.count)"
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos!.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width + 50.0, height: view.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WLReaderPhotoCell", for: indexPath) as! WLReaderPhotoCell
        cell.model = photos![indexPath.item]
        cell.index = indexPath.item
        cell.delegate = self
        return cell
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        let index = offsetX / (WL_SCREEN_WIDTH + 50.0)
        setupProperty(index: Int(index))
        self.currentIndex = Int(index)
        let cur = currentIndex + 1
        pageIndicator?.text = "\(cur) / \(photos!.count)"
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let indexPath = IndexPath(item: self.currentIndex, section: 0)
        let cell = collectionView?.cellForItem(at: indexPath) as! WLReaderPhotoCell
        cell.zoomImageView?.cancelTapEvent()
    }
    private func setupProperty(index:Int) {
        let indexPath = IndexPath(item: index, section: 0)
        let cell = collectionView?.cellForItem(at: indexPath) as! WLReaderPhotoCell
        animationTransition?.transition.transitionImage = cell.zoomImageView?.zoomImageView.image
        animationTransition?.transition.transitionIndex = index
        imageView?.frame = cell.zoomImageView!.zoomImageView.frame
        imageView?.image = cell.zoomImageView?.zoomImageView.image
        imageView?.isHidden = true
        transitionImageViewCenter = imageView!.center
    }
    @objc private func onPan(pan:UIPanGestureRecognizer) {
        let translation = pan.translation(in: pan.view)
        var scale = 1 - CGFloat(translation.y) / WL_SCREEN_HEIGHT
        scale = scale < 0 ? 0 : scale;
        scale = scale > 1 ? 1 : scale;
        switch (pan.state) {
            case .possible:
                    break;
            case .began:
                    self.responsePan = true
                    setupProperty(index: animationTransition!.transition.transitionIndex!)
                    collectionView?.isHidden = true
                    imageView?.isHidden = false
                    animationTransition?.transition.panGesture = pan
                    animationTransition?.intractivePercent?.panGesture = pan
                    dismiss(animated: true)
                    break;
            case .changed:
                    imageView!.center = CGPointMake(transitionImageViewCenter!.x + translation.x * scale, transitionImageViewCenter!.y + translation.y)
                    imageView!.transform = CGAffineTransformMakeScale(scale, scale)
                    break;
            case .failed, .cancelled, .ended:
                    if (scale > 0.8) {
                        UIView.animate(withDuration: 0.2) {
                            self.imageView!.center = self.transitionImageViewCenter!
                            self.imageView!.transform = CGAffineTransformMakeScale(1, 1)
                        } completion: { _ in
                            self.imageView!.transform = .identity
                        }
                    }
                    self.animationTransition?.transition.transitionImage = self.imageView!.image
                    self.animationTransition?.transition.currentPanGestureFrame = self.imageView!.frame
                    self.animationTransition?.transition.panGesture = nil
                    self.responsePan = false
                    self.collectionView?.isHidden = false
                default:
                    break;
        }
    }
    func didClickImageView(index: Int) {
        if !responsePan {
            dismiss(animated: true)
        }
    }
}
