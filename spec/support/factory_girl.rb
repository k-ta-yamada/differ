require 'factory_girl'
# @ref RSpecにおけるFactoryGirlの使い方まとめ
# @url http://qiita.com/muran001/items/436fd07eba1db18ed622

# @ref FactoryGirlのロードの仕組み
# @url http://kinjouj.github.io/2014/08/factorygirl-fixture-loading-architecture.html
# @ref Using Without Bundler
# @url http://www.rubydoc.info/gems/factory_girl/file/GETTING_STARTED.md#Using_Without_Bundler
FactoryGirl.find_definitions

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
end
