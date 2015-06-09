describe DifferHelper do
  # @ref Testing Ruby Modules with rspec - Stack Overflow
  # @url http://stackoverflow.com/questions/27341800/testing-ruby-modules-with-rspec
  let(:included_class) do
    Class.new do
      include DifferHelper
      attr_accessor :result_set
      def initialize
        @result_set = Set.new
      end
    end
  end
  let(:differ) { included_class.new }

  describe '#count_by_col' do
    context '@result_setが空の場合' do
      subject { differ.count_by_col }
      it { should {} }
    end

    context '@result_setが空ではない場合' do
      before do
        differ.result_set << build(:differ_result, :diff1)
        differ.result_set << build(:differ_result, :diff2)
        differ.result_set << build(:differ_result, :diff3)
      end
      let(:expected) { { a: 2, b: 2, c: 2 } }
      it 'keyごとの件数を集計して返すこと' do
        expect(differ.count_by_col).to eq(expected)
      end
    end
  end

  describe '#output' do
    xit
  end
end
