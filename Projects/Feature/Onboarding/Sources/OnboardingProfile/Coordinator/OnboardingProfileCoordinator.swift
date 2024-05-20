//
//  OnboardingProfileCoordinator.swift
//  FeatureOnboardingInterface
//
//  Created by 윤지호 on 12/31/23.
//

import UIKit
import PhotosUI
import Mantis
import Shared
import SharedDesignSystem
import FeatureOnboardingInterface

public final class OnboardingProfileCoordinator: BaseCoordinator {
  public override var type: CoordinatorType {
    .onboarding(.profileUpdate(.profiles))
  }
  
  private let dependencyProvider: FeatureOnboardingDependencyProvider
  
  public init(navigationController: CustomNavigationController, dependencyProvider: FeatureOnboardingDependencyProvider) {
    self.dependencyProvider = dependencyProvider
    super.init(navigationController: navigationController)
  }
  
  public override func start() {
    let onboardingProfileReactor = OnboardingProfileReactor(
      saveProfileDataUseCase: dependencyProvider.makeSaveProfileDataUseCase(),
      getInterestsUseCase: dependencyProvider.makeGetAllInterestsUseCase(),
      profileType: .gender, 
      profileData: .init(nickName: dependencyProvider.makeGetProfileDataUseCase().execute().nickname ?? "", gender: .none, birth: nil, interest: [], mbti: .init())
    )
    let onboardingProfileController = OnboardingProfileController(reactor: onboardingProfileReactor)
    onboardingProfileController.delegate = self
    navigationController.pushViewController(onboardingProfileController, animated: true)
  }
  
  deinit {
    print("해제됨: Profile Coordinator")
  }
}

extension OnboardingProfileCoordinator: OnboardingProfileDelegate {
  public func pushToNextView(_ state: OnboardingProfileReactor.State) {
    let profileType: EditProfileType = state.viewState.nextViewType
    let profileData: ProfileState = state.profileData
    
    let onboardingProfileReator = OnboardingProfileReactor(
      saveProfileDataUseCase: dependencyProvider.makeSaveProfileDataUseCase(),
      getInterestsUseCase: dependencyProvider.makeGetAllInterestsUseCase(),
      profileType: profileType, 
      profileData: profileData
    )
    let onboardingProfileController = OnboardingProfileController(reactor: onboardingProfileReator)
    
    onboardingProfileController.delegate = self
    
    navigationController.pushViewController(onboardingProfileController, animated: true)
  }
  
  public func presentImageGuideModal() {
    let onboardingImageGuideContoller = OnboardingImageGuideController(reactor: OnboardingImageGuideReactor())

    onboardingImageGuideContoller.modalPresentationStyle = .pageSheet
    onboardingImageGuideContoller.delegate = self
    
    navigationController.present(onboardingImageGuideContoller, animated: true)
  }
  
  public func switchToMainTab() {
    appFlowControl.delegete?.showMainFlow()
  }
}

extension OnboardingProfileCoordinator: OnboardingImageGuideDelegate, PHPickerViewControllerDelegate {
  public func pushToImagePicker() {
    var configuration = PHPickerConfiguration()
    configuration.selectionLimit = 1
    configuration.filter = .any(of: [.images])
    
    let picker = PHPickerViewController(configuration: configuration)
    picker.delegate = self
    
    navigationController.present(picker, animated: true)
  }
    
  public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
    picker.dismiss(animated: true)
    
    let itemProvider = results.first?.itemProvider
    
    if let itemProvider = itemProvider,
       itemProvider.canLoadObject(ofClass: UIImage.self) {
      itemProvider.loadObject(ofClass: UIImage.self) { image, error in
        if let image = image as? UIImage {
          DispatchQueue.main.async {
            var config = Mantis.Config()
            config.cropViewConfig.showAttachedRotationControlView = false
            config.cropToolbarConfig.toolbarButtonOptions = []
            config.presetFixedRatioType = .alwaysUsingOnePresetFixedRatio(ratio: 1 / 1)
            let cropViewController = Mantis.cropViewController(
              image: image,
              config: config
            )
            cropViewController.delegate = self
            
            self.navigationController.present(cropViewController, animated: true)
          }
        }
      }
    }
  }
}

extension OnboardingProfileCoordinator: CropViewControllerDelegate {
  public func cropViewControllerDidCrop(_ cropViewController: Mantis.CropViewController, cropped: UIImage, transformation: Mantis.Transformation, cropInfo: Mantis.CropInfo) {
    DispatchQueue.main.async {
      let vcCount = self.navigationController.viewControllers.count
      if let vc = self.navigationController.viewControllers[vcCount - 1] as? OnboardingProfileController {
        vc.reactor?.action.onNext(.selectImage(cropped))
      }
      self.navigationController.dismiss(animated: true)

    }
  }
  
  public func cropViewControllerDidCancel(_ cropViewController: Mantis.CropViewController, original: UIImage) {
    DispatchQueue.main.async {
      self.navigationController.dismiss(animated: true)
    }
  }
}
