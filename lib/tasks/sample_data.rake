require 'factory_girl_rails'

namespace :db do

  desc "Populate the database with some sample data"

  task :populate => [:environment] do |t, args|

    puts "Resetting the database"
    Rake::Task['db:reset'].invoke

    puts "Creating 10 locations"
    location1 = FactoryGirl.create(:location, latitude: 44.41213, longitude: 26.165925)
    location2 = FactoryGirl.create(:location, latitude: 44.417475, longitude: 26.165271)
    location3 = FactoryGirl.create(:location, latitude: 44.415731, longitude: 26.164327)
    location4 = FactoryGirl.create(:location, latitude: 44.414731, longitude: 26.161478)
    location5 = FactoryGirl.create(:location, latitude: 44.413544, longitude: 26.160395)
    location6 = FactoryGirl.create(:location, latitude: 44.427881, longitude: 26.105833)
    location7 = FactoryGirl.create(:location, latitude: 44.42562, longitude: 26.103655)
    location8 = FactoryGirl.create(:location, latitude: 44.429367, longitude: 26.102148)
    location9 = FactoryGirl.create(:location, latitude: 44.434132, longitude: 26.021526)
    location10 = FactoryGirl.create(:location, latitude: 44.434937, longitude: 26.019809)
    locations = [location1, location2, location3, location4, location5, location6, location7, location8, location9, location10]

    puts "Creating events for these locations and media for all"
    events = []
    media = []
    locations.each_with_index do |l,index|
      event = FactoryGirl.create(:event, :location_id => l.id)
      events << event

      medium = FactoryGirl.create(:medium)
      media << medium
      l.media << medium

      medium = FactoryGirl.create(:medium)
      media << medium
      events[index].media << medium
    end

    puts "Creating 7 categories"
    ###
    #  0   1   2
    # / \ / \
    # 3 4 5 6
    ###

    categories = FactoryGirl.create_list(:category, 7)
    categories[3].parent_id = categories[0].id
    categories[3].save
    categories[4].parent_id = categories[0].id
    categories[4].save
    categories[5].parent_id = categories[1].id
    categories[5].save
    categories[6].parent_id = categories[1].id
    categories[6].save

    puts "Creating lists of events for categories"
      categories[3].events << events[0]
      categories[3].events << events[1]
      categories[4].events << events[2]
      categories[4].events << events[3]
      categories[5].events << events[4]
      categories[5].events << events[5]
      categories[6].events << events[6]
      categories[2].events << events[7]
      categories[2].events << events[8]
      categories[2].events << events[9]

    puts "Creating 5 users"
    users = FactoryGirl.create_list(:user, 5)
    puts "Creating a review for each event and location"
    puts "Creating a subscription for each category and location"
    users.each_with_index do |u,index|
      FactoryGirl.create(:review, :user_id => u.id, event: events[index])
      FactoryGirl.create(:review, :user_id => u.id, location: locations[index])
      FactoryGirl.create(:subscription, :user_id => u.id, category: categories[index])
      FactoryGirl.create(:subscription, :user_id => u.id, location: locations[index+2])
    end

    puts "Done!"
  end
end