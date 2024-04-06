//
//  ProfileEditMainCoordinator.swift
//  FeatureProfileInterface
//
//  Created by 윤지호 on 3/21/24.
//

import Foundation
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
    let reactor = ProfileEditMainReactor(getUserDataUseCase: featureProfileDependencyProvider.makeGetProfileDataUseCase())
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
    print("presentImageGuide")
  }
  
  func presentSelectImage() {
    print("presentSelectImage")
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
