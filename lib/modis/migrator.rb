module Modis
  class Migrator
    def self.migrate(redis)
      new(redis).migrate
    end

    def self.migrations_key
      [Modis.config.namespace, '_modis_internal:migrations'].join(':')
    end

    def initialize(redis)
      @redis = redis
    end

    def migrate
      migrations.each { |id, cls| perform_migration(id, cls) }
    end

    private

    def perform_migration(id, cls)
      return if @redis.lindex(self.class.migrations_key, id)
      @redis.lpush(self.class.migrations_key, id)
      cls.new(@redis).perform
    end

    def migrations
      glob = File.join(File.dirname(__FILE__), 'migrations', '*.rb')

      @migrations ||= Dir.glob(glob).map do |file|
        id, name = File.basename(file).match(/^(\d+)_(.+)\.rb$/)[1..-1]
        load file
        cls = Modis::Migrations.const_get(name.camelize)
        [id.to_i, cls]
      end.sort_by { |pair| pair[0] }
    end
  end
end
