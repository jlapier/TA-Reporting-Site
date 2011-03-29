require 'spec_helper'

describe SummaryReport do
  # stats correctness can be verified by creating some activities across
  # a few months in the same year and then by testing that:
  # - ytd stats == period stats when period is eg Jan 1 - Mar 31
  # - ytd_stats are same for above example as when period is eg Mar 1 - Mar 30
  it "collects relevant State participation statistics"
end