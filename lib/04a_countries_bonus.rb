# == Schema Information
#
# Table name: countries
#
#  name        :string       not null, primary key
#  continent   :string
#  area        :integer
#  population  :integer
#  gdp         :integer

require_relative './sqlzoo.rb'

# BONUS QUESTIONS: These problems require knowledge of aggregate
# functions. Attempt them after completing section 05.

def highest_gdp
  # Which countries have a GDP greater than every country in Europe? (Give the
  # name only. Some countries may have NULL gdp values)
  execute(<<-SQL)
    SELECT
      countries.name
    FROM
      countries
    WHERE
      countries.gdp > (
        SELECT
          MAX(countries.gdp)
        FROM
          countries
        WHERE
          countries.continent = 'Europe'
      )
  SQL
end

def largest_in_continent
  # Find the largest country (by area) in each continent. Show the continent,
  # name, and area.
  execute(<<-SQL)
  SELECT
    countries.continent,
    countries.name,
    countries.area
  FROM
    countries AS countries
  WHERE
    countries.area = (
      SELECT
        MAX(biggest_countries.area)
      FROM
         countries AS biggest_countries
      WHERE
        countries.continent = biggest_countries.continent
    );
  SQL
end

def large_neighbors
  # Some countries have populations more than three times that of any of their
  # neighbors (in the same continent). Give the countries and continents.
  execute(<<-SQL)
      SELECT
        countries.name, countries.continent
      FROM
        countries
      WHERE
        countries.population > 3 * (
          SELECT
            MAX(most_populous_countries.population)
          FROM
             countries AS most_populous_countries
          WHERE
            countries.continent = most_populous_countries.continent
              AND countries.name <> most_populous_countries.name
        )
  SQL
end
