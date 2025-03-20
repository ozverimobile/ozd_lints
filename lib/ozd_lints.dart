import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:ozd_lints/rules/bloc_check_is_closed.dart';

// This is the entrypoint of our custom linter
PluginBase createPlugin() => _OZDLinter();

/// A plugin class is used to list all the assists/lints defined by a plugin.
final class _OZDLinter extends PluginBase {
  /// We list all the custom warnings/infos/errors
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) => [BlocCheckIsClosedRule()];
}
