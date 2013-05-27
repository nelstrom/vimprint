require 'minitest/autorun'

def require_compiled_ragel(filepath)
  if system "ragel -R #{filepath.gsub(/\.\.\//, '')}.rl"
    require_relative filepath.sub(/\.\.\//, '')
  else
    puts "ragel failed to compile"
    exit!
  end
end
