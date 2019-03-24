require "yaml"
require "optparse"
require "pathname"

DESCRIPTION  = "The path to your docker pull config file."
SHORT_OPTION = "-c"
LONG_OPTION  = "--config config_file_path"

DEFAULT_WORKING_DIR = "./"

class NoRepoException < Exception
end

class DockerPull
  def initialize
    get_config
  end

  def clone_repos
    working_dir = @@options[:working_dir] || DEFAULT_WORKING_DIR
    Dir.chdir(working_dir) do
      @@docker_pull["repos"].each do |repo|
        clone_repo(repo)
      end
    end
  end

  private

  def parse_options
    options = { config_path: "docker-pull.yml" }
    options.tap do |options|
      OptionParser.new do |parser|
        parser.on(SHORT_OPTION, LONG_OPTION, DESCRIPTION) do |config_path|
          options[:config_path] = config_path
        end
      end.parse
    end
  end

  def read_docker_file(pathname)
    path = Pathname.new(pathname)
    file = File.read(path.expand_path)
    YAML.load(file)
  end

  def get_config
    @@options     ||= parse_options
    @@docker_pull ||= read_docker_file(@@options[:config_path])
  end

  def clone_repo(repo)
    url, name = repo["url"], repo["name"]
    puts "No URL or name given for your repo. #{url} #{name}" if !url || !name
    `git clone #{url} #{name}`
  end
end
