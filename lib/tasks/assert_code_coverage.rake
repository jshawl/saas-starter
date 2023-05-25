# frozen_string_literal: true

desc 'Remove SaaS Starter specific code'
task :assert_code_coverage do
  coverage = JSON.parse(File.read('coverage/.last_run.json'))
  percent = coverage['result']['line']
  abort("❌ Code coverage is < 100% (#{percent})") if percent < 100
end
