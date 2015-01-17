require "rails_helper"

describe Tagging do

  it { should belong_to(:tag) }
  it { should belong_to(:submission) }

end