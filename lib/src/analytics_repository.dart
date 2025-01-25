import 'package:equatable/equatable.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import 'models/models.dart';

/// {@template analytics_failure}
/// A base failure for analytics repository failure.
/// {@endtemplate}
abstract class AnalyticFalure with EquatableMixin implements Exception {
  ///{@macro analytics_failure}
  const AnalyticFalure(this.error);

  /// Thorw the error caught.
  final Object error;

  @override
  List<Object> get props => [error];
}

class TrackEventFailure extends AnalyticFalure {
  TrackEventFailure(super.error);
}

class SetUserIdFailure extends AnalyticFalure {
  SetUserIdFailure(super.error);
}

/// {@template  analytic_repository }
/// Repository manage tracking of  analytics
/// {@endtemplate }
class AnalyticsRepository {
  /// {@macro analytic_repository}
  ///
  final FirebaseAnalytics _analytics;

  AnalyticsRepository(
    FirebaseAnalytics analytics,
  ) : _analytics = analytics;

  /// Tracks the provided [AnalyticsEvent].
  Future<void> track(AnalyticsEvent event) async {
    try {
      await _analytics.logEvent(
        name: event.name,
        parameters: event.properties,
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(TrackEventFailure(error), stackTrace);
    }
  }

  /// Sets the user identifier associated with tracked events.
  ///
  /// Setting a null [userId] will clear the user identifier.
  Future<void> setUserId(String? userId) async {
    try {
      await _analytics.setUserId(id: userId);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(SetUserIdFailure(error), stackTrace);
    }
  }
}
