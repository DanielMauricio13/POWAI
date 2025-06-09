import SwiftUI
import AVFoundation

struct BarcodeScannerView: UIViewControllerRepresentable {
    var onCancel: () -> Void
    var completion: (String) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(onCancel: onCancel, completion: completion)
    }

    func makeUIViewController(context: Context) -> ScannerViewController {
        let controller = ScannerViewController()
        controller.delegate = context.coordinator
        controller.cancelAction = { context.coordinator.cancel() }
        context.coordinator.controller = controller
        return controller
    }

    func updateUIViewController(_ uiViewController: ScannerViewController, context: Context) { }

    class Coordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {
        var completion: (String) -> Void
        var onCancel: () -> Void
        weak var controller: ScannerViewController?
        private var lastScanDate: Date?
        private let cooldown: TimeInterval = 10

        init(onCancel: @escaping () -> Void, completion: @escaping (String) -> Void) {
            self.onCancel = onCancel
            self.completion = completion
        }

        func cancel() {
            controller?.captureSession.stopRunning()
            DispatchQueue.main.async { [onCancel] in
                onCancel()
            }
        }

        func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
            guard Date().timeIntervalSince(lastScanDate ?? .distantPast) >= cooldown else { return }
            lastScanDate = Date()
            if let obj = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
               let code = obj.stringValue {
                controller?.captureSession.stopRunning()
                output.setMetadataObjectsDelegate(nil, queue: nil)
                DispatchQueue.main.async { [completion] in
                    completion(code)
                }
            }
        }
    }
}

class ScannerViewController: UIViewController {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    weak var delegate: AVCaptureMetadataOutputObjectsDelegate?
    var cancelAction: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        captureSession = AVCaptureSession()
        guard let videoDevice = AVCaptureDevice.default(for: .video),
              let videoInput = try? AVCaptureDeviceInput(device: videoDevice) else { return }
        if captureSession.canAddInput(videoInput) { captureSession.addInput(videoInput) }
        let metadataOutput = AVCaptureMetadataOutput()
        if captureSession.canAddOutput(metadataOutput) { captureSession.addOutput(metadataOutput) }
        metadataOutput.setMetadataObjectsDelegate(delegate, queue: DispatchQueue.main)
        metadataOutput.metadataObjectTypes = [.ean8, .ean13, .upce, .code128]
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        let cancelButton = UIButton(type: .system)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(.white, for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        view.addSubview(cancelButton)
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.captureSession.startRunning()
        }
    }

    @objc private func cancelTapped() {
        cancelAction?()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if captureSession?.isRunning == true {
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                self?.captureSession.stopRunning()
            }
        }
    }
}
