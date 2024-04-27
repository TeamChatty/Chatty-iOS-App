// This is for Tuist
import Foundation
import DomainCommunity

public protocol FeatureFeedDependencyProvider {
  func makeGetFeedsPageUseCase() -> DefaultGetFeedsPageUseCase
  func makeWriteFeedUseCase() -> DefaultWriteFeedUseCase
}
