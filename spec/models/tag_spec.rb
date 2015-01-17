require "rails_helper"

describe Tag do

  it { should have_many(:taggings) }
  it { should have_many(:submissions) }

end