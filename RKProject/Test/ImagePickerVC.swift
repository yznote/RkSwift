//
//  ImagePickerVC.swift
//  RKProject
//
//  Created by yunbao02 on 2025/2/13.
//

import FlexLayout
import UIKit
import YPImagePicker

// MARK: View -

class IpView: UIView {
    var rootView = UIView()
    var btnEvent: (() -> Void)?

    init() {
        super.init(frame: CGRectZero)

        addSubview(rootView)

        //
        let btn = UIButton(type: .custom)
        btn.layer.cornerRadius = 5
        btn.layer.masksToBounds = true
        btn.setTitleColor(.hex("#ff0000"), for: .normal)
        btn.setTitle("test", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 15)
        btn.addTarget(self, action: #selector(clickBtn), for: .touchUpInside)

        rootView.flex.alignItems(.center).define { flex in
            flex.addItem(btn).border(1, .hex("#ff0000")).paddingHorizontal(10).marginTop(50)
        }
    }

    @objc func clickBtn() {
        if let btnEvent = btnEvent {
            btnEvent()
        }
    }

    func layout() {
        rootView.pin.top(rkNaviHeight).left().right().bottom()
        rootView.flex.layout()
    }

    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: ViewController -

class ImagePickerVC: RKBaseVC {
    private var rootView: IpView {
        return view as! IpView
    }

    override func loadView() {
        view = IpView()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        rootView.layoutIfNeeded()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        rootView.btnEvent = { [self] in
            ts1()
        }
    }

    func ts1() {
        // let coloredImage = UIImage(color: .red, size: CGSizeMake(rkScreenWidth, rkNaviContentHeight))
        // UINavigationBar.appearance().setBackgroundImage(coloredImage, for: UIBarMetrics.default)

        var config = YPImagePickerConfiguration()
        config.screens = [.library, .video, .photo]

        config.wordings.ok = "好了"
        config.wordings.next = "下下下"
        config.wordings.cancel = "cccc"

        let picker = YPImagePicker(configuration: config)
        picker.didFinishPicking { [unowned picker] items, _ in
            if let video = items.singleVideo {
                print(video.fromCamera)
                print(video.thumbnail)
                print(video.url)
            }
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
    }
}
