# Jekyll category page generator.
# http://recursive-design.com/projects/jekyll-plugins/
#
# Version: 0.1.8-feed
#
# Copyright (c) 2010 Dave Perrett, http://recursive-design.com/
# Licensed under the MIT license (http://www.opensource.org/licenses/mit-license.php)
#
# A generator that creates category pages for jekyll sites.
#
# Feed version by Martin Richard for Isbullsh.it, add feeds per category.
#
# To use it, simply drop this script into the _plugins directory of your Jekyll site. You should 
# also create a file called 'category_index.html' in the _layouts directory of your jekyll site 
# with the following contents (note: you should remove the leading '# ' characters):
#
# ================================== COPY BELOW THIS LINE ==================================
# ---
# layout: default
# ---
# 
# <h1 class="category">{{ page.title }}</h1>
# <ul class="posts">
# {% for post in site.categories[page.category] %}
#     <div>{{ post.date | date_to_html_string }}</div>
#     <h2><a href="{{ post.url }}">{{ post.title }}</a></h2>
#     <div class="categories">Filed under {{ post.categories | category_links }}</div>
# {% endfor %}
# </ul>
# ================================== COPY ABOVE THIS LINE ==================================
# 
# You can alter the _layout_ setting if you wish to use an alternate layout, and obviously you
# can change the HTML above as you see fit. 
#
# When you compile your jekyll site, this plugin will loop through the list of categories in your 
# site, and use the layout above to generate a page for each one with a list of links to the 
# individual posts.
#
# Included filters :
# - category_links:      Outputs the list of categories as comma-separated <a> links.
# - date_to_html_string: Outputs the post.date as formatted html, with hooks for CSS styling.
#
# Available _config.yml settings :
# - category_dir:          The subfolder to build category pages in (default is 'categories').
# - category_title_prefix: The string used before the category name in the page title (default is 
#                          'Category: ').
module Jekyll


  # The CategoryIndex class creates a single category page for the specified category.
  class CategoryIndex < Page

    # Initializes a new CategoryIndex.
    #
    #  +base+         is the String path to the <source>.
    #  +category_dir+ is the String path between <source> and the category folder.
    #  +category+     is the category currently being processed.
    def initialize(site, base, category_dir, category, *all_tags)
      @site = site
      @base = base
      @dir  = category_dir
      @name = 'index.html'
      self.process(@name)
      if category != "index"
        # Read the YAML data from the layout page.
        self.read_yaml(File.join(base, '_layouts'), 'category_index.html')
        self.data['tag']         = category
        # Set the title for this page.
        title_prefix             = site.config['tag_page_title_prefix'] || 'Articles'
        self.data['title']       = "#{title_prefix} #{category.capitalize}"
        # Set the meta-description for this page.
        meta_description_prefix  = site.config['category_meta_description_prefix'] || 'Category: '
        self.data['description'] = "#{meta_description_prefix}#{category}"
      elsif all_tags
        self.read_yaml(File.join(base, '_layouts'), 'category_list.html')
        self.data['tag'] = "tag_index"
        self.data['title']     = site.config['tag_list_page_title'] || 'List of article tags'
      end
    end

  end

  # The CategoryFeed class creates a single category page for the specified category.
  class CategoryFeed < Page

    # Initializes a new CategoryRss.
    #
    #  +base+         is the String path to the <source>.
    #  +category_dir+ is the String path between <source> and the category folder.
    #  +category+     is the category currently being processed.
    def initialize(feedtype, site, base, category_dir, category, *all_tags)
      @site = site
      @base = base
      @dir  = category_dir
      @name = "#{feedtype}.xml"
      self.process(@name)
      if category != "index"
        # Read the YAML data from the layout page.
        self.read_yaml(File.join(base, '_layouts'), "category_#{feedtype}.xml")
        self.data['tag']         = category
        # Set the title for this page.
        title_prefix             = site.config['tag_page_title_prefix'] || 'Articles'
        self.data['title']       = "#{title_prefix} #{category.capitalize}"
        # Set the meta-description for this page.
        meta_description_prefix  = site.config['category_meta_description_prefix'] || 'Category: '
        self.data['description'] = "#{meta_description_prefix}#{category}"
      elsif all_tags
        self.read_yaml(File.join(base, '_layouts'), "category_#{feedtype}.xml")
        self.data['tag'] = "tag_index"
        self.data['title']     = site.config['tag_list_page_title'] || 'List of article tags'
      end
    end

  end


  # The Site class is a built-in Jekyll class with access to global site config information.
  class Site

    # Creates an instance of CategoryIndex for each category page, renders it, and 
    # writes the output to a file.
    #
    #  +category_dir+ is the String path to the category folder.
    #  +category+     is the category currently being processed.
    def write_category_index(category_dir, category, *all_tags)
      if all_tags
        index = CategoryIndex.new(self, self.source, category_dir, category, all_tags)
        rss = CategoryFeed.new('rss', self, self.source, category_dir, category, all_tags)
        atom = CategoryFeed.new('atom', self, self.source, category_dir, category, all_tags)
      else
        index = CategoryIndex.new(self, self.source, category_dir, category)
        rss = CategoryFeed.new('rss', self, self.source, category_dir, category)
        atom = CategoryFeed.new('atom', self, self.source, category_dir, category)
      end
      index.render(self.layouts, site_payload)
      index.write(self.dest)
      rss.render(self.layouts, site_payload)
      rss.write(self.dest)
      atom.render(self.layouts, site_payload)
      atom.write(self.dest)

      # Record the fact that this page has been added, otherwise Site::cleanup will remove it.
      self.pages << index
      self.pages << rss
      self.pages << atom
    end


    # Loops through the list of category pages and processes each one.
    def write_category_indexes
      if self.layouts.key? 'category_index'
        dir = self.config['category_dir'] || 'categories'
        self.tags.keys.each do |category| # hack: categories -> tags
          self.write_category_index(File.join(dir, category), category)  
        end
        all_tags = self.tags.keys
        self.write_category_index(File.join(dir), "index", all_tags)

      # Throw an exception if the layout couldn't be found.
      else
        throw "No 'category_index' layout found."
      end
    end

  end


  # Jekyll hook - the generate method is called by jekyll, and generates all of the category pages.
  class GenerateCategories < Generator
    safe true
    priority :low

    def generate(site)
      puts "Generating tag folders..."
      site.write_category_indexes
    end

  end

  # Adds some extra filters used during the category creation process.
  module Filters

    # Outputs a list of categories as comma-separated <a> links. This is used
    # to output the category list for each post on a category page.
    #
    #  +categories+ is the list of categories to format.
    #
    # Returns string
    def category_links(categories)
      categories = categories.sort!.map do |item|
        '<a href="/blog/category/'+item+'/">'+item+'</a>'
      end

      connector = "and"
      case categories.length
      when 0
        ""
      when 1
        categories[0].to_s
      when 2
        "#{categories[0]} #{connector} #{categories[1]}"
      else
        "#{categories[0...-1].join(', ')}, #{connector} #{categories[-1]}"
      end
    end

    # Outputs the post.date as formatted html, with hooks for CSS styling.
    #
    #  +date+ is the date object to format as HTML.
    #
    # Returns string
    def date_to_html_string(date)
      result = '<span class="month">' + date.strftime('%b').upcase + '</span> '
      result += date.strftime('<span class="day">%d</span> ')
      result += date.strftime('<span class="year">%Y</span> ')
      result
    end

  end

end
