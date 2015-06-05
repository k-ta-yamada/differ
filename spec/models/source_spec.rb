describe Source do
  describe '.default_scope' do
    context "same primary key's record is exclude" do
      before do
        Source.create(dummy_pk: '1', search_key: '1101')
        Source.create(dummy_pk: '1', search_key: '1102')
        Source.create(dummy_pk: '2', search_key: '1103')
      end
      it do
        expect(Source.count).to eq(1)
        expect(Source.first.dummy_pk).to eq('2')
      end
    end
  end

  describe '.exclude_keys' do
    before do
      Source.create(dummy_pk: '1', search_key: '1101')
      Source.create(dummy_pk: '2', search_key: '1101')
      Source.create(dummy_pk: '2', search_key: '1102')
    end
    it do
      expect(Source.exclude_keys).to eq(['2'])
      expect(Source.exclude_keys.size).to eq(1)
    end
  end

  describe '.search_key_like' do
    context 'col_nm is default' do
      before do
        Source.create(dummy_pk: '1', search_key: '1101')
        Source.create(dummy_pk: '2', search_key: '1201')
        Source.create(dummy_pk: '3', search_key: '1301')
      end
      it do
        expect(Source.count).to eq(3)
        expect(Source.search_key_like(11).count).to eq(1)
      end
    end

    context 'col_nm is not default' do
      before do
        Source.create(dummy_pk: '1', search_key: '1101', include_col1_id: '2101')
        Source.create(dummy_pk: '2', search_key: '1201', include_col1_id: '2201')
        Source.create(dummy_pk: '3', search_key: '1301', include_col1_id: '2301')
      end
      it 'col_nm is not default' do
        expect(Source.count).to eq(3)
        expect(Source.search_key_like(21, :include_col1_id).count).to eq(1)
      end
    end

    context 'col_nm is not exist' do
      let(:error_klass) { RuntimeError }
      let(:error_message) { "Source#key_check[#{:not_exist_col}]" }
      it do
        expect { Source.search_key_like(11, :not_exist_col) }
          .to raise_error(error_klass, error_message)
      end
    end
  end

  describe '#target_has_many?' do
    subject { Source.first.target_has_many? }

    context 'target is many' do
      before do
        Source.create(dummy_pk: '1', search_key: '1101', include_col1_id: '2101')
        Target.create(dummy_pk: '1', search_key: '1101', include_col1_id: '2301')
        Target.create(dummy_pk: '1', search_key: '1101', include_col1_id: '2201')
      end
      it { should be_truthy }
    end

    context 'target is one' do
      before do
        Source.create(dummy_pk: '1', search_key: '1101', include_col1_id: '2101')
        Target.create(dummy_pk: '1', search_key: '1101', include_col1_id: '2301')
      end
      it { should be_falsey }
    end
  end
end
