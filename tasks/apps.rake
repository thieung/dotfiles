namespace :install do
  desc 'Install Neovim'
  task :neovim do
    section 'Installing Neovim'

    unless testing?
      time = Time.new.strftime('%s')
      run %( git clone --depth 1 --branch nightly https://github.com/neovim/neovim ~/.neovim/#{time} )
      run %( rm -rf /opt/homebrew/bin/nvim )
      run %( rm -rf /usr/local/bin/nvim )
      run %( rm -rf /usr/local/share/nvim )
      run %( \(cd ~/.neovim/#{time} && make CMAKE_BUILD_TYPE=RelWithDebInfo && make install\) )
      run %( ln -s ~/.neovim/#{time} ~/.neovim/latest )
    end
  end

  # As per:
  # https://blog.backtick.consulting/neovims-built-in-lsp-with-ruby-and-rails/
  desc 'Install Rails YARD directives'
  task :rails do
    section 'Installing Rails YARD directives'

    run %( git clone https://gist.github.com/castwide/28b349566a223dfb439a337aea29713e #{DOTS_FOLDER}/misc/enhance-rails-intellisense-in-solargraph )
  end
end

namespace :update do
  desc 'Update Neovim'
  task :neovim do
    section 'Updating Neovim'

    unless testing?
      run %( rm ~/.neovim/backup )
      run %( mv ~/.neovim/latest ~/.neovim/backup )
      Rake::Task['install:neovim'].invoke
    end
  end

  # desc 'Update Neovim plugins'
  # task :neovim_plugins do
  #   section 'Updating Neovim plugins'
  #
  #   run %( nvim --headless "+Lazy! sync" +qa )
  # end

  desc 'Update Rails YARD directives'
  task :rails do
    section 'Updating Rails YARD directives'

    run %( git -C #{DOTS_FOLDER}/misc/enhance-rails-intellisense-in-solargraph pull )
  end
end

namespace :uninstall do
  desc 'Uninstall Neovim'
  task :neovim do
    section 'Uninstalling Neovim'

    unless testing?
      run %( rm ~/.neovim/backup )
      run %( mv ~/.neovim/latest ~/.neovim/backup )
      run %( rm -rf /usr/local/bin/nvim )
      run %( rm -rf /opt/homebrew/bin/nvim )
    end
  end
end
