# frozen_string_literal: true

require 'dry/monads/all'
require 'dry/matcher/result_matcher'

Dry::Schema.load_extensions(:hints)
Dry::Schema.load_extensions(:info)
Dry::Schema.load_extensions(:monads)
Dry::Validation.load_extensions(:monads)
Dry::Types.load_extensions(:monads)
