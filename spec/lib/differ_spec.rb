describe Differ do
  describe '.do_perform' do
    xit do
      binding.pry
      src = create(:source)
      expect(src.dummy_pk).to eq(1)
    end
  end

  describe '#do_perform' do
    xit
  end
end
