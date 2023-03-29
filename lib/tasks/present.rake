# frozen_string_literal: true

namespace :present do
  desc 'Load demo data'
  task :load, %i[file] => %i[environment db:drop db:create db:schema:load] do |_, args|
    sh "bundle exec rails db < #{args.file}"
  end
end
