Gem::Specification.new do |s|
  s.name          = 'kele'
  s.version       = '0.0.1'
  s.date          = '2017-03-23'
  s.summary       = 'Kele API Client'
  s.description   = 'A client for the Bloc API'
  s.authors       = ['Nathaniel Dake']
  s.email         = 'ndake11@gmail.com'
  s.files         = ['lib/kele.rb']
  s.require_paths = ["lib"]
  s.homepage      =
      'http://rubygems.org/gems/kele'
  s.license       = 'MIT'
  s.add_runtime_dependency 'httparty', '~> 0.13'
end

#files is an array of files included in the gem
#a gemspec is called from a ruby method - anything you can do in ruby
#you can do in a gemspec
#httparty dependency added. This instructs bundle to install httparty
#which provides a programmatic ruby interface to make http requests
#Note: '~> 0.13' is semantic versioning (want latest version in 0.13 range
#but not 0.14)