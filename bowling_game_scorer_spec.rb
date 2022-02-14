require './bowling_game_scorer'

describe BowlingGameScorer do
  describe '#initialize' do
    subject { BowlingGameScorer.new(score) }
    let(:score) { input_score }

    context 'with invalid input data' do
      context 'with invalid frame count' do
        let(:err_msg) { 'Invalid input! First argument should be a numbers of pins ' \
                         "knocked down by each ball separated by commas without spaces!\n" }

        context 'bigger than 10' do
          let(:input_score) { '3,2,3,2,3,2,3,2,3,2,3,2,3,2,3,2,3,2,3,2,3,2' }

          specify { expect { to_fail }.to output(err_msg).to_stderr }
        end

        context 'smaller than 10' do
          let(:input_score) { '10,10,10,10,10,10,10,10,10' }

          specify { expect { to_fail }.to output(err_msg).to_stderr }
        end
      end

      context 'when frame score is bigger than 10' do
        let(:input_score) { '3,2,3,2,3,2,3,2,3,2,3,2,3,2,3,2,9,2,3,2' }
        let(:err_msg) { "Invalid frame count or frame scores!\n" }

        specify { expect { to_fail }.to output(err_msg).to_stderr }
      end

      context 'when last frame first throw is strike' do
        let(:err_msg) { "Invalid last (10th) frame!\n" }

        context 'when only 1 additional throw is done' do
          let(:input_score) { '3,2,3,2,3,2,3,2,3,2,3,2,3,2,3,2,3,2,10,1' }

          specify { expect { to_fail }.to output(err_msg).to_stderr }
        end

        context 'when no additional throws are done' do
          let(:input_score) { '3,2,3,2,3,2,3,2,3,2,3,2,3,2,3,2,3,2,10' }

          specify { expect { to_fail }.to output(err_msg).to_stderr }
        end
      end

      context 'when last frame is spare and no additional throws are done' do
        let(:input_score) { '3,2,3,2,3,2,3,2,3,2,3,2,3,2,3,2,3,2,2,8' }
        let(:err_msg) { "Invalid last (10th) frame!\n" }

        specify { expect { to_fail }.to output(err_msg).to_stderr }
      end

      context 'when last frame is open and third throw is done' do
        let(:input_score) { '3,2,3,2,3,2,3,2,3,2,3,2,3,2,3,2,3,2,2,2,2' }
        let(:err_msg) { "Invalid last (10th) frame!\n" }

        specify { expect { to_fail }.to output(err_msg).to_stderr }
      end
    end

    context 'with valid input data' do
      context 'with last open frame' do
        let(:input_score) { '3,2,10,3,2,3,2,10,3,2,3,2,3,7,3,2,2,3' }

        it 'should correctly process score' do
          expect(subject.input).to eq([[3, 2], [10], [3, 2], [3, 2], [10], [3, 2], [3, 2], [3, 7], [3, 2], [2, 3]])
        end
      end

      context 'with last spare' do
        let(:input_score) { '3,2,10,3,2,3,2,10,3,2,3,2,3,7,3,2,2,8,5' }

        it 'should correctly process score' do
          expect(subject.input).to eq([[3, 2], [10], [3, 2], [3, 2], [10], [3, 2], [3, 2], [3, 7], [3, 2], [2, 8, 5]])
        end
      end

      context 'with last strike' do
        let(:input_score) { '3,2,10,3,2,3,2,10,3,2,3,2,3,7,3,2,10,6,10' }

        it 'should correctly process score' do
          expect(subject.input).to eq([[3, 2], [10], [3, 2], [3, 2], [10], [3, 2], [3, 2], [3, 7], [3, 2], [10, 6, 10]])
        end
      end
    end
  end
end

def to_fail
  expect { subject }.to raise_error(SystemExit) do |error|
    expect(error.status).to eq(1)
  end
end
