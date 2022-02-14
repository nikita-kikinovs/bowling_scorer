class BowlingGameScorer
  SCORE_INPUT_REGEX = //

  attr_accessor :input

  def initialize(input_score)
    @input = input_score
    process_input
  end

  def calculate_score
  end

  private

  def process_input
  end
end

BowlingGameScorer.new(ARGV[0]).calculate_score
