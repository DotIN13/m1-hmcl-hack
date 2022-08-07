require 'shellwords'
require 'json'
require 'pathname'

# 1.19 vanilla works out of the box with java 17 or newer, and hence is not in need of this wrapper.
VERSIONS = [
  # 1.18 forge runs with java 17 or newer, and official lwjgl 3.3.1 native jars.
  # 1.16 forge runs with java 8 or newer, and official lwjgl 3.3.1 native jars.
  {
    versions: ['1.18', '1.16'], # versions keys are currently for documentation purposes only
    classpath: {
      remove: ['org/lwjgl'],
      append: ['./libraries/lwjgl-3.3.1']
    }
  },
  # 1.17 forge runs with java 17 or newer, unofficial lwjgl 3.2.1 native jars, and modified dylibs.
  # 1.15 forge runs with java 8 to 11, unofficial lwjgl 3.2.1 native jars, and modified dylibs.
  {
    versions: ['1.17', '1.15'],
    classpath: {
      remove: ['org/lwjgl'],
      append: ['./libraries/lwjgl-3.2.3']
    },
    library_path: {
      set: ['./natives/lwjgl-3.2.3']
    }
  },
  # 1.12 forge or older runs with java 8, unofficial lwjgl 2.9.4 native jars, and modified dylibs.
  {
    versions: ['<= 1.12'],
    classpath: {
      remove: ['org/lwjgl', 'ca/weblite/java-objc-bridge', 'com/mojang/text2speech', 'com/paulscode/soundsystem',
               'net/java/jinput', 'net/java/dev/jna', 'com/paulscode/librarylwjglopenal'],
      append: ['./libraries/lwjgl-2.9.4']
    },
    library_path: {
      set: ['./natives/lwjgl-2.9.4']
    }
  }
].freeze

# Determine minecraft version by reading the assets property of the client json.
# The id, jar and other properties can be arbitrarily changed in the launcher,
# and thus cannot be used to determine minecraft versions.
def assets_version
  version_json = "#{ENV['INST_DIR']}/#{ENV['INST_ID']}.json"
  json = JSON.parse(File.read(version_json))
  json['assets']
end

# Select config file based on the asset version
def select_config
  config = nil
  version = assets_version
  config = VERSIONS[0] if ['1.18', '1.16'].include? version
  config = VERSIONS[1] if ['1.17', '1.15'].include? version
  config = VERSIONS[2] if Gem::Version.new(version) <= Gem::Version.new('1.12')
  puts "Launching minecraft #{version}, using config for minecraft #{config[:versions].join(' and ')}." if config
  puts "No extra libraries needed for minecraft #{version}, launching directly." if config.nil?
  config
end

# Rewrite parameter --classpath to inject arm-compatible libraries
def rewrite_classpath(actions)
  return if actions.nil? || actions.empty?

  index = ARGV.index('-cp') + 1
  jars = ARGV[index].split(':')
  jars.reject! do |jarname|
    actions[:remove].any? { |path| jarname.start_with? "#{ENV['INST_MC_DIR']}/libraries/#{path}" }
  end
  new_path = actions[:append].map { |path| "#{File.expand_path(path, __dir__)}/*" }.join(':')
  ARGV[index] = "#{jars.join(':')}:#{new_path}"
end

# Rewrite parameter --Djava.library.path to inject arm-compatible natives
def rewrite_library_path(actions)
  return if actions.nil? || actions.empty?

  prefix = '-Djava.library.path='
  index = ARGV.index { |x| x.start_with? prefix }
  new_path = actions[:set].map { |path| File.expand_path(path, __dir__) }.join(':')
  ARGV[index] = "#{prefix}#{new_path}"
end

# Main function, rebuild args by rewriting classpaths and library paths
def rebuild_args
  config = select_config
  return if config.nil?

  rewrite_classpath(config[:classpath])
  rewrite_library_path(config[:library_path])
  puts ARGV
end

rebuild_args
exec ARGV.shelljoin
