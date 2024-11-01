abstract final class Env {
  static const String youtrackApiUrl = String.fromEnvironment('YOUTRACK_API_TOKEN');
  static const String youtrackApiToken = String.fromEnvironment('YOUTRACK_API_TOKEN');

  static const String redmineApiKey = String.fromEnvironment('REDMINE_API_KEY');
  static const String redmineApiUrl = String.fromEnvironment('REDMINE_API_URL');

  static const String jiraApiUrl = String.fromEnvironment('JIRA_API_URL');
  static const String jiraEmail = String.fromEnvironment('JIRA_EMAIL');
  static const String jiraApiToken = String.fromEnvironment('JIRA_API_TOKEN');
}
