TEST_INPUT = <<~DATA
Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
DATA

TEST_CRITERION = {red: 12, green: 13, blue: 14}

TEST_ANSWER = 8

TEST_POWERS = [48, 12, 1560, 630, 36]

TEST_ANSWER2 = 2286

def parse_set(val)
  amount, color = val.split " "
  return { color.to_sym => amount.to_i }
end

def parse_round(val)
  val.split(", ").map { |set| parse_set set }
    .reduce({}) { |obj, val| obj.merge val }
end

def parse_rounds(val)
  id, rounds = val.split ": "
  return {
    id: id[5..-1].to_i,
    rounds: rounds.split("; ").map { |round| parse_round round }
  }
end

def maximum_viable_round(val)
  # print "maximum_viable_round\n"
  result = val.reduce({}) do |obj, round|
    # print "obj", obj, "\n"
    # print "round", round, "\n"
    keys = obj.keys | round.keys
    # print "keys", keys, "\n"
    values = keys.map do |key|
      (obj.include? key) ?
        ((round.include? key) ? [obj[key], round[key]].max : obj[key]) : round[key]
    end
    # print "values", values, "\n"
    pairs = keys.zip values
    pairs.to_h
  end
  # print  "result", result, "\n\n"
  result
end

def parsed_input(val)
  games = val.split "\n"
  result = games.map { |game| parse_rounds game }
  # print "parsed_input:\n", result, "\n\n"
  result
end

def viable_games(games, required)
  games.select do |game|
    result = required.none? do |key, maximum_val|
      fails = (game[:maximum].include? key) && (game[:maximum][key] > maximum_val)
      # print game[:id], ' ', key, ' game ', game[:maximum][key], ' limit ', maximum_val, ' ', fails, "\n"
      fails
    end
    # print game[:id], ' ', result, "\n"
    result
  end
end

def answer(val)
  game_rounds = parsed_input val
  maximums = game_rounds.map { |game| {id: game[:id], maximum: (maximum_viable_round game[:rounds]) } }
  # print "maximums:\n", maximums, "\n\n"
  viable = viable_games maximums, TEST_CRITERION
  # print "viable:\n", viable, "\n\n"
  viable.reduce(0) { |sum, game| sum + game[:id] }
end

def answer2(val)
  game_rounds = parsed_input val
  maximums = game_rounds.map { |game| {id: game[:id], maximum: (maximum_viable_round game[:rounds]) } }
  # print "maximums:\n", maximums, "\n\n"
  # viable = viable_games maximums, TEST_CRITERION
  # print "viable:\n", viable, "\n\n"
  maximums.reduce(0) { |sum, game| sum + power(game) }
end

def power(val)
  result = val[:maximum][:red] * val[:maximum][:blue] * val[:maximum][:green]
  print val[:id], ": ", val[:maximum][:red], ' ', val[:maximum][:blue], ' ', val[:maximum][:green], " = ", result, "\n"
  result
end

print "criterion:", TEST_CRITERION, "\n\n"
print "answer:", (answer TEST_INPUT), "\n\n"

test_result = answer TEST_INPUT

if test_result == TEST_ANSWER2 then
  data = File.read($0.sub ".rb", ".txt")
  print (answer data)
end

print "answer2:", (answer2 TEST_INPUT), "\n\n"
if test_result == TEST_ANSWER then
  data = File.read($0.sub ".rb", ".txt")
  print (answer2 data)
end
