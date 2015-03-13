namespace :db do
  desc "Erase and fill database"
  task :create_patients => :environment do

    [Physician, Patient].each(&:delete_all)

    physician = Physician.create(:name => "Dr. Smith")
    20.times do
        Patient.create(:physician_id => physician.id)    
    end   
  end
end