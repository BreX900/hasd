abstract final class Env {
  static const String youtrackApiUrl = String.fromEnvironment('YOUTRACK_API_TOKEN');
  static const String youtrackApiToken = String.fromEnvironment('YOUTRACK_API_TOKEN');
  static const String redmineApiKey = String.fromEnvironment('REDMINE_API_KEY');
  static const String redmineApiUrl = String.fromEnvironment('REDMINE_API_URL');
}
