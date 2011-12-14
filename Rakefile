desc 'Running Jekyll with --server --auto opition'
task :dev do
  system('jekyll --server --auto')
end

namespace :juicer do
  desc 'Merges stylesheets for production'
    task :css do
      sh 'juicer merge --force _site/static/css/*.css'
      sh 'mv _site/static/css/style.min.css _site/static/css/style.css'
    end
  desc 'Merges JavaScripts'
    task :js do
      sh  'juicer merge -i --force _site/js/master.js'
    end
end

