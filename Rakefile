require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

RSpec::Core::RakeTask.new(:spec_with_formatters) do |t|
  t.rspec_opts =
    "--format RspecOverview::Formatter --format RspecOverview::FormatterCsv"
end

task default: [:spec, :spec_with_formatters]
