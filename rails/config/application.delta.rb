# Override generator defaults
config.generators do |generator|
  generator.assets false
  generator.helper false
  generator.view_specs false
  generator.test_framework :rspec
end
