# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create!(movie)
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  flunk "Unimplemented"
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  rating_list.split.each do |rating|
    step "I #{uncheck ? 'un' : ''}check \"ratings_#{rating.gsub(/,/,'')}\"" 
  end
end

Then /I should (not\s)?see movies with ratings: (.*)/ do |neg, rating_list|
  movies = Movie.find_all_by_rating(rating_list)
  movies.each do |movie|
    step "I should #{neg ? 'not ' : ''}see #{movie.title}"
  end
end

Then /I should see (all|none) (?:of )?the movies/ do |all|
  movies = Movie.all
  movie_table = []
  movies.each do |movie|
    movie_table << [movie.title, movie.rating, movie.release_date.to_s, "More info about #{movie.title}"]
  end
  if all
    page.has_table?(:movies, :rows => movie_table)
  else
    assert page.has_no_table?(:movies, :rows => {})
  end
end

Then /the checkboxes for all ratings should be checked/ do
  ratings = Movie.all_ratings
  ratings.each do |rating|
    step "the \"ratings_#{rating}\" checkbox within \"form#ratings_form\" should be checked"
  end
end
