guard 'spinach', all_on_start: false, backtrace: true do
  watch(%r|^features/(.*)\.feature|)
  watch(%r|^features/steps/(.*)([^/]+)\.rb|) do |m|
    "features/#{m[1]}#{m[2]}.feature"
  end
end

guard :rspec, cmd: "bin/rspec --tty" do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib\/event_sourcing\/(.+)\.rb$}) { |m| "spec/unit/#{m[1]}_spec.rb" }
  watch('spec/unit_helper.rb')  { "spec" }
end