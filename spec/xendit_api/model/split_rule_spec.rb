require 'spec_helper'

RSpec.describe XenditApi::Model::SplitRule do
  describe 'inheritance' do
    it 'inherits from Base' do
      expect(described_class.superclass).to eq(XenditApi::Model::Base)
    end
  end

  describe 'attributes' do
    it 'has all expected attribute accessors' do
      expect(described_class.new).to respond_to(:id)
      expect(described_class.new).to respond_to(:id=)
      expect(described_class.new).to respond_to(:name)
      expect(described_class.new).to respond_to(:name=)
      expect(described_class.new).to respond_to(:description)
      expect(described_class.new).to respond_to(:description=)
      expect(described_class.new).to respond_to(:created)
      expect(described_class.new).to respond_to(:created=)
      expect(described_class.new).to respond_to(:updated)
      expect(described_class.new).to respond_to(:updated=)
      expect(described_class.new).to respond_to(:routes)
      expect(described_class.new).to respond_to(:routes=)
    end
  end

  describe '#initialize' do
    context 'when initialized without parameters' do
      it 'creates an instance with nil attributes' do
        split_rule = described_class.new

        expect(split_rule.id).to be_nil
        expect(split_rule.name).to be_nil
        expect(split_rule.description).to be_nil
        expect(split_rule.created).to be_nil
        expect(split_rule.updated).to be_nil
        expect(split_rule.routes).to be_nil
      end
    end

    context 'when initialized with a hash of attributes' do
      let(:attributes) do
        {
          id: 'sr_123456789',
          name: 'Test Split Rule',
          description: 'A test split rule for payments',
          created: '2023-10-08T10:00:00.000Z',
          updated: '2023-10-08T10:30:00.000Z',
          routes: [
            {
              flat_amount: 1000,
              currency: 'IDR',
              destination: {
                type: 'MERCHANT',
                account_code: 'MERCHANT_001'
              }
            },
            {
              flat_amount: 500,
              currency: 'IDR',
              destination: {
                type: 'MERCHANT',
                account_code: 'MERCHANT_002'
              }
            }
          ]
        }
      end

      it 'sets all attributes correctly' do
        split_rule = described_class.new(attributes)

        expect(split_rule.id).to eq('sr_123456789')
        expect(split_rule.name).to eq('Test Split Rule')
        expect(split_rule.description).to eq('A test split rule for payments')
        expect(split_rule.created).to eq('2023-10-08T10:00:00.000Z')
        expect(split_rule.updated).to eq('2023-10-08T10:30:00.000Z')
        expect(split_rule.routes).to eq(attributes[:routes])
      end

      it 'returns expected attributes using have_attributes matcher' do
        split_rule = described_class.new(attributes)

        expect(split_rule).to have_attributes(
          id: 'sr_123456789',
          name: 'Test Split Rule',
          description: 'A test split rule for payments',
          created: '2023-10-08T10:00:00.000Z',
          updated: '2023-10-08T10:30:00.000Z',
          routes: attributes[:routes]
        )
      end
    end

    context 'when initialized with string keys' do
      let(:attributes) do
        {
          'id' => 'sr_987654321',
          'name' => 'String Key Split Rule',
          'description' => 'Split rule with string keys',
          'created' => '2023-10-08T11:00:00.000Z',
          'updated' => '2023-10-08T11:15:00.000Z',
          'routes' => []
        }
      end

      it 'sets attributes correctly with string keys' do
        split_rule = described_class.new(attributes)

        expect(split_rule.id).to eq('sr_987654321')
        expect(split_rule.name).to eq('String Key Split Rule')
        expect(split_rule.description).to eq('Split rule with string keys')
        expect(split_rule.created).to eq('2023-10-08T11:00:00.000Z')
        expect(split_rule.updated).to eq('2023-10-08T11:15:00.000Z')
        expect(split_rule.routes).to eq([])
      end
    end

    context 'when initialized with mixed symbol and string keys' do
      let(:attributes) do
        {
          :id => 'sr_mixed123',
          'name' => 'Mixed Keys Split Rule',
          :description => 'Split rule with mixed keys',
          'created' => '2023-10-08T12:00:00.000Z',
          :updated => '2023-10-08T12:05:00.000Z',
          'routes' => [{ flat_amount: 2000 }]
        }
      end

      it 'sets attributes correctly with mixed keys' do
        split_rule = described_class.new(attributes)

        expect(split_rule.id).to eq('sr_mixed123')
        expect(split_rule.name).to eq('Mixed Keys Split Rule')
        expect(split_rule.description).to eq('Split rule with mixed keys')
        expect(split_rule.created).to eq('2023-10-08T12:00:00.000Z')
        expect(split_rule.updated).to eq('2023-10-08T12:05:00.000Z')
        expect(split_rule.routes).to eq([{ flat_amount: 2000 }])
      end
    end

    context 'when initialized with partial attributes' do
      let(:partial_attributes) do
        {
          id: 'sr_partial',
          name: 'Partial Split Rule'
        }
      end

      it 'sets only provided attributes' do
        split_rule = described_class.new(partial_attributes)

        expect(split_rule.id).to eq('sr_partial')
        expect(split_rule.name).to eq('Partial Split Rule')
        expect(split_rule.description).to be_nil
        expect(split_rule.created).to be_nil
        expect(split_rule.updated).to be_nil
        expect(split_rule.routes).to be_nil
      end
    end

    context 'when initialized with unknown attributes' do
      let(:attributes_with_unknown) do
        {
          id: 'sr_unknown',
          name: 'Split Rule with Unknown',
          unknown_attribute: 'should be ignored',
          another_unknown: 12345
        }
      end

      it 'ignores unknown attributes and sets only known ones' do
        split_rule = described_class.new(attributes_with_unknown)

        expect(split_rule.id).to eq('sr_unknown')
        expect(split_rule.name).to eq('Split Rule with Unknown')
        expect(split_rule).not_to respond_to(:unknown_attribute)
        expect(split_rule).not_to respond_to(:another_unknown)
      end
    end

    context 'when initialized with empty hash' do
      it 'creates instance with nil attributes' do
        split_rule = described_class.new({})

        expect(split_rule.id).to be_nil
        expect(split_rule.name).to be_nil
        expect(split_rule.description).to be_nil
        expect(split_rule.created).to be_nil
        expect(split_rule.updated).to be_nil
        expect(split_rule.routes).to be_nil
      end
    end

    context 'when initialized with nil' do
      it 'creates instance with nil attributes' do
        split_rule = described_class.new(nil)

        expect(split_rule.id).to be_nil
        expect(split_rule.name).to be_nil
        expect(split_rule.description).to be_nil
        expect(split_rule.created).to be_nil
        expect(split_rule.updated).to be_nil
        expect(split_rule.routes).to be_nil
      end
    end
  end

  describe 'attribute assignment after initialization' do
    let(:split_rule) { described_class.new }

    it 'allows setting attributes individually' do
      split_rule.id = 'sr_individual'
      split_rule.name = 'Individual Assignment'
      split_rule.description = 'Set individually'
      split_rule.created = '2023-10-08T13:00:00.000Z'
      split_rule.updated = '2023-10-08T13:01:00.000Z'
      split_rule.routes = [{ flat_amount: 3000 }]

      expect(split_rule.id).to eq('sr_individual')
      expect(split_rule.name).to eq('Individual Assignment')
      expect(split_rule.description).to eq('Set individually')
      expect(split_rule.created).to eq('2023-10-08T13:00:00.000Z')
      expect(split_rule.updated).to eq('2023-10-08T13:01:00.000Z')
      expect(split_rule.routes).to eq([{ flat_amount: 3000 }])
    end
  end

  describe 'complex routes data' do
    let(:complex_routes) do
      [
        {
          flat_amount: 1000,
          currency: 'IDR',
          destination: {
            type: 'MERCHANT',
            account_code: 'MERCHANT_001'
          }
        },
        {
          percentage: 0.15,
          currency: 'IDR',
          destination: {
            type: 'WALLET',
            wallet_id: 'wallet_123'
          }
        },
        {
          flat_amount: 500,
          currency: 'USD',
          destination: {
            type: 'BANK_ACCOUNT',
            bank_account_id: 'ba_456'
          }
        }
      ]
    end

    it 'handles complex nested route structures' do
      split_rule = described_class.new(routes: complex_routes)

      expect(split_rule.routes).to eq(complex_routes)
      expect(split_rule.routes.length).to eq(3)
      expect(split_rule.routes[0][:flat_amount]).to eq(1000)
      expect(split_rule.routes[1][:percentage]).to eq(0.15)
      expect(split_rule.routes[2][:destination][:bank_account_id]).to eq('ba_456')
    end
  end
end
