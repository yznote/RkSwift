//
//  TzImagePickerController.swift
//  RKProject
//
//  Created by yunbao02 on 2025/6/19.
//

import FlexLayout
import PinLayout
import TZImagePickerController
import UIKit

class TzImagePickerController: RKBaseVC {
    var rootView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()

        let takeBtn = createBtn()
        takeBtn.addTarget(self, action: #selector(clickTake), for: .touchUpInside)
        let albumBtn = createBtn()
        albumBtn.addTarget(self, action: #selector(clickAlbum), for: .touchUpInside)

        rootView.flex.direction(.row).justifyContent(.center).alignItems(.center).define { flex in
            flex.addItem(takeBtn).width(60).height(30)
            flex.addItem(albumBtn).width(60).height(30).marginLeft(20)
        }
        view.addSubview(rootView)
    }

    // 创建
    func createBtn() -> UIButton {
        let btn = UIButton(type: .custom)
        btn.layer.cornerRadius = 10
        btn.layer.masksToBounds = true
        btn.backgroundColor = .hex("#ff000", 0.3)
        return btn
    }

    // 布局
    func layout() {
        rootView.pin.top(rkNaviHeight + 60).right().width(100%)
        rootView.flex.layout(mode: .adjustHeight)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        layout()
    }
}

// MARK: - 相机
import MobileCoreServices
import UniformTypeIdentifiers

// event
extension TzImagePickerController {
    @objc func clickTake() {
        let picker = UIImagePickerController()
        picker.delegate = self
        if #available(iOS 15, *) {
            picker.mediaTypes = [UTType.movie.identifier, UTType.image.identifier]
        } else {
            picker.mediaTypes = [kUTTypeMovie as String, kUTTypeImage as String]
        }
        picker.sourceType = .camera
        UIApplication.shared.present(picker, animated: true)
    }
}

// delegate
extension TzImagePickerController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)
        // debug.log("==>sel", info)
        let type = info[UIImagePickerController.InfoKey.mediaType] as? String
        if type == "public.image" {
            let selImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            if let selImage = selImage {
                debug.log("selected image:", selImage)
                // TODO: 可以执行上传云存储[图片]

                /// 截止此步骤之前，图片是未存储的
                let meta = info[UIImagePickerController.InfoKey.mediaMetadata] as? [AnyHashable: Any]
                TZImageManager.default().savePhoto(with: selImage, meta: meta, location: nil) { asset, error in
                    debug.log("save iamge: ", error ?? "save success")
                    if let asset = asset {
                        debug.log("image size: \(asset.pixelWidth),\(asset.pixelHeight)")
                    }
                }

            } else {
                debug.log("selected image none")
            }
        } else if type == "public.movie" {
            let videoUrl = info[UIImagePickerController.InfoKey.mediaURL] as? URL
            if let videoUrl = videoUrl {
                TZImageManager.default().saveVideo(with: videoUrl) { [self] phasset, error in
                    if let error = error {
                        debug.log("save video error:", error)
                        return
                    }
                    if let phasset = phasset {
                        let tzAssetModel = TZImageManager.default().createModel(with: phasset)
                        debug.log("video info: \(tzAssetModel?.timeLength ?? "no-time")")
                        // 获取封面
                        TZImageManager.default().getPhotoWith(phasset) { coverImage, info, isDegraded in
                            debug.log("take video cover image: ", coverImage ?? 999)
                            // TODO: 可以执行上传云存储[图片]
                        }
                        // 视频路径
                        getVideoOutpath(asset: phasset)
                    } else {
                        debug.log("save video error no, but asset non-existent")
                    }
                }
            } else {
                debug.log("selected video none")
            }
        }
    }
}

// MARK: - 相册
// event
extension TzImagePickerController {
    @objc func clickAlbum() {
        let picker = TZImagePickerController(maxImagesCount: 1, delegate: self)!
        UIApplication.shared.present(picker, animated: true)
    }

    func getVideoOutpath(asset: PHAsset) {
        debug.log("video lenght:", asset.duration)
        debug.log("video size: \(asset.pixelWidth),\(asset.pixelHeight)")
        TZImageManager.default().getVideoOutputPath(with: asset, presetName: AVAssetExportPresetLowQuality) { outpath in
            debug.log("video ouput success, path:", outpath ?? "oh no")
            // TODO: 可以执行上传云存储[视频]
        } failure: { errMsg, error in
            debug.log("video output error", errMsg ?? "oh no", error ?? 999)
        }
    }
}

// delegate
extension TzImagePickerController: TZImagePickerControllerDelegate {
    //
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool) {
        let selImage = photos[0]
        debug.log("selected image:", selImage)
        debug.log("image img.size", selImage.size)
        // TODO: 可以执行上传云存储[图片]
        // asset
        let phAssets = assets as? [PHAsset]
        if let phAssets = phAssets {
            for asset in phAssets {
                debug.log("selected image size: \(asset.pixelWidth),\(asset.pixelHeight)")
                debug.log("scale:\(UIScreen.main.scale)")
            }
        }
    }

    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingVideo coverImage: UIImage!, sourceAssets asset: PHAsset!) {
        // 封面
        debug.log("video cover image: ", coverImage ?? 999)
        debug.log("cover image img.size", coverImage.size)
        debug.log("cover image size: \(asset.pixelWidth),\(asset.pixelHeight)")
        debug.log("scale:\(UIScreen.main.scale)")
        // TODO: 可以执行上传云存储[图片]
        // 视频路径
        getVideoOutpath(asset: asset)
    }
}
