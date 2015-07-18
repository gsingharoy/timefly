Gem::Specification.new do |spec|
  spec.name        = 'timefly'
  spec.version     = '0.0.1'
  spec.date        = Time.now.strftime('%Y-%m-%d')
  spec.summary     = "Timefly"
  spec.description = "A simple library which makes it easier to get time related data, eg, age from Date of birth, elapsed time in beautiful format, etc."
  spec.authors     = ["Gaurav Singha Roy"]
  spec.email       = 'neogauravsvnit@gmail.com'
  spec.files       = ["lib/timefly.rb"]
  spec.homepage    =
    'https://github.com/aaalo/timefly'
  spec.license       = 'MIT'

  spec.add_development_dependency "rspec"
end