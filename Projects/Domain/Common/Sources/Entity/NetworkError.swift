//
//  NetworkError.swift
//  DomainCommon
//
//  Created by 윤지호 on 1/21/24.
//

import Foundation

public struct NetworkError: Error {
  public let errorCase: ErrorCase
  public let massage: String
  
  public init(errorCase: ErrorCase, massage: String) {
    self.errorCase = errorCase
    self.massage = massage
  }
}

public enum ErrorCase: Error {
  // Common Error
  case E000WrongParameter
  case E001TokenAuthenticationFailed
  case E002AccessTokenExpired
  case E003NonExistentUser
  case E004DisabledUser
  
  // Custom Error
  case E005NaverSMSFailed
  case E006AlreadyExistNickname
  case E007SMSAuthenticationFailed
  case E008AlreadyExistUser
  case E009RefreshTokenExpired
  case E011NonExistentChatRoom
  case E012AlreadyExistChatRoom
  case E013NonExistentChatContent
  case E015NoUserInChatRoom
  case E016InvalidExtension
  case E017NonExistentMatch
  case E018DailyMatchingLimitOver
  case E019FailedAccountVerification
  case E020NonExistentAccountVerificationHistory
  case E021CompleteAllAccountVerificationQuestions
  case E022ForbiddenWordDetected
  case E023MismatchedAccountAndDeviceId
  case E024NonExistentInterest
  case E025AlreadyUnlockedProfile
  case E026InsufficientCandies
  case E027InsufficientTickets
  case E028InsufficientPermissions
  case E029NonExistentSubscription
  case E030CompleteSignUp
  case E031NonExistentPost
  case E032NonExistentComment
  case E033TimeLimitExceeded
  case E034AlreadyLiked
  case E035LikeDoesNotExist
  case E036PhoneAuthentificationDailyRequestLimitExceeded
  
  // Common Error
  case E097WrongEndpointRequest
  case E098OverCall
  case E099ServerError
  case UnknownError
  
  public var message: String {
    switch self {
      
      // Common Error
    case .E000WrongParameter:
      return "잘못된 파라미터"
    case .E001TokenAuthenticationFailed:
      return "토큰 인증 실패"
    case .E002AccessTokenExpired:
      return "엑세스 토큰 만료"
    case .E003NonExistentUser:
      return "존재하지 않는 사용자"
    case .E004DisabledUser:
      return "이용 정지된 사용자"
      
      // Custom Error
    case .E005NaverSMSFailed:
      return "naver에서 sms 전송을 실패했습니다. "
    case .E006AlreadyExistNickname:
      return "이미 존재 하는 닉네임입니다."
    case .E007SMSAuthenticationFailed:
      return "유효하지 않은 인증 번호입니다."
    case .E008AlreadyExistUser:
      return "이미 존재 하는 유저입니다."
    case .E009RefreshTokenExpired:
      return "refreshToken이 만료되었습니다."
    case .E011NonExistentChatRoom:
      return "채팅방이 존재하지 않습니다."
    case .E012AlreadyExistChatRoom:
      return "채팅방이 이미 존재합니다."
    case .E013NonExistentChatContent:
      return "채팅 내용이 존재하지 않습니다."
    case .E015NoUserInChatRoom:
      return "유저가 채팅방에 존재하지 않습니다."
    case .E016InvalidExtension:
      return "올바르지 않은 확장자입니다."
    case .E017NonExistentMatch:
      return "존재하지 않는 매치입니다."
    case .E018DailyMatchingLimitOver:
      return "일일 매칭 횟수 제한을 초과했습니다."
    case .E019FailedAccountVerification:
      return "계정 확인에 실패했습니다."
    case .E020NonExistentAccountVerificationHistory:
      return "계정 확인 이력이 존재하지 않습니다."
    case .E021CompleteAllAccountVerificationQuestions:
      return "계정 확인 질문을 전부 완료해야 합니다."
    case .E022ForbiddenWordDetected:
      return "금칙어가 존재합니다."
    case .E023MismatchedAccountAndDeviceId:
      return "기존 계정과 기기 번호가 일치하지 않습니다."
    case .E024NonExistentInterest:
      return "존재하지 않는 관심사입니다."
    case .E025AlreadyUnlockedProfile:
      return "이미 프로필 잠금을 해제했습니다."
    case .E026InsufficientCandies:
      return "캔디의 개수가 부족합니다."
    case .E027InsufficientTickets:
      return "티켓의 개수가 부족합니다."
    case .E028InsufficientPermissions:
      return "권한이 없습니다."
    case .E029NonExistentSubscription:
      return "존재하지 않는 구독권입니다."
    case .E030CompleteSignUp:
      return "회원가입을 완료해주세요."
    case .E031NonExistentPost:
      return "존재하지 않는 게시글입니다."
    case .E032NonExistentComment:
      return "존재하지 않는 댓글입니다."
    case .E033TimeLimitExceeded:
      return "제한 시간을 초과했습니다."
    case .E034AlreadyLiked:
      return "이미 좋아요를 눌렀습니다."
    case .E035LikeDoesNotExist:
      return "좋아요가 존재하지 않습니다."
    case .E036PhoneAuthentificationDailyRequestLimitExceeded:
      return "요청 일일횟수 제한은 5번입니다."
      
      // Common Error
    case .E097WrongEndpointRequest:
      return "잘못된 요청"
    case .E098OverCall:
      return "과호출"
    case .E099ServerError:
      return "내부 서버 오류"
    case .UnknownError:
      return "알 수 없는 오류"
    }
    
  }
}

