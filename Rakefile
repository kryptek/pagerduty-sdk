desc "Build gem file"
task :buildgem do 
    sh "gem build pagerduty-sdk.gemspec"
end
desc "Install local gem file"
task :installgem do 
    sh "gem install pagerduty-sdk"
end

desc "Build and install local gem file"
task :gem => [ :buildgem, :installgem ]
