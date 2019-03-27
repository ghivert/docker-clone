require "yaml"
require "optparse"
require "pathname"

CONFIG_DESCRIPTION  = "Path to your docker clone config file"
HELP_DESCRIPTION    = "Show this help message"

HELP_BANNER = "Usage: docker-clone [options]"

DEFAULT_WORKING_DIR = "../"

class NoRepoException < Exception
end

class DockerClone
  def initialize
    get_config
  end

  def clone_repos
    working_dir = @@options[:working_dir] || DEFAULT_WORKING_DIR
    Dir.chdir(working_dir) do
      @@docker_clone["repos"].each do |repo|
        clone_repo(repo)
      end
    end
  end

  private

  def parse_options
    options = { config_path: "docker-clone.yml" }
    options.tap do |options|
      OptionParser.new do |parser|
        parser.banner = HELP_BANNER
        parser.separator ""
        parser.on("-h", "--help", HELP_DESCRIPTION) do
          puts parser
          exit(true)
        end
        parser.on("-c", "--config config_file_path", CONFIG_DESCRIPTION) do |config_path|
          options[:config_path] = config_path
        end
      end.parse!
    end
  end

  def full_path(pathname)
    path = Pathname.new(pathname)
    path.expand_path
  end

  def read_docker_file(pathname)
    path = full_path(pathname)
    file = File.read(path)
    YAML.load(file)
  end

  def print_docker_clone_error(path)
    puts "No corresponding config file, looking for #{path}"
  end

  def print_docker_clone_error_and_exit
    config_path      = @@options[:config_path]
    full_config_path = full_path(config_path)

    print_docker_clone_error(full_config_path)
    exit(false)
  end

  def get_config
    @@options      ||= parse_options
    @@docker_clone ||= read_docker_file(@@options[:config_path])
  rescue
    print_docker_clone_error_and_exit
  end

  def clone_repo(repo)
    url, name = repo["url"], repo["name"]
    puts "No URL or name given for your repo. #{url} #{name}" if !url || !name
    `git clone #{url} #{name}`
  end
end
