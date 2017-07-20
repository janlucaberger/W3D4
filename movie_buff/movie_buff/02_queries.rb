def eighties_b_movies
  # List all the movies from 1980-1989 with scores falling between 3 and 5 (inclusive).
  # Show the id, title, year, and score.
  Movie.select(:id, :title, :yr, :score).where(yr: 1980..1989, score: 3..5)
end

def bad_years
  # List the years in which a movie with a rating above 8 was not released.

  # good_years = Movie.select(:yr).joins("LEFT OUTER JOIN movies above_eight ON movies.id = above_eight.id").where("above_eight.score > 8")
  # bad_years = Movie.select(:yr).distinct.where("yr NOT IN (?)", good_years)
  #
  # yrs = []
  # bad_years.each do |year|
  #   yrs << year.yr
  # end
  # yrs

  Movie.group(:yr).having('MAX(score) < 8').pluck(:yr)
end

def cast_list(title)
  # List all the actors for a particular movie, given the title.
  # Sort the results by starring order (ord). Show the actor id and name.

  Actor.select(:id, :name).joins(:movies).where("movies.title = ?", title).order("castings.ord")
end

def vanity_projects
  # List the title of all movies in which the director also appeared as the starring actor.
  # Show the movie id and title and director's name.

  # Note: Directors appear in the 'actors' table.
  # Actor.select("movies.id", :name, "movies.title").joins(:directed_movies).where("actor.id = movies.director_id")
  Movie.select(:id, :title, "actors.name").joins(:actors).where("movies.director_id = castings.actor_id AND castings.ord = 1")
end

def most_supportive
  # Find the two actors with the largest number of non-starring roles.
  # Show each actor's id, name and number of supporting roles.
  Actor.select(:id, :name, "COUNT(*) AS roles").joins(:movies).where("castings.ord != 1").group("actors.id").order('COUNT(*) DESC').limit(2)
end
