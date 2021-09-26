FactoryBot.define do
  factory :blog do
    title { Faker::Lorem.characters(number: 10) }
    body { Faker::Lorem.characters(number: 30) }
    image {Rack::Test::UploadedFile.new(File.join(Rails.root, 'app/assets/images/no_image.jpg')) }
  end
end