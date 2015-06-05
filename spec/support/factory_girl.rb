require 'factory_girl'
# @ref RSpecにおけるFactoryGirlの使い方まとめ
# @url http://qiita.com/muran001/items/436fd07eba1db18ed622

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
end
