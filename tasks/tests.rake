namespace :tests do
  desc "Setup tests"
  task :setup do
    section "Setting up the tests"

    run %( cp #{DOTS_FOLDER}/tests/stubs/app_store.txt #{DOTS_FOLDER}/misc/packages/app_store.txt)
    run %( cp #{DOTS_FOLDER}/tests/stubs/python_pip.txt #{DOTS_FOLDER}/misc/packages/python_pip.txt)
    run %( cp #{DOTS_FOLDER}/tests/stubs/ruby_gems.txt #{DOTS_FOLDER}/misc/packages/ruby_gems.txt)
    run %( cp #{DOTS_FOLDER}/tests/stubs/brew_taps.txt #{DOTS_FOLDER}/misc/packages/brew_taps.txt)
    run %( cp #{DOTS_FOLDER}/tests/stubs/brew_packages.txt #{DOTS_FOLDER}/misc/packages/brew_packages.txt)
    run %( cp #{DOTS_FOLDER}/tests/stubs/brew_cask.txt #{DOTS_FOLDER}/misc/packages/brew_cask.txt)
  end
end

