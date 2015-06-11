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
    subject { described_class }
    before { Dir.mkdir('./result') }
    it do
      expect(subject.do_perform.size).to eq(10)
    end
  end

  describe '#do_perform' do
    subject { described_class.new(1) }
    it do
      expect(subject.do_perform).to eq(subject)
    end
  end
end