public enum ErrorCode: String {
  // Common Error
  case E000
  case E001
  case E002
  case E003
  case E004
  
  // Custom Error
  case E005
  case E006
  case E007
  case E008
  case E009
  case E011
  case E012
  case E013
  case E015
  case E016
  case E017
  case E018
  case E019
  case E020
  case E021
  case E022
  case E023
  case E024
  case E025
  case E026
  case E027
  case E028
  case E029
  case E030
  case E031
  case E032
  case E033
  case E034
  case E035
  case E036
  
  // Common Error
  case E097
  case E098
  case E099
  case unknown
  
  public func toCase() -> ErrorCase {
    switch self {
      // Common Error
    case .E000:
      return .E000WrongParameter
    case .E001:
      return .E001TokenAuthenticationFailed
    case .E002:
      return .E002AccessTokenExpired
    case .E003:
      return .E003NonExistentUser
    case .E004:
      return .E004DisabledUser
      
      // Custom Error
    case .E005:
      return .E005NaverSMSFailed
    case .E006:
      return .E006AlreadyExistNickname
    case .E007:
      return .E007SMSAuthenticationFailed
    case .E008:
      return .E008AlreadyExistUser
    case .E009:
      return .E009RefreshTokenExpired
    case .E011:
      return .E011NonExistentChatRoom
    case .E012:
      return .E012AlreadyExistChatRoom
    case .E013:
      return .E013NonExistentChatContent
    case .E015:
      return .E015NoUserInChatRoom
    case .E016:
      return .E016InvalidExtension
    case .E017:
      return .E017NonExistentMatch
    case .E018:
      return .E018DailyMatchingLimitOver
    case .E019:
      return .E019FailedAccountVerification
    case .E020:
      return .E020NonExistentAccountVerificationHistory
    case .E021:
      return .E021CompleteAllAccountVerificationQuestions
    case .E022:
      return .E022ForbiddenWordDetected
    case .E023:
      return .E023MismatchedAccountAndDeviceId
    case .E024:
      return .E024NonExistentInterest
    case .E025:
      return .E025AlreadyUnlockedProfile
    case .E026:
      return .E026InsufficientCandies
    case .E027:
      return .E027InsufficientTickets
    case .E028:
      return .E028InsufficientPermissions
    case .E029:
      return .E029NonExistentSubscription
    case .E030:
      return .E034AlreadyLiked
    case .E031:
      return .E031NonExistentPost
    case .E032:
      return .E032NonExistentComment
    case .E033:
      return .E033TimeLimitExceeded
    case .E034:
      return .E034AlreadyLiked
    case .E035:
      return .E035LikeDoesNotExist
    case .E036:
      return .E036PhoneAuthentificationDailyRequestLimitExceeded
      
      // Common Error
    case .E097:
      return .E097WrongEndpointRequest
    case .E098:
      return .E098OverCall
    case .E099:
      return .E099ServerError
    default:
      return .UnknownError
    }
  }
}
