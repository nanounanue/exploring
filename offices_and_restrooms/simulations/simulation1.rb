# -*- coding: utf-8 -*-
require 'csv'

# Importamos los modelos
require_relative '../models/constants'
require_relative '../models/person'
require_relative '../models/facility'
require_relative '../models/restroom'


frequency = 3                # Número de veces que una persona en 540 minutos va al baño (en promedio)
facilities_per_restroom = 3  # Urinales por baño
use_duration = 1             # Cuánto tiempo una persona usa el urinal
population_range = 10..600   # Rango de personas que usaremos en la simulación

data = {}                    # Hash donde guardamos los datos de la simulación

population_range.step(10).each do |population_size|
  Person.population.clear
  population_size.times{ Person.population << Person.new(frequency, use_duration) }
  data[population_size] = []

  restroom = Restroom.new facilities_per_restroom

  DURATION.times do |t|
    data[population_size] << restroom.queue.size
    queue = restroom.queue.clone
    restroom.queue.clear
    unless queue.empty?
      restroom.enter queue.shift
    end
    Person.population.each do |person|
      if person.need_to_go?
        restroom.enter person
      end
    end
    restroom.tick
  end
end


CSV.open('simulation1.csv', 'w') do |csv|
  lbl = []
  population_range.step(10).each { |population_size| lbl << population_size }
  csv << lbl
  
  DURATION.times do |t|
    row = []
    population_range.step(10).each do |population_size|
      row << data[population_size][t]
    end
    csv << row
  end
end


  
