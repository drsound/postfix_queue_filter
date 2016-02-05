#!/usr/bin/env ruby

require 'optparse'

def postqueue
  lines = `postqueue -p`.split(/\n/)
  lines.grep(/^[0-9A-F]{9}/).map { |line| line.gsub(/[!*\s].*/, '') }
end

def postcat(id)
  `postcat -q -h '#{id}'`.split(/\n/)
end

def delete(id)
  `postsuper -d '#{id}'`
end

options = {}
parser = OptionParser.new do |opts|
  opts.banner = "Usage: #{File.basename($0)} [OPTION]... FILTER..."
  opts.on('-d', '--delete', 'Delete matching messages from mail queue') { options[:delete] = true }
  opts.on('-h', '--headers', 'Dump matched messages headers') { options[:dump_headers] = true }
  opts.on('-r', '--regexp', 'Filters are regular expressions') { options[:regexp] = true }
end

begin
  parser.parse!
  raise OptionParser::ParseError if ARGV.size < 1
rescue OptionParser::ParseError
  puts parser.help
  exit 1
end

matches = []
queue_ids = postqueue
queue_ids.each.with_index(1) do |id, i|
  puts "Examining message #{i}/#{queue_ids.size}: #{id}"
  if ARGV.all? do |filter|
    if options[:regexp]
      postcat(id).grep(Regexp.new(filter)).size > 0
    else
      postcat(id).any? { |line| line.include?(filter) }
    end
  end
    matches << id
    puts postcat(id) if options[:dump_headers]
  end
end

puts "Matched #{matches.size} message ids:"
matches.each { |id| puts id }

if options[:delete]
  matches.each.with_index(1) do |id, i|
    puts "Deleting message #{i}/#{matches.size}: #{id}"
    delete(id)
  end
end