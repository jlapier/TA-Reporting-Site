# Create first user
if User.count < 1
  User.create!({
    :email => 'first.user@example.com',
    :password => 'first.user.password',
    :password_confirmation => 'first.user.password'
  })
end

# Create Collaborating Agencies
[
  {:name => 'Regional Resource Center Program', :abbrev => 'RRCP'},
  {:name => 'National Secondary Transition Technical Assistance Center', :abbrev => 'NSTTAC'}
].each do |agency|
  CollaboratingAgency.find_or_create_by_name(agency[:name], {
    :abbrev => agency[:abbrev]
  })
end

# Create Objectives
{
  'Objective' => [
    {:number => 1, :name => 'Knowledge Development'},
    {:number => 2, :name => 'Provide TA'},
    {:number => 3, :name => 'Leadership and Coordination'},
    {:number => 4, :name => 'Evaluate and Manage (includes Advisory)'}
  ],
  'ActivityType' => [
    {:name => 'Information Request'},
    {:name => 'Teleconference/webinar'},
    {:name => 'Conference'},
    {:name => 'Consult - Phone/email/in-person'},
    {:name => 'Consult - onsite'},
    {:name => 'Workshop'}
  ],
  'IntensityLevel' => [
    {:name => 'General/Universal', :number => 1},
    {:name => 'Targeted/Specific', :number => 2},
    {:name => 'Intensive/Sustained', :number => 3}
  ],
  'TaCategory' => [
    {:name => 'Data collection activities'},
    {:name => 'SLDS'},
    {:name => 'Technical Details of the SPP/APR'},
    {:name => 'Reporting and Data Use'},
    {:name => 'Improvement Activities'}
  ]
}.each do |type, items|
  items.each do |item|
    type.constantize.send(:find_or_create_by_name, item[:name]) unless item[:number]
    type.constantize.send(:find_or_create_by_name, item[:name], {
      :number => item[:number]
    }) if item[:number]
  end
end

# Create regions and states
{
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
    {:name => 'Nebraska', :abbreviation => 'NB'},
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
    {:name => 'Nevada', :abbreviation => 'NV'},
    {:name => 'Federated States of Micronesia', :abbreviation => 'FSM'},
    {:name => 'Guam', :abbreviation => 'GU'},
    {:name => 'Commonwealth of the Northern Marianna Islands', :abbreviation => 'CNMI'},
    {:name => 'Republic of Palau', :abbreviation => 'RP'},
    {:name => 'Republic of the Marshall Islands', :abbreviation => 'RMI'},
    {:name => 'Virgin Islands', :abbreviation => "VI"}
  ],
  'Foreign' => [
    {:name => "Burundi", :abbreviation => 'BI'}
  ]
}.each do |region_name, state_attributes|
  region = State.find_or_create_by_name(region_name)
  if region.valid?
    state_attributes.each do |state_attr|
      State.find_or_create_by_name(state_attr[:name], {
        :region_id => region.id,
        :abbreviation => state_attr[:abbreviation]
      })
    end
  else
    puts "Invalid Region: #{region_name} - #{region.errors.full_messages}"
  end
end
