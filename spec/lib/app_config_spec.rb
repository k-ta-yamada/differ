describe AppConfig do
  describe '.environment' do
    subject { described_class.environment }
    let(:expected) { :test }
    it { should eq(expected) }
  end

  describe '.database' do
    subject { described_class.database }
    let(:expected) do
      { adapter: 'sqlite3', database: 'db/test.sqlite3' }
    end
    it { should eq(expected) }
  end

  describe '.models' do
    subject { described_class.models }
    let(:expected) do
      { source_table_name: :source, source_primary_key: :dummy_pk,
        target_table_name: :target, target_primary_key: :dummy_pk }
    end
    it { should eq(expected) }
  end

  describe '.differ' do
    subject { described_class.differ }
    let(:expected) do
      { search_key:      :search_key,
        search_values:   %w(0 1 2 3 4).map(&:to_i),
        include_keys:    %i(include_col1_id include_col2_id),
        exclude_keys:    %i(exclude_col1 exclude_col2),
        acceptable_keys: { acceptable_col1: [NilClass, String],
                           acceptable_col2: [String, NilClass] } }
    end
    it { should eq(expected) }
  end

  describe 'private method' do
    describe '#key_check' do
      # subject(:subject) { AppConfig.send(:key_check, doc_keys, be_included, file_name) }
      let(:doc_keys) { %i(a b c) }
      let(:be_included) { %i(a b c) }
      let(:file_name) { 'test' }

      context 'doc_keys == be_included' do
        it do
          expect(AppConfig.send(:key_check, doc_keys, be_included, file_name)).to be_nil
        end
      end

      context 'doc_keys != be_included' do
        it do
          be_included = %i(a b)
          expect { AppConfig.send(:key_check, doc_keys, be_included, file_name) }
            .to raise_error(RuntimeError, '[test] #<Set: {:c}>')
        end
      end
    end
  end
end
