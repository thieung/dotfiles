# Inspiration taken from: https://github.com/olimorris/dotfiles
# This Rakefile should not be run with sudo, it will use sudo where necessary.
# To perform tasks in a 'dry run' state append the following to your command:
# DRY_RUN=true
DOTS_FOLDER = '~/.local/share/chezmoi'
DIRECTORY_NAME = File.dirname(__dir__)
SKIP_TESTS_FOR = %w[].freeze # mas.rake brew.rake

Dir.glob('./tasks/**/*').map { |file| load file }

task default: [:backup]

desc 'Install Everything'
task :install do
  section 'Installing'

  Rake::Task['tests:setup'].invoke if testing?

  # Packages
  Rake::Task['install:xcode'].invoke
  Rake::Task['install:brew'].invoke
  Rake::Task['install:brew_packages'].invoke
  Rake::Task['install:brew_cask_packages'].invoke
  Rake::Task['install:brew_clean_up'].invoke
  Rake::Task['install:app_store'].invoke unless testing?
  Rake::Task['install:gems'].invoke unless testing?
  Rake::Task['install:npm'].invoke unless testing?
  Rake::Task['install:pip'].invoke unless testing?
  Rake::Task['install:tmux'].invoke unless testing?

  # Files
  Rake::Task['install:app_config'].invoke
  Rake::Task['install:dotfiles'].invoke

  # System
  Rake::Task['install:chmod'].invoke
  Rake::Task['install:fish'].invoke
  Rake::Task['install:fonts'].invoke
  Rake::Task['install:hammerspoon'].invoke
  Rake::Task['install:launch_agents'].invoke
  Rake::Task['install:macos'].invoke
  Rake::Task['install:servers'].invoke

  # Packages
  Rake::Task['install:gems'].invoke
  Rake::Task['install:npm'].invoke
  Rake::Task['install:pip'].invoke
  Rake::Task['install:tmux'].invoke

  # Apps
  # Rake::Task['install:neovim'].invoke
  Rake::Task['install:rails'].invoke
  Rake::Task['install:vim'].invoke
end
