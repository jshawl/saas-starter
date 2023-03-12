# frozen_string_literal: true

def run(desc, opts = {})
  print "#{desc} "
  begin
    yield if block_given?
    print opts[:warn] ? '⚠️  ' : '✅ '
  rescue StandardError => e
    print '❌ '
    puts ''
    puts e.backtrace.join("\n")
  end
  puts (opts[:epilogue]).to_s
end

desc 'Remove SaaS Starter specific code'
task :clean_slate do
  run 'Truncate CHANGELOG.md' do
    File.write(Rails.root.join('CHANGELOG.md'), "# Changelog\n")
  end
  run 'Remove docs/*' do
    dirs = Dir.glob('docs/*').select { |f| File.directory?(f) && f !~ %r{/_} }
    dirs.each do |dir|
      FileUtils.remove_dir(dir)
    end
  end

  run 'Update docs/_config.yml', warn: true, epilogue: '(not yet implemented)'

  run 'Remove encrypted credentials' do
    files = Dir.glob('**/*.enc')
    files.each do |file|
      File.delete(file)
    end
  end

  puts '---'
  puts 'All done! 🥳'
  puts 'To check for any additional unhandled references, run:'
  puts ''
  puts '  git grep -in starter'
  puts ''
end
