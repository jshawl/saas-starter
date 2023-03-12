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
    sleep 1
  end
  run "Truncate CHANGELOG.md again" do
    sleep 1
    raise 'hell'
  end
end
