Gem::Specification.new do |s|
  s.name        = "docker-clone"
  s.homepage    = "https://github.com/ghivert/docker-clone"
  s.version     = "0.1.0"
  s.date        = "2019-03-24"
  s.summary     = "Clone all your Docker micro-services repos in once."
  s.description = "Docker Clone is an utility to handle the boring work of cloning all your repos in a micro-services architecture using Docker, with a simple file definition format."
  s.author      = "Guillaume Hivert"
  s.email       = "hivert.is.coming@gmail.com"
  s.files       = [ "lib/docker_clone.rb" ]
  s.executables = [ "docker-clone" ]
  s.license     = "MIT"
end
