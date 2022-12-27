require 'spec_helper'

RSpec.describe XenditApi::Api::Transaction do
  let(:client) { XenditApi::Client.new(ENV['XENDIT_SECRET_KEY']) }

  describe '#list' do
    it 'returns expected response' do
      VCR.use_cassette('xendit_api/api/transactions/transactions') do
        transaction = described_class.new(client)
        transactions = transaction.list
        expect(transactions.data.size).to eq 10
        expect(transactions.next_query).to eq 'currency=IDR&limit=10&after_id=txn_0811c413-12c4-470a-be62-dfd1bf3c280d'
        transaction = transactions.data.last
        expect(transaction).to be_instance_of XenditApi::Model::Transaction
        expect(transaction.account_identifier).to eq "8808999921687033"
        expect(transaction.amount).to eq 10000
        expect(transaction.business_id).to eq "57fdbb445eec38910d3a4c47"
        expect(transaction.cashflow).to eq "MONEY_IN"
        expect(transaction.channel_category).to eq "VIRTUAL_ACCOUNT"
        expect(transaction.channel_code).to eq "BNI"
        expect(transaction.created).to eq "2022-11-14T06:15:44.977Z"
        expect(transaction.currency).to eq "IDR"
        expect(transaction.estimated_settlement_time).to eq "2022-11-14T06:15:42.605Z"
        expect(transaction.fee).to eq({"status"=>"COMPLETED", "third_party_withholding_tax"=>0, "value_added_tax"=>440, "xendit_fee"=>4000, "xendit_withholding_tax"=>0})
        expect(transaction.id).to eq "txn_0811c413-12c4-470a-be62-dfd1bf3c280d"
        expect(transaction.net_amount).to eq 5560
        expect(transaction.product_id).to eq "6371dd104374b900a2c4b1bb"
        expect(transaction.reference_id).to eq "payment-link-example1"
        expect(transaction.settlement_status).to eq "SETTLED"
        expect(transaction.status).to eq "SUCCESS"
        expect(transaction.type).to eq "PAYMENT"
        expect(transaction.updated).to eq "2022-11-14T06:15:44.977Z"
      end
    end

    it 'returns expected when Transaction was blank' do
      VCR.use_cassette('xendit_api/api/transactions/blank_transactions') do
        transaction = described_class.new(client)
        transactions = transaction.list('statuses=VOIDED')
        expect(transactions.data).to eq []
        expect(transactions.next_query).to eq nil
      end
    end

    # it 'raise error when find transactions with invalid external-id' do
    #   VCR.use_cassette('xendit_api/api/transactions/not_found_data_99999') do
    #     transaction = described_class.new(client)
    #     transactions = transaction.list('not_found_data_99999')
    #     expect(transactions).to eq []
    #   end
    # end
  end
end
