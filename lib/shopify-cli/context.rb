# frozen_string_literal: true
require 'shopify_cli'

module ShopifyCli
  class Context
    attr_writer :app_metadata
    attr_accessor :root

    def initialize
      @env = ($original_env || ENV).clone
    end

    def getenv(name)
      v = @env[name]
      v == '' ? nil : v
    end

    def print_task(text)
      puts CLI::UI.fmt("{{yellow:*}} #{text}")
    end

    def write(fname, content)
      File.write(File.join(@root, fname), content)
    end

    def puts(*args)
      Kernel.puts(CLI::UI.fmt(*args))
    end

    def spawn(*args)
      Kernel.spawn(*args)
    end

    def method_missing(method, *args)
      if CLI::Kit::System.respond_to?(method)
        CLI::Kit::System.send(method, *args)
      else
        super
      end
    end

    def respond_to_missing?(method, include_private = false)
      if CLI::Kit::System.respond_to?(method)
        true
      else
        super
      end
    end

    def app_metadata
      @app_metadata ||= {}
    end
  end
end