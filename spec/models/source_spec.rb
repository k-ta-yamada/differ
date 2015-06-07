describe Source do
  describe '.default_scope' do
    context '同一のprimary_keyを持つレコードが存在する場合' do
      before do
        create_list(:source, 2, dummy_pk: 1)
        create(:source, dummy_pk: 2)
      end
      it '同一のprimary_keyを持つレコードが除外されること' do
        expect(Source.count).to eq(1)
        expect(Source.first).to eq(build(:source, dummy_pk: 2))
      end
    end
  end

  describe '.exclude_keys' do
    context '同一のprimary_keyを持つレコードが存在する場合' do
      before do
        create_list(:source, 2, dummy_pk: 1)
        create(:source, dummy_pk: 2)
        create_list(:source, 2, dummy_pk: 3)
      end
      it '対象となるレコードのprimary_keyを返すこと' do
        expect(Source.exclude_keys).to match_array(%w(1 3))
      end
    end

    context '同一のprimary_keyを持つレコードが存在しない場合' do
      before do
        create_list(:source, 2)
      end
      it '[]となること' do
        expect(Source.exclude_keys).to match_array([])
      end
    end
  end

  describe '.search_key_like' do
    context 'カラム名を指定しない場合' do
      before do
        create(:source, search_key: '1101')
        create(:source, search_key: '1201')
        create(:source, search_key: '1301')
        create(:source, search_key: '1401')
      end
      it 'differ.ymlに設定したカラム名で検索すること' do
        expect(Source.count).to eq(4)
        expect(Source.search_key_like(11).count).to eq(1)
      end
    end

    context 'カラム名を指定した場合' do
      before do
        create(:source, include_col1_id: '2101')
        create(:source, include_col1_id: '2201')
        create(:source, include_col1_id: '2301')
        create(:source, include_col1_id: '2401')
      end
      it '指定したカラム名で検索すること' do
        expect(Source.count).to eq(4)
        expect(Source.search_key_like(21, :include_col1_id).count).to eq(1)
      end
    end

    context '存在しないカラム名を指定した場合' do
      it 'エラーとなること' do
        expect { Source.search_key_like(11, :not_exist_col) }.to raise_error(RuntimeError)
      end
    end
  end
end
