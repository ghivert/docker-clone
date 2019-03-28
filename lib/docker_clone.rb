require "yaml"
require "optparse"
require "pathname"

DEFAULT_WORKING_DIR = "../"

class NoRepoException < Exception
end

class DockerClone
  def initialize(options = {})
    raise ArgumentError.new("No Config File Path Given.") if !options[:config_file_path]
    @config_file_path = full_path(options[:config_file_path])
    @working_dir = options[:working_dir] || DEFAULT_WORKING_DIR
    get_config
  end

  def clone_repos
    Dir.chdir(@working_dir) do
      @docker_clone_config["repos"].each do |repo|
        clone_repo(repo)
      end
    end
  end

  private

  def full_path(pathname)
    path = Pathname.new(pathname)
    path.expand_path
  end

  def read_docker_file
    file = File.read(@config_file_path)
    YAML.load(file)
  end

  def print_docker_clone_error(path)
    raise ArgumentError.new("No corresponding config file, looking for #{path}")
  end

  def print_docker_clone_error_and_exit
    print_docker_clone_error(@config_file_path)
    exit(false)
  end

  def get_config
    @docker_clone_config ||= read_docker_file
  rescue
    print_docker_clone_error_and_exit
  end

  def clone_repo(repo)
    url, name = repo["url"], repo["name"]
    raise ArgumentError.new("No URL or name given for your repo. #{url} #{name}") if !url || !name
    `git clone #{url} #{name}`
  end
end
