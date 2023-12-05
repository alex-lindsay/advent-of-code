TEST_INPUT = <<~DATA
Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
DATA

TEST_ANSWER1 = 13
TEST_ANSWER2 = 30

def parse(input)
  input.lines.map do |line|
    label, content = line.split(": ")
    _, game = label.split(" ")
    winner_text, picked_text = content.split(" | ")
    winners = winner_text.split(" ").map(&:to_i)
    picked = picked_text.split(" ").map(&:to_i)
    {game: game.to_i, winners: winners, picked: picked}
  end
end

def add_picked_winners(game)
  game[:picked_winners] = game[:winners].intersection game[:picked]
  game
end

def add_score(game)
  game[:score] = game[:picked_winners].length > 0 ? 2 ** (game[:picked_winners].length-1) : 0
  game
end

def answer1(input)
  data = parse input
  # p "data1:", data
  data = data.map { |game| add_picked_winners game }
  # p "data2:", data
  data = data.map { |game| add_score game }
  # p "data3:", data
  data.sum(0) { |game| game[:score] }
end

def answer2(input)
  data = parse input
  # p "data1:", data
  data = data.map { |game| add_picked_winners game }
  # p "data2:", data
  data = data.map { |game| add_score game }
  # p "data3:", data
  data.each { |game| game[:instances] = 1 }
  data.each.with_index do |game, index|
    if game[:picked_winners].length > 0 then
      (1..game[:picked_winners].length).each do |game_offset|
        next_game = data[index + game_offset]
        next_game[:instances] += game[:instances]
      end
    end
  end
  p "data4", data
  data.sum(0) { |game| game[:instances] }
end

result1 = answer1(TEST_INPUT)
if result1 == TEST_ANSWER1 then
  p "Yay we matched"
  data = File.read($0.sub ".rb", ".txt")
  p answer1(data)

  result2 = answer2(TEST_INPUT)
  if result2 == TEST_ANSWER2 then
    p "Yay we matched"
    p answer2(data)
  end
else
  p "Boo we didn't match #{result1} != #{TEST_ANSWER1}"
end
