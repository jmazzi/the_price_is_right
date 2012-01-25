require 'the_price_is_right/version'
require 'github_api'
require 'retryable'
require 'awesome_print'

begin
  require File.join(ENV['HOME'], '.the_price_is_right')
rescue LoadError
  puts "Please create a ~/.the_price_is_right.rb file with your Github config"
  puts "\nExample:\n
    Github.configure do |config|
      config.oauth_token   = 'token'

      # OR

      config.basic_auth    = 'username:password'
    end

    See https://github.com/peter-murach/github for more info
  "
  exit
end

module ThePriceIsRight
  class Repo
    attr_reader :github

    def initialize(github)
      @github = github
    end

    def all
      @all ||= github.repos.repos(per_page: 100).sort_by { |repo| repo['watchers'] }.reverse
    end

    def owned
      @owned ||= all.reject { |repo| repo['fork'] }
    end

    def forked
      @forked ||= all.select { |repo| repo['fork'] }
    end

    def with_language(language, opts = {})
      scope = opts[:owned] ? owned : all
      scope.select { |repo| repo['language'] == language }
    end
  end

  class User
    attr_reader :user, :repos, :gists, :github

    def initialize(user)
      @user   = user
      @github = Github.new(user: user)
    end

    def repos
      Retryable.retryable :times => 3, :sleep => 5 do
        @repos ||= Repo.new(github)
      end
    end

    def gists
      @gists ||= github.gists.gists
    end

    def watching
      @watching ||= repos.watched
    end
  end

  class << self
    def spin(user)
      User.new(user)
    end

    def commit_count_for(user, repo)
      Retryable.retryable :times => 3, :sleep => 2 do
        user.github.repos.commits(user.user, repo).size
      end
    end

    def overview(username, max = :all)
     user      = self.spin(username)
     repo_info = []
     count     = 0

     user.repos.owned.each do |repo|
       break if max.kind_of?(Integer) && count == max
       info = {
         name:       repo['name'],
         watchers:   repo['watchers'],
         commits:    commit_count_for(user, repo['name']),
         language:   repo['language'],
         created_at: repo['created_at'],
         updated_at: repo['updated_at'],
         url:        repo['html_url'],
         homepage:   repo['homepage'],
         issues:     repo['open_issues'],
       }
       repo_info << info
       count += 1
     end
     repo_info
    end
  end # self

end
