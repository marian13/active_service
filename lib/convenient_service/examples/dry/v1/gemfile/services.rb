# frozen_string_literal: true

require_relative "services/run_shell_command"

require_relative "services/assert_file_exists"
require_relative "services/assert_file_not_empty"
require_relative "services/assert_node_available"
require_relative "services/assert_npm_package_available"
require_relative "services/assert_valid_ruby_syntax"
require_relative "services/read_file_content"
require_relative "services/strip_comments"
require_relative "services/parse_content"
require_relative "services/format_header"
require_relative "services/format_gems_without_envs"
require_relative "services/format_gems_with_envs"
require_relative "services/format_body"
require_relative "services/format"
