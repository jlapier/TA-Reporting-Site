# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

# Create regions and states
united_states_and_territories = {
  'Southeast' => [
    {:name => 'Arkansas', :abbreviation => 'AR'},
    {:name => 'Alabama', :abbreviation => 'AL'},
    {:name => 'Florida', :abbreviation => 'FL'},
    {:name => 'Georgia', :abbreviation => 'GA'},
    {:name => 'Louisiana', :abbreviation => 'LA'},
    {:name => 'Mississippi', :abbreviation => 'MS'},
    {:name => 'Oklahoma', :abbreviation => 'OK'},
    {:name => 'Texas', :abbreviation => 'TX'},
    {:name => 'Puerto Rico', :abbreviation => 'PR'}
  ],
  'Mid-South' => [
    {:name => 'Kentucky', :abbreviation => 'KY'},
    {:name => 'North Carolina', :abbreviation => 'NC'},
    {:name => 'South Carolina', :abbreviation => 'SC'},
    {:name => 'Tennessee', :abbreviation => 'TN'},
    {:name => 'Virginia', :abbreviation => 'VA'},
    {:name => 'Delaware', :abbreviation => 'DE'},
    {:name => 'District of Columbia', :abbreviation => 'DC'},
    {:name => 'Maryland', :abbreviation => 'MD'},
    {:name => 'New Jersey', :abbreviation => 'NJ'},
    {:name => 'West Virginia', :abbreviation => 'WV'}
  ],
  'Northeast' => [
    {:name => 'Maine', :abbreviation => 'ME'},
    {:name => 'Vermont', :abbreviation => 'VT'},
    {:name => 'New Hampshire', :abbreviation => 'NH'},
    {:name => 'Massachusetts', :abbreviation => 'MA'},
    {:name => 'Rhode Island', :abbreviation => 'RI'},
    {:name => 'Connecticut', :abbreviation => 'CT'},
    {:name => 'New York', :abbreviation => 'NY'}
  ],
  'North Central' => [
    {:name => 'Minnesota', :abbreviation => 'MN'},
    {:name => 'Iowa', :abbreviation => 'IA'},
    {:name => 'Missouri', :abbreviation => 'MO'},
    {:name => 'Illinois', :abbreviation => 'IL'},
    {:name => 'Indiana', :abbreviation => 'IN'},
    {:name => 'Ohio', :abbreviation => 'OH'},
    {:name => 'Pennsylvania', :abbreviation => 'PA'},
    {:name => 'Michigan', :abbreviation => 'MI'},
    {:name => 'Wisconsin', :abbreviation => 'WI'}
  ],
  'Mountain Plains' => [
    {:name => 'North Dakota', :abbreviation => 'ND'},
    {:name => 'Montana', :abbreviation => 'MT'},
    {:name => 'Wyoming', :abbreviation => 'WY'},
    {:name => 'South Dakota', :abbreviation => 'SD'},
    {:name => 'Nebraska', :abbreviation => 'NE'},
    {:name => 'Utah', :abbreviation => 'UT'},
    {:name => 'Colorado', :abbreviation => 'CO'},
    {:name => 'Kansas', :abbreviation => 'KS'},
    {:name => 'New Mexico', :abbreviation => 'NM'},
    {:name => 'Arizona', :abbreviation => 'AZ'}
  ],
  'Western' => [
    {:name => 'Idaho', :abbreviation => 'ID'},
    {:name => 'Washington', :abbreviation => 'WA'},
    {:name => 'Oregon', :abbreviation => 'OR'},
    {:name => 'California', :abbreviation => 'CA'},
    {:name => 'Alaska', :abbreviation => 'AK'},
    {:name => 'Hawaii', :abbreviation => 'HI'},
    {:name => 'Nevada', :abbreviation => 'NV'}
  ]
}.each do |region_name, state_attributes|
  region = State.find_or_create_by_name(region_name)
  state_attributes.each do |state_attr|
    State.find_or_create_by_name(state_attr[:name], {
      :region_id => region.id,
      :abbreviation => state_attr[:abbreviation]
    })
  end
end
