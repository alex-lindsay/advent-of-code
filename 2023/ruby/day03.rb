TEST_INPUT = <<~DATA
467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598..
DATA

TEST_ANSWER1 = 4361
TEST_ANSWER2 = 467835

def parse_input(val)
  numbers = []
  symbols = []
  val.each_line(chomp: true).with_index do |line, index|
    # print index, "\t", line, "\n"
    next_match = true
    offset = 0
    while next_match do
      next_match = line.match(/(\d+|[^.0123456789])/, offset)
      break unless next_match
      offset = next_match.offset(0)[1]
      value = next_match.captures[0]
      # print "\t", next_match.offset(0), "\t", value, "\n"
      if "0123456789".include? next_match.captures[0][0] then
        numbers.append({value: value.to_i, row: index, columns: next_match.offset(0)})
      else
        symbols.append({value: value, row: index, column: next_match.offset(0)[0]})
      end
    end
  end
  [numbers, symbols]
end

def valid_part_numbers(numbers, symbols)
  numbers.select do |number|
    symbols.any? do |symbol|
      ((number[:row]-1..number[:row]+1).include? symbol[:row]) &&
      ((number[:columns][0]-1..number[:columns][1]).include? symbol[:column])
    end
  end
end

def gears(symbols, numbers)
  (symbols.map do |symbol|
    neighbors = numbers.select do |number|
      ((symbol[:row]-1..symbol[:row]+1).include? number[:row]) &&
      ((number[:columns][0]-1) <= symbol[:column]) &&
      ((number[:columns][1]) >= symbol[:column]) &&
      (number[:value].is_a? Integer)
    end
    {symbol: symbol, neighbors: neighbors}
  end).select { |item| item[:neighbors].length == 2 }
end

def gear_ratio(gear)
  gear[:neighbors].reduce(1) { |res, item| res * item[:value] }
end

def answer1(val)
  numbers, symbols = parse_input(val)
  print "numbers:\n#{numbers}\nsymbols:\n#{symbols}\n\n"
  part_numbers = valid_part_numbers(numbers, symbols)
  # print "part_numbers:\n#{part_numbers}\n\n"
  part_numbers.sum { |item| item[:value] }
end

def answer2(val)
  numbers, symbols = parse_input(val)
  available_gears = gears(symbols, numbers)
  print "available_gears:\n#{available_gears}\n\n"
  ratios = available_gears.map { |gear| gear_ratio gear }
  print "ratios:\n#{ratios}\n\n"
  ratios.sum
end

test_result1 = answer1(TEST_INPUT)
print "test1: #{test_result1} == #{TEST_ANSWER1}? #{test_result1 == TEST_ANSWER1}\n\n"

data = File.read($0.sub ".rb", ".txt")
result1 = answer1(data)
print "result1: #{result1}\n\n"

test_result2 = answer2(TEST_INPUT)
print "test2: #{test_result2} == #{TEST_ANSWER2}? #{test_result2 == TEST_ANSWER2}\n\n"

result2 = answer2(data)
print "result2: #{result2}\n\n"
