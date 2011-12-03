
module Jekyll
  
  
  # The AuthorIndex class creates a single author page for the specified author
  class AuthorIndex < Page
    
    # Initializes a new CategoryIndex.
    #
    #  +base+         is the String path to the <source>.
    #  +author_dir+ is the String path between <source> and the author folder.
    #  +author+     is the author currently being processed.
    def initialize(site, base, author_dir, author, global)
      @site = site
      @base = base
      @dir  = author_dir
      @name = 'index.html'
      self.process(@name)
      if global == true
        self.read_yaml(File.join(base, '_layouts'), 'list_authors.html')
        self.data['bylines'] = author
        # Set the title for this page.
        self.data['title']       = "List of all authors"
        # Set the meta-description for this page.
        self.data['description'] = self.data['title'] 
      else
        # Read the YAML data from the layout page.
        self.read_yaml(File.join(base, '_layouts'), 'posts_by_author.html')
        self.data['byline']      = author.capitalize
        # Set the title for this page.
        title_prefix             =  'Articles by'
        self.data['title']       = "#{title_prefix} #{author.capitalize}"
        # Set the meta-description for this page.
        self.data['description'] = self.data['title'] 

      end
    end
    
  end
  
  
  # The Site class is a built-in Jekyll class with access to global site config information.
  class Site
    
    # Creates an instance of AuthorIndex for each author, renders it, and 
    # writes the output to a file.
    #
    #  +author_dir+ is the String path to the author folder.
    #  +category+     is the author currently being processed.
    
    # renders the author page
    def write_author_index(author_dir, author, global)
      index = AuthorIndex.new(self, self.source, author_dir, author, global)
      index.render(self.layouts, site_payload)
      index.write(self.dest)
      # Record the fact that this page has been added, otherwise Site::cleanup will remove it.
      self.pages << index
    end
      
    
    # Loops through the list of author and processes each one.
    def write_authors_index
      prefix = self.config['post_by_author_dir']
      authors = self.config['authors']
      global = false
      authors.each do |author|
        self.write_author_index(File.join(prefix, author), author, global) 
      end
      global = true
      self.write_author_index(File.join(prefix), authors, global)
    end
    
  end
  
  
  # Jekyll hook - the generate method is called by jekyll, and generates all of the category pages.
  class GeneratePostByAuthor < Generator
    safe true
    priority :low

    def generate(site)
      puts "Generating posts by author folder..."
      site.write_authors_index
    end

  end
  
end
