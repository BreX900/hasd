/// https://support.atlassian.com/jira-service-management-cloud/docs/search-for-issues-in-jira/
sealed class JqlSpec {}

class JqlFilter implements JqlSpec {
  final String field;
  final String operator;
  final String value;

  JqlFilter(this.field, {required String equalTo})
      : operator = '=',
        value = equalTo;

  @override
  String toString() => '$field $operator "$value"';
}

class JqlExpression implements JqlSpec {
  final List<JqlSpec> children;
  final String operator;

  const JqlExpression.and(this.children) : operator = 'AND';
  const JqlExpression.or(this.children) : operator = 'OR';

  @override
  String toString() => '(${children.join(' $operator ')})';
}
