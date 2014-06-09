Gem::Specification.new do |s|
  s.name        = 'image_distance'
  s.version     = '0.1.0'
  s.date        = '2014-06-06'
  s.summary     = "Image similarity testing gem"
  s.description = "Simplifies the comparison of similar images"
  s.authors     = ["Kyle Van Wagenen"]
  s.email       = 'kvanwagenen@gmail.com'
  s.files       = ["lib/image_distance.rb"]
  s.license     = 'MIT'

  s.add_dependency 'phashion', '1.1.1'
end