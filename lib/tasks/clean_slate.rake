def run(desc, opts = {}, &block)
  print "#{desc} "
  begin
    yield if block_given?
    if opts[:warn]
      print "⚠️  "
    else
      print "✅ "
    end
  rescue => e
    print "❌ "
    puts ""
    puts e.backtrace.join("\n")
  end
  puts "#{opts[:epilogue]}"
end

desc "Remove SaaS Starter specific code"
task :clean_slate do
  run "Truncate CHANGELOG.md" do
    File.write(Rails.root.join("CHANGELOG.md"), "# Changelog\n")
  end
  run "Remove docs/*" do
    dirs = Dir.glob('docs/*').select { |f| File.directory?(f) && !(f =~ /\/_/)}
    dirs.each do |dir|
      FileUtils.remove_dir(dir)
    end
  end

  run "Update docs/_config.yml", warn: true, epilogue: "(not yet implemented)"

  run "Remove encrypted credentials" do
    files = Dir.glob("**/*.enc")
    files.each do |file|
      File.delete(file)
    end
  end

  puts "---"
  puts "All done! 🥳"
  puts "To check for any additional unhandled references, run:"
  puts ""
  puts "  git grep -in starter"
  puts ""
end
