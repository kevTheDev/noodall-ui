When /^today is "([^\"]*)"$/ do |date|
  Time.stub!(:now).and_return(date.to_time)
end

When /^I publish the content$/ do
  visit noodall_admin_node_path(@_content)
  click_button('Publish')
end

When /^I hide the content$/ do
  visit noodall_admin_node_path(@_content)
  click_button('Hide')
end

Then /^the content should (not |)be visible on the website$/ do |is_not|
  if is_not.blank?
    visit node_path(@_content)
    page.should within('#content h1') { have_content(@_content.title) }
  else
    visit node_path(@_content)
    page.should have_content("The page you were looking for doesn't exist")
  end
end

Given /^I publish content between "([^\"]*)" and "([^\"]*)"$/ do |from, to|
  visit noodall_admin_node_path(@_content)
  select_datetime(from.to_time, :from => 'Publish at')
  select_datetime(to.to_time, :from => 'Publish until')
  click_button('Publish')
  page.should have_content('was successfully published')
end


Given /^published content exists with publish to date: "([^\"]*)"$/ do |time|
  time = time.to_time
  @_content = Factory(:page_a, :published_at => time.yesterday, :published_to => time)
end

When /^I am editing the content$/ do
  visit noodall_admin_node_path(@_content)
end

When /^I clear the publish to date$/ do
  5.times{ |i|   select("", :from => "node[published_to(#{i+1}i)]" ) }
  click_button 'Publish'
end
