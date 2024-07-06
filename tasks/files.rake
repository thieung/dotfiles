namespace :install do
  desc 'Install files'

  task :app_config do
    section 'Installing Mackup'

    if !File.file?(File.expand_path('~/.mackup.cfg')) && !ENV['DRY_RUN']
      run %( ln -s #{DOTS_FOLDER}/.mackup.cfg ~/.mackup.cfg )
      run %( ln -s #{DOTS_FOLDER}/.mackup ~/.mackup )
    else
      puts '~> Already installed'
    end

    section 'Using Mackup to restore app configs'

    if ENV['DRY_RUN']
      puts "~> Chill! It's a dry run"
      system %( mackup restore --dry-run && mackup uninstall --dry-run )
    else
      run %( mackup restore --force && mackup uninstall --force )
    end
  end

  task :dotfiles do
    section 'Using chezmoi to manage dotfiles'

    run %( chezmoi init --apply git@github.com:thieung/dotfiles.git )
  end
end
