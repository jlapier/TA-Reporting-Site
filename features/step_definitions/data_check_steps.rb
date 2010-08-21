Then /the "(.*)" with a "(.*)" of "(.*)" should have a "(.*)" of "(.*)"/ do |obj_class, obj_attr, attr_val, obj_compare_attr, attr_compare_val|
  klass = obj_class.capitalize.constantize
  obj = klass.send("find_by_#{obj_attr.underscore}".to_sym, attr_val)
  obj.send(obj_compare_attr.underscore.to_sym).should == attr_compare_val
end

Then /the summary map cache should be cleared/ do
  Dir.entries(File.join(Rails.root, "public")).should_not include("summary_reports")
end