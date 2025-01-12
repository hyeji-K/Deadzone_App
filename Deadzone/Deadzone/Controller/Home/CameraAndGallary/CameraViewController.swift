//
//  CameraViewController.swift
//  Deadzone
//
//  Created by heyji on 2024/04/29.
//

import UIKit
import AVFoundation
import Photos

final class CameraViewController: UIViewController {
    
    private let cameraButtonView = CameraButtonView()
    
    let captureSession = AVCaptureSession()
    
    var backFacingCamera: AVCaptureDevice!
    var frontFacingCamera: AVCaptureDevice!
    var currentDevice: AVCaptureDevice!
    var currentDeviceInput: AVCaptureInput!
    
    var stillImageOutput: AVCapturePhotoOutput!
    var stillImage: UIImage?
    
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer!
    
    var isPhotoLibraryReadWriteAccessGranted: Bool {
        get async {
            let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
            var isAuthorized = status == .authorized
            
            if status == .notDetermined {
                isAuthorized = await PHPhotoLibrary.requestAuthorization(for: .readWrite) == .authorized
            }
            
            return isAuthorized
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupView()
        requestCameraAuthorization()
//        configure()
        
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchCamera))
        self.view.addGestureRecognizer(pinch)
    }
    
    private func setupNavigationBar() {
        self.navigationItem.leftBarButtonItem =  UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeButtonTapped))
        self.navigationController?.navigationBar.tintColor = DZColor.backgroundColor
    }
    
    private func setupView() {
        self.view.backgroundColor = .black
        self.view.addSubview(cameraButtonView)
        cameraButtonView.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(100)
        }
        
        cameraButtonView.albumButton.addTarget(self, action: #selector(albumButtonTapped), for: .touchUpInside)
        cameraButtonView.cameraButton.addTarget(self, action: #selector(cameraButtonTapped), for: .touchUpInside)
        cameraButtonView.reversalButton.addTarget(self, action: #selector(switchCameraButtonTapped), for: .touchUpInside)
    }
    
    private func configure() {
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
        
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            backFacingCamera = device
        } else {
            fatalError("후면 카메라가 없어요.")
        }
        
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) {
            frontFacingCamera = device
        } else {
            fatalError("전면 카메라가 없어요.")
        }
        
        // 초기 후면 카메라로 인풋설정
        currentDevice = backFacingCamera
        guard let backCameraDeviceInput = try? AVCaptureDeviceInput(device: currentDevice) else { return }
        currentDeviceInput = backCameraDeviceInput
        captureSession.addInput(backCameraDeviceInput)
        
        stillImageOutput = AVCapturePhotoOutput()
        captureSession.addOutput(stillImageOutput)
        
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.addSublayer(cameraPreviewLayer!)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraPreviewLayer?.frame = view.layer.frame
        
        view.bringSubviewToFront(cameraButtonView)
        
        self.captureSession.startRunning()
    }

    @objc private func closeButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @objc private func cameraButtonTapped(_ sender: UIButton) {
        let photoSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        photoSettings.isHighResolutionPhotoEnabled = true
//        photoSettings.flashMode = .auto
        
        stillImageOutput.isHighResolutionCaptureEnabled = true
        stillImageOutput.capturePhoto(with: photoSettings, delegate: self)
    }
    
    @objc private func switchCameraButtonTapped(_ sender: UIButton) {
        self.cameraButtonView.reversalButton.isUserInteractionEnabled = false
        
        captureSession.beginConfiguration()
        if currentDevice == backFacingCamera {
            captureSession.removeInput(currentDeviceInput)
            currentDevice = frontFacingCamera
            guard let frontCameraDeviceInput = try? AVCaptureDeviceInput(device: currentDevice) else { return }
            currentDeviceInput = frontCameraDeviceInput
            captureSession.addInput(frontCameraDeviceInput)
        } else {
            captureSession.removeInput(currentDeviceInput)
            currentDevice = backFacingCamera
            guard let backCameraDeviceInput = try? AVCaptureDeviceInput(device: currentDevice) else { return }
            currentDeviceInput = backCameraDeviceInput
            captureSession.addInput(backCameraDeviceInput)
        }
        captureSession.commitConfiguration()
        
        self.cameraButtonView.reversalButton.isUserInteractionEnabled = true
    }
    
    @objc private func albumButtonTapped(_ sender: UIButton) {
        // 갤러리에 대한 접근 권한 얻기
        // 사용자 갤러리에 읽고 쓸 수 있는 .readWrite와 삭제가 불가능한 .addOnly가 있습니다
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        switch status {
        case .notDetermined, .limited:
            print("1")
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                switch status {
                case .authorized, .limited:
                    print("권한이 부여 됬습니다. 앨범 사용이 가능합니다")
                    DispatchQueue.main.async {
                        let gallaryViewContoller = GallaryViewController()
                        gallaryViewContoller.modalPresentationStyle = .fullScreen
                        self.present(gallaryViewContoller, animated: false) {
                            self.navigationController?.popToRootViewController(animated: false)
                        }                        
                    }
                case .denied:
                    print("권한이 거부 됬습니다. 앨범 사용 불가합니다.")
                    DispatchQueue.main.async {
                        self.moveToSetting(message: "앨범 접근이 거부 되었습니다. 앱의 일부 기능을 사용할 수 없어요")
                    }
                default:
                    print("그 밖의 권한이 부여 되었습니다.")
                }
            }
        case .restricted:
            print("2")
        case .denied:
            print("3")
            DispatchQueue.main.async {
                self.moveToSetting(message: "앨범 접근이 거부 되었습니다. 앱의 일부 기능을 사용할 수 없어요")
            }
        case .authorized:
            print("4")
            let gallaryViewContoller = GallaryViewController()
            gallaryViewContoller.modalPresentationStyle = .fullScreen
            self.present(gallaryViewContoller, animated: false) {
                self.navigationController?.popToRootViewController(animated: false)
            }
        @unknown default:
            fatalError()
        }
        
    }

    private func moveToSetting(message: String) {
        let alertController = UIAlertController(title: "권한 거부됨", message: message, preferredStyle: UIAlertController.Style.alert)
        
        let okAction = UIAlertAction(title: "권한 설정으로 이동하기", style: .default) { (action) in
            
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)")
                })
            }
        }
        let cancelAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: false, completion: nil)
    }
    
    private func requestCameraAuthorization() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { result in
                switch result {
                case true:
                    DispatchQueue.main.async {
                        self.configure()
                    }
                case false:
                    print("권한이 거부되었습니다.")
                }
            }
        case .authorized:
            print("권한이 부여됐습니다.")
            configure()
        case .denied:
            AVCaptureDevice.requestAccess(for: .video) { result in
                switch result {
                case true:
                    print("권한이 부여됐습니다.")
                case false:
                    DispatchQueue.main.async {
                        self.moveToSetting(message: "카메라 접근이 거부 되었습니다. 앱의 일부 기능을 사용할 수 없어요")
                    }
                }
            }
        case .restricted:
            print("3")
        @unknown default:
            fatalError()
        }   
    }
    
    @objc private func handlePinchCamera(_ pinch: UIPinchGestureRecognizer) {
        guard let device = backFacingCamera else { return }
        
        var initialScale: CGFloat = device.videoZoomFactor
        let minAvailableZoomScale = 1.0
        let maxAvailableZoomScale = 4.0 // device.maxAvailableVideoZoomFactor
        
        do {
            try device.lockForConfiguration()
            if pinch.state == UIPinchGestureRecognizer.State.began {
                initialScale = device.videoZoomFactor
                cameraButtonView.zoomSlider.value = Float(initialScale)
            } else {
                if initialScale * pinch.scale < minAvailableZoomScale {
                    device.videoZoomFactor = minAvailableZoomScale
                    cameraButtonView.zoomSlider.value = Float(minAvailableZoomScale)
                } else if initialScale * pinch.scale > maxAvailableZoomScale {
                    device.videoZoomFactor = maxAvailableZoomScale
                    cameraButtonView.zoomSlider.value = Float(maxAvailableZoomScale)
                } else {
                    device.videoZoomFactor = initialScale * pinch.scale
                    cameraButtonView.zoomSlider.value = Float(initialScale * pinch.scale)
                }
            }
            pinch.scale = 1.0
            
        } catch {
            return
        }
        
        device.unlockForConfiguration()
    }
}

extension CameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        if let error {
            print("Error processing photo: \(error.localizedDescription)")
            return
        }
        
        Task {
            await save(photo: photo)
        }
        
        guard let imageData = photo.fileDataRepresentation() else {
            return
        }
        
        stillImage = UIImage(data: imageData)
        
        let photoViewController = PhotoViewController()
        photoViewController.photoImageView = stillImage
        self.navigationController?.pushViewController(photoViewController, animated: false)
    }
    
    // MARK: 갤러리에 사진 저장
    func save(photo: AVCapturePhoto) async {
        guard await isPhotoLibraryReadWriteAccessGranted else { return }
        
        if let photoData = photo.fileDataRepresentation() {
            PHPhotoLibrary.shared().performChanges {
                let creationRequest = PHAssetCreationRequest.forAsset()
                creationRequest.addResource(with: .photo, data: photoData, options: nil)
            } completionHandler: { success, error in
                if let error {
                    print("Error saving photo: \(error.localizedDescription)")
                    return
                }
            }
        }
    }
}
