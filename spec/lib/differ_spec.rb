require 'fakefs/spec_helpers'
describe Differ do
  include FakeFS::SpecHelpers

  before do
    10.times do |i|
      create_list(:source, 10, search_key: i)
      create_list(:target, 10, search_key: i)
    end
  end

  describe '.do_perform' do
    subject { described_class.do_perform }
    before { Dir.mkdir('./result') }
    it '配列が10件' do
      expect(subject).to be_a(Array)
      expect(subject.size).to eq(10)
    end
  end

  describe '#do_perform' do
    subject { described_class.new(1) }
    it '自身のインスタンスが返ること' do
      expect(subject.do_perform).to eq(subject)
    end
  end
end
