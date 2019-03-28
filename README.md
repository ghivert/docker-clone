# Docker Clone

Developing with micro-services is awesome, but it can be a little boring
sometimes. Having to setup everything, make the services talking together,
databases properly set, etc.

Happily, Docker comes into play, and completely deals with all your painful
processes. It abstracts everything you need, setup databases for you, creates
a common network, and connect every services together. It’s a huge gain. But
this brings a problem: how should you organize your repos? Should you do a
mono-repo? Multi-repos? And if you do multi-repos, how are you supposed to clone
all of your GitHub or GitLab repos without having to open every repo, find its
URL, clone the directory into your workspace, …?

Come Docker Clone!

# Opinions

Docker Clone is opinionated. It expects from you that you’re working with
micro-services, and with multi-repos. Multi-repos are better. They’re much
more isolated, it forces to decouple by design, it ensures no one can access
databases from other services, and they’re much more easily manageable for one
person or a team. You’re just concerned by your repos, and nothing else. Just
grab the interfaces of other services, and work on your business logic. That’s
all.

Docker Clone has been created due to the work on
[French Pastries](https://frenchpastries.dev). It is made to respond to needs
of micro-services, mainly made with JavaScript (and JavaScript’s family) and Node.

# How does it work?

Docker Clone uses a file named `docker-clone.yml` to get which repos should be
cloned, how they should be named, and where they should resides. Usually, it is
placed at the root of a directory, as well as a `docker-compose.yml` file to run
everything once it’s downloaded.

In correct order, Docker Clone:

1. Fetch the `docker-clone.yml` file.
2. Determine the correct working directory in which repo-cloning should happen.
3. Iterate over all the repos, and trigger a `git clone` in the working directory.
4. Name the repos accordingly to the `docker-clone.yml` file.

# What is the file format?

The Docker Clone config file is a YAML file, to be coherent with Docker. It is
somewhat similar to a `docker-compose.yml`, because it only describes what
should be done. The default config file is named `docker-clone.yml`. It is made
of an optional `working_dir` field at root (initialized at `../` if not set),
and a `repos` field, containing an array of repo object. A repo is made of two
fields: an `url` field, and a `name` field. The first one should be either an
HTTPS or a git address, for git to clone the repo, and a name corresponding to
the repo name.

# Example of `docker-clone.yml`

```yaml
working_dir: '../' # ../ is the default value for working_dir if not set.
repos:
  - url: git@github.com:ghivert/my-awesome-docker-server.git
    name: docker-server
  - url: https://gitlab.com/wolfoxco/my-second-awesome-server.git
    name: other-docker-server
```

# Installation

You can use the `gem` utility to install Docker Clone.

```bash
gem install docker-clone
```

You now have the `docker-clone` command globally installed.

# Usage

Docker Clone is easy to use. Just type `docker-clone` without any argument, and
it will launch, search for `docker-clone.yml`, and install everything.

You can use `-h` or `--help` to display help directly. The other option is `-c`,
or `--config`, followed by a path to the config file. It will be used instead of
`docker-clone.yml`.

You can also use a programmatic access. Add the `docker-clone` gem to your `Gemfile`,
run a `bundle install`, and you can `require "docker-clone"` directly into your
Ruby files. It gives access to a `DockerClone` object.

The object must be initialized with an options map, with `working_dir` and
`config_file_path`. Then, run `clone_repos` and it will install everything.

```ruby
require "docker_clone"

# Folder structure
# workspace
# └── docker-cloner
#     ├── .git/
#     ├── .gitignore
#     ├── docker-clone.yml
#     ├── docker-compose.yml
#     └── README.md

# Initialize the object. It reads the config file during initialization.
cloner = DockerClone.new(
  working_dir: '../',
  # working_dir will be expanded to the workspace directory.
  config_file_path: './docker-clone.yml'
  # config_file_path will be expanded to docker-clone.yml in the root directory.
)
# And clone the repos!
clone.clone_repos
```

# Contributions

Do you love the package? Love the utility? Want to improve it? PR are welcome, as
well as issues!
