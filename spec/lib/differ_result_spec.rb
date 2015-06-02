describe DifferResult do
  describe '#move_to_acceptable_diff!' do
    subject(:subject) { described_class.new }
    let(:all_acceptables) { { acceptable_col1: [nil, '1'], acceptable_col2: ['1', nil] } }
    let(:only_col1_accept) { { acceptable_col1: [nil, '1'], acceptable_col2: ['1', 1] } }
    let(:none_acceptable) { { acceptable_col1: [1, '1'], acceptable_col2: ['1', 1] } }
    let(:normal_cols) { { a: [1, 2], b: [2, 3] } }

    context '除外対象項目の値がすべて除外対象の場合' do
      before do
        subject.diff = all_acceptables.dup
        subject.move_to_acceptable_diff!
      end
      it { expect(subject.diff.empty?).to be_truthy }
      it { expect(subject.acceptable_diff.count).to eq(2) }
      it { expect(subject.acceptable_diff).to eq(all_acceptables) }
    end

    context '除外対象項目の値が一部除外対象の場合' do
      before do
        subject.diff = only_col1_accept.dup
        subject.move_to_acceptable_diff!
      end
      it { expect(subject.diff).to eq(acceptable_col2: ['1', 1]) }
      it { expect(subject.acceptable_diff.count).to eq(1) }
      it { expect(subject.acceptable_diff).to eq(acceptable_col1: [nil, '1']) }
    end

    context '除外対象項目の値がすべて除外対象ではないの場合' do
      before do
        subject.diff = none_acceptable.dup
        subject.move_to_acceptable_diff!
      end
      it { expect(subject.diff).to eq(none_acceptable) }
      it { expect(subject.acceptable_diff.empty?).to be_truthy }
    end

    context '除外対象項目以外の場合' do
      before do
        subject.diff = normal_cols.dup
        subject.move_to_acceptable_diff!
      end
      it { expect(subject.diff).to eq(normal_cols) }
      it { expect(subject.acceptable_diff.empty?).to be_truthy }
    end

    context '@diffが空の場合の場合' do
      before do
        subject.diff = {}
        subject.move_to_acceptable_diff!
      end
      it { expect(subject.diff.empty?).to be_truthy }
      it { expect(subject.acceptable_diff.empty?).to be_truthy }
    end
  end
end
