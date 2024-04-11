//
//  ProfileEditMainView.swift
//  FeatureProfileInterface
//
//  Created by 윤지호 on 3/21/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

import SharedDesignSystem
import DomainUserInterface

enum ProfileEditMainType {
  case edit
  case preview
}

enum ProfileEditMainCellType {
  case profileImage
  case basicInformation
  case additionalInformation
}

final class ProfileEditMainPageTypeViewController: UIViewController {
  // MARK: - View Property
  private var tableView: UITableView = UITableView()
  
  // MARK: - Rx Property
  private let disposeBag = DisposeBag()
  
  // MARK: - Touchable Property
  var touchEventRelay: PublishRelay<TouchEventType> = .init()
  
  private let pageType: ProfileEditMainType
  private let dataSource: [ProfileEditMainCellType]
  private var userData: UserProfile? = nil
  
  // MARK: - Initialize Method
  required init(pageType: ProfileEditMainType) {
    self.pageType = pageType
    self.dataSource = [.profileImage, .basicInformation, .additionalInformation]
    super.init(nibName: nil, bundle: nil)
    configureUI(type: pageType)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - UIConfigurable
  private func configureUI(type: ProfileEditMainType) {
    setTableView()
  }
  
  // MARK: - UIBindable
  private func setEditCells() {
    
  }
}

extension ProfileEditMainPageTypeViewController {
  enum TouchEventType {
    case chatImageGuide
    case imageGuide
    case selectImage
    
    case nickname
    case address
    case job
    case school
    
    case introduce
    case mbti
    case interests
  }
}

extension ProfileEditMainPageTypeViewController: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return dataSource.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cellCase = dataSource[indexPath.section]
    switch pageType {
    case .edit:
      switch cellCase {
      case .profileImage:
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EditImageTableViewCell.cellId, for: indexPath) as? EditImageTableViewCell else { return UITableViewCell() }
        cell.updateCell(userData: userData!)
        cell.touchEventRelay
          .map { event in
            switch event {
            case .chatImageGuide:
              return TouchEventType.chatImageGuide
            case .imageGuide:
              return TouchEventType.imageGuide
            case .selectImage:
              return TouchEventType.selectImage
            }
          }
          .bind(to: touchEventRelay)
          .disposed(by: disposeBag)
        
        return cell
      case .basicInformation:
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EditBasicInfoTableViewCell.cellId, for: indexPath) as? EditBasicInfoTableViewCell else { return UITableViewCell() }
        cell.updateCell(userData: userData!)
        cell.touchEventRelay
          .map { event in
            switch event {
            case .nickname:
              return TouchEventType.nickname
            case .address:
              return TouchEventType.address
            case .job:
              return TouchEventType.job
            case .school:
              return TouchEventType.school
            }
          }
          .bind(to: touchEventRelay)
          .disposed(by: disposeBag)
          
        return cell
      case .additionalInformation:
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EditAdditionalInfoTableViewCell.cellId, for: indexPath) as? EditAdditionalInfoTableViewCell else { return UITableViewCell() }
        cell.updateCell(userData: userData!)
        cell.touchEventRelay
          .map { event in
            switch event {
            case .introduce:
              return TouchEventType.introduce
            case .mbti:
              return TouchEventType.mbti
            case .interests:
              return TouchEventType.interests
            }
          }
          .bind(to: touchEventRelay)
          .disposed(by: disposeBag)
        
        return cell
      }
    case .preview:
      switch cellCase {
      case .profileImage:
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PreviewImageTableViewCell.cellId, for: indexPath) as? PreviewImageTableViewCell else { return UITableViewCell() }
        cell.updateCell(userData: userData!)
        return cell
      case .basicInformation:
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PreviewBasicInfoTableViewCell.cellId, for: indexPath) as? PreviewBasicInfoTableViewCell else { return UITableViewCell() }
        cell.updateCell(userData: userData!)
        return cell
      case .additionalInformation:
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PreviewAdditionalInfoTableViewCell.cellId, for: indexPath) as? PreviewAdditionalInfoTableViewCell else { return UITableViewCell() }
        cell.updateCell(userData: userData!)
        return cell
      }
    }
  }
}

extension ProfileEditMainPageTypeViewController: UITableViewDelegate {

  public func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
      return false
  }
}

extension ProfileEditMainPageTypeViewController {
  private func setTableView() {
    tableView.delegate = self
    tableView.dataSource = self
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = UITableView.automaticDimension
    tableView.separatorStyle = .none
    
    switch pageType {
    case .edit:
      registerEditCell()
    case .preview:
      registerPreviewCell()
    }
    
    self.view.addSubview(tableView)
    tableView.snp.makeConstraints {
      $0.horizontalEdges.verticalEdges.equalToSuperview()
    }
  }
  
  private func registerEditCell() {
    tableView.register(EditImageTableViewCell.self, forCellReuseIdentifier: EditImageTableViewCell.cellId)
    tableView.register(EditBasicInfoTableViewCell.self, forCellReuseIdentifier: EditBasicInfoTableViewCell.cellId)
    tableView.register(EditAdditionalInfoTableViewCell.self, forCellReuseIdentifier: EditAdditionalInfoTableViewCell.cellId)
  }
  
  private func registerPreviewCell() {
    tableView.register(PreviewImageTableViewCell.self, forCellReuseIdentifier: PreviewImageTableViewCell.cellId)
    tableView.register(PreviewBasicInfoTableViewCell.self, forCellReuseIdentifier: PreviewBasicInfoTableViewCell.cellId)
    tableView.register(PreviewAdditionalInfoTableViewCell.self, forCellReuseIdentifier: PreviewAdditionalInfoTableViewCell.cellId)
  }
}

extension ProfileEditMainPageTypeViewController {
  func setUserData(userData: UserProfile) {
    self.userData = userData
    switch pageType {
    case .edit:
      setUserDataEdit(userData)
    case .preview:
      setUserDataPreview(userData)
    }
  }

  private func setUserDataEdit(_ userData: UserProfile) {
    if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? EditImageTableViewCell {
      cell.updateCell(userData: userData)
    }
    
    if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? EditBasicInfoTableViewCell {
      cell.updateCell(userData: userData)
    }
    
    if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 2)) as? EditAdditionalInfoTableViewCell {
      cell.updateCell(userData: userData)
    }
  }
  
  private func setUserDataPreview(_ userData: UserProfile) {
    if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? PreviewImageTableViewCell {
      cell.updateCell(userData: userData)
    }
    
    if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? PreviewBasicInfoTableViewCell {
      cell.updateCell(userData: userData)
    }
    
    if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 2)) as? PreviewAdditionalInfoTableViewCell {
      cell.updateCell(userData: userData)
    }
  }
}
