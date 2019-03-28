require "docker_clone"

DOCKER_CLONE_CONFIG_PATH = "./docker-clone.yml"
DOCKER_CLONE_CONFIG = <<~EOF
  working_dir: "../"
  repos:
    - url: https://test.com:test/test.git
      name: test
EOF

describe DockerClone do
  # Configure the environment. Creates the docker-clone.yml file.
  before :all do
    IO.write(
      DOCKER_CLONE_CONFIG_PATH,
      DOCKER_CLONE_CONFIG
    )
  end

  it "should not initialize if no config file path given" do
    expect { DockerClone.new }.to raise_error(ArgumentError)
  end

  it "should correctly initialize if no working dir given" do
    expect { DockerClone.new(config_file_path: './test.yml') }.to_not raise_error
  end

  # Clean the environment.
  after :all do
    File.delete(DOCKER_CLONE_CONFIG_PATH)
  end
end
