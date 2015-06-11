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
        search_values:   %w(0 1 2 3 4 5 6 7 8 9).map(&:to_i),
        include_keys:    %i(include_col1_id include_col2_id),
        exclude_keys:    %i(exclude_col1 exclude_col2),
        acceptable_keys: { acceptable_col1: [NilClass, String],
                           acceptable_col2: [String, NilClass] },
        output_file_encoding: Encoding::SJIS }
    end
    it { should eq(expected) }
  end

  describe 'private method' do
    describe '#key_check' do
      let(:valid_doc) { { a: 1, b: 2, c: 3 } }
      let(:invalid_doc) { { a: 1, b: 2 } }
      let(:be_included) { %i(a b c) }
      let(:method_name) { 'test' }

      context 'doc.keys == be_included' do
        subject { AppConfig.send(:key_check, valid_doc, be_included, method_name) }
        it { should eq(valid_doc) }
      end

      context 'doc.keys != be_included' do
        subject { AppConfig.send(:key_check, invalid_doc, be_included, method_name) }
        it do
          expect { subject }.to raise_error(RuntimeError, '[test] #<Set: {:c}>')
        end
      end
    end
  end
end
