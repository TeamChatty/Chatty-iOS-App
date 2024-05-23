//
//  ProfileEditMainCoordinator.swift
//  FeatureProfileInterface
//
//  Created by 윤지호 on 3/21/24.
//

import UIKit
import PhotosUI
import Mantis
import Shared
import SharedDesignSystem
import FeatureProfileInterface

public final class ProfileEditMainCoordinator: BaseCoordinator, ProfileEditMainCoordinatorProtocol {
  public override var type: CoordinatorType {
    .profile(.editMain)
  }
  
  private let featureProfileDependencyProvider: FeatureProfileDependencyProvider

  public init(navigationController: CustomNavigationController, featureProfileDependencyProvider: FeatureProfileDependencyProvider) {
    self.featureProfileDependencyProvider = featureProfileDependencyProvider
    super.init(navigationController: navigationController)
  }
  
  deinit {
    print("해제됨: ProfileEditMainCoordinator")
  }
  
  public override func start() {
    let reactor = ProfileEditMainReactor(getUserDataUseCase: featureProfileDependencyProvider.makeGetProfileDataUseCase(), saveProfileImageUseCase: featureProfileDependencyProvider.makeSaveProfileImageUseCase())
    let profileEditMainController = ProfileEditMainController(reactor: reactor)
    profileEditMainController.delegate = self
    navigationController.pushViewController(profileEditMainController, animated: true)
  }
}

extension ProfileEditMainCoordinator: ProfileEditModalDelegate {
  func dismissModal() {
    navigationController.dismiss(animated: true)
  }
  
  func successEdit(editType: ProfileEditType) {
    DispatchQueue.main.async {
      let vcCount = self.navigationController.viewControllers.count
      if let vc = self.navigationController.viewControllers[vcCount - 1] as? ProfileEditMainController {
        vc.reactor?.action.onNext(.editSuccessed(editType))
      }
      self.navigationController.dismiss(animated: true)
    }
  }
}

extension ProfileEditMainCoordinator: ProfileEditMainControllerDelegate {
  func presentImageGuide() {
    let onboardingImageGuideContoller = OnboardingImageGuideController(reactor: OnboardingImageGuideReactor())

    onboardingImageGuideContoller.modalPresentationStyle = .pageSheet
    onboardingImageGuideContoller.delegate = self
    
    navigationController.present(onboardingImageGuideContoller, animated: true)
  }
  
  func presentSelectImage() {
    let onboardingImageGuideContoller = OnboardingImageGuideController(reactor: OnboardingImageGuideReactor())

    onboardingImageGuideContoller.modalPresentationStyle = .pageSheet
    onboardingImageGuideContoller.delegate = self
    
    navigationController.present(onboardingImageGuideContoller, animated: true)
  }

  func presentNickname() {
    let profileEditNicknameModal = ProfileEditNicknameModal(
      reactor: ProfileEditTypeReactor(
        saveProfileNicknameUseCase: featureProfileDependencyProvider.makeSaveProfileNicknameUseCase(),
        getUserDataUseCase: featureProfileDependencyProvider.makeGetProfileDataUseCase()
      )
    )
    
    profileEditNicknameModal.modalPresentationStyle = .pageSheet
    profileEditNicknameModal.delegate = self
    navigationController.present(profileEditNicknameModal, animated: true)
  }
  
  func presentAddress() {
    let profileEditAddressModal = ProfileEditAddressModal(
      reactor: ProfileEditAddressReactor(
        saveSaveAddressUseCase: featureProfileDependencyProvider.makeSaveAddressUseCase(),
        getUserDataUseCase: featureProfileDependencyProvider.makeGetProfileDataUseCase()
      )
    )
    
    profileEditAddressModal.modalPresentationStyle = .pageSheet
    profileEditAddressModal.delegate = self
    navigationController.present(profileEditAddressModal, animated: true)
  }
  
  func presentJob() {
    let profileEditJobModal = ProfileEditJobAndSchoolModal(
      reactor: ProfileEditJobAndSchoolReactor(
        editType: .job,
        getUserDataUseCase: featureProfileDependencyProvider.makeGetProfileDataUseCase(),
        saveSchoolUserCase: featureProfileDependencyProvider.makeSaveSchoolUseCase(),
        saveJobUseCase: featureProfileDependencyProvider.makeSaveJobUseCase()
      )
    )
    
    profileEditJobModal.modalPresentationStyle = .pageSheet
    profileEditJobModal.delegate = self
    navigationController.present(profileEditJobModal, animated: true)
  }
  
  func presentSchool() {
    let profileEditJobModal = ProfileEditJobAndSchoolModal(
      reactor: ProfileEditJobAndSchoolReactor(
        editType: .school,
        getUserDataUseCase: featureProfileDependencyProvider.makeGetProfileDataUseCase(),
        saveSchoolUserCase: featureProfileDependencyProvider.makeSaveSchoolUseCase(),
        saveJobUseCase: featureProfileDependencyProvider.makeSaveJobUseCase()
      )
    )
    
    profileEditJobModal.modalPresentationStyle = .pageSheet
    profileEditJobModal.delegate = self
    navigationController.present(profileEditJobModal, animated: true)
  }
  
  func presentIntroduce() {
    let profileEditIntroduceModal = ProfileEditIntroduceModal(
      reactor: ProfileEditIntroduceReactor(
        saveIntroduceUseCase: featureProfileDependencyProvider.makeSaveIntroduceUseCase(),
        getUserDataUseCase: featureProfileDependencyProvider.makeGetProfileDataUseCase()
      )
    )
    
    profileEditIntroduceModal.modalPresentationStyle = .pageSheet
    profileEditIntroduceModal.delegate = self
    navigationController.present(profileEditIntroduceModal, animated: true)
  }
  
  func presentMBTI() {
    let profileEditIntroduceModal = ProfileEditMBTIModal(
      reactor: ProfileEditMBTIReactor(
        saveMBTIUseCase: featureProfileDependencyProvider.makeSaveMBTIUseCase(),
        getUserDataUseCase: featureProfileDependencyProvider.makeGetProfileDataUseCase()
      )
    )
    
    profileEditIntroduceModal.modalPresentationStyle = .pageSheet
    profileEditIntroduceModal.delegate = self
    navigationController.present(profileEditIntroduceModal, animated: true)
  }
  
  func presentInterests() {
    
    let profileEditInterestsModal = ProfileEditInterestsModal(
      reactor: ProfileEditInterestsReactor(
        getAllInterestsUseCase: featureProfileDependencyProvider.makeGetAllInterestsUseCase(),
        saveInterestsUseCase: featureProfileDependencyProvider.makeSaveInterestsUseCase(),
        getUserDataUseCase: featureProfileDependencyProvider.makeGetProfileDataUseCase())
    )
    
    profileEditInterestsModal.modalPresentationStyle = .pageSheet
    profileEditInterestsModal.delegate = self
    navigationController.present(profileEditInterestsModal, animated: true)
  }
}

extension ProfileEditMainCoordinator: ProfileImageGuideDelegate, PHPickerViewControllerDelegate {
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

extension ProfileEditMainCoordinator: CropViewControllerDelegate {
  public func cropViewControllerDidCrop(_ cropViewController: Mantis.CropViewController, cropped: UIImage, transformation: Mantis.Transformation, cropInfo: Mantis.CropInfo) {
    DispatchQueue.main.async {
      let vcCount = self.navigationController.viewControllers.count
      if let vc = self.navigationController.viewControllers[vcCount - 1] as? ProfileEditMainController {
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
