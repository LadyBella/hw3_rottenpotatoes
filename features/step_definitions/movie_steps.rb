# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create!(movie)
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  if page.body.index(e1) >= page.body.index(e2) then 
    "Movies are in the wrong order" 
  else 
    true 
  end
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |not_selected, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  rating_list.split(",").each do |rating| 
    if not_selected then
      uncheck("ratings_#{rating.strip}")
    else
      check("ratings_#{rating.strip}")
    end
  end
end

When /I (un)?check all of the ratings/ do |not_selected|
  Movie.all_ratings.each do |rating|
    if not_selected then
      uncheck("ratings_#{rating.strip}")
    else
      check("ratings_#{rating.strip}")
    end
  end
end

Then /I should (not )?see movies rated: (.*)/ do |not_shown, rating_list|
  ratings = rating_list.split(",")
  ratings.each do |rating|
    if not_shown then 
      page.has_content?(rating.strip) == false
    else 
      page.has_content?(rating.strip) == true
    end
  end
end

Then /I should see (none|all) of the movies/ do |selection|
  if selection == 'none' then
    page.all("table#movies tbody tr").count == 0
  else
    page.all("table#movies tbody tr").count == Movie.all.count
  end
end
