desc 'Running Jekyll with --server --auto opition'
task :dev do
  system('jekyll --server --auto')
end

namespace :juicer do
  desc 'Merges stylesheets for production'
    task :css do
      sh 'juicer merge --force static/css/style.css static/css/syntax.css'
    end
  desc 'Merges JavaScripts'
    task :js do
      sh  'juicer merge -i --force _site/js/master.js'
    end
end

