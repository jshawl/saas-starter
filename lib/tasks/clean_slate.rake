def run(desc, &block)
  print "#{desc} "
  begin
    yield
    print "✅ "
  rescue => e
    print "❌ "
    puts ""
    puts e.backtrace.join("\n")
  end
  puts ""
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
  run "Remove encrypted credentials" do
    files = Dir.glob("**/*.enc")
    files.each do |file|
      File.delete(file)
    end
  end
end
