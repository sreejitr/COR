class AddPhoneNumberToPatient < ActiveRecord::Migration
  def change
    add_column :patients, :phone_number, :string
  end
end
