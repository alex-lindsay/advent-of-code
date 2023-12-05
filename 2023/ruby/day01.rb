TEST_INPUT = <<~DATA
1abc2
pqr3stu8vwx
a1b2c3d4e5f
treb7uchet
DATA

TEST_INPUT_LINES = TEST_INPUT.split("\n")

TEST_RESULTS = <<~DATA
12
38
15
77
DATA

TEST_ANSWER = 142

DIGITS = ["zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]
REVERSED_DIGITS = DIGITS.map { |v| v.reverse }

def first_digit(value)
  digit = value[/\d|one|two|three|four|five|six|seven|eight|nine/]
  (DIGITS.include? digit) ? DIGITS.index(digit).to_s : digit
end

def last_digit(value)
  digit = value.reverse[/\d|eno|owt|eerht|ruof|evif|xis|neves|thgie|enin/]
  (REVERSED_DIGITS.include? digit) ? REVERSED_DIGITS.index(digit).to_s : digit
end

def decoded(value)
  (first_digit value) + (last_digit value)
end

def answer(data)
  lines = data.split("\n")
  p lines
  decoded_lines = lines.map { |val| decoded val }
  p decoded_lines
  result = decoded_lines.reduce(0) { |sum, val| sum + val.to_i }
  p result
  result
end

test_result = answer TEST_INPUT

if test_result == TEST_ANSWER then
  data = File.read($0.sub ".rb", ".txt")
  print (answer data)
end
