describe DifferHelper do
  # @ref Testing Ruby Modules with rspec - Stack Overflow
  # @url http://stackoverflow.com/questions/27341800/testing-ruby-modules-with-rspec
  let(:included_class) do
    Class.new do
      include DifferHelper
      attr_accessor :result_set
    end
  end
  let(:differ) { included_class.new }

  describe '#diff_keys' do
    context '@result_setがnil, []の場合' do
      it do
        [Set.new].each do |result|
          differ.result_set = result
          expect(differ.diff_keys).to be_nil
        end
      end
    end

    context 'keyの一覧を返すこと' do
      before do
        # TODO: DifferResult.newに直す
        Result = Struct.new(:diff)
        result1 = Result.new
        result1.diff = { aaa: [1, 2], bbb: [2, 1] }
        result2 = Result.new
        result2.diff = { aaa: [1, 2], ccc: [2, 1] }
        differ.result_set = [result1, result2]
      end
      xit do
        expect(differ.diff_keys).to eq([:aaa, :bbb, :ccc])
      end
    end
  end

  describe '#results_search' do
    xit
  end

  describe '#count_by_colt' do
    xit
  end

  describe '#output' do
    xit
  end
end
