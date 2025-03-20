import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/listener.dart' show ErrorReporter;
import 'package:custom_lint_builder/custom_lint_builder.dart';

final class BlocCheckIsClosedRule extends DartLintRule {
  BlocCheckIsClosedRule() : super(code: _code);

  static const _code = LintCode(name: 'bloc_check_is_closed', problemMessage: 'You should check for `isClosed` before calling `emit` in async methods.', correctionMessage: 'Add an `if (!isClosed)` check before the `emit` statement.');

  @override
  void run(CustomLintResolver resolver, ErrorReporter reporter, CustomLintContext context) {
    context.registry.addMethodDeclaration((node) {
      node.body.visitChildren(_Visitor(reporter));
    });
  }
}

final class _Visitor extends RecursiveAstVisitor<void> {
  final ErrorReporter reporter;
  _Visitor(this.reporter);

 
  @override
  void visitAwaitExpression(AwaitExpression node) {
    super.visitAwaitExpression(node);
    final parent = node.parent;
    if (parent is ExpressionStatement) {
      final grandParent = parent.parent;
      if (grandParent is Block) {
        final body = grandParent.parent;
        if (body is BlockFunctionBody) {
          final statements = body.block.statements;
          final index = statements.indexOf(parent);
          for (var i = index + 1; i < statements.length; i++) {
            final statement = statements[i];
            if (statement is ExpressionStatement) {
              final expression = statement.expression;
              if (expression is FunctionExpressionInvocation && expression.function is SimpleIdentifier) {
                final identifier = expression.function as SimpleIdentifier;
                if (identifier.name == 'emit') {
                  reporter.atNode(expression, BlocCheckIsClosedRule._code);
                }
              }
            } else if (statement is IfStatement) {
              final conditionString = statement.expression.toString();
              final thenStatement = statement.thenStatement;
              if (conditionString.contains('isClosed') && conditionString.contains('!isClosed') == false) {
                if (thenStatement is ReturnStatement) {
                  final expressionString = thenStatement.toString();
                  if (expressionString.contains('return') && expressionString.contains('emit') == false) {
                    return;
                  }
                } else if (thenStatement is Block) {
                  final statements = thenStatement.statements;
                  if (statements.length == 1 && statements.first is ReturnStatement) {
                    final expressionString = statements.first.toString();
                    if (expressionString.contains('return') && expressionString.contains('emit') == false) {
                      return;
                    }
                  } else if (statements.length == 1 && statements.first is ExpressionStatement) {
                    final statement = statements.first;
                    if (statement is! ExpressionStatement) return;
                    final expression = statement.expression;
                    if (expression is FunctionExpressionInvocation && expression.function is SimpleIdentifier) {
                      final identifier = expression.function as SimpleIdentifier;
                      if (identifier.name == 'emit') {
                        reporter.atNode(expression, BlocCheckIsClosedRule._code);
                      }
                    }
                  }
                } else if (thenStatement is ExpressionStatement) {
                  final expression = thenStatement.expression;
                  if (expression is FunctionExpressionInvocation && expression.function is SimpleIdentifier) {
                    final identifier = expression.function as SimpleIdentifier;
                    if (identifier.name == 'emit') {
                      reporter.atNode(expression, BlocCheckIsClosedRule._code);
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}
