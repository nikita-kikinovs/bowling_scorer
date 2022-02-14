class BowlingGameScorer
  FRAME_COUNT = 10
  FRAME_MAX_SCORE = 10
  SCORE_INPUT_REGEX = /\A((10|[0-9]),){10,20}(10|[0-9])\z/

  attr_accessor :input, :frame_scores

  def initialize(input_score)
    @input = input_score
    process_input
  end

  def print_game_score
    puts "Frame scores are: #{frame_scores}\nGame score is: #{frame_scores.last}"
  end

  def frame_scores
    @frame_scores ||= calculate_frame_scores
  end

  private

  def calculate_frame_scores
    frame_scores = []

    input.each_with_index do |frame, i|
      if i > 0
        frame_scores[i - 1] += frame.first if spare?(input[i - 1])
        frame_scores[i - 1] += frame.first(2).sum if strike?(input[i - 1])
      end

      if i > 1 && strike?(input[i - 2]) && strike?(input[i - 1])
        frame_scores[i - 2] += frame.first
        frame_scores[i - 1] += frame.first
      end

      frame_scores << (frame_scores[i - 1].to_i + frame.sum)
    end

    frame_scores
  end

  def process_input
    print_invalid_input_message unless input&.match(SCORE_INPUT_REGEX)

    splitted = input.split(',').map(&:to_i)
    processed = []
    skip_next = false

    splitted.each_with_index do |throw, i|
      if skip_next
        skip_next = false
        next
      end

      if processed.size == FRAME_COUNT - 1
        processed << splitted[i..]
        break
      end

      case throw
        when FRAME_MAX_SCORE
          processed << [throw]
        when 0..FRAME_MAX_SCORE - 1
          processed << [throw, splitted[i + 1]]
          skip_next = true
      end
    end

    @input = processed

    print_invalid_frame_message unless valid_frames?
    print_invalid_last_frame_message unless valid_last_frame?
  end

  def valid_frames?
    input.count == FRAME_COUNT && input[0..FRAME_COUNT - 2].all? { |frame| frame.sum <= FRAME_MAX_SCORE }
  end

  def valid_last_frame?
    frame = input.last
    valid_last_frame_two_throws?(frame) || valid_last_frame_three_throws?(frame)
  end

  def valid_last_frame_two_throws?(frame)
    frame.size == 2 && frame.sum < FRAME_MAX_SCORE
  end

  def valid_last_frame_three_throws?(frame)
    frame.size == 3 && (strike?([frame.first]) || spare?(frame.first(2)))
  end

  def strike?(frame)
    frame.first == FRAME_MAX_SCORE && frame.size == 1
  end

  def spare?(frame)
    !strike?(frame) && frame.first(2).sum == FRAME_MAX_SCORE
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
BowlingGameScorer.new(ARGV[0]).print_game_score
