class BowlingGameScorer
  SCORE_INPUT_REGEX = /\A((10|[0-9]),){10,20}(10|[0-9])\z/

  attr_accessor :input

  def initialize(input_score)
    @input = input_score
    process_input
  end

  def calculate_score
  end

  private

  def process_input
    print_invalid_input_message unless input.match(SCORE_INPUT_REGEX)

    splitted = input.split(',').map(&:to_i)
    processed = []
    skip_next = false

    splitted.each_with_index do |throw, i|
      if skip_next
        skip_next = false
        next
      end

      if processed.size == 9
        processed << splitted[i..]
        break
      end

      case throw
        when 10
          processed << [throw]
        when 0..9
          processed << [throw, splitted[i + 1]]
          skip_next = true
      end
    end

    @input = processed

    print_invalid_frame_message unless valid_frames?
    print_invalid_last_frame_message unless valid_last_frame?
  end

  def valid_frames?
    input.count == 10 && input[0..8].all? { |frame| frame.sum <= 10 }
  end

  def valid_last_frame?
    frame = input.last
    valid_last_frame_two_throws?(frame) || valid_last_frame_three_throws?(frame)
  end

  def valid_last_frame_two_throws?(frame)
    frame.size == 2 && frame.sum < 10
  end

  def valid_last_frame_three_throws?(frame)
    frame.size == 3 && (strike?([frame.first]) || spare?(frame.first(2)))
  end

  def strike?(frame)
    frame.first == 10 && frame.size == 1
  end

  def spare?(frame)
    !strike?(frame) && frame.first(2).sum == 10
  end

  def print_invalid_input_message
    abort 'Invalid input! First argument should be a numbers of pins ' \
          'knocked down by each ball separated by commas without spaces!'
  end

  def print_invalid_last_frame_message
    abort 'Invalid last (10th) frame!'
  end

  def print_invalid_frame_message
    abort 'Invalid frame count or frame scores!'
  end
end

# Comment line below when running tests
BowlingGameScorer.new(ARGV[0]).calculate_score
