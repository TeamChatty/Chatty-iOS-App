// This is for Tuist
import Foundation
import DomainCommunity

public protocol FeatureFeedDependencyProvider {
  func makeWriteFeedUseCase() -> DefaultWriteFeedUseCase
}
