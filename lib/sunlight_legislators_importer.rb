require 'csv'
require 'pry'
require_relative '../db/config'
require_relative '../app/models/politician'
require_relative '../app/models/party'
require_relative '../app/models/state'


class SunlightLegislatorsImporter
  def self.import(filename)
    csv = CSV.new(File.open(filename), :headers => true, :header_converters => :symbol)
    csv.each do |row|
      state = State.find_or_create_by_name(row[:state])
      party = Party.find_or_create_by_name(row[:party])
      Politician.create(:title => row[:title], :name => row[:firstname] + " " + row[:middlename] + " " + row[:lastname],
                        :email => row[:email], :phone => row[:phone], :fax => row[:fax], :website => row[:website], :gender => row[:gender],
                        :birthdate => row[:birthdate], :twitter_id => row[:twitter_id], :in_office => row[:in_office], :state => state, :party => party)
      # row.each do |field, value|
        # TODO: begin
        # raise NotImplementedError, "TODO: figure out what to do with this row and do it!"
        # TODO: end
      # end
    end
  end
end

begin
  raise ArgumentError, "you must supply a filename argument" unless ARGV.length == 1
  SunlightLegislatorsImporter.import(ARGV[0])
rescue ArgumentError => e
  $stderr.puts "Usage: ruby sunlight_legislators_importer.rb <filename>"
rescue NotImplementedError => e
  $stderr.puts "You shouldn't be running this until you've modified it with your implementation!"
end
