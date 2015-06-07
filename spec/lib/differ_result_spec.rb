describe DifferResult do
  describe '#move_to_acceptable_diff!' do
    context '対象項目が許容対象の場合' do
      subject { build(:differ_result, :acceptables).move_to_acceptable_diff! }
      it 'acceptable_diffに移ること' do
        expect(subject.diff).to be_empty
        expect(subject.acceptable_diff.size).to eq(2)
      end
    end

    context '対象項目であるが、値が許容対象外の組み合わせの場合' do
      subject { build(:differ_result, :unacceptables).move_to_acceptable_diff! }
      it 'diffに残ること' do
        expect(subject.diff.size).to eq(2)
        expect(subject.acceptable_diff).to be_empty
      end
    end

    context 'diffが空の場合' do
      subject { build(:differ_result).move_to_acceptable_diff! }
      it 'acceptable_diffも空のままとなること' do
        expect(subject.diff).to be_empty
        expect(subject.acceptable_diff).to be_empty
      end
    end
  end
end
