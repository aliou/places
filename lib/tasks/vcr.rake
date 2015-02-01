namespace :vcr do
  desc 'Remove all VCR cassettes'
  task :remove_cassettes => :environment do |t, args|
    if Rails.env.development? or Rails.env.test?
      Dir.glob('./spec/cassettes/*').each { |cassette| File.delete(cassette) }
      puts 'Remember to run `./bin/rspec`.'
    end
  end
end
