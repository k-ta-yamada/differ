# @ref https://github.com/defunkt/fakefs/blob/master/lib/fakefs/spec_helpers.rb
require 'fakefs/spec_helpers'
describe DifferHelper do
  describe '#count_by_col' do
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
    subject { differ.send(:count_by_col) }

    context '@result_setが空の場合' do
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
        expect(subject).to eq(expected)
      end
    end
  end

  describe '#output_diff' do
    include FakeFS::SpecHelpers
    before { Dir.mkdir('./result') }
    subject(:differ) { Differ.new(11) }
    let(:file) { './result/11xx_diff.csv' }
    let(:data) do
      [[1, 'search_key', 11, nil, nil, 'A', 1, 2],
       [1, 'search_key', 11, nil, nil, 'B', 1, 2],
       [2, 'search_key', 11, nil, nil, 'A', 1, 2],
       [2, 'search_key', 11, nil, nil, 'B', 1, 2],
       [3, 'search_key', 11, nil, nil, 'A', 1, 2],
       [3, 'search_key', 11, nil, nil, 'B', 1, 2],
       [4, 'search_key', 11, nil, nil, 'A', 1, 2],
       [4, 'search_key', 11, nil, nil, 'B', 1, 2],
       [5, 'search_key', 11, nil, nil, 'A', 1, 2],
       [5, 'search_key', 11, nil, nil, 'B', 1, 2]]
    end

    context '@result_setが空の場合' do
      before { differ.result_set.clear }

      it '空ファイルは作成されること' do
        expect(differ.output_diff).to eq(file)
        expect(File.file?(file)).to be_truthy
        expect(File.open(file, 'r').read).to eq('')
      end
    end

    context '@result_setが空でない場合' do
      before { differ.result_set.merge build_list(:differ_result_for_diff, 5) }
      let(:expected) { data.map { |d| d.join("\t") }.join("\n") << "\n" }

      it 'DifferResult#diffの内容が出力されること' do
        expect(differ.output_diff).to eq(file)
        expect(File.file?(file)).to be_truthy
        expect(File.open(file, 'r').read).to eq(expected)
      end
    end
  end

  describe '#acceptable_diff' do
    include FakeFS::SpecHelpers
    before { Dir.mkdir('./result') }
    subject(:differ) { Differ.new(11) }
    let(:file) { './result/11xx_acceptable_diff.csv' }
    let(:data) do
      [[1, 'search_key', 11, nil, nil, 'A', 1, 2],
       [1, 'search_key', 11, nil, nil, 'B', 1, 2],
       [2, 'search_key', 11, nil, nil, 'A', 1, 2],
       [2, 'search_key', 11, nil, nil, 'B', 1, 2],
       [3, 'search_key', 11, nil, nil, 'A', 1, 2],
       [3, 'search_key', 11, nil, nil, 'B', 1, 2],
       [4, 'search_key', 11, nil, nil, 'A', 1, 2],
       [4, 'search_key', 11, nil, nil, 'B', 1, 2],
       [5, 'search_key', 11, nil, nil, 'A', 1, 2],
       [5, 'search_key', 11, nil, nil, 'B', 1, 2]]
    end

    context '@result_setが空の場合' do
      before { differ.result_set.clear }

      it '空ファイルは作成されること' do
        expect(differ.output_acceptable_diff).to eq(file)
        expect(File.file?(file)).to be_truthy
        expect(File.open(file, 'r').read).to eq('')
      end
    end

    context '@result_setが空でない場合' do
      before { differ.result_set.merge build_list(:differ_result_for_acceptable_diff, 5) }
      let(:expected) { data.map { |d| d.join("\t") }.join("\n") << "\n" }

      it 'DifferResult#acceptable_diffの内容が出力されること' do
        expect(differ.output_acceptable_diff).to eq(file)
        expect(File.file?(file)).to be_truthy
        expect(File.open(file, 'r').read).to eq(expected)
      end
    end
  end
end
