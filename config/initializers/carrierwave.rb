#use file system in test and development
puts "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
puts "Carrierwave Initialization"
puts "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"

if Rails.env.development? || Rails.env.test?
	 puts "in development using file system "
		 
	CarrierWave.configure do |config|
		config.storage = :file
	end
else 
	puts "Production using S3"
		   
    CarrierWave.configure do |config|
	   	config.storage = :s3
	end 
end